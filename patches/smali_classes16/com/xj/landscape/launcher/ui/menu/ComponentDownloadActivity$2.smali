# ShowListRunnable — UI thread: populate ListView with fetched names, or show "nothing found" and finish
.class final Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$2;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

.field final this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;

.method constructor <init>(Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$2;->this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;
    return-void
.end method

.method public run()V
    .locals 5
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$2;->this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;

    iget-object v1, v0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->mNames:Ljava/util/ArrayList;
    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I
    move-result v2
    if-nez v2, :not_empty

    # empty: toast + finish
    const-string v1, "No nightly components found"
    const/4 v2, 0x1
    invoke-static {v0, v1, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v1
    invoke-virtual {v1}, Landroid/widget/Toast;->show()V
    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->finish()V
    return-void

    :not_empty
    # build ArrayAdapter from mNames and set on listView
    invoke-virtual {v1}, Ljava/util/ArrayList;->toArray()[Ljava/lang/Object;
    move-result-object v2

    new-instance v3, Landroid/widget/ArrayAdapter;
    sget v4, Landroid/R$layout;->simple_list_item_1:I
    invoke-direct {v3, v0, v4, v2}, Landroid/widget/ArrayAdapter;-><init>(Landroid/content/Context;I[Ljava/lang/Object;)V

    iget-object v4, v0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->mListView:Landroid/widget/ListView;
    invoke-virtual {v4, v3}, Landroid/widget/ListView;->setAdapter(Landroid/widget/ListAdapter;)V

    iget-object v3, v0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->mStatusText:Landroid/widget/TextView;
    const-string v4, "Tap a component to download and inject"
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    return-void
.end method
