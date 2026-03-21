.class public final Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$5;
.super Ljava/lang/Object;

# BannerHub: OnClickListener for the store URL TextView in the game detail dialog.
# Opens the GOG store page in the device's browser via Intent.ACTION_VIEW.

.implements Landroid/view/View$OnClickListener;

.field public final a:Landroid/content/Context;
.field public final b:Ljava/lang/String;  # storeUrl


.method public constructor <init>(Landroid/content/Context;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$5;->a:Landroid/content/Context;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$5;->b:Ljava/lang/String;

    return-void
.end method


.method public onClick(Landroid/view/View;)V
    .locals 4

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$5;->a:Landroid/content/Context;
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$5;->b:Ljava/lang/String;

    invoke-static {v1}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;
    move-result-object v1  # Uri

    new-instance v2, Landroid/content/Intent;
    const-string v3, "android.intent.action.VIEW"
    invoke-direct {v2, v3, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;Landroid/net/Uri;)V

    invoke-virtual {v0, v2}, Landroid/content/Context;->startActivity(Landroid/content/Intent;)V

    return-void
.end method
