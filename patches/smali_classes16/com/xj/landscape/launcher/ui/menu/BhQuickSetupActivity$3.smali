# BhQuickSetupActivity$3 — ErrorRunnable
# UI thread: re-enable button, show error in global status bar
# Constructor: (outer, index, errorMsg)

.class final Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$3;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

.field final this$0:Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;
.field final val$index:I
.field final val$error:Ljava/lang/String;

.method constructor <init>(Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;ILjava/lang/String;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$3;->this$0:Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;
    iput p2, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$3;->val$index:I
    iput-object p3, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$3;->val$error:Ljava/lang/String;
    return-void
.end method

.method public run()V
    .locals 5
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$3;->this$0:Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;
    iget v1, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$3;->val$index:I
    iget-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$3;->val$error:Ljava/lang/String;

    # Re-enable button
    iget-object v3, v0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->mBtns:[Landroid/widget/Button;
    aget-object v3, v3, v1
    const/4 v4, 0x1   # true = enabled
    invoke-virtual {v3, v4}, Landroid/widget/Button;->setEnabled(Z)V
    const v4, 0xFFFF9800   # orange bg
    invoke-virtual {v3, v4}, Landroid/widget/Button;->setBackgroundColor(I)V
    const-string v4, "Install"
    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    # Update global status: "Error: {msg}"
    iget-object v3, v0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->mGlobalStatus:Landroid/widget/TextView;
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "Error: "
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    return-void
.end method
