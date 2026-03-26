# BhQuickSetupActivity$BhInstallListener — install single component on click
.class final Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$BhInstallListener;
.super Ljava/lang/Object;
.implements Landroid/view/View$OnClickListener;

.field final this$0:Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;
.field final val$index:I

.method constructor <init>(Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;I)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$BhInstallListener;->this$0:Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;
    iput p2, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$BhInstallListener;->val$index:I
    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 2
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$BhInstallListener;->this$0:Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;
    iget v1, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$BhInstallListener;->val$index:I
    invoke-virtual {v0, v1}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->startInstall(I)V
    return-void
.end method
