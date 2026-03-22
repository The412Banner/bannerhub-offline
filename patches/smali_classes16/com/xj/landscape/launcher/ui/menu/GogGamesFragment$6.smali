.class public final Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$6;
.super Ljava/lang/Object;

# BannerHub: View$OnClickListener for the in-dialog "Install" Button.
# Disables the button to prevent double-tap, shows the ProgressBar,
# then starts the download pipeline via GogDownloadManager.startDownload().

.implements Landroid/view/View$OnClickListener;

.field public final a:Landroid/content/Context;
.field public final b:Lcom/xj/landscape/launcher/ui/menu/GogGame;
.field public final c:Landroid/widget/Button;
.field public final d:Landroid/widget/ProgressBar;
.field public final e:Landroid/widget/TextView;


.method public constructor <init>(Landroid/content/Context;Lcom/xj/landscape/launcher/ui/menu/GogGame;Landroid/widget/Button;Landroid/widget/ProgressBar;Landroid/widget/TextView;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$6;->a:Landroid/content/Context;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$6;->b:Lcom/xj/landscape/launcher/ui/menu/GogGame;
    iput-object p3, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$6;->c:Landroid/widget/Button;
    iput-object p4, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$6;->d:Landroid/widget/ProgressBar;
    iput-object p5, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$6;->e:Landroid/widget/TextView;

    return-void
.end method


.method public onClick(Landroid/view/View;)V
    .locals 5

    # v0 = context
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$6;->a:Landroid/content/Context;

    # v1 = GogGame
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$6;->b:Lcom/xj/landscape/launcher/ui/menu/GogGame;

    # Disable the Install button so it can't be tapped twice
    iget-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$6;->c:Landroid/widget/Button;
    const/4 v3, 0x0
    invoke-virtual {v2, v3}, Landroid/view/View;->setEnabled(Z)V

    # Show the ProgressBar
    iget-object v3, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$6;->d:Landroid/widget/ProgressBar;
    const/4 v4, 0x0  # VISIBLE
    invoke-virtual {v3, v4}, Landroid/view/View;->setVisibility(I)V

    # v4 = StatusTextView
    iget-object v4, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$6;->e:Landroid/widget/TextView;

    invoke-static {v0, v1, v3, v4}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager;->startDownload(Landroid/content/Context;Lcom/xj/landscape/launcher/ui/menu/GogGame;Landroid/widget/ProgressBar;Landroid/widget/TextView;)V

    return-void
.end method
