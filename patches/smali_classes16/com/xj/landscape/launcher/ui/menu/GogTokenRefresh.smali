.class public Lcom/xj/landscape/launcher/ui/menu/GogTokenRefresh;
.super Ljava/lang/Object;

# BannerHub: Static helper for silent GOG access token refresh.
# Reads refresh_token from bh_gog_prefs, POSTs grant_type=refresh_token
# to auth.gog.com/token, saves new access_token + refresh_token to SP,
# returns new access_token on success or null on failure/no refresh_token.


.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# ── static String refresh(Context ctx) ───────────────────────────────────────
# Returns new access_token string on success, null on any failure.
.method public static refresh(Landroid/content/Context;)Ljava/lang/String;
    .locals 12

    # v0–v11 used; p0 = context

    # ── Read refresh_token from SharedPreferences ─────────────────────────────
    const-string v0, "bh_gog_prefs"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0

    const-string v1, "refresh_token"
    const/4 v2, 0x0
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1  # refreshToken or null

    if-nez v1, :have_refresh_token

    const/4 v0, 0x0
    return-object v0  # no stored refresh_token → caller must re-login

    :have_refresh_token

    :try_start

    # ── Build POST body ───────────────────────────────────────────────────────
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "client_id=46899977096215655&client_secret=9d85c43b1482497dbbce61f6e4aa173a&grant_type=refresh_token&refresh_token="
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v2  # POST body string

    const-string v3, "UTF-8"
    invoke-virtual {v2, v3}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B
    move-result-object v3  # bodyBytes

    # ── Open connection ───────────────────────────────────────────────────────
    new-instance v4, Ljava/net/URL;
    const-string v5, "https://auth.gog.com/token"
    invoke-direct {v4, v5}, Ljava/net/URL;-><init>(Ljava/lang/String;)V
    invoke-virtual {v4}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;
    move-result-object v4
    check-cast v4, Ljava/net/HttpURLConnection;

    const-string v5, "POST"
    invoke-virtual {v4, v5}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V

    const/4 v5, 0x1
    invoke-virtual {v4, v5}, Ljava/net/HttpURLConnection;->setDoOutput(Z)V

    const-string v5, "Content-Type"
    const-string v6, "application/x-www-form-urlencoded"
    invoke-virtual {v4, v5, v6}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    const/16 v5, 0x3a98  # 15000 ms
    invoke-virtual {v4, v5}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V
    invoke-virtual {v4, v5}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    # ── Write POST body ───────────────────────────────────────────────────────
    invoke-virtual {v4}, Ljava/net/HttpURLConnection;->getOutputStream()Ljava/io/OutputStream;
    move-result-object v5
    invoke-virtual {v5, v3}, Ljava/io/OutputStream;->write([B)V
    invoke-virtual {v5}, Ljava/io/OutputStream;->close()V

    # ── Check HTTP status ─────────────────────────────────────────────────────
    invoke-virtual {v4}, Ljava/net/HttpURLConnection;->getResponseCode()I
    move-result v5
    const/16 v6, 0xC8  # 200
    if-eq v5, v6, :read_response

    invoke-virtual {v4}, Ljava/net/HttpURLConnection;->disconnect()V
    const/4 v0, 0x0
    return-object v0  # non-200 refresh response → return null

    :read_response

    # ── Read response body ────────────────────────────────────────────────────
    invoke-virtual {v4}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;
    move-result-object v5
    new-instance v6, Ljava/io/InputStreamReader;
    const-string v7, "UTF-8"
    invoke-direct {v6, v5, v7}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/lang/String;)V
    new-instance v7, Ljava/io/BufferedReader;
    invoke-direct {v7, v6}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V
    new-instance v8, Ljava/lang/StringBuilder;
    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    :read_loop
    invoke-virtual {v7}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;
    move-result-object v9
    if-eqz v9, :read_done
    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    goto :read_loop

    :read_done
    invoke-virtual {v7}, Ljava/io/BufferedReader;->close()V
    invoke-virtual {v4}, Ljava/net/HttpURLConnection;->disconnect()V
    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v8  # JSON response body

    # ── Parse new access_token ────────────────────────────────────────────────
    const-string v9, "access_token"
    invoke-static {v8, v9}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;->parseJsonStringField(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v9  # new access_token or null

    if-nez v9, :got_access_token

    const/4 v0, 0x0
    return-object v0  # no access_token in response

    :got_access_token

    # ── Parse new refresh_token ───────────────────────────────────────────────
    const-string v10, "refresh_token"
    invoke-static {v8, v10}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;->parseJsonStringField(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v10  # new refresh_token (may be null if not rotated)

    # ── Save new tokens to SharedPreferences ──────────────────────────────────
    const-string v11, "bh_gog_prefs"
    const/4 v5, 0x0
    invoke-virtual {p0, v11, v5}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v5

    invoke-interface {v5}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v5

    const-string v6, "access_token"
    invoke-interface {v5, v6, v9}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    move-result-object v5

    if-eqz v10, :skip_refresh_save

    const-string v6, "refresh_token"
    invoke-interface {v5, v6, v10}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    move-result-object v5

    :skip_refresh_save

    invoke-interface {v5}, Landroid/content/SharedPreferences$Editor;->apply()V

    return-object v9  # return new access_token

    :try_end

    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_all

    :catch_all
    const/4 v0, 0x0
    return-object v0

.end method
