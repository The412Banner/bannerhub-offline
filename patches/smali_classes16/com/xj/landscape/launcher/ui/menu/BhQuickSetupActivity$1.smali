# BhQuickSetupActivity$1 — InstallRunnable
# Background thread: download WCP to cacheDir → inject via ComponentInjectorHelper
# → write SP keys → post $2 (success) or $3 (error) on UI thread
# Constructor: (outer, url, type, index)

.class final Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$1;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

.field final this$0:Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;
.field final val$url:Ljava/lang/String;
.field final val$type:I
.field final val$index:I

.method constructor <init>(Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;Ljava/lang/String;II)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$1;->this$0:Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$1;->val$url:Ljava/lang/String;
    iput p3, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$1;->val$type:I
    iput p4, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$1;->val$index:I
    return-void
.end method

.method public run()V
    .locals 9
    # v0=outer  v1=url  v2=filename  v3=destFile/reuse
    # v4=HttpURLConnection/reuse  v5=InputStream/FileOutputStream
    # v6=buf  v7=bytesRead  v8=uri

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$1;->this$0:Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$1;->val$url:Ljava/lang/String;

    :try_start

    # v2 = filename = last path segment of URL
    const/16 v3, 0x2f   # '/'
    invoke-virtual {v1, v3}, Ljava/lang/String;->lastIndexOf(I)I
    move-result v3
    add-int/lit8 v3, v3, 0x1
    invoke-virtual {v1, v3}, Ljava/lang/String;->substring(I)Ljava/lang/String;
    move-result-object v2   # v2 = filename

    # v3 = destFile = cacheDir/filename
    invoke-virtual {v0}, Landroid/content/Context;->getCacheDir()Ljava/io/File;
    move-result-object v3
    new-instance v3, Ljava/io/File;    # will be init'd below
    invoke-virtual {v0}, Landroid/content/Context;->getCacheDir()Ljava/io/File;
    move-result-object v4
    invoke-direct {v3, v4, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    # v3 = destFile

    # Open HTTP connection
    new-instance v4, Ljava/net/URL;
    invoke-direct {v4, v1}, Ljava/net/URL;-><init>(Ljava/lang/String;)V
    invoke-virtual {v4}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;
    move-result-object v4
    check-cast v4, Ljava/net/HttpURLConnection;
    const v5, 0x7530   # 30s timeout
    invoke-virtual {v4, v5}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V
    invoke-virtual {v4, v5}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V
    invoke-virtual {v4}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;
    move-result-object v5   # v5 = InputStream

    # Write to destFile
    new-instance v6, Ljava/io/FileOutputStream;
    invoke-direct {v6, v3}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    # 8KB buffer
    const/16 v8, 0x2000
    new-array v8, v8, [B
    :copy_loop
    invoke-virtual {v5, v8}, Ljava/io/InputStream;->read([B)I
    move-result v7
    if-lez v7, :copy_done
    const/4 v4, 0x0   # offset = 0
    invoke-virtual {v6, v8, v4, v7}, Ljava/io/OutputStream;->write([BII)V
    goto :copy_loop
    :copy_done
    invoke-virtual {v5}, Ljava/io/InputStream;->close()V
    invoke-virtual {v6}, Ljava/io/FileOutputStream;->close()V

    # Post $2 (success) to UI thread — injection happens on UI thread (needs Looper)
    invoke-static {v3}, Landroid/net/Uri;->fromFile(Ljava/io/File;)Landroid/net/Uri;
    move-result-object v8   # v8 = Uri

    iget v5, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$1;->val$type:I
    iget v6, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$1;->val$index:I

    new-instance v4, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$2;
    invoke-direct {v4, v0, v8, v5, v2, v6}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$2;-><init>(Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;Landroid/net/Uri;ILjava/lang/String;I)V
    invoke-virtual {v0, v4}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    :try_end
    return-void

    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_dl

    :catch_dl
    move-exception v3
    invoke-virtual {v3}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;
    move-result-object v3
    if-nez v3, :has_err
    const-string v3, "Download failed"
    :has_err
    iget v4, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$1;->val$index:I
    new-instance v5, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$3;
    invoke-direct {v5, v0, v4, v3}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$3;-><init>(Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;ILjava/lang/String;)V
    invoke-virtual {v0, v5}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V
    return-void
.end method
