# BhQuickSetupActivity$5 — GameHubExtractRunnable
# Background thread: extract all 7 GameHub components from bundled APK ZipFile to filesDir.
# Posts $6 (success) or $3 (index=-1, error) on UI thread.

.class final Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$5;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

.field final this$0:Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;

.method constructor <init>(Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$5;->this$0:Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;
    return-void
.end method

.method public run()V
    .locals 12
    # v0=outer  v1=filesDir  v2=ZipFile  v3=loopIndex
    # v4=bundlePath/entry  v5=relPath/parent/FOS  v6=destFile  v7=IS
    # v8=buf  v9=bytesRead  v10=offset(0)  v11=loopLimit(7)

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$5;->this$0:Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;

    :try_start

    # Get APK path into v4 (temporary string)
    invoke-virtual {v0}, Landroid/content/Context;->getApplicationInfo()Landroid/content/pm/ApplicationInfo;
    move-result-object v4
    iget-object v4, v4, Landroid/content/pm/ApplicationInfo;->sourceDir:Ljava/lang/String;
    # v4 = apkPath string

    # Open ZipFile: new-instance first, then <init> with path
    new-instance v2, Ljava/util/zip/ZipFile;
    invoke-direct {v2, v4}, Ljava/util/zip/ZipFile;-><init>(Ljava/lang/String;)V
    # v2 = ZipFile

    # Get filesDir
    invoke-virtual {v0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;
    move-result-object v1
    # v1 = filesDir

    # Loop constants
    const/4 v10, 0x0    # write offset constant = 0
    const/16 v11, 0x9   # loop limit = 9
    const/4 v3, 0x0     # loop index = 0

    :gh_loop
    if-ge v3, v11, :gh_done

    # bundlePath = getGhBundlePath(i)
    invoke-virtual {v0, v3}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->getGhBundlePath(I)Ljava/lang/String;
    move-result-object v4   # v4 = bundlePath

    # relPath = getGhRelPath(i)
    invoke-virtual {v0, v3}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->getGhRelPath(I)Ljava/lang/String;
    move-result-object v5   # v5 = relPath

    # destFile = new File(filesDir, relPath)
    new-instance v6, Ljava/io/File;
    invoke-direct {v6, v1, v5}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    # v6 = destFile

    # If destFile.exists() → skip to next
    invoke-virtual {v6}, Ljava/io/File;->exists()Z
    move-result v5
    if-nez v5, :gh_next

    # mkdirs for parent dir
    invoke-virtual {v6}, Ljava/io/File;->getParentFile()Ljava/io/File;
    move-result-object v5
    invoke-virtual {v5}, Ljava/io/File;->mkdirs()Z

    # Get zip entry
    invoke-virtual {v2, v4}, Ljava/util/zip/ZipFile;->getEntry(Ljava/lang/String;)Ljava/util/zip/ZipEntry;
    move-result-object v4   # v4 = ZipEntry

    # Open input stream from zip entry
    invoke-virtual {v2, v4}, Ljava/util/zip/ZipFile;->getInputStream(Ljava/util/zip/ZipEntry;)Ljava/io/InputStream;
    move-result-object v7   # v7 = IS

    # Open file output stream
    new-instance v5, Ljava/io/FileOutputStream;
    invoke-direct {v5, v6}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    # v5 = FOS

    # Allocate 8KB copy buffer
    const/16 v8, 0x2000
    new-array v8, v8, [B

    :copy_loop
    invoke-virtual {v7, v8}, Ljava/io/InputStream;->read([B)I
    move-result v9
    if-lez v9, :copy_done
    invoke-virtual {v5, v8, v10, v9}, Ljava/io/OutputStream;->write([BII)V
    goto :copy_loop
    :copy_done

    invoke-virtual {v7}, Ljava/io/InputStream;->close()V
    invoke-virtual {v5}, Ljava/io/FileOutputStream;->close()V

    :gh_next
    add-int/lit8 v3, v3, 0x1
    goto :gh_loop

    :gh_done
    invoke-virtual {v2}, Ljava/util/zip/ZipFile;->close()V

    # Post $6 (success) on UI thread
    new-instance v2, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$6;
    invoke-direct {v2, v0}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$6;-><init>(Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;)V
    invoke-virtual {v0, v2}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    :try_end
    return-void

    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_ex

    :catch_ex
    move-exception v3
    invoke-virtual {v3}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;
    move-result-object v3
    if-nez v3, :has_err
    const-string v3, "GameHub extraction failed"
    :has_err
    # index = -1 signals GameHub error to $3 (skip button restore)
    const/4 v4, -0x1
    new-instance v5, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$3;
    invoke-direct {v5, v0, v4, v3}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$3;-><init>(Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;ILjava/lang/String;)V
    invoke-virtual {v0, v5}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V
    return-void
.end method
