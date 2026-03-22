.class public final Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$10;
.super Ljava/lang/Object;

# BannerHub: DialogInterface$OnClickListener for the Uninstall button
# in the game detail dialog (GogGamesFragment$3).
# - Reads gog_dir_{gameId} (dir name only) from bh_gog_prefs
# - Builds full path: context.getFilesDir()/gog_games/{dirName}
# - Recursively deletes the install directory
# - Clears all gog_*_ prefs keys for the game
# - Shows Toast "Uninstalled"
# - Triggers a new GogGamesFragment$1 sync to rebuild the card list

.implements Landroid/content/DialogInterface$OnClickListener;

.field public final a:Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;
.field public final b:Lcom/xj/landscape/launcher/ui/menu/GogGame;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;Lcom/xj/landscape/launcher/ui/menu/GogGame;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$10;->a:Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$10;->b:Lcom/xj/landscape/launcher/ui/menu/GogGame;

    return-void
.end method


.method private static deleteRecursive(Ljava/io/File;)V
    .locals 4
    # p0 = File (v4 with .locals 4)

    invoke-virtual {p0}, Ljava/io/File;->isDirectory()Z
    move-result v0
    if-eqz v0, :delete_self

    invoke-virtual {p0}, Ljava/io/File;->listFiles()[Ljava/io/File;
    move-result-object v0
    if-eqz v0, :delete_self

    array-length v1, v0
    const/4 v2, 0x0

    :child_loop
    if-ge v2, v1, :delete_self
    aget-object v3, v0, v2
    invoke-static {v3}, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$10;->deleteRecursive(Ljava/io/File;)V
    add-int/lit8 v2, v2, 0x1
    goto :child_loop

    :delete_self
    invoke-virtual {p0}, Ljava/io/File;->delete()Z

    return-void
.end method


.method public onClick(Landroid/content/DialogInterface;I)V
    .locals 9
    # p0=v9(this), p1=v10(dialog), p2=v11(which)

    # v0 = GogGamesFragment (persistent — needed for re-sync at end)
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$10;->a:Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;

    # v1 = GogGame
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$10;->b:Lcom/xj/landscape/launcher/ui/menu/GogGame;

    # v2 = gameId
    iget-object v2, v1, Lcom/xj/landscape/launcher/ui/menu/GogGame;->gameId:Ljava/lang/String;
    if-eqz v2, :uninstall_done

    # v3 = context (from fragment)
    invoke-virtual {v0}, Landroidx/fragment/app/Fragment;->getContext()Landroid/content/Context;
    move-result-object v3
    if-eqz v3, :uninstall_done

    # v4 = SharedPreferences
    const-string v5, "bh_gog_prefs"
    const/4 v6, 0x0
    invoke-virtual {v3, v5, v6}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v4

    # Read gog_dir_{gameId} — stored as dir NAME only (e.g. "HitmanContracts")
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V
    const-string v6, "gog_dir_"
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5

    const-string v6, ""
    invoke-interface {v4, v5, v6}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v5  # v5 = dir name or ""

    invoke-virtual {v5}, Ljava/lang/String;->isEmpty()Z
    move-result v6
    if-nez v6, :clear_prefs

    # Build full path: context.getFilesDir()/gog_games/{dirName}
    invoke-virtual {v3}, Landroid/content/Context;->getFilesDir()Ljava/io/File;
    move-result-object v6
    invoke-virtual {v6}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;
    move-result-object v6

    new-instance v7, Ljava/lang/StringBuilder;
    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v6, "/gog_games/"
    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v7

    new-instance v6, Ljava/io/File;
    invoke-direct {v6, v7}, Ljava/io/File;-><init>(Ljava/lang/String;)V
    invoke-static {v6}, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$10;->deleteRecursive(Ljava/io/File;)V

    :clear_prefs
    invoke-interface {v4}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v5  # v5 = editor

    # gog_dir_
    new-instance v6, Ljava/lang/StringBuilder;
    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V
    const-string v7, "gog_dir_"
    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v6
    invoke-interface {v5, v6}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    move-result-object v5

    # gog_exe_
    new-instance v6, Ljava/lang/StringBuilder;
    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V
    const-string v7, "gog_exe_"
    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v6
    invoke-interface {v5, v6}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    move-result-object v5

    # gog_cover_
    new-instance v6, Ljava/lang/StringBuilder;
    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V
    const-string v7, "gog_cover_"
    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v6
    invoke-interface {v5, v6}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    move-result-object v5

    # gog_gen_
    new-instance v6, Ljava/lang/StringBuilder;
    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V
    const-string v7, "gog_gen_"
    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v6
    invoke-interface {v5, v6}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    move-result-object v5

    invoke-interface {v5}, Landroid/content/SharedPreferences$Editor;->apply()V

    # Toast "Uninstalled"
    const-string v5, "Uninstalled"
    const/4 v6, 0x0
    invoke-static {v3, v5, v6}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v5
    invoke-virtual {v5}, Landroid/widget/Toast;->show()V

    # Trigger re-sync to rebuild card list with fresh prefs state
    const-string v5, "access_token"
    const-string v6, ""
    invoke-interface {v4, v5, v6}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v5  # v5 = access token or ""

    invoke-virtual {v5}, Ljava/lang/String;->isEmpty()Z
    move-result v6
    if-nez v6, :uninstall_done

    new-instance v6, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$1;
    invoke-direct {v6, v0, v5}, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$1;-><init>(Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;Ljava/lang/String;)V

    new-instance v7, Ljava/lang/Thread;
    invoke-direct {v7, v6}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V
    invoke-virtual {v7}, Ljava/lang/Thread;->start()V

    :uninstall_done
    return-void
.end method
