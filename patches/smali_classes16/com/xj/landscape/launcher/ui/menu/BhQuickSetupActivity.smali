# BhQuickSetupActivity — one-tap install of essential components (Box64, DXVK, VKD3D)
# Reads bundle.json from GitHub, shows install status per component, installs via
# ComponentInjectorHelper. Does NOT require root. Works online only (offline zip planned).
#
# Side menu ID=11. Package: com.xj.landscape.launcher.ui.menu
#
# Components (hardcoded from bundle.json defaults):
#   [0] Box64          type=94  box64-0.4.1-fix
#   [1] DXVK           type=12  dxvk-gplasync-arm64ec-2.7.1-1
#   [2] VKD3D-Proton   type=13  vkd3d-proton-3.0b

.class public final Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;
.super Landroidx/appcompat/app/AppCompatActivity;

# ── Fields ────────────────────────────────────────────────────────────────────
# Array of 3 install buttons (one per component)
.field private mBtns:[Landroid/widget/Button;
# Array of 3 status TextViews (one per component — "✓ Installed" or hidden)
.field private mStatusTVs:[Landroid/widget/TextView;
# Global status bar at bottom of screen
.field private mGlobalStatus:Landroid/widget/TextView;
# "Install All Missing" button
.field private mInstallAllBtn:Landroid/widget/Button;

# ── Component data arrays (parallel, index 0-2) ───────────────────────────────
# These are initialised as static string arrays in static{} block, but smali
# doesn't have convenient static initialisers, so we use helper methods.

# ── Constructor ───────────────────────────────────────────────────────────────
.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroidx/appcompat/app/AppCompatActivity;-><init>()V
    return-void
.end method

# ── dp: density-independent pixel helper ──────────────────────────────────────
.method public dp(I)I
    .locals 2
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/Resources;
    move-result-object v0
    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;
    move-result-object v0
    iget v1, v0, Landroid/util/DisplayMetrics;->density:F
    int-to-float v0, p1
    mul-float v0, v0, v1
    float-to-int v0, v0
    return v0
.end method

# ── isInstalled(url) -> boolean ───────────────────────────────────────────────
# Checks SharedPreferences("banners_sources") for "dl:{url}" key
.method private isInstalled(Ljava/lang/String;)Z
    .locals 3
    const-string v0, "banners_sources"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "dl:"
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1
    invoke-interface {v0, v1}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z
    move-result v0
    return v0
.end method

# ── getName(index) -> String ───────────────────────────────────────────────────
.method public getName(I)Ljava/lang/String;
    .locals 0
    packed-switch p1, :pswitch_data
    const-string p1, "Component"
    return-object p1
    :pswitch_data
    .packed-switch 0x0
        :pswitch_0
        :pswitch_1
        :pswitch_2
    .end packed-switch
    :pswitch_0
    const-string p1, "Box64"
    return-object p1
    :pswitch_1
    const-string p1, "DXVK"
    return-object p1
    :pswitch_2
    const-string p1, "VKD3D-Proton"
    return-object p1
.end method

# ── getVersion(index) -> String ───────────────────────────────────────────────
.method public getVersion(I)Ljava/lang/String;
    .locals 0
    packed-switch p1, :pswitch_data
    const-string p1, ""
    return-object p1
    :pswitch_data
    .packed-switch 0x0
        :pswitch_0
        :pswitch_1
        :pswitch_2
    .end packed-switch
    :pswitch_0
    const-string p1, "box64-0.4.1-fix"
    return-object p1
    :pswitch_1
    const-string p1, "dxvk-gplasync-arm64ec-2.7.1-1"
    return-object p1
    :pswitch_2
    const-string p1, "vkd3d-proton-3.0b"
    return-object p1
.end method

# ── getUrl(index) -> String ────────────────────────────────────────────────────
.method public getUrl(I)Ljava/lang/String;
    .locals 0
    packed-switch p1, :pswitch_data
    const-string p1, ""
    return-object p1
    :pswitch_data
    .packed-switch 0x0
        :pswitch_0
        :pswitch_1
        :pswitch_2
    .end packed-switch
    :pswitch_0
    const-string p1, "https://github.com/The412Banner/Nightlies/releases/download/Box64/box64-0.4.1-fix.wcp"
    return-object p1
    :pswitch_1
    const-string p1, "https://github.com/The412Banner/Nightlies/releases/download/Dxvk-gplasync-arm64ec/dxvk-gplasync-arm64ec-2.7.1-1.wcp"
    return-object p1
    :pswitch_2
    const-string p1, "https://github.com/The412Banner/Nightlies/releases/download/Vkd3d-proton/vkd3d-proton-3.0b.wcp"
    return-object p1
.end method

# ── getType(index) -> int ──────────────────────────────────────────────────────
.method public getType(I)I
    .locals 0
    packed-switch p1, :pswitch_data
    const/4 p1, 0x0
    return p1
    :pswitch_data
    .packed-switch 0x0
        :pswitch_0
        :pswitch_1
        :pswitch_2
    .end packed-switch
    :pswitch_0
    const/16 p1, 0x5e   # Box64
    return p1
    :pswitch_1
    const/16 p1, 0xc    # DXVK
    return p1
    :pswitch_2
    const/16 p1, 0xd    # VKD3D
    return p1
.end method

# ── getDesc(index) -> String ───────────────────────────────────────────────────
.method public getDesc(I)Ljava/lang/String;
    .locals 0
    packed-switch p1, :pswitch_data
    const-string p1, ""
    return-object p1
    :pswitch_data
    .packed-switch 0x0
        :pswitch_0
        :pswitch_1
        :pswitch_2
    .end packed-switch
    :pswitch_0
    const-string p1, "x64 emulator - required for most Windows games"
    return-object p1
    :pswitch_1
    const-string p1, "DirectX 9-11 to Vulkan translation"
    return-object p1
    :pswitch_2
    const-string p1, "DirectX 12 to Vulkan translation"
    return-object p1
.end method

# ── startInstall(index) ────────────────────────────────────────────────────────
# Starts background download+inject for component at given index.
# Updates button text to "Installing..." and disables it.
.method public startInstall(I)V
    .locals 4
    # p0=this  p1=index

    # Get url and type for this index
    invoke-virtual {p0, p1}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->getUrl(I)Ljava/lang/String;
    move-result-object v0   # v0 = url

    invoke-virtual {p0, p1}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->getType(I)I
    move-result v1          # v1 = type

    # Disable button + set text to "Installing..."
    iget-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->mBtns:[Landroid/widget/Button;
    aget-object v2, v2, p1
    const/4 v3, 0x0
    invoke-virtual {v2, v3}, Landroid/widget/Button;->setEnabled(Z)V
    const-string v3, "Installing..."
    invoke-virtual {v2, v3}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    # Update global status: show component name
    iget-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->mGlobalStatus:Landroid/widget/TextView;
    invoke-virtual {p0, p1}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->getName(I)Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    # Start $1 thread with (outer=p0, url=v0, type=v1, index=p1)
    new-instance v2, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$1;
    invoke-direct {v2, p0, v0, v1, p1}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$1;-><init>(Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;Ljava/lang/String;II)V
    new-instance v3, Ljava/lang/Thread;
    invoke-direct {v3, v2}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V
    invoke-virtual {v3}, Ljava/lang/Thread;->start()V
    return-void
.end method

# ── onCreate ──────────────────────────────────────────────────────────────────
.method protected onCreate(Landroid/os/Bundle;)V
    .locals 14
    # v0-v13 = locals  p0=v14=this  p1=v15=Bundle

    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->onCreate(Landroid/os/Bundle;)V

    # ── Allocate mBtns and mStatusTVs arrays ──────────────────────────────────
    const/4 v0, 0x3
    new-array v0, v0, [Landroid/widget/Button;
    iput-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->mBtns:[Landroid/widget/Button;

    const/4 v0, 0x3
    new-array v0, v0, [Landroid/widget/TextView;
    iput-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->mStatusTVs:[Landroid/widget/TextView;

    # ── Root Layout ────────────────────────────────────────────────────────────
    # Root = vertical LinearLayout, black bg, MATCH_PARENT x MATCH_PARENT
    new-instance v0, Landroid/widget/LinearLayout;
    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v1, 0x1   # VERTICAL
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const v1, 0xFF000000   # black
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setBackgroundColor(I)V
    # v0 = root

    # ── Header bar ─────────────────────────────────────────────────────────────
    # Header = horizontal LL, orange bg, MATCH_PARENT x 48dp
    new-instance v1, Landroid/widget/LinearLayout;
    invoke-direct {v1, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v2, 0x0   # HORIZONTAL
    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const v2, 0xFFFF9800   # orange
    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setBackgroundColor(I)V

    const/4 v2, 0x10   # 16dp padding
    invoke-virtual {p0, v2}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->dp(I)I
    move-result v2
    invoke-virtual {v1, v2, v2, v2, v2}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    # Header LP: MATCH_PARENT width, 48dp height
    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v3, -0x1   # MATCH_PARENT
    const/16 v4, 0x30  # 48 dp nominal — will be dp'd
    invoke-virtual {p0, v4}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->dp(I)I
    move-result v4
    invoke-direct {v2, v3, v4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    invoke-virtual {v1, v2}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    # Back button "←"
    new-instance v2, Landroid/widget/Button;
    invoke-direct {v2, p0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V
    const-string v3, "\u2190"   # ←
    invoke-virtual {v2, v3}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    const v3, 0xFFFFFFFF   # white
    invoke-virtual {v2, v3}, Landroid/widget/Button;->setTextColor(I)V
    const/16 v3, 0x10   # 16sp
    int-to-float v3, v3
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextSize(F)V
    const/4 v3, 0x0   # no background
    invoke-virtual {v2, v3}, Landroid/view/View;->setBackgroundResource(I)V
    # Back button listener = $BhBackListener
    new-instance v3, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$BhBackListener;
    invoke-direct {v3, p0}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$BhBackListener;-><init>(Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;)V
    invoke-virtual {v2, v3}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # Title TextView "Quick Setup"
    new-instance v2, Landroid/widget/TextView;
    invoke-direct {v2, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v3, "Quick Setup"
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v3, 0xFFFFFFFF   # white
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V
    const/16 v3, 0x12   # 18sp
    int-to-float v3, v3
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextSize(F)V
    const/4 v3, 0x1   # CENTER_VERTICAL gravity
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setGravity(I)V
    # LP: 0 width, WRAP_CONTENT height, weight=1
    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v4, 0x0
    const/4 v5, -0x2   # WRAP_CONTENT
    invoke-direct {v3, v4, v5}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/high16 v4, 0x3f800000   # 1.0f
    iput v4, v3, Landroid/widget/LinearLayout$LayoutParams;->weight:F
    invoke-virtual {v2, v3}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V
    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # Add header to root
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    # v0=root still valid

    # ── ScrollView containing 3 component cards ────────────────────────────────
    new-instance v1, Landroid/widget/ScrollView;
    invoke-direct {v1, p0}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V
    # LP: MATCH_PARENT width, 0 height, weight=1 (takes remaining space)
    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v3, -0x1   # MATCH_PARENT
    const/4 v4, 0x0
    invoke-direct {v2, v3, v4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/high16 v3, 0x3f800000   # 1.0f
    iput v3, v2, Landroid/widget/LinearLayout$LayoutParams;->weight:F
    invoke-virtual {v1, v2}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V
    # v1 = scrollview

    # Content LinearLayout inside ScrollView
    new-instance v2, Landroid/widget/LinearLayout;
    invoke-direct {v2, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v3, 0x1   # VERTICAL
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const/4 v3, 0x8   # 8dp padding
    invoke-virtual {p0, v3}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->dp(I)I
    move-result v3
    invoke-virtual {v2, v3, v3, v3, v3}, Landroid/widget/LinearLayout;->setPadding(IIII)V
    invoke-virtual {v1, v2}, Landroid/widget/ScrollView;->addView(Landroid/view/View;)V
    # v1=scrollView  v2=scrollContent

    # Add scrollview to root
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # ── Global status bar ─────────────────────────────────────────────────────
    new-instance v1, Landroid/widget/TextView;
    invoke-direct {v1, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v3, "Tap Install to add a component"
    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v3, 0xFF888888   # gray
    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setTextColor(I)V
    const/16 v3, 0xc   # 12sp
    int-to-float v3, v3
    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setTextSize(F)V
    const/16 v3, 0xc   # 12dp padding
    invoke-virtual {p0, v3}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->dp(I)I
    move-result v3
    invoke-virtual {v1, v3, v3, v3, v3}, Landroid/widget/TextView;->setPadding(IIII)V
    iput-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->mGlobalStatus:Landroid/widget/TextView;
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # ── Install All Missing button ─────────────────────────────────────────────
    new-instance v1, Landroid/widget/Button;
    invoke-direct {v1, p0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V
    const-string v3, "Install All Missing"
    invoke-virtual {v1, v3}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    const v3, 0xFFFFFFFF   # white
    invoke-virtual {v1, v3}, Landroid/widget/Button;->setTextColor(I)V
    const v3, 0xFFFF9800   # orange bg
    invoke-virtual {v1, v3}, Landroid/widget/Button;->setBackgroundColor(I)V
    # LP: MATCH_PARENT x 48dp
    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v4, -0x1   # MATCH_PARENT
    const/16 v5, 0x30  # 48dp nominal
    invoke-virtual {p0, v5}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->dp(I)I
    move-result v5
    invoke-direct {v3, v4, v5}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    invoke-virtual {v1, v3}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V
    # Listener
    new-instance v3, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$BhInstallAllListener;
    invoke-direct {v3, p0}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$BhInstallAllListener;-><init>(Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;)V
    invoke-virtual {v1, v3}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    iput-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->mInstallAllBtn:Landroid/widget/Button;
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # Set root as content view
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->setContentView(Landroid/view/View;)V

    # Now populate cards — use scrollContent stored in v2 above
    # Note: v2 = scrollContent LinearLayout; build cards into it
    invoke-virtual {p0, v2}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->buildCards(Landroid/widget/LinearLayout;)V

    return-void
.end method

# ── buildCards: create 3 component cards and add to parent ────────────────────
# p0=this  p1=parent(LinearLayout)
.method private buildCards(Landroid/widget/LinearLayout;)V
    .locals 14
    # v0-v13 locals; p0=v14=this; p1=v15=parent

    const/4 v13, 0x0   # loop index
    :card_loop
    const/4 v12, 0x3
    if-ge v13, v12, :card_done

    # ── Card outer LL: horizontal, dark bg, margin bottom 8dp ─────────────────
    new-instance v0, Landroid/widget/LinearLayout;
    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v1, 0x0   # HORIZONTAL
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const v1, 0xFF1E1E1E   # dark card bg
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setBackgroundColor(I)V

    const/16 v1, 0x10   # 16dp padding
    invoke-virtual {p0, v1}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->dp(I)I
    move-result v1
    invoke-virtual {v0, v1, v1, v1, v1}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    # Card LP: MATCH_PARENT x WRAP_CONTENT, margin bottom 8dp
    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v2, -0x1   # MATCH_PARENT
    const/4 v3, -0x2   # WRAP_CONTENT
    invoke-direct {v1, v2, v3}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/4 v2, 0x8   # 8dp margin
    invoke-virtual {p0, v2}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->dp(I)I
    move-result v2
    iput v2, v1, Landroid/widget/LinearLayout$LayoutParams;->bottomMargin:I
    invoke-virtual {v0, v1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V
    # v0 = card outer LL

    # ── Left column: vertical LL with name/version/desc/status ────────────────
    new-instance v1, Landroid/widget/LinearLayout;
    invoke-direct {v1, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v2, 0x1   # VERTICAL
    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V
    # LP: 0 width, WRAP_CONTENT, weight=1
    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v3, 0x0
    const/4 v4, -0x2   # WRAP_CONTENT
    invoke-direct {v2, v3, v4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/high16 v3, 0x3f800000   # 1.0f
    iput v3, v2, Landroid/widget/LinearLayout$LayoutParams;->weight:F
    invoke-virtual {v1, v2}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V
    # v1 = left col LL

    # Name TextView (white 16sp bold)
    new-instance v2, Landroid/widget/TextView;
    invoke-direct {v2, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    invoke-virtual {p0, v13}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->getName(I)Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v3, 0xFFFFFFFF   # white
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V
    const/16 v3, 0x10   # 16sp
    int-to-float v3, v3
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextSize(F)V
    # setTypeface(null, Typeface.BOLD) — null = inherit default typeface, 1 = BOLD
    const/4 v3, 0x0   # null Typeface (use default)
    const/4 v4, 0x1   # Typeface.BOLD
    invoke-virtual {v2, v3, v4}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;I)V
    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # Version+desc TextView (gray 12sp)
    new-instance v2, Landroid/widget/TextView;
    invoke-direct {v2, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    # text = version + " — " + desc
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {p0, v13}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->getVersion(I)Ljava/lang/String;
    move-result-object v4
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v4, "  \u2014  "   # " — "
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {p0, v13}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->getDesc(I)Ljava/lang/String;
    move-result-object v4
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v3, 0xFF888888   # gray
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V
    const/16 v3, 0xc   # 12sp
    int-to-float v3, v3
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextSize(F)V
    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # Status TextView "✓ Installed" (green, GONE unless installed)
    new-instance v2, Landroid/widget/TextView;
    invoke-direct {v2, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v3, "\u2713 Installed"   # ✓ Installed
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v3, 0xFF4CAF50   # green
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V
    const/16 v3, 0xc   # 12sp
    int-to-float v3, v3
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextSize(F)V
    # Check if installed → VISIBLE(0) or GONE(8)
    invoke-virtual {p0, v13}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->getUrl(I)Ljava/lang/String;
    move-result-object v3
    invoke-virtual {p0, v3}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->isInstalled(Ljava/lang/String;)Z
    move-result v3
    if-nez v3, :status_visible
    const/4 v3, 0x8   # GONE
    goto :set_status_vis
    :status_visible
    const/4 v3, 0x0   # VISIBLE
    :set_status_vis
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setVisibility(I)V
    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    # Store in mStatusTVs[v13]
    iget-object v3, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->mStatusTVs:[Landroid/widget/TextView;
    aput-object v2, v3, v13
    # v0=card v1=leftCol v2=statusTV

    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    # v1 no longer needed

    # ── Install button (right side of card) ───────────────────────────────────
    new-instance v1, Landroid/widget/Button;
    invoke-direct {v1, p0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V
    const-string v2, "Install"
    invoke-virtual {v1, v2}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    const v2, 0xFFFFFFFF   # white
    invoke-virtual {v1, v2}, Landroid/widget/Button;->setTextColor(I)V
    const v2, 0xFFFF9800   # orange
    invoke-virtual {v1, v2}, Landroid/widget/Button;->setBackgroundColor(I)V
    # LP: WRAP_CONTENT x WRAP_CONTENT, gravity CENTER_VERTICAL
    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v3, -0x2   # WRAP_CONTENT
    invoke-direct {v2, v3, v3}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/16 v3, 0x10   # Gravity.CENTER_VERTICAL = 16
    iput v3, v2, Landroid/widget/LinearLayout$LayoutParams;->gravity:I
    invoke-virtual {v1, v2}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V
    # If already installed: disable button + gray bg
    invoke-virtual {p0, v13}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->getUrl(I)Ljava/lang/String;
    move-result-object v2
    invoke-virtual {p0, v2}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->isInstalled(Ljava/lang/String;)Z
    move-result v2
    if-eqz v2, :btn_not_installed
    const/4 v2, 0x0   # false
    invoke-virtual {v1, v2}, Landroid/widget/Button;->setEnabled(Z)V
    const v2, 0xFF555555   # gray bg when installed
    invoke-virtual {v1, v2}, Landroid/widget/Button;->setBackgroundColor(I)V
    const-string v2, "\u2713"   # ✓
    invoke-virtual {v1, v2}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    goto :btn_listener
    :btn_not_installed
    # Set click listener = $BhInstallListener(outer, index)
    :btn_listener
    new-instance v2, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$BhInstallListener;
    invoke-direct {v2, p0, v13}, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity$BhInstallListener;-><init>(Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;I)V
    invoke-virtual {v1, v2}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    # Store in mBtns[v13]
    iget-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/BhQuickSetupActivity;->mBtns:[Landroid/widget/Button;
    aput-object v1, v2, v13
    # Add btn to card
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # Add card to parent
    invoke-virtual {p1, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    add-int/lit8 v13, v13, 0x1
    goto :card_loop
    :card_done

    return-void
.end method
