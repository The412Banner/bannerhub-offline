.class public final Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;
.super Landroidx/appcompat/app/AppCompatActivity;
.implements Landroid/widget/AdapterView$OnItemClickListener;

.field mListView:Landroid/widget/ListView;
.field mNames:Ljava/util/ArrayList;
.field mUrls:Ljava/util/ArrayList;
.field mDownloadUrl:Ljava/lang/String;
.field mDownloadFilename:Ljava/lang/String;
.field mStatusText:Landroid/widget/TextView;

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroidx/appcompat/app/AppCompatActivity;-><init>()V
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 6
    # v0=root, v1=statusText, v2=titleText, v3=listView, v4=params, v5=tmp
    # p0=this, p1=bundle (reused after super)

    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->onCreate(Landroid/os/Bundle;)V

    # init mNames / mUrls
    new-instance v5, Ljava/util/ArrayList;
    invoke-direct {v5}, Ljava/util/ArrayList;-><init>()V
    iput-object v5, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->mNames:Ljava/util/ArrayList;

    new-instance v5, Ljava/util/ArrayList;
    invoke-direct {v5}, Ljava/util/ArrayList;-><init>()V
    iput-object v5, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->mUrls:Ljava/util/ArrayList;

    # title TextView
    new-instance v2, Landroid/widget/TextView;
    invoke-direct {v2, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v5, "Download from Nightlies"
    invoke-virtual {v2, v5}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const/high16 v5, 0x41900000
    invoke-virtual {v2, v5}, Landroid/widget/TextView;->setTextSize(F)V
    const v5, -0x1
    invoke-virtual {v2, v5}, Landroid/widget/TextView;->setTextColor(I)V
    const/16 v5, 0x30
    const/16 p1, 0x18
    invoke-virtual {v2, v5, p1, v5, p1}, Landroid/widget/TextView;->setPadding(IIII)V

    # status TextView
    new-instance v1, Landroid/widget/TextView;
    invoke-direct {v1, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    iput-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->mStatusText:Landroid/widget/TextView;
    const-string v5, "Fetching nightly releases..."
    invoke-virtual {v1, v5}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const/high16 v5, 0x41080000
    invoke-virtual {v1, v5}, Landroid/widget/TextView;->setTextSize(F)V
    const v5, -0x5000001
    invoke-virtual {v1, v5}, Landroid/widget/TextView;->setTextColor(I)V
    const/16 v5, 0x30
    const/16 p1, 0x18
    invoke-virtual {v1, v5, p1, v5, p1}, Landroid/widget/TextView;->setPadding(IIII)V

    # ListView
    new-instance v3, Landroid/widget/ListView;
    invoke-direct {v3, p0}, Landroid/widget/ListView;-><init>(Landroid/content/Context;)V
    iput-object v3, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->mListView:Landroid/widget/ListView;
    invoke-virtual {v3, p0}, Landroid/widget/AbsListView;->setOnItemClickListener(Landroid/widget/AdapterView$OnItemClickListener;)V
    const/4 v5, 0x0
    invoke-virtual {v3, v5}, Landroid/view/ViewGroup;->setClipToPadding(Z)V

    # root LinearLayout
    new-instance v0, Landroid/widget/LinearLayout;
    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v5, 0x1
    invoke-virtual {v0, v5}, Landroid/widget/LinearLayout;->setOrientation(I)V
    invoke-virtual {v0, v5}, Landroid/view/View;->setFitsSystemWindows(Z)V

    # add title: MATCH_PARENT x WRAP_CONTENT
    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v5, -0x1
    const/4 p1, -0x2
    invoke-direct {v4, v5, p1}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    invoke-virtual {v0, v2, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # add status: MATCH_PARENT x WRAP_CONTENT
    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v5, -0x1
    const/4 p1, -0x2
    invoke-direct {v4, v5, p1}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    invoke-virtual {v0, v1, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # add listView: MATCH_PARENT x 0dp weight=1
    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v5, -0x1
    const/4 p1, 0x0
    const/high16 v2, 0x3f800000
    invoke-direct {v4, v5, p1, v2}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V
    invoke-virtual {v0, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->setContentView(Landroid/view/View;)V

    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->startFetch()V
    return-void
.end method

.method public startFetch()V
    .locals 2
    new-instance v0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$1;
    invoke-direct {v0, p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$1;-><init>(Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;)V
    new-instance v1, Ljava/lang/Thread;
    invoke-direct {v1, v0}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V
    invoke-virtual {v1}, Ljava/lang/Thread;->start()V
    return-void
.end method

.method public onItemClick(Landroid/widget/AdapterView;Landroid/view/View;IJ)V
    .locals 2
    # p3 = position (int)
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->mNames:Ljava/util/ArrayList;
    invoke-virtual {v0, p3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Ljava/lang/String;
    iput-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->mDownloadFilename:Ljava/lang/String;

    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->mUrls:Ljava/util/ArrayList;
    invoke-virtual {v1, p3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;
    move-result-object v1
    check-cast v1, Ljava/lang/String;
    iput-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->mDownloadUrl:Ljava/lang/String;

    # clear list to prevent double-tap
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->mListView:Landroid/widget/ListView;
    const/4 v1, 0x0
    invoke-virtual {v0, v1}, Landroid/widget/ListView;->setAdapter(Landroid/widget/ListAdapter;)V

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->mStatusText:Landroid/widget/TextView;
    const-string v1, "Downloading..."
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->startDownload()V
    return-void
.end method

.method public startDownload()V
    .locals 2
    new-instance v0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$3;
    invoke-direct {v0, p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$3;-><init>(Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;)V
    new-instance v1, Ljava/lang/Thread;
    invoke-direct {v1, v0}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V
    invoke-virtual {v1}, Ljava/lang/Thread;->start()V
    return-void
.end method

.method public static detectType(Ljava/lang/String;)I
    .locals 1

    invoke-virtual {p0}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;
    move-result-object p0

    const-string v0, "box64"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-eqz v0, :not_box64
    const/16 v0, 0x5e
    return v0

    :not_box64
    const-string v0, "fex"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-eqz v0, :not_fex
    const/16 v0, 0x5f
    return v0

    :not_fex
    const-string v0, "vkd3d"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-eqz v0, :not_vkd3d
    const/16 v0, 0xd
    return v0

    :not_vkd3d
    const-string v0, "turnip"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-eqz v0, :not_turnip
    const/16 v0, 0xa
    return v0

    :not_turnip
    const-string v0, "adreno"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-eqz v0, :not_adreno
    const/16 v0, 0xa
    return v0

    :not_adreno
    const-string v0, "driver"
    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-eqz v0, :not_driver
    const/16 v0, 0xa
    return v0

    :not_driver
    # default: DXVK
    const/16 v0, 0xc
    return v0
.end method
