.class public final Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$3;
.super Ljava/lang/Object;

# BannerHub: UI-thread Runnable posted by GogDownloadManager$1 to update the
# progress bar and status text in the game detail dialog.
# progress 0-99: updates bar only.
# progress >= 100: updates bar, hides it, and shows status text ("✓ Complete").
# message non-null: sets status TextView text and makes it visible.

.implements Ljava/lang/Runnable;

.field public final a:Landroid/widget/ProgressBar;
.field public final b:Landroid/widget/TextView;
.field public final c:I
.field public final d:Ljava/lang/String;


.method public constructor <init>(Landroid/widget/ProgressBar;Landroid/widget/TextView;ILjava/lang/String;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$3;->a:Landroid/widget/ProgressBar;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$3;->b:Landroid/widget/TextView;
    iput p3, p0, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$3;->c:I
    iput-object p4, p0, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$3;->d:Ljava/lang/String;

    return-void
.end method


.method public run()V
    .locals 2

    # Update progress bar value
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$3;->a:Landroid/widget/ProgressBar;
    iget v1, p0, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$3;->c:I
    invoke-virtual {v0, v1}, Landroid/widget/ProgressBar;->setProgress(I)V

    # If message provided: set text and show status TextView
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$3;->d:Ljava/lang/String;
    if-eqz v1, :no_msg
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$3;->b:Landroid/widget/TextView;
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const/4 v1, 0x0  # VISIBLE
    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V
    :no_msg

    # If progress >= 100: hide the progress bar
    iget v1, p0, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$3;->c:I
    const/16 v0, 0x64
    if-lt v1, v0, :run_done
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$3;->a:Landroid/widget/ProgressBar;
    const/16 v1, 0x8  # GONE
    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    :run_done
    return-void
.end method
