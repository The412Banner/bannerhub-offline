.class public final Lcom/xj/landscape/launcher/ui/menu/GogMainActivity$1;
.super Ljava/lang/Object;

# BannerHub: OnClickListener for the "Login with GOG" button in GogMainActivity
.implements Landroid/view/View$OnClickListener;


.field public final a:Lcom/xj/landscape/launcher/ui/menu/GogMainActivity;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/GogMainActivity;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/GogMainActivity$1;->a:Lcom/xj/landscape/launcher/ui/menu/GogMainActivity;

    return-void
.end method


.method public onClick(Landroid/view/View;)V
    .locals 3

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/GogMainActivity$1;->a:Lcom/xj/landscape/launcher/ui/menu/GogMainActivity;

    # v0 is the Activity itself — directly start GogLoginActivity
    new-instance v1, Landroid/content/Intent;

    const-class v2, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;

    invoke-direct {v1, v0, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {v0, v1}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V

    return-void
.end method
