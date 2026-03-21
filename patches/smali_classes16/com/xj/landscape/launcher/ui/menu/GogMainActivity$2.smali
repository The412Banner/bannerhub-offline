.class public final Lcom/xj/landscape/launcher/ui/menu/GogMainActivity$2;
.super Ljava/lang/Object;

# BannerHub: OnClickListener for the "Sign Out" button in GogMainActivity
.implements Landroid/view/View$OnClickListener;


.field public final a:Lcom/xj/landscape/launcher/ui/menu/GogMainActivity;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/GogMainActivity;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/GogMainActivity$2;->a:Lcom/xj/landscape/launcher/ui/menu/GogMainActivity;

    return-void
.end method


.method public onClick(Landroid/view/View;)V
    .locals 4

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/GogMainActivity$2;->a:Lcom/xj/landscape/launcher/ui/menu/GogMainActivity;

    # Clear SharedPreferences (v0 is the Activity, which is also a Context)
    const-string v2, "bh_gog_prefs"

    const/4 v3, 0x0

    invoke-virtual {v0, v2, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->clear()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V

    # Refresh the UI to show the login card
    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/menu/GogMainActivity;->refreshView()V

    return-void
.end method
