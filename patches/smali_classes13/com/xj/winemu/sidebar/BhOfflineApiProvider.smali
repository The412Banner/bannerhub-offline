# BhOfflineApiProvider — OkHttp interceptor for offline dashboard
# Returns pre-baked JSON responses for known GameHub API endpoints so the
# dashboard UI shell renders without any network access. Locally imported
# games still come from Room DB; this just feeds the surrounding UI shell.
# Registered as the first interceptor in EggGameHttpConfig.d().

.class public Lcom/xj/winemu/sidebar/BhOfflineApiProvider;
.super Ljava/lang/Object;
.implements Lokhttp3/Interceptor;

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method public intercept(Lokhttp3/Interceptor$Chain;)Lokhttp3/Response;
    .locals 7
    .throws Ljava/io/IOException;
    # v0 = Request
    # v1 = temp / bool / HttpUrl
    # v2 = encoded path String
    # v3 = comparison String / Response$Builder
    # v4 = response body String
    # v5 = ResponseBody
    # v6 = temp (Protocol / int / String)

    # Get request from chain
    invoke-interface {p1}, Lokhttp3/Interceptor$Chain;->request()Lokhttp3/Request;
    move-result-object v0

    # Only intercept GET requests
    invoke-virtual {v0}, Lokhttp3/Request;->method()Ljava/lang/String;
    move-result-object v1
    const-string v2, "GET"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :proceed

    # Get encoded path (includes leading '/')
    invoke-virtual {v0}, Lokhttp3/Request;->url()Lokhttp3/HttpUrl;
    move-result-object v1
    invoke-virtual {v1}, Lokhttp3/HttpUrl;->encodedPath()Ljava/lang/String;
    move-result-object v2

    # ── Path matching ────────────────────────────────────────────────────────

    const-string v3, "/base/getBaseInfo"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-nez v1, :resp_base_info

    const-string v3, "/user/info"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-nez v1, :resp_empty_obj

    const-string v3, "/card/getTopPlatform"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-nez v1, :resp_top_platform

    const-string v3, "/card/getIndexList"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-nez v1, :resp_empty_arr

    const-string v3, "/card/getCtsList"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-nez v1, :resp_empty_arr

    const-string v3, "/card/getNewsList"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-nez v1, :resp_empty_arr

    const-string v3, "/card/getGameIcon"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-nez v1, :resp_empty_arr

    const-string v3, "/card/getGameCircleList"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-nez v1, :resp_empty_arr

    const-string v3, "/simulator/getTabList"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-nez v1, :resp_tab_list

    const-string v3, "/upgrade/getAppUpgradeApk"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-nez v1, :resp_empty_obj

    const-string v3, "/devices/getDevicesList"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-nez v1, :resp_empty_arr

    const-string v3, "/game/checkLocalHandTourGame"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-nez v1, :resp_empty_obj

    const-string v3, "/game/userVideoNum"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-nez v1, :resp_empty_obj

    const-string v3, "/game/getDnsIpPool"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-nez v1, :resp_empty_arr

    const-string v3, "/game/getGameCircleList"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-nez v1, :resp_empty_arr

    const-string v3, "/heartbeat/game/getUserPlayTimeList"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-nez v1, :resp_empty_arr

    const-string v3, "/cloud/game/check_user_timer"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-nez v1, :resp_empty_obj

    # Unknown path — pass through (will fail gracefully offline)
    :proceed
    invoke-interface {p1, v0}, Lokhttp3/Interceptor$Chain;->proceed(Lokhttp3/Request;)Lokhttp3/Response;
    move-result-object v0
    return-object v0

    # ── Response body constants ──────────────────────────────────────────────

    :resp_base_info
    const-string v4, "{\"code\":200,\"msg\":\"Success\",\"data\":{\"cloud_game_switch\":2,\"guide_info_img\":\"\",\"guide_storage_img\":\"\"},\"time\":\"0\"}"
    goto :build

    :resp_top_platform
    const-string v4, "{\"code\":200,\"msg\":\"\",\"time\":\"0\",\"data\":[{\"id\":13,\"name\":\"PC Emulator\",\"icon\":\"\",\"type\":7,\"back_img\":\"\"}]}"
    goto :build

    :resp_tab_list
    const-string v4, "{\"code\":200,\"msg\":\"\",\"time\":\"0\",\"data\":[{\"name\":\"Firmware\",\"type\":1,\"sub_type\":0},{\"name\":\"Compatibility layer\",\"type\":2,\"sub_type\":0},{\"name\":\"Translator\",\"type\":3,\"sub_type\":1},{\"name\":\"GPUdriver\",\"type\":3,\"sub_type\":2},{\"name\":\"DXVK\",\"type\":3,\"sub_type\":3},{\"name\":\"VKD3D\",\"type\":3,\"sub_type\":4}]}"
    goto :build

    :resp_empty_arr
    const-string v4, "{\"code\":200,\"msg\":\"\",\"time\":\"0\",\"data\":[]}"
    goto :build

    :resp_empty_obj
    const-string v4, "{\"code\":200,\"msg\":\"\",\"time\":\"0\",\"data\":{}}"
    # fall through to :build

    # ── Build mock OkHttp Response ───────────────────────────────────────────
    :build
    # MediaType = "application/json; charset=utf-8"
    const-string v3, "application/json; charset=utf-8"
    invoke-static {v3}, Lokhttp3/MediaType;->parse(Ljava/lang/String;)Lokhttp3/MediaType;
    move-result-object v3

    # ResponseBody.create(MediaType, String)
    invoke-static {v3, v4}, Lokhttp3/ResponseBody;->create(Lokhttp3/MediaType;Ljava/lang/String;)Lokhttp3/ResponseBody;
    move-result-object v5

    # new Response.Builder()
    new-instance v3, Lokhttp3/Response$Builder;
    invoke-direct {v3}, Lokhttp3/Response$Builder;-><init>()V

    # .request(request)
    invoke-virtual {v3, v0}, Lokhttp3/Response$Builder;->request(Lokhttp3/Request;)Lokhttp3/Response$Builder;

    # .protocol(Protocol.HTTP_1_1)
    sget-object v6, Lokhttp3/Protocol;->HTTP_1_1:Lokhttp3/Protocol;
    invoke-virtual {v3, v6}, Lokhttp3/Response$Builder;->protocol(Lokhttp3/Protocol;)Lokhttp3/Response$Builder;

    # .code(200)
    const/16 v6, 0xc8
    invoke-virtual {v3, v6}, Lokhttp3/Response$Builder;->code(I)Lokhttp3/Response$Builder;

    # .message("OK")
    const-string v6, "OK"
    invoke-virtual {v3, v6}, Lokhttp3/Response$Builder;->message(Ljava/lang/String;)Lokhttp3/Response$Builder;

    # .body(responseBody)
    invoke-virtual {v3, v5}, Lokhttp3/Response$Builder;->body(Lokhttp3/ResponseBody;)Lokhttp3/Response$Builder;

    # .build()
    invoke-virtual {v3}, Lokhttp3/Response$Builder;->build()Lokhttp3/Response;
    move-result-object v3
    return-object v3

.end method
