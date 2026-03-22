.class public final Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$1;
.super Ljava/lang/Object;

# BannerHub: Background fetch Runnable for GogGamesFragment.
# Two-step library sync:
#   Step 1: GET embed.gog.com/user/data/games -> {"owned":[id1, id2, ...]}
#   Step 2: per ID -> GET api.gog.com/products/{id}?expand=downloads,description
#           -> extract title, slug->storeUrl, images.logo2x->imageUrl,
#              description.lead->description (fallback .full), developers[0]->developer,
#              genres[0].name->category
# Filters: skip ID 1801418160, is_secret=true, game_type="dlc", empty title
# Posts ArrayList<GogGame> to main thread via GogGamesFragment$2.
# On auth failure: clears bh_gog_prefs tokens, posts null.
# On per-product JSON parse error: skips that product, continues loop.
#
# Register layout (.locals 16, p0=v16):
#   v0  = GogGamesFragment
#   v1  = access_token (updated after refresh)
#   v2  = ArrayList<GogGame> result
#   v3  = HttpURLConnection (step1 + per-product), then JSONObject (per-product)
#   v4  = scratch (int, String, boolean, nested JSONObject/Array)
#   v5  = scratch (String, InputStreamReader, StringBuilder)
#   v6  = scratch (BufferedReader, String)
#   v7  = response body String (step1 then per-product, sequentially)
#   v8  = JSONArray "owned" (PERSISTENT through loop)
#   v9  = loop index
#   v10 = game ID String (owned[v9])
#   v11 = GogGame being constructed
#   v12 = description String (per product)
#   v13 = developer String (per product)
#   v14 = category String (per product)
#   v15 = loop length (PERSISTENT); also used to bridge p0 at start

.implements Ljava/lang/Runnable;

.field public final a:Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;
.field public final b:Ljava/lang/String;  # accessToken


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$1;->a:Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$1;->b:Ljava/lang/String;

    return-void
.end method


