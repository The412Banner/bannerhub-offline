# BhQuickSetupActivity$6 — GameHubSuccessRunnable
# UI thread: update mGameHubBtn + mGameHubStatus + mGlobalStatus after all GameHub components extracted.

.class final Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$6;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

.field final this$0:Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;

.method constructor <init>(Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$6;->this$0:Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;
    return-void
.end method

.method public run()V
    .locals 3
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$6;->this$0:Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;

    # Disable mGameHubBtn with gray bg and "✓" text
    iget-object v1, v0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->mGameHubBtn:Landroid/widget/Button;
    const/4 v2, 0x0   # false = disabled
    invoke-virtual {v1, v2}, Landroid/widget/Button;->setEnabled(Z)V
    const v2, 0xFF555555   # gray bg
    invoke-virtual {v1, v2}, Landroid/widget/Button;->setBackgroundColor(I)V
    const-string v2, "\u2713"   # ✓
    invoke-virtual {v1, v2}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    # Set mGameHubStatus text to "✓ All installed"
    iget-object v1, v0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->mGameHubStatus:Landroid/widget/TextView;
    const-string v2, "\u2713 All installed"
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    # Set mGlobalStatus text to "GameHub components ready ✓"
    iget-object v1, v0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->mGlobalStatus:Landroid/widget/TextView;
    const-string v2, "GameHub components ready \u2713"
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    return-void
.end method
