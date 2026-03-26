# BhQuickSetupActivity$BhBackListener — finish activity on back button click
.class final Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$BhBackListener;
.super Ljava/lang/Object;
.implements Landroid/view/View$OnClickListener;

.field final this$0:Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;

.method constructor <init>(Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$BhBackListener;->this$0:Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;
    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 1
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$BhBackListener;->this$0:Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;
    invoke-virtual {v0}, Landroid/app/Activity;->finish()V
    return-void
.end method