.method public run()V
    .locals 16

    # p0=v16 -- too high for 4-bit register ops; bridge via v15 at start
    move-object/from16 v15, p0
    iget-object v0, v15, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$1;->a:Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;
    iget-object v1, v15, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$1;->b:Ljava/lang/String;

    new-instance v2, Ljava/util/ArrayList;
    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    :try_start

    # ---- PROACTIVE TOKEN EXPIRY CHECK (Task #4) -----------------------------
    # Read loginTime + expiresIn from bh_gog_prefs.
    # If currentTime >= loginTime + expiresIn, refresh silently before first call.
    # loginTime=0 means token was saved before beta23 tracking — treat as expired.
    invoke-virtual {v0}, Landroidx/fragment/app/Fragment;->getContext()Landroid/content/Context;
    move-result-object v3
    if-eqz v3, :expiry_skip

    const-string v4, "bh_gog_prefs"
    const/4 v5, 0x0
    invoke-virtual {v3, v4, v5}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v4

    const-string v5, "bh_gog_login_time"
    const/4 v6, 0x0
    invoke-interface {v4, v5, v6}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I
    move-result v5   # v5 = loginTime (0 if never stored)

    const-string v6, "bh_gog_expires_in"
    const/16 v7, 0xE10   # 3600 default
    invoke-interface {v4, v6, v7}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I
    move-result v6   # v6 = expiresIn

    add-int v7, v5, v6   # v7 = loginTime + expiresIn

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J
    move-result-wide v8   # v8+v9 = millis
    const-wide/16 v10, 0x3E8   # v10+v11 = 1000L
    div-long v8, v8, v10
    long-to-int v8, v8   # v8 = current unix seconds

    if-lt v8, v7, :expiry_skip   # not expired yet

    # Token expired (or loginTime=0) — refresh now
    invoke-static {v3}, Lcom/xj/landscape/launcher/ui/menu/GogTokenRefresh;->refresh(Landroid/content/Context;)Ljava/lang/String;
    move-result-object v5
    if-eqz v5, :expiry_skip   # refresh failed — proceed; API 401 will retry anyway
    move-object v1, v5   # update token with fresh one

    :expiry_skip
    # ---- END PROACTIVE CHECK ------------------------------------------------

    # ---- STEP 1: GET embed.gog.com/user/data/games --------------------------
    new-instance v3, Ljava/net/URL;
    const-string v4, "https://embed.gog.com/user/data/games"
    invoke-direct {v3, v4}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;
    move-result-object v3
    check-cast v3, Ljava/net/HttpURLConnection;

    const/16 v4, 0x3a98
    invoke-virtual {v3, v4}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V
    invoke-virtual {v3, v4}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    const-string v4, "Authorization"
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V
    const-string v6, "Bearer "
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5
    invoke-virtual {v3, v4, v5}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->getResponseCode()I
    move-result v4
    const/16 v5, 0xC8
    if-eq v4, v5, :step1_ok

    # Non-200: try silent token refresh before clearing session
    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->disconnect()V

    invoke-virtual {v0}, Landroidx/fragment/app/Fragment;->getContext()Landroid/content/Context;
    move-result-object v4
    if-eqz v4, :clear_tokens

    invoke-static {v4}, Lcom/xj/landscape/launcher/ui/menu/GogTokenRefresh;->refresh(Landroid/content/Context;)Ljava/lang/String;
    move-result-object v5
    if-eqz v5, :clear_tokens

    # Refresh succeeded -- retry step 1 with new token
    move-object v1, v5

    new-instance v3, Ljava/net/URL;
    const-string v6, "https://embed.gog.com/user/data/games"
    invoke-direct {v3, v6}, Ljava/net/URL;-><init>(Ljava/lang/String;)V
    invoke-virtual {v3}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;
    move-result-object v3
    check-cast v3, Ljava/net/HttpURLConnection;

    const/16 v6, 0x3a98
    invoke-virtual {v3, v6}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V
    invoke-virtual {v3, v6}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    const-string v6, "Authorization"
    new-instance v7, Ljava/lang/StringBuilder;
    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "Bearer "
    invoke-virtual {v7, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v7, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v7
    invoke-virtual {v3, v6, v7}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->getResponseCode()I
    move-result v6
    const/16 v7, 0xC8
    if-eq v6, v7, :step1_ok

    # Retry also non-200 -- fall through to clear tokens
    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->disconnect()V

    :clear_tokens
    invoke-virtual {v0}, Landroidx/fragment/app/Fragment;->getContext()Landroid/content/Context;
    move-result-object v4
    if-eqz v4, :expired_done
    const-string v5, "bh_gog_prefs"
    const/4 v6, 0x0
    invoke-virtual {v4, v5, v6}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v5
    invoke-interface {v5}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v5
    const-string v6, "access_token"
    invoke-interface {v5, v6}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    move-result-object v5
    const-string v6, "refresh_token"
    invoke-interface {v5, v6}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    move-result-object v5
    invoke-interface {v5}, Landroid/content/SharedPreferences$Editor;->apply()V
    :expired_done
    const/4 v2, 0x0
    goto :post_ui

    :step1_ok
    # Read step 1 response body
    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;
    move-result-object v4
    new-instance v5, Ljava/io/InputStreamReader;
    const-string v6, "UTF-8"
    invoke-direct {v5, v4, v6}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/lang/String;)V
    new-instance v6, Ljava/io/BufferedReader;
    invoke-direct {v6, v5}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    :step1_read
    invoke-virtual {v6}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;
    move-result-object v4
    if-eqz v4, :step1_read_done
    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    goto :step1_read

    :step1_read_done
    invoke-virtual {v6}, Ljava/io/BufferedReader;->close()V
    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->disconnect()V
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v7   # v7 = step1 JSON: {"owned":[...]}

    # Parse owned array from step 1 JSON
    new-instance v3, Lorg/json/JSONObject;
    invoke-direct {v3, v7}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    const-string v4, "owned"
    invoke-virtual {v3, v4}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;
    move-result-object v8   # v8 = owned JSONArray (PERSISTENT through loop)

    if-eqz v8, :loop_done

    invoke-virtual {v8}, Lorg/json/JSONArray;->length()I
    move-result v15         # v15 = loop length (PERSISTENT)

    const/4 v9, 0x0         # v9 = loop index

    :game_loop
    if-ge v9, v15, :loop_done

    # Get game ID string (numeric IDs are auto-converted to String by optString)
    invoke-virtual {v8, v9}, Lorg/json/JSONArray;->optString(I)Ljava/lang/String;
    move-result-object v10  # v10 = game ID

    # Skip empty ID
    invoke-virtual {v10}, Ljava/lang/String;->isEmpty()Z
    move-result v4
    if-nez v4, :loop_next

    # Skip known internal/secret ID
    const-string v4, "1801418160"
    invoke-virtual {v10, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v4
    if-nez v4, :loop_next

    # ---- STEP 2: GET api.gog.com/products/{id}?expand=downloads,description -
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "https://api.gog.com/products/"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v4, "?expand=downloads,description"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4   # v4 = product URL

    new-instance v3, Ljava/net/URL;
    invoke-direct {v3, v4}, Ljava/net/URL;-><init>(Ljava/lang/String;)V
    invoke-virtual {v3}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;
    move-result-object v3
    check-cast v3, Ljava/net/HttpURLConnection;

    const/16 v4, 0x3a98
    invoke-virtual {v3, v4}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V
    invoke-virtual {v3, v4}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    const-string v4, "Authorization"
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V
    const-string v6, "Bearer "
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5
    invoke-virtual {v3, v4, v5}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->getResponseCode()I
    move-result v4
    const/16 v5, 0xC8
    if-eq v4, v5, :product_ok

    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->disconnect()V
    goto :loop_next

    :product_ok
    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;
    move-result-object v4
    new-instance v5, Ljava/io/InputStreamReader;
    const-string v6, "UTF-8"
    invoke-direct {v5, v4, v6}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/lang/String;)V
    new-instance v6, Ljava/io/BufferedReader;
    invoke-direct {v6, v5}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    :product_read
    invoke-virtual {v6}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;
    move-result-object v4
    if-eqz v4, :product_read_done
    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    goto :product_read

    :product_read_done
    invoke-virtual {v6}, Ljava/io/BufferedReader;->close()V
    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->disconnect()V
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v7   # v7 = product JSON

    # ---- PARSE PRODUCT JSON -------------------------------------------------
    # Try block: only the JSONObject constructor can throw JSONException.
    # On failure, skip this product and continue loop.
    :try_product_start
    new-instance v3, Lorg/json/JSONObject;
    invoke-direct {v3, v7}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V
    :try_product_end

    # Skip secret games (is_secret=true)
    const-string v4, "is_secret"
    const/4 v5, 0x0
    invoke-virtual {v3, v4, v5}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;Z)Z
    move-result v4
    if-nez v4, :loop_next

    # Skip DLCs
    const-string v4, "game_type"
    const-string v5, ""
    invoke-virtual {v3, v4, v5}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v4
    const-string v5, "dlc"
    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v4
    if-nez v4, :loop_next

    # title (skip if empty)
    const-string v4, "title"
    const-string v5, ""
    invoke-virtual {v3, v4, v5}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v5   # v5 = title
    invoke-virtual {v5}, Ljava/lang/String;->isEmpty()Z
    move-result v4
    if-nez v4, :loop_next

    # Build GogGame
    new-instance v11, Lcom/xj/landscape/launcher/ui/menu/GogGame;
    invoke-direct {v11}, Lcom/xj/landscape/launcher/ui/menu/GogGame;-><init>()V
    iput-object v10, v11, Lcom/xj/landscape/launcher/ui/menu/GogGame;->gameId:Ljava/lang/String;
    iput-object v5, v11, Lcom/xj/landscape/launcher/ui/menu/GogGame;->title:Ljava/lang/String;

    # storeUrl: "https://www.gog.com/game/{slug}"
    const-string v4, "slug"
    const-string v5, ""
    invoke-virtual {v3, v4, v5}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v4   # v4 = slug
    invoke-virtual {v4}, Ljava/lang/String;->isEmpty()Z
    move-result v5
    if-nez v5, :no_store_url
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V
    const-string v6, "https://www.gog.com/game/"
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4
    iput-object v4, v11, Lcom/xj/landscape/launcher/ui/menu/GogGame;->storeUrl:Ljava/lang/String;
    :no_store_url

    # imageUrl from images.logo2x (protocol-relative "//images-4.gog.com/...")
    const-string v4, "images"
    invoke-virtual {v3, v4}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;
    move-result-object v4   # v4 = images obj
    if-eqz v4, :no_image
    const-string v5, "logo2x"
    const-string v6, ""
    invoke-virtual {v4, v5, v6}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v5   # v5 = raw logo2x
    invoke-virtual {v5}, Ljava/lang/String;->isEmpty()Z
    move-result v4
    if-nez v4, :no_image

    # Unescape "\/" -> "/"
    const-string v6, "\\/"
    const-string v4, "/"
    invoke-virtual {v5, v6, v4}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;
    move-result-object v5

    # Append CDN suffix if no file extension
    const-string v6, ".jpg"
    invoke-virtual {v5, v6}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v4
    if-nez v4, :img_has_ext
    const-string v6, ".webp"
    invoke-virtual {v5, v6}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v4
    if-nez v4, :img_has_ext
    const-string v6, ".png"
    invoke-virtual {v5, v6}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v4
    if-nez v4, :img_has_ext
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v6, "_product_card_v2_mobile_slider_639.jpg"
    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5
    :img_has_ext

    # Prepend "https:" to protocol-relative URL
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V
    const-string v6, "https:"
    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4
    iput-object v4, v11, Lcom/xj/landscape/launcher/ui/menu/GogGame;->imageUrl:Ljava/lang/String;
    :no_image

    # description: prefer description.lead (plain text), fallback to description.full (HTML)
    const-string v4, "description"
    invoke-virtual {v3, v4}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;
    move-result-object v4   # v4 = description obj
    if-eqz v4, :no_desc
    const-string v5, "lead"
    const-string v6, ""
    invoke-virtual {v4, v5, v6}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v12  # v12 = lead
    invoke-virtual {v12}, Ljava/lang/String;->isEmpty()Z
    move-result v5
    if-eqz v5, :desc_ready  # not empty -> use lead
    # lead empty -- try full
    const-string v5, "full"
    const-string v6, ""
    invoke-virtual {v4, v5, v6}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v12  # v12 = full HTML
    invoke-virtual {v12}, Ljava/lang/String;->isEmpty()Z
    move-result v5
    if-nez v5, :no_desc
    :desc_ready
    iput-object v12, v11, Lcom/xj/landscape/launcher/ui/menu/GogGame;->description:Ljava/lang/String;
    :no_desc

    # developer from developers[0]
    const-string v4, "developers"
    invoke-virtual {v3, v4}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;
    move-result-object v4   # v4 = developers array
    if-eqz v4, :no_dev
    invoke-virtual {v4}, Lorg/json/JSONArray;->length()I
    move-result v5
    if-lez v5, :no_dev
    const/4 v5, 0x0
    invoke-virtual {v4, v5}, Lorg/json/JSONArray;->optString(I)Ljava/lang/String;
    move-result-object v13  # v13 = developer
    invoke-virtual {v13}, Ljava/lang/String;->isEmpty()Z
    move-result v4
    if-nez v4, :no_dev
    iput-object v13, v11, Lcom/xj/landscape/launcher/ui/menu/GogGame;->developer:Ljava/lang/String;
    :no_dev

    # category from genres[0].name
    const-string v4, "genres"
    invoke-virtual {v3, v4}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;
    move-result-object v4   # v4 = genres array
    if-eqz v4, :no_cat
    invoke-virtual {v4}, Lorg/json/JSONArray;->length()I
    move-result v5
    if-lez v5, :no_cat
    const/4 v5, 0x0
    invoke-virtual {v4, v5}, Lorg/json/JSONArray;->optJSONObject(I)Lorg/json/JSONObject;
    move-result-object v4   # v4 = first genre object
    if-eqz v4, :no_cat
    const-string v5, "name"
    const-string v6, ""
    invoke-virtual {v4, v5, v6}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v14  # v14 = category
    invoke-virtual {v14}, Ljava/lang/String;->isEmpty()Z
    move-result v4
    if-nez v4, :no_cat
    iput-object v14, v11, Lcom/xj/landscape/launcher/ui/menu/GogGame;->category:Ljava/lang/String;
    :no_cat

    # ── fileSize: downloads.installers[N] where os=windows → total_size (long) ─
    const-string v4, "downloads"
    invoke-virtual {v3, v4}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;
    move-result-object v4
    if-eqz v4, :no_filesize

    const-string v5, "installers"
    invoke-virtual {v4, v5}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;
    move-result-object v4
    if-eqz v4, :no_filesize

    const/4 v5, 0x0
    :fsize_loop
    invoke-virtual {v4}, Lorg/json/JSONArray;->length()I
    move-result v12
    if-ge v5, v12, :no_filesize

    invoke-virtual {v4, v5}, Lorg/json/JSONArray;->optJSONObject(I)Lorg/json/JSONObject;
    move-result-object v12
    if-eqz v12, :fsize_next

    const-string v13, "os"
    const-string v14, ""
    invoke-virtual {v12, v13, v14}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v13
    const-string v14, "windows"
    invoke-virtual {v13, v14}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z
    move-result v13
    if-eqz v13, :fsize_next

    const-string v13, "total_size"
    const-wide/16 v6, 0x0
    invoke-virtual {v12, v13, v6, v7}, Lorg/json/JSONObject;->optLong(Ljava/lang/String;J)J
    move-result-wide v6
    iput-wide v6, v11, Lcom/xj/landscape/launcher/ui/menu/GogGame;->fileSize:J
    goto :no_filesize

    :fsize_next
    add-int/lit8 v5, v5, 0x1
    goto :fsize_loop

    :no_filesize

    invoke-virtual {v2, v11}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    # ── Gen 1 vs Gen 2 detection: probe builds?generation=2 per game ──────────
    # Stores gog_gen_{gameId} = 2 (Gen 2 available) or 1 (Gen 1 only)
    const/16 v11, 0x1  # default = Gen 1
    const/4 v4, 0x0    # null connection guard

    :try_gen_start
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "https://api.gog.com/v2/games/"
    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v5, "/builds?generation=2&system=windows"
    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3

    new-instance v5, Ljava/net/URL;
    invoke-direct {v5, v3}, Ljava/net/URL;-><init>(Ljava/lang/String;)V
    invoke-virtual {v5}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;
    move-result-object v4
    check-cast v4, Ljava/net/HttpURLConnection;

    const/16 v3, 0x3a98
    invoke-virtual {v4, v3}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V
    invoke-virtual {v4, v3}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    const-string v3, "Authorization"
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V
    const-string v6, "Bearer "
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5
    invoke-virtual {v4, v3, v5}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v4}, Ljava/net/HttpURLConnection;->getResponseCode()I
    move-result v3
    const/16 v5, 0xC8
    if-ne v3, v5, :gen_parse_done  # non-200 → keep Gen 1

    invoke-virtual {v4}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;
    move-result-object v5
    new-instance v6, Ljava/io/InputStreamReader;
    const-string v3, "UTF-8"
    invoke-direct {v6, v5, v3}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/lang/String;)V
    new-instance v5, Ljava/io/BufferedReader;
    invoke-direct {v5, v6}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V
    new-instance v6, Ljava/lang/StringBuilder;
    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    :gen_read
    invoke-virtual {v5}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;
    move-result-object v3
    if-eqz v3, :gen_read_done
    invoke-virtual {v6, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    goto :gen_read

    :gen_read_done
    invoke-virtual {v5}, Ljava/io/BufferedReader;->close()V
    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v7

    new-instance v3, Lorg/json/JSONObject;
    invoke-direct {v3, v7}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V
    const-string v5, "items"
    invoke-virtual {v3, v5}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;
    move-result-object v3
    if-eqz v3, :gen_parse_done
    invoke-virtual {v3}, Lorg/json/JSONArray;->length()I
    move-result v3
    if-lez v3, :gen_parse_done
    const/16 v11, 0x2  # Gen 2 confirmed

    :gen_parse_done
    :try_gen_end

    :gen_check_done
    if-eqz v4, :gen_store
    invoke-virtual {v4}, Ljava/net/HttpURLConnection;->disconnect()V

    :gen_store
    invoke-virtual {v0}, Landroidx/fragment/app/Fragment;->getContext()Landroid/content/Context;
    move-result-object v3
    if-eqz v3, :gen_store_done

    const-string v5, "bh_gog_prefs"
    const/4 v6, 0x0
    invoke-virtual {v3, v5, v6}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v5

    invoke-interface {v5}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v5

    new-instance v6, Ljava/lang/StringBuilder;
    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V
    const-string v7, "gog_gen_"
    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v6

    invoke-interface {v5, v6, v11}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;
    move-result-object v5
    invoke-interface {v5}, Landroid/content/SharedPreferences$Editor;->apply()V

    :gen_store_done

    :loop_next
    add-int/lit8 v9, v9, 0x1
    goto :game_loop

    :loop_done

    :try_end

    :post_ui
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;
    move-result-object v3

    new-instance v4, Landroid/os/Handler;
    invoke-direct {v4, v3}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    new-instance v3, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$2;
    invoke-direct {v3, v0, v2}, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$2;-><init>(Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;Ljava/util/ArrayList;)V

    invoke-virtual {v4, v3}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void

    # Outer catch: network/IO errors -> post empty list
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_all

    # Inner catch: bad product JSON -> skip that product, continue loop
    .catch Ljava/lang/Exception; {:try_product_start .. :try_product_end} :loop_next

    # Inner catch: gen-check HTTP/JSON error -> skip gen store, continue loop
    .catch Ljava/lang/Exception; {:try_gen_start .. :try_gen_end} :gen_check_done

    :catch_all
    goto :post_ui

.end method
