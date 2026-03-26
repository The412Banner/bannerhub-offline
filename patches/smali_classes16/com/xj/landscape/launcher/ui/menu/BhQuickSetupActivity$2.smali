# BhQuickSetupActivity$2 — SuccessRunnable
# UI thread: call injectComponent, write SP keys, update button/statusTV
# Constructor: (outer, uri, type, filename, index)

.class final Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$2;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

.field final this$0:Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;
.field final val$uri:Landroid/net/Uri;
.field final val$type:I
.field final val$filename:Ljava/lang/String;
.field final val$index:I

.method constructor <init>(Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;Landroid/net/Uri;ILjava/lang/String;I)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$2;->this$0:Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$2;->val$uri:Landroid/net/Uri;
    iput p3, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$2;->val$type:I
    iput-object p4, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$2;->val$filename:Ljava/lang/String;
    iput p5, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$2;->val$index:I
    return-void
.end method

.method public run()V
    .locals 12
    # v0=outer  v1=uri  v2=type  v3=filename  v4=index
    # v5-v11=SP writing helpers

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$2;->this$0:Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$2;->val$uri:Landroid/net/Uri;
    iget v2, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$2;->val$type:I
    iget-object v3, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$2;->val$filename:Ljava/lang/String;
    iget v4, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$2;->val$index:I

    # Call ComponentInjectorHelper.injectComponent (shows Toast internally)
    :try_start
    invoke-static {v0, v1, v2}, Lcom/xj/landscape/launcher/ui/menu/ComponentInjectorHelper;->injectComponent(Landroid/content/Context;Landroid/net/Uri;I)V
    :try_end

    # === Write SP keys (same as ComponentDownloadActivity$5) ==================

    # Scan components dir for newest dir (post-injection)
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J
    move-result-wide v5    # v5:v6 = current time (approximate, timestamp before scan)

    # Build File(getFilesDir(), "usr/home/components")
    invoke-virtual {v0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;
    move-result-object v7
    new-instance v8, Ljava/io/File;
    const-string v9, "usr/home/components"
    invoke-direct {v8, v7, v9}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    invoke-virtual {v8}, Ljava/io/File;->listFiles()[Ljava/io/File;
    move-result-object v7   # v7 = files[] (may be null)

    # Find newest component dir
    const/4 v8, 0x0   # v8 = found name (null = use filename fallback)

    if-eqz v7, :use_filename
    array-length v9, v7
    if-eqz v9, :use_filename

    # Find the most recently modified component dir (= the one just injected)
    const-wide/16 v5, 0x0   # v5:v6 = max lastModified seen so far
    const/4 v10, 0x0         # loop index
    :scan_loop
    if-ge v10, v9, :scan_done
    aget-object v11, v7, v10
    invoke-virtual {v11}, Ljava/io/File;->lastModified()J
    move-result-wide v5
    invoke-virtual {v11}, Ljava/io/File;->getName()Ljava/lang/String;
    move-result-object v8    # last-seen dir name (use last = most recently added)
    add-int/lit8 v10, v10, 0x1
    goto :scan_loop
    :scan_done
    if-nez v8, :write_sp
    goto :use_filename

    :use_filename
    # Strip extension from filename
    const/16 v9, 0x2e   # '.'
    invoke-virtual {v3, v9}, Ljava/lang/String;->lastIndexOf(I)I
    move-result v9
    if-lez v9, :write_sp
    const/4 v10, 0x0
    invoke-virtual {v3, v10, v9}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v8
    # v8 = component dir name (sans extension)

    :write_sp
    # Determine type name string from type int
    const/16 v9, 0x5e
    if-ne v2, v9, :not_box64
    const-string v9, "Box64"
    goto :type_done
    :not_box64
    const/16 v9, 0x5f
    if-ne v2, v9, :not_fex
    const-string v9, "FEXCore"
    goto :type_done
    :not_fex
    const/16 v9, 0xd
    if-ne v2, v9, :not_vkd3d
    const-string v9, "VKD3D"
    goto :type_done
    :not_vkd3d
    const/16 v9, 0xc
    if-ne v2, v9, :not_dxvk
    const-string v9, "DXVK"
    goto :type_done
    :not_dxvk
    const/4 v9, 0x0
    :type_done
    # v9 = type name string or null

    # Get component download URL for "dl:" key
    invoke-virtual {v0, v4}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->getUrl(I)Ljava/lang/String;
    move-result-object v10   # v10 = url
    new-instance v11, Ljava/lang/StringBuilder;
    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V
    const-string v7, "dl:"
    invoke-virtual {v11, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v11, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v7   # v7 = "dl:url"

    # Open SP editor
    const-string v11, "banners_sources"
    const/4 v5, 0x0
    invoke-virtual {v0, v11, v5}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v5
    invoke-interface {v5}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v5   # v5 = editor

    # dirName → "BannerHub"
    const-string v6, "BannerHub"
    invoke-interface {v5, v8, v6}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    move-result-object v6

    # "dl:url" → "1"
    const-string v6, "1"
    invoke-interface {v5, v7, v6}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    move-result-object v6

    # dirName + ":type" → type name (if not null)
    if-eqz v9, :no_type
    new-instance v6, Ljava/lang/StringBuilder;
    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v6, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v7, ":type"
    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v6
    invoke-interface {v5, v6, v9}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    move-result-object v6
    :no_type

    # "url_for:dirName" → url
    new-instance v6, Ljava/lang/StringBuilder;
    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V
    const-string v7, "url_for:"
    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v6
    invoke-virtual {v0, v4}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->getUrl(I)Ljava/lang/String;
    move-result-object v7
    invoke-interface {v5, v6, v7}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    move-result-object v6

    invoke-interface {v5}, Landroid/content/SharedPreferences$Editor;->apply()V

    # Update UI: disable btn, show ✓ statusTV, update global status
    iget-object v5, v0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->mBtns:[Landroid/widget/Button;
    aget-object v5, v5, v4
    const/4 v6, 0x0   # false
    invoke-virtual {v5, v6}, Landroid/widget/Button;->setEnabled(Z)V
    const v6, 0xFF555555   # gray
    invoke-virtual {v5, v6}, Landroid/widget/Button;->setBackgroundColor(I)V
    const-string v6, "\u2713"
    invoke-virtual {v5, v6}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    iget-object v5, v0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->mStatusTVs:[Landroid/widget/TextView;
    aget-object v5, v5, v4
    const/4 v6, 0x0   # VISIBLE
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setVisibility(I)V

    iget-object v5, v0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->mGlobalStatus:Landroid/widget/TextView;
    invoke-virtual {v0, v4}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->getName(I)Ljava/lang/String;
    move-result-object v6
    new-instance v7, Ljava/lang/StringBuilder;
    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v6, " installed \u2713"
    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v6
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    return-void

    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_inject
    :catch_inject
    move-exception v5
    # On injection failure: re-enable button
    iget-object v6, v0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->mBtns:[Landroid/widget/Button;
    aget-object v6, v6, v4
    const/4 v7, 0x1   # true
    invoke-virtual {v6, v7}, Landroid/widget/Button;->setEnabled(Z)V
    const-string v7, "Install"
    invoke-virtual {v6, v7}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    iget-object v6, v0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->mGlobalStatus:Landroid/widget/TextView;
    const-string v7, "Install failed"
    invoke-virtual {v6, v7}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    return-void
.end method
