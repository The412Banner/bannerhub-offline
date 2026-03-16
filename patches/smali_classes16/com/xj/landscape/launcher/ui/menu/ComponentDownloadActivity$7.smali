# AllReleasesRunnable — background: GET GitHub releases API (all releases, per_page=100),
#                       collect all .wcp/.zip/.xz assets across every release,
#                       name format: "tagName / assetName",
#                       populate mAllNames/mAllUrls, post $2 (showCategories on UI thread)
.class final Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$7;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

.field final this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;
.field final val$url:Ljava/lang/String;

.method constructor <init>(Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;Ljava/lang/String;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$7;->this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$7;->val$url:Ljava/lang/String;
    return-void
.end method

.method public run()V
    .locals 20
    # v0=outer  v1,v2=temp strings  v3=HttpURLConnection
    # v4=reader/stream temp  v5=StringBuilder→responseStr
    # v6=releases JSONArray  v7=release count  v8=release index
    # v9=release JSONObject  v10=tag_name
    # v11=assets JSONArray  v12=asset count  v13=asset index
    # v14=asset JSONObject  v15=asset name  v16=asset url
    # v17=mAllNames  v18=mAllUrls  v19=label StringBuilder

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$7;->this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;

    :try_start

    # open HTTP connection to val$url
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$7;->val$url:Ljava/lang/String;
    new-instance v2, Ljava/net/URL;
    invoke-direct {v2, v1}, Ljava/net/URL;-><init>(Ljava/lang/String;)V
    invoke-virtual {v2}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;
    move-result-object v3
    check-cast v3, Ljava/net/HttpURLConnection;

    const-string v1, "GET"
    invoke-virtual {v3, v1}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V
    const v1, 0x3a98
    invoke-virtual {v3, v1}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V
    invoke-virtual {v3, v1}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V
    const-string v1, "User-Agent"
    const-string v2, "BannerHub/1.0"
    invoke-virtual {v3, v1, v2}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    # read response into StringBuilder
    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;
    move-result-object v4
    new-instance v5, Ljava/io/InputStreamReader;
    invoke-direct {v5, v4}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;)V
    new-instance v4, Ljava/io/BufferedReader;
    invoke-direct {v4, v5}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    :read_loop
    invoke-virtual {v4}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;
    move-result-object v1
    if-eqz v1, :read_done
    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    goto :read_loop
    :read_done
    invoke-virtual {v4}, Ljava/io/BufferedReader;->close()V

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5

    # parse releases JSONArray
    new-instance v6, Lorg/json/JSONArray;
    invoke-direct {v6, v5}, Lorg/json/JSONArray;-><init>(Ljava/lang/String;)V

    invoke-virtual {v6}, Lorg/json/JSONArray;->length()I
    move-result v7
    const/4 v8, 0x0

    iget-object v17, v0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->mAllNames:Ljava/util/ArrayList;
    iget-object v18, v0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->mAllUrls:Ljava/util/ArrayList;

    # outer loop: iterate all releases
    :release_loop
    if-ge v8, v7, :release_done

    invoke-virtual {v6, v8}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;
    move-result-object v9

    # v10 = tag_name
    const-string v1, "tag_name"
    invoke-virtual {v9, v1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v10

    # v11 = assets array
    const-string v1, "assets"
    invoke-virtual {v9, v1}, Lorg/json/JSONObject;->getJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;
    move-result-object v11

    invoke-virtual {v11}, Lorg/json/JSONArray;->length()I
    move-result v12
    const/4 v13, 0x0

    # inner loop: iterate assets for this release
    :asset_loop
    if-ge v13, v12, :asset_done

    invoke-virtual {v11, v13}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;
    move-result-object v14

    # v15 = asset name
    const-string v1, "name"
    invoke-virtual {v14, v1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v15

    # accept .wcp, .zip, .xz only
    const-string v1, ".wcp"
    invoke-virtual {v15, v1}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v1
    if-nez v1, :accept_asset
    const-string v1, ".zip"
    invoke-virtual {v15, v1}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v1
    if-nez v1, :accept_asset
    const-string v1, ".xz"
    invoke-virtual {v15, v1}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v1
    if-eqz v1, :skip_asset

    :accept_asset
    # v16 = browser_download_url
    const-string v1, "browser_download_url"
    invoke-virtual {v14, v1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v16

    # build label: "tagName / assetName"
    new-instance v19, Ljava/lang/StringBuilder;
    invoke-direct {v19}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v19, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v1, " / "
    invoke-virtual {v19, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v19, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v19}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v2

    invoke-virtual {v17, v2}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z
    invoke-virtual {v18, v16}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    :skip_asset
    add-int/lit8 v13, v13, 0x1
    goto :asset_loop

    :asset_done
    add-int/lit8 v8, v8, 0x1
    goto :release_loop

    :release_done

    # post $2 to UI thread — calls showCategories()
    new-instance v1, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$2;
    invoke-direct {v1, v0}, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$2;-><init>(Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;)V
    invoke-virtual {v0, v1}, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    :try_end
    return-void

    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_fetch

    :catch_fetch
    move-exception v1
    invoke-virtual {v1}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;
    move-result-object v1
    if-nez v1, :has_err_msg
    const-string v1, "Unknown error"
    :has_err_msg
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "Fetch failed: "
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1
    new-instance v2, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$4;
    invoke-direct {v2, v0, v1}, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$4;-><init>(Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;Ljava/lang/String;)V
    invoke-virtual {v0, v2}, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->runOnUiThread(Ljava/lang/Runnable;)V
    return-void
.end method
