# BhQuickSetupActivity$1 — InstallRunnable
# Background thread: extract WCP from bundled APK ZipFile to cacheDir → post $2 (success) or $3 (error)
# Constructor: (outer, bundlePath, type, index)

.class final Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$1;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

.field final this$0:Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;
.field final val$bundlePath:Ljava/lang/String;
.field final val$type:I
.field final val$index:I

.method constructor <init>(Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;Ljava/lang/String;II)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$1;->this$0:Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$1;->val$bundlePath:Ljava/lang/String;
    iput p3, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$1;->val$type:I
    iput p4, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$1;->val$index:I
    return-void
.end method

.method public run()V
    .locals 12
    # v0=outer  v1=bundlePath  v2=filename  v3=destFile
    # v4=ZipFile  v5=ZipEntry/IS  v6=FOS  v7=buf
    # v8=bytesRead  v9=scratch  v10=scratch  v11=scratch

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$1;->this$0:Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$1;->val$bundlePath:Ljava/lang/String;

    :try_start

    # v2 = filename = last path segment of bundlePath
    const/16 v9, 0x2f   # '/'
    invoke-virtual {v1, v9}, Ljava/lang/String;->lastIndexOf(I)I
    move-result v9
    add-int/lit8 v9, v9, 0x1
    invoke-virtual {v1, v9}, Ljava/lang/String;->substring(I)Ljava/lang/String;
    move-result-object v2   # v2 = filename

    # v4 = ZipFile(apkPath)
    invoke-virtual {v0}, Landroid/content/Context;->getApplicationInfo()Landroid/content/pm/ApplicationInfo;
    move-result-object v9
    iget-object v9, v9, Landroid/content/pm/ApplicationInfo;->sourceDir:Ljava/lang/String;
    new-instance v4, Ljava/util/zip/ZipFile;
    invoke-direct {v4, v9}, Ljava/util/zip/ZipFile;-><init>(Ljava/lang/String;)V
    # v4 = ZipFile

    # Get zip entry for bundlePath
    invoke-virtual {v4, v1}, Ljava/util/zip/ZipFile;->getEntry(Ljava/lang/String;)Ljava/util/zip/ZipEntry;
    move-result-object v5   # v5 = ZipEntry

    # Open input stream
    invoke-virtual {v4, v5}, Ljava/util/zip/ZipFile;->getInputStream(Ljava/util/zip/ZipEntry;)Ljava/io/InputStream;
    move-result-object v5   # v5 = InputStream

    # v3 = destFile = new File(getCacheDir(), filename)
    invoke-virtual {v0}, Landroid/content/Context;->getCacheDir()Ljava/io/File;
    move-result-object v9
    new-instance v3, Ljava/io/File;
    invoke-direct {v3, v9, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    # v3 = destFile

    # v6 = FileOutputStream(destFile)
    new-instance v6, Ljava/io/FileOutputStream;
    invoke-direct {v6, v3}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    # v6 = FOS

    # 8KB buffer
    const/16 v7, 0x2000
    new-array v7, v7, [B

    :copy_loop
    invoke-virtual {v5, v7}, Ljava/io/InputStream;->read([B)I
    move-result v8
    if-lez v8, :copy_done
    const/4 v9, 0x0   # offset = 0
    invoke-virtual {v6, v7, v9, v8}, Ljava/io/OutputStream;->write([BII)V
    goto :copy_loop
    :copy_done

    invoke-virtual {v5}, Ljava/io/InputStream;->close()V
    invoke-virtual {v6}, Ljava/io/FileOutputStream;->close()V
    invoke-virtual {v4}, Ljava/util/zip/ZipFile;->close()V

    # Build $2 and post to UI thread
    # $2 constructor: (outer, uri, type, filename, index)
    # Need consecutive regs v4..v9 for invoke-direct/range
    # v4 = new $2 instance
    # v5 = outer
    # v6 = uri
    # v7 = type
    # v8 = filename
    # v9 = index

    invoke-static {v3}, Landroid/net/Uri;->fromFile(Ljava/io/File;)Landroid/net/Uri;
    move-result-object v9   # v9 = uri (temp)

    iget v10, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$1;->val$type:I
    iget v11, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$1;->val$index:I

    # Set up consecutive regs v4..v9
    new-instance v4, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$2;
    move-object v5, v0        # v5 = outer
    move-object v6, v9        # v6 = uri
    move v7, v10              # v7 = type
    move-object v8, v2        # v8 = filename
    move v9, v11              # v9 = index

    invoke-direct/range {v4 .. v9}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$2;-><init>(Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;Landroid/net/Uri;ILjava/lang/String;I)V
    invoke-virtual {v0, v4}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    :try_end
    return-void

    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_ex

    :catch_ex
    move-exception v3
    invoke-virtual {v3}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;
    move-result-object v3
    if-nez v3, :has_err
    const-string v3, "Extraction failed"
    :has_err
    iget v4, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$1;->val$index:I
    new-instance v5, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$3;
    invoke-direct {v5, v0, v4, v3}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$3;-><init>(Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;ILjava/lang/String;)V
    invoke-virtual {v0, v5}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V
    return-void
.end method
