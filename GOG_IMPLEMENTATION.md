# BannerHub — GOG Games Integration: Complete Implementation Reference

**Version:** v2.7.0
**Branch merged:** gog-beta → main
**Date:** 2026-03-22

**Credits:** The GOG API pipeline, OAuth2 authentication flow, download architecture, and library sync logic in this implementation are based on the research and implementation of [The GameNative Team](https://github.com/utkarshdalal/GameNative). Without their work this feature would not have been possible.

---

## Table of Contents

1. [Overview](#1-overview)
2. [Class Structure](#2-class-structure)
3. [Injection Points](#3-injection-points)
4. [Data Model — GogGame](#4-data-model--goggame)
5. [Authentication — GogLoginActivity](#5-authentication--gogloginactivity)
6. [Token Refresh — GogTokenRefresh](#6-token-refresh--gogtokenrefresh)
7. [Library Sync — GogGamesFragment$1 / $3 / $4](#7-library-sync--goggamesfragment1--3--4)
8. [Card UI — GogGamesFragment$2](#8-card-ui--goggamesfragment2)
9. [Install Button — GogGamesFragment$6](#9-install-button--goggamesfragment6)
10. [Download Confirmation — GogGamesFragment$8](#10-download-confirmation--goggamesfragment8)
11. [Download Pipeline — GogDownloadManager + $1](#11-download-pipeline--gogdownloadmanager--1)
12. [Progress Updates — GogDownloadManager$3](#12-progress-updates--gogdownloadmanager3)
13. [Toast — GogDownloadManager$2](#13-toast--gogdownloadmanager2)
14. [Add Button — GogGamesFragment$7](#14-add-button--goggamesfragment7)
15. [Uninstall — GogGamesFragment$10](#15-uninstall--goggamesfragment10)
16. [Install Path — GogInstallPath](#16-install-path--goginstallpath)
17. [SharedPreferences Layout](#17-sharedpreferences-layout)
18. [GOG API Reference](#18-gog-api-reference)
19. [Smali Register Constraints and Solutions](#19-smali-register-constraints-and-solutions)
20. [Progress Band Map](#20-progress-band-map)
21. [DEX Placement](#21-dex-placement)
22. [CI and Build Notes](#22-ci-and-build-notes)

---

## 1. Overview

The GOG Games tab is a full game store integration built entirely in smali, injected into GameHub 5.3.5 ReVanced. It provides:

- OAuth2 login to GOG account via WebView
- Full library sync (Gen 1 + Gen 2 games)
- Per-game card UI with thumbnail, title, developer, Gen badge, download size
- Install flow with confirmation dialog → download pipeline → progress bar
- Post-install checkmark shown immediately on the card
- "Add" button to register the game with GameHub's built-in Import Game dialog
- Persistent install state across app restarts
- Uninstall with full card reset

All code lives in `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/Gog*.smali`.

---

## 2. Class Structure

| Class | Role |
|---|---|
| `GogGame` | Data holder: title, imageUrl, gameId, storeUrl, category, description, developer, fileSize (long) |
| `GogMainActivity` | Host activity for the GOG tab; contains a TabLayout with Login and Games tabs |
| `GogMainActivity$1` | TabLayout.OnTabSelectedListener — switches between Login and Games fragments |
| `GogMainActivity$2` | Fragment instantiator helper |
| `GogLoginActivity` | Fragment: WebView OAuth2 login flow; stores tokens to `bh_gog_prefs` |
| `GogLoginActivity$1` | WebViewClient: intercepts redirect URL, extracts auth code |
| `GogLoginActivity$2` | Token exchange network Runnable; parses JSON, saves tokens |
| `GogLoginActivity$3` | Runnable: posts "Login successful" Toast on main thread |
| `GogLoginActivity$4` | Runnable: posts "Login failed" Toast on main thread |
| `GogTokenRefresh` | Static helper: reads refresh_token from SP, GETs new access_token, saves it |
| `GogGamesFragment` | Fragment: hosts the games tab; RecyclerView-style scroll view of game cards |
| `GogGamesFragment$TabFactory` | TabHost.TabContentFactory — creates tab content views |
| `GogGamesFragment$1` | Library sync network Runnable: fetches owned game IDs + per-game metadata |
| `GogGamesFragment$2` | Card builder: creates all views for one game card (thumbnail, labels, buttons, checkmark) |
| `GogGamesFragment$3` | Image fetch Runnable: downloads cover image bytes on background thread |
| `GogGamesFragment$4` | Image decode + set Runnable: decodes Bitmap, posts setImageBitmap to UI thread |
| `GogGamesFragment$4$1` | Inner Runnable of $4: the actual UI-thread setImageBitmap call |
| `GogGamesFragment$5` | "Sync Library" button click listener: re-triggers $1 library sync |
| `GogGamesFragment$6` | Install button click listener: shows confirmation dialog |
| `GogGamesFragment$7` | Add button click listener: reads gog_exe_ from SP, calls B3(exePath) |
| `GogGamesFragment$8` | Dialog positive-button listener: hides Install button, shows ProgressBar, calls startDownload |
| `GogGamesFragment$10` | Uninstall button click listener: deletes install dir, clears SP keys, resets card |
| `GogDownloadManager` | Static entry point: `startDownload(ctx, game, pb, statusTV, addBtn, checkmark)` → Thread |
| `GogDownloadManager$1` | Background Runnable: 7-step Gen 2 download pipeline |
| `GogDownloadManager$2` | Toast Runnable: posts Toast to main thread |
| `GogDownloadManager$3` | Progress Runnable: posted to main thread Handler to update ProgressBar + card UI |
| `GogInstallPath` | Static helper: returns `File(filesDir/gog_games/{installDirectory})` |

---

## 3. Injection Points

### HomeLeftMenuDialog — menu item registration

File: `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog.smali`

A new menu item with ID=10 and label "GOG" is injected immediately before the `submitList()` call in `HomeLeftMenuDialog.Z0()`. Tapping it starts `GogMainActivity`.

### LandscapeLauncherMainActivity — menu item handler

File: `patches/smali_classes16/com/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity.smali`

The `handleMenuItemClick` method has an injected branch: when `item.getItemId() == 10`, it starts `GogMainActivity` via `startActivity(new Intent(context, GogMainActivity.class))`.

### AndroidManifest.xml

`GogMainActivity` and `GogLoginActivity` are declared as `<activity>` entries. The `android:theme` for both is set to `@style/Theme.AppCompat.NoActionBar` to match the rest of GameHub's UI.

### public.xml / strings.xml

- `gog_menu_item` string resource declared for the sidebar label
- Resource ID entries added to `public.xml` for the new string resources

---

## 4. Data Model — GogGame

```
GogGame fields:
  String  title        — display name
  String  imageUrl     — https://images.gog-statics.com/...
  String  gameId       — numeric string (product ID)
  String  storeUrl     — https://www.gog.com/game/{slug}
  String  category     — "game" / "dlc" / etc.
  String  description  — short description text
  String  developer    — developer name
  long    fileSize     — total download size in bytes
```

`fileSize` is read as a `long` (`iget-wide`) when computing "X MB" for the dialog and when computing `fileSizeMB = fileSize / 1048576`.

---

## 5. Authentication — GogLoginActivity

### OAuth2 Authorization URL

```
https://auth.gog.com/auth
  ?client_id=46899977096215655
  &redirect_uri=https://embed.gog.com/on_login_success?origin=client
  &response_type=code
  &layout=galaxy
```

### Token Exchange

```
GET https://auth.gog.com/token
  ?client_id=46899977096215655
  &client_secret=9d85c43b1482497dbbce61f6e4aa173a433796eeae2ca8c5f6129f2dc4de46d9
  &grant_type=authorization_code
  &code={authCode}
  &redirect_uri=https://embed.gog.com/on_login_success?origin=client
```

Note: `client_id` and `client_secret` are the public GOG Galaxy credentials, intentionally public and used by all third-party GOG clients (Heroic Games Launcher, heroic-gogdl, etc.).

### Redirect Intercept (GogLoginActivity$1 — WebViewClient)

`shouldOverrideUrlLoading()` checks if URL contains `on_login_success`. If so, extracts `code=` query param and triggers `GogLoginActivity$2` (token exchange Runnable) on a background thread.

### Token Storage (bh_gog_prefs SharedPreferences)

After successful token exchange:
```
access_token    → SP string
refresh_token   → SP string
user_id         → SP string
bh_gog_login_time   → SP int  (System.currentTimeMillis() / 1000)
bh_gog_expires_in   → SP int  (value from JSON "expires_in" field)
```

### JSON Parsing

`GogLoginActivity.parseJsonStringField(json, key)` — static helper. Finds `"key":"value"` pattern via `String.indexOf()` + substring extraction. Used throughout all GOG classes (no org.json dependency needed for simple string fields).

---

## 6. Token Refresh — GogTokenRefresh

Called at the start of any authenticated operation:

```
if (currentTime >= loginTime + expiresIn) → GogTokenRefresh.refresh(context)
```

`refresh()`:
1. Reads `refresh_token` from `bh_gog_prefs`
2. GETs `https://auth.gog.com/token?...&grant_type=refresh_token&refresh_token={token}`
3. Parses new `access_token` and optionally new `refresh_token` from JSON response
4. Writes new values back to SP; resets `bh_gog_login_time` to current time
5. Returns new `access_token` string, or `null` on any failure

If `null` is returned, the caller proceeds with the old token (best-effort). A hard auth failure would require the user to re-login from the Login tab.

---

## 7. Library Sync — GogGamesFragment$1 / $3 / $4

### Step 1 — Get owned game IDs

```
GET https://embed.gog.com/user/data/games
Authorization: Bearer {access_token}
```

Response: `{"owned": [123456789, ...]}`

The owned array is iterated. Each numeric ID is fetched in the next step.

### Step 2 — Per-game metadata

```
GET https://api.gog.com/products/{id}?expand=downloads,description
Authorization: Bearer {access_token}
```

Response fields used:
- `title` → `GogGame.title`
- `images.logo2x` or `images.background` → base for `GogGame.imageUrl`
- `game_type` → `GogGame.category` (used for Gen 1/Gen 2 detection)
- `description.full` → `GogGame.description`
- `developers[0]` or `developer` → `GogGame.developer`
- `downloads.installers[].total_size` (Gen 1) or build manifest size → `GogGame.fileSize`
- `slug` → used to build `GogGame.storeUrl`
- `id` (string) → `GogGame.gameId`

`imageUrl` is constructed by taking the CDN base URL and appending `.png` or the appropriate suffix.

### Image Loading (GogGamesFragment$3 / $4)

`$3` fetches raw image bytes from `GogGame.imageUrl` via `HttpURLConnection` on a background thread. `$4` decodes via `BitmapFactory.decodeByteArray()` and posts a `$4$1` Runnable to the main thread Handler which calls `imageView.setImageBitmap(bitmap)`.

### Gen 1 / Gen 2 Detection

After metadata fetch: if `content-system.gog.com/products/{id}/os/windows/builds?generation=2` returns a non-empty builds array, the game is Gen 2. Otherwise Gen 1. The badge label ("Gen 1" / "Gen 2") is set on the card's badge TextView.

---

## 8. Card UI — GogGamesFragment$2

Called once per game to build all views programmatically. All views are added to a `LinearLayout` (vertical card container) which is then added to the main scroll container.

### View hierarchy per card

```
LinearLayout (card, vertical, dark background, rounded corners, margin)
  ├── LinearLayout (horizontal header row)
  │     ├── ImageView         — cover thumbnail (78dp height)
  │     ├── LinearLayout (vertical info column)
  │     │     ├── TextView    — title
  │     │     ├── TextView    — developer
  │     │     ├── TextView    — Gen badge ("Gen 1" / "Gen 2")
  │     │     └── TextView    — file size ("X MB")
  ├── ProgressBar             — GONE initially; shown during download
  ├── TextView (statusTV)     — GONE initially; "Downloading: filename X%"
  ├── Button (Install)        — VISIBLE initially; GONE after install starts
  ├── Button (Add)            — GONE initially; VISIBLE + enabled at progress=100
  ├── TextView (checkmark)    — GONE initially; "✓ Installed" in green
  └── [Detail dialog trigger on card tap → shows title + description + Uninstall button]
```

### Register constraint: v16 for checkmark ref

With `.locals 17`, p0=v17 (the `$2` instance). v16 is a free local but **invalid in all standard (non-range) instructions**.

Solution:
1. Create and configure checkmark TextView in v13 (4-bit, fully accessible)
2. Persist to v16: `move-object/from16 v16, v13` (8-bit dest — valid)
3. Set GONE via v13 (still holds the ref)
4. Add to parent via v13
5. Pref check uses v13/v14/v15 as temps (v16 is safe from being overwritten)
6. If installed: reload from v16: `move-object/from16 v13, v16`, then `setVisibility(VISIBLE)`
7. Pass to `$6` constructor via range: `invoke-direct/range {v10 .. v16}` (v16 is valid as range endpoint)

### Install state check on card build

After creating the checkmark as GONE, `GogGamesFragment$2` reads `gog_dir_{gameId}` from `bh_gog_prefs`. If non-empty, the install directory is checked for existence with `File.exists()`. If it exists:
- Checkmark reloaded from v16 → set VISIBLE
- Install button stays GONE
- Add button set VISIBLE + enabled

This ensures cards built on app restart reflect persisted install state.

---

## 9. Install Button — GogGamesFragment$6

`View.OnClickListener` on the Install button.

Fields: `a:Context`, `b:GogGame`, `c:ProgressBar`, `d:TextView (statusTV)`, `e:Button (Add)`, `f:TextView (checkmark)`

`onClick()`:
1. Reads `GogGame.fileSize` (long, `iget-wide`) → computes `fileSizeMB = fileSize / 1048576` (int)
2. Gets `StatFs(context.getFilesDir().getAbsolutePath()).getAvailableBytes()` → `availableGB`
3. Builds message: `"Download Size: X MB\nAvailable Space: Y GB"`
4. Creates `GogGamesFragment$8` instance (the dialog's positive-button listener) — passes all 7 args including checkmark ref
5. Builds and shows `AlertDialog` ("Download Game" title, message, Cancel / Download buttons)

### Register layout in onClick (.locals 15)

With `.locals 15`, p0=v15, p1=v16 (the clicked View).

The `$8` creation needs 8 consecutive registers. Solution: shift `new-instance` to v6, args to v7–v13:
- v5 = message string
- v6 = new $8 instance
- v7 = context, v8 = game, v9 = p1 (via `move-object/from16 v9, p1`), v10 = progressBar, v11 = statusTV, v12 = addButton, v13 = checkmark
- `invoke-direct/range {v6 .. v13}`

AlertDialog builder uses v9 (fresh temp) for builder instance, v5 for message, v6 for positive listener.

---

## 10. Download Confirmation — GogGamesFragment$8

`DialogInterface.OnClickListener` on the dialog's "Download" positive button.

Fields: `a:Context`, `b:GogGame`, `c:View (install button)`, `d:ProgressBar`, `e:TextView (statusTV)`, `f:Button (Add)`, `g:TextView (checkmark)`

`onClick()`:
1. Hides Install button (GONE)
2. Shows ProgressBar (VISIBLE)
3. Shows statusTV (VISIBLE), sets text "Starting download..."
4. Calls `GogDownloadManager.startDownload(context, game, progressBar, statusTV, addButton, checkmark)`

---

## 11. Download Pipeline — GogDownloadManager + $1

### Entry point

`GogDownloadManager.startDownload(ctx, game, pb, statusTV, addBtn, checkmark)` — static method.

Creates `GogDownloadManager$1` with all 6 args (using `invoke-direct/range {v0..v6}`), wraps in `Thread`, calls `thread.start()`.

### GogDownloadManager$1 fields

| Field | Type | Content |
|---|---|---|
| `a` | Context | app context |
| `b` | GogGame | game being downloaded |
| `c` | String | access token (read from SP at start of run()) |
| `d` | ProgressBar | card progress bar |
| `e` | Button | Add button |
| `f` | Handler | `new Handler(Looper.getMainLooper())` |
| `g` | TextView | statusTV |
| `h` | TextView | checkmark |

### 7-step pipeline (run())

**Step 1 — Token check + builds URL**
```
GET https://content-system.gog.com/products/{gameId}/os/windows/builds?generation=2
```
Parses `items[0].link` from JSON response → build manifest URL.
Progress: 5% "Fetching build info..."

**Step 2 — Build manifest**
```
GET {buildLink}
```
Response is zlib-compressed. Decompressed with `java.util.zip.Inflater`. Parsed as JSON:
- `installDirectory` → used as subdirectory name in `gog_games/`
- `baseProductId` → used for CDN secure link
- `depots[]` → array of depot objects to fetch
Progress: 20% "Reading manifest..."

**Step 3 — Per-depot meta**
For each depot in depots[]:
```
GET https://gog-cdn-fastly.gog.com/content-system/v2/meta/{AA}/{BB}/{hash}
```
Where `AA` = first 2 chars of depot hash, `BB` = next 2 chars, `hash` = full depot hash.
Response is also zlib-compressed. Decompressed, parsed as JSON.
Collects `DepotFile` entries (path + chunks array + md5). Language filter: skips files with a `languages` field that doesn't contain `"en"` or `"*"`.
Also scans for exe: first `.exe` not containing "redist" → stored as `temp_executable` candidate.
Progress: 40% "Reading depot..."

**Step 4 — Secure CDN link**
```
GET https://content-system.gog.com/products/{baseProductId}/secure_link
  ?generation=2&_version=2&path=/
Authorization: Bearer {access_token}
```
Response JSON: `urls[0].endpoint_name` or `url` field → CDN base URL (time-limited signed URL).
Progress: 45% "Preparing download..."

**Steps 5 + 6 — File download loop**
For each `DepotFile` in collected list:
- Skips directories (path ends with `/`)
- Creates parent directories via `File.mkdirs()`
- For each chunk in file's chunk array:
  - Chunk URL: `{cdnBaseUrl}/{AA}/{BB}/{compressedMd5}` (same 2-char prefix pattern)
  - Downloads to `.gog_chunks/` temp file
  - If chunk is zlib-compressed: decompresses with `Inflater`
  - Appends decompressed bytes to output file via `FileOutputStream` (append mode)
- Progress: `(fileIndex * 40 / totalFiles) + 45` → maps to 45%–85% band
- Status text: `"Downloading: {filename} {pct}%"` (uses `mul-int/lit8` for `fileIndex * 40`)

**Step 7 — Post-install cleanup**
- Creates `_gog_manifest.json` in install dir (title, gameId, version, installDirectory)
- Deletes `.gog_chunks/` temp directory
- Writes SP keys to `bh_gog_prefs`:
  - `gog_dir_{gameId}` = `installDirectory` string
  - `gog_exe_{gameId}` = full absolute path to discovered exe
  - `gog_cover_{gameId}` = absolute path to cover image (if downloaded)
  - `gog_gen_{gameId}` = `"1"` or `"2"`
- Posts Toast "Install complete" via `GogDownloadManager$2`
- Calls `postProgress(100, "✓ Complete")` → triggers `$3.run()` on main thread

**Gen 1 fallback**
If Step 1 returns empty builds (no Gen 2 manifest), `run()` switches to the legacy GOG endpoint:
```
GET https://api.gog.com/products/{gameId}?expand=downloads
```
Parses `downloads.installers[]` for Windows entries → picks the largest `total_size` entry → direct download URL. Downloads as a single file (no chunking).

### httpGet / fetchBytes helpers

`httpGet(url, token)` — opens `HttpURLConnection`, optionally sets `Authorization: Bearer {token}`, reads response as UTF-8 string. Returns null on non-200 or exception.

`fetchBytes(url, token)` — same but reads raw bytes into `byte[]`. Used for compressed manifests and image downloads.

`decompressZlib(byte[])` — `java.util.zip.Inflater`, iterates `inflate()` until `finished()`. Returns decompressed `byte[]`.

---

## 12. Progress Updates — GogDownloadManager$3

UI-thread `Runnable` posted by `$1.postProgress(int, String)` via the main-thread `Handler`.

Fields: `a:ProgressBar`, `b:TextView (statusTV)`, `c:Button (Add)`, `d:int (progress)`, `e:String (message)`, `f:TextView (checkmark)`

`run()` logic:
- Always: `progressBar.setProgress(progress)`
- If message non-null: `statusTV.setText(message)`
- If `progress >= 100`:
  - ProgressBar → GONE
  - statusTV → GONE
  - Add button → VISIBLE + enabled
  - checkmark → VISIBLE

The checkmark ref is passed all the way from `GogGamesFragment$2` through `$6 → $8 → GogDownloadManager.startDownload → $1 → postProgress → $3` to ensure the exact TextView created at card-build time is the one made visible.

---

## 13. Toast — GogDownloadManager$2

Simple `Runnable` holding `Context` and `String`. `run()` calls `Toast.makeText(ctx, msg, Toast.LENGTH_SHORT).show()`. Posted to main thread Handler by `$1.showToast(msg)`.

---

## 14. Add Button — GogGamesFragment$7

`View.OnClickListener` on the Add button (shown after install).

`onClick()`:
1. Opens `bh_gog_prefs`
2. Reads `gog_exe_{gameId}` → full absolute exe path
3. `check-cast` context field (`a`) to `LandscapeLauncherMainActivity`
4. Calls `LandscapeLauncherMainActivity.B3(exePath)` — GameHub's built-in Import Game entry point
5. `B3()` opens `EditImportedGameInfoDialog` where the user fills in the game name and confirms

The exe path is the full absolute Android path, e.g.:
```
/data/data/banner.hub/files/gog_games/Witcher3/bin/x64/witcher3.exe
```

This is what GameHub's import dialog expects — it maps the path into the Wine prefix and creates a game entry.

---

## 15. Uninstall — GogGamesFragment$10

`View.OnClickListener` on the Uninstall button inside the detail dialog.

`onClick()`:
1. Reads `gog_dir_{gameId}` from SP → reconstructs install dir path via `GogInstallPath.getInstallDir(ctx, dirName)`
2. Recursively deletes the install directory
3. Removes SP keys: `gog_dir_{gameId}`, `gog_exe_{gameId}`, `gog_cover_{gameId}`, `gog_gen_{gameId}`
4. Resets card views:
   - Install button → VISIBLE
   - Add button → GONE
   - checkmark → GONE
   - ProgressBar → GONE
   - statusTV → GONE
5. Dismisses the detail dialog

---

## 16. Install Path — GogInstallPath

```
static File getInstallDir(Context ctx, String installDirectory):
    return new File(new File(ctx.getFilesDir(), "gog_games"), installDirectory)
```

Example: `/data/data/banner.hub/files/gog_games/TheWitcher3`

The `installDirectory` value comes directly from the GOG build manifest JSON. It is also what is stored in `gog_dir_{gameId}` in SP so uninstall can reconstruct the path.

---

## 17. SharedPreferences Layout

**SP file:** `bh_gog_prefs` (MODE_PRIVATE)

| Key | Type | Set by | Content |
|---|---|---|---|
| `access_token` | String | GogLoginActivity$2, GogTokenRefresh | GOG Bearer token |
| `refresh_token` | String | GogLoginActivity$2, GogTokenRefresh | GOG refresh token |
| `user_id` | String | GogLoginActivity$2 | GOG numeric user ID |
| `bh_gog_login_time` | Int | GogLoginActivity$2, GogTokenRefresh | Unix timestamp (seconds) of last token issue |
| `bh_gog_expires_in` | Int | GogLoginActivity$2, GogTokenRefresh | Token lifetime in seconds (3600) |
| `gog_dir_{gameId}` | String | GogDownloadManager$1 | `installDirectory` from build manifest |
| `gog_exe_{gameId}` | String | GogDownloadManager$1 | Absolute path to game exe |
| `gog_cover_{gameId}` | String | GogDownloadManager$1 | Absolute path to cover.jpg |
| `gog_gen_{gameId}` | String | GogDownloadManager$1 | `"1"` or `"2"` |

---

## 18. GOG API Reference

| Endpoint | Auth | Purpose |
|---|---|---|
| `https://auth.gog.com/auth?...` | None | Opens login WebView |
| `GET https://auth.gog.com/token?grant_type=authorization_code&...` | None | Exchange auth code for tokens |
| `GET https://auth.gog.com/token?grant_type=refresh_token&...` | None | Refresh access token |
| `GET https://embed.gog.com/user/data/games` | Bearer | Get owned game ID list |
| `GET https://api.gog.com/products/{id}?expand=downloads,description` | Bearer | Per-game metadata |
| `GET https://content-system.gog.com/products/{id}/os/windows/builds?generation=2` | Bearer | Gen 2 build manifest URL |
| `GET {buildLink}` | None | Zlib-compressed build manifest JSON |
| `GET https://gog-cdn-fastly.gog.com/content-system/v2/meta/{AA}/{BB}/{hash}` | None | Zlib-compressed depot meta (file+chunk list) |
| `GET https://content-system.gog.com/products/{id}/secure_link?generation=2&_version=2&path=/` | Bearer | Time-limited signed CDN base URL |
| `GET {cdnBaseUrl}/{AA}/{BB}/{compressedMd5}` | None | Individual file chunk download |

---

## 19. Smali Register Constraints and Solutions

### 4-bit register limit

All standard smali instructions (`invoke-virtual`, `invoke-direct`, `new-instance`, `iget-object`, `iput-object`, `move-object`, etc.) accept only **v0–v15**. This is a hard architectural limit of the DEX format for non-range instructions.

### v16 as a local

With `.locals 17`, registers are: v0–v16 as locals, p0=v17. v16 is a valid local but **cannot appear in any standard instruction**.

Valid uses of v16:
- `move-object/from16 v16, v13` — write TO v16 (8-bit destination, format `22x` — valid up to v255)
- `move-object/from16 v13, v16` — read FROM v16 into a 4-bit register
- `invoke-direct/range {v10 .. v16}` — range endpoint (uses 16-bit register index)

This is how the checkmark TextView ref is persisted across the card-build code in `GogGamesFragment$2`.

### Range invokes

When a constructor takes more than 5 args (filling v0–v15 completely), use `invoke-direct/range` with consecutive registers. The range instruction uses 16-bit register indices, so v16 is valid as the end of the range.

Example: `GogGamesFragment$8` constructor (7 args + new-instance = 8 regs) uses `{v6..v13}`.

### mul-int vs mul-int/lit8

`mul-int` (opcode 0x92, format `23x`) takes **three register operands** — cannot take an immediate. For multiplying by a small constant, use `mul-int/lit8` (opcode 0xd2, format `22b`) which takes two registers + an 8-bit immediate literal. Used in the download percentage calculation: `mul-int/lit8 v13, v9, 0x28` (fileIndex × 40).

### p0 in range invokes

With `.locals N`, `p0 = vN`. If `N > 15`, p0 is not 4-bit accessible. In `GogGamesFragment$5.onClick()` (`.locals 21`, p0=v21), a non-range `invoke-static {p0}` would fail. Solution: `invoke-static/range {p0 .. p0}`.

---

## 20. Progress Band Map

| Band | Progress value | Status text |
|---|---|---|
| Token check + builds fetch | 5% | "Fetching build info..." |
| Build manifest decompressed | 20% | "Reading manifest..." |
| All depot metas collected | 40% | "Reading depot..." |
| Secure CDN link obtained | 45% | "Preparing download..." |
| File download loop | 45%–85% | "Downloading: {filename} {pct}%" |
| Manifest written, chunks cleaned | 90% | "Finishing..." |
| Complete | 100% | "✓ Complete" |

---

## 21. DEX Placement

All GOG classes live in `patches/smali_classes16/`.

- `smali_classes9` — at 65535 DEX method index limit; do NOT add
- `smali_classes11` — near limit; do NOT add
- `smali_classes12` — **bypassed** in all 3 CI workflows (original `classes12.dex` extracted from base APK and zip-injected after rebuild; `smali_classes12/` deleted before apktool rebuild so it is never reassembled)
- `smali_classes16` — safe overflow DEX, used for all BannerHub additions

---

## 22. CI and Build Notes

The GOG feature adds no new external dependencies. All HTTP, JSON, file I/O, and decompression use Android framework classes or libraries already bundled in GameHub:

- `java.net.HttpURLConnection` — HTTP (no OkHttp obfuscation concern)
- `org.json.JSONObject` / `JSONArray` — Android framework, always available
- `java.util.zip.Inflater` — zlib decompression, Android framework
- `java.io.FileOutputStream` / `FileInputStream` — file I/O, Android framework
- `android.graphics.BitmapFactory` — image decode, Android framework

The CI workflow (`build.yml` for stable, `build-quick.yml` for pre-release) requires no changes for the GOG feature. All new smali files in `patches/smali_classes16/` are picked up automatically by the `Apply patches` step which runs `cp -r patches/* apktool_out/`.
