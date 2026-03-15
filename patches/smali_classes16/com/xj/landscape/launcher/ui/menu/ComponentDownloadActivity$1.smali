# FetchRunnable — background: GET GitHub releases API, find latest nightly, populate mNames/mUrls, post $2
.class final Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$1;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

.field final this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;

.method constructor <init>(Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$1;->this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;
    return-void
.end method

.method public run()V
    .locals 10
    # v0=outer  v1=reuse(url/filter/download_url)  v2=HttpURLConnection
    # v3=reuse(requestMethod/InputStream/assets/tag_name)  v4=reuse(BR/startsWith/assetsLen)
    # v5=reuse(ISR/SB/response/assetCounter)  v6=reuse(line/JSONArray(releases)/mNames)
    # v7=reuse(releases.length/mUrls)  v8=reuse(searchCounter/assetJSONObj)
    # v9=reuse(releaseJSONObj/assetName)

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$1;->this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;

    :try_start

    # Open HTTP connection
    const-string v1, "https://api.github.com/repos/The412Banner/Nightlies/releases?per_page=10"
    new-instance v2, Ljava/net/URL;
    invoke-direct {v2, v1}, Ljava/net/URL;-><init>(Ljava/lang/String;)V
    invoke-virtual {v2}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;
    move-result-object v2
    check-cast v2, Ljava/net/HttpURLConnection;

    const-string v3, "GET"
    invoke-virtual {v2, v3}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V
    const v3, 0x3a98
    invoke-virtual {v2, v3}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V
    invoke-virtual {v2, v3}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V
    const-string v3, "User-Agent"
    const-string v1, "BannerHub/1.0"
    invoke-virtual {v2, v3, v1}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    # Read response into StringBuilder
    invoke-virtual {v2}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;
    move-result-object v3

    new-instance v5, Ljava/io/InputStreamReader;
    invoke-direct {v5, v3}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;)V
    new-instance v4, Ljava/io/BufferedReader;
    invoke-direct {v4, v5}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    :read_loop
    invoke-virtual {v4}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;
    move-result-object v6
    if-eqz v6, :read_done
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    goto :read_loop

    :read_done
    invoke-virtual {v4}, Ljava/io/BufferedReader;->close()V

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5

    # Parse releases JSONArray
    new-instance v6, Lorg/json/JSONArray;
    invoke-direct {v6, v5}, Lorg/json/JSONArray;-><init>(Ljava/lang/String;)V

    invoke-virtual {v6}, Lorg/json/JSONArray;->length()I
    move-result v7
    const/4 v8, 0x0

    # Find first release with tag starting with "nightly-"
    :search_loop
    if-ge v8, v7, :search_done
    invoke-virtual {v6, v8}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;
    move-result-object v9
    const-string v3, "tag_name"
    invoke-virtual {v9, v3}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    const-string v4, "nightly-"
    invoke-virtual {v3, v4}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v4
    if-eqz v4, :not_nightly
    goto :found_nightly
    :not_nightly
    add-int/lit8 v8, v8, 0x1
    goto :search_loop

    :search_done
    # no nightly found — mNames/mUrls stay empty
    goto :post_show

    :found_nightly
    # v9 = nightly release JSONObject
    const-string v3, "assets"
    invoke-virtual {v9, v3}, Lorg/json/JSONObject;->getJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;
    move-result-object v3

    invoke-virtual {v3}, Lorg/json/JSONArray;->length()I
    move-result v4
    const/4 v5, 0x0

    iget-object v6, v0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->mNames:Ljava/util/ArrayList;
    iget-object v7, v0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->mUrls:Ljava/util/ArrayList;

    :asset_loop
    if-ge v5, v4, :asset_done

    invoke-virtual {v3, v5}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;
    move-result-object v8
    const-string v9, "name"
    invoke-virtual {v8, v9}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v9

    # accept .wcp, .zip, .xz
    const-string v1, ".wcp"
    invoke-virtual {v9, v1}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v1
    if-nez v1, :accept_asset

    const-string v1, ".zip"
    invoke-virtual {v9, v1}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v1
    if-nez v1, :accept_asset

    const-string v1, ".xz"
    invoke-virtual {v9, v1}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v1
    if-eqz v1, :skip_asset

    :accept_asset
    const-string v1, "browser_download_url"
    invoke-virtual {v8, v1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    invoke-virtual {v6, v9}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z
    invoke-virtual {v7, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    :skip_asset
    add-int/lit8 v5, v5, 0x1
    goto :asset_loop

    :asset_done

    :post_show
    new-instance v3, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$2;
    invoke-direct {v3, v0}, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$2;-><init>(Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;)V
    invoke-virtual {v0, v3}, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    :try_end
    return-void

    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_fetch

    :catch_fetch
    move-exception v3
    invoke-virtual {v3}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;
    move-result-object v3
    if-nez v3, :has_err_msg
    const-string v3, "Unknown error"
    :has_err_msg
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "Fetch failed: "
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    new-instance v4, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$4;
    invoke-direct {v4, v0, v3}, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$4;-><init>(Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;Ljava/lang/String;)V
    invoke-virtual {v0, v4}, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->runOnUiThread(Ljava/lang/Runnable;)V
    return-void
.end method
