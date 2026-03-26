# BhQuickSetupActivity$BhInstallAllListener — install all missing components on click
.class final Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$BhInstallAllListener;
.super Ljava/lang/Object;
.implements Landroid/view/View$OnClickListener;

.field final this$0:Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;

.method constructor <init>(Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$BhInstallAllListener;->this$0:Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;
    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 3
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$BhInstallAllListener;->this$0:Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;

    # Install each component if not already installed
    const/4 v1, 0x0
    :loop
    const/4 v2, 0x3
    if-ge v1, v2, :done

    # Check if installed
    invoke-virtual {v0, v1}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->getUrl(I)Ljava/lang/String;
    move-result-object v2
    invoke-virtual {v0, v2}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->isInstalled(Ljava/lang/String;)Z
    move-result v2
    if-nez v2, :already_installed

    # Not installed → start install
    invoke-virtual {v0, v1}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->startInstall(I)V

    :already_installed
    add-int/lit8 v1, v1, 0x1
    const/4 v2, 0x3
    goto :loop
    :done
    return-void
.end method
