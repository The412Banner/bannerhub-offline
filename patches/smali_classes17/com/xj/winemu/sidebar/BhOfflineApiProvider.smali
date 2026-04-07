# BhOfflineApiProvider — OkHttp interceptor for offline dashboard
# Returns pre-baked JSON responses for known GameHub API endpoints so the
# dashboard UI shell renders without any network access.
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
    # v0=Request v1=method/HttpUrl/temp v2=encodedPath v3=comparison/Builder
    # v4=body string v5=ResponseBody v6=temp(Protocol/int/str)

    invoke-interface {p1}, Lokhttp3/Interceptor$Chain;->request()Lokhttp3/Request;
    move-result-object v0

    # Get HTTP method
    invoke-virtual {v0}, Lokhttp3/Request;->method()Ljava/lang/String;
    move-result-object v1

    # Get encoded path
    invoke-virtual {v0}, Lokhttp3/Request;->url()Lokhttp3/HttpUrl;
    move-result-object v3
    invoke-virtual {v3}, Lokhttp3/HttpUrl;->encodedPath()Ljava/lang/String;
    move-result-object v2

    # ── POST paths ──────────────────────────────────────────────────────────
    const-string v3, "POST"
    invoke-virtual {v3, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-eqz v3, :check_get

    const-string v3, "/vtouch/startType"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-nez v3, :resp_vtouch

    const-string v3, "/vtouch/startType_steam"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-nez v3, :resp_vtouch

    goto :proceed

    # ── GET paths ───────────────────────────────────────────────────────────
    :check_get
    const-string v3, "GET"
    invoke-virtual {v3, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-eqz v3, :proceed

    const-string v3, "/base/getBaseInfo"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-nez v3, :resp_base_info

    const-string v3, "/user/info"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-nez v3, :resp_empty_obj

    const-string v3, "/card/getTopPlatform"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-nez v3, :resp_top_platform

    const-string v3, "/card/getIndexList"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-nez v3, :resp_empty_arr

    const-string v3, "/card/getCtsList"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-nez v3, :resp_empty_arr

    const-string v3, "/card/getNewsList"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-nez v3, :resp_empty_arr

    const-string v3, "/card/getGameIcon"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-nez v3, :resp_empty_arr

    const-string v3, "/card/getGameCircleList"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-nez v3, :resp_empty_arr

    const-string v3, "/simulator/getTabList"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-nez v3, :resp_tab_list

    const-string v3, "/simulator/v2/getComponentList"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-nez v3, :resp_component_list

    const-string v3, "/simulator/v2/getAllComponentList"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-nez v3, :resp_all_component_list

    const-string v3, "/simulator/v2/getContainerList"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-nez v3, :resp_container_list

    const-string v3, "/simulator/v2/getDefaultComponent"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-nez v3, :resp_default_component

    const-string v3, "/simulator/v2/getImagefsDetail"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-nez v3, :resp_imagefs_detail

    const-string v3, "/upgrade/getAppUpgradeApk"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-nez v3, :resp_empty_obj

    const-string v3, "/devices/getDevicesList"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-nez v3, :resp_empty_arr

    const-string v3, "/game/checkLocalHandTourGame"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-nez v3, :resp_empty_obj

    const-string v3, "/game/userVideoNum"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-nez v3, :resp_empty_obj

    const-string v3, "/game/getDnsIpPool"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-nez v3, :resp_empty_arr

    const-string v3, "/heartbeat/game/getUserPlayTimeList"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-nez v3, :resp_empty_arr

    const-string v3, "/cloud/game/check_user_timer"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-nez v3, :resp_empty_obj

    # Unknown path — pass through
    :proceed
    invoke-interface {p1, v0}, Lokhttp3/Interceptor$Chain;->proceed(Lokhttp3/Request;)Lokhttp3/Response;
    move-result-object v0
    return-object v0

    # ── Response bodies ──────────────────────────────────────────────────────

    :resp_base_info
    const-string v4, "{\"code\":200,\"msg\":\"Success\",\"data\":{\"cloud_game_switch\":2,\"guide_info_img\":\"\",\"guide_storage_img\":\"\"},\"time\":\"0\"}"
    goto :build

    :resp_top_platform
    const-string v4, "{\"code\":200,\"msg\":\"\",\"time\":\"0\",\"data\":[{\"id\":13,\"name\":\"PC Emulator\",\"icon\":\"\",\"type\":7,\"back_img\":\"\"}]}"
    goto :build

    :resp_tab_list
    const-string v4, "{\"code\":200,\"msg\":\"\",\"time\":\"0\",\"data\":[{\"name\":\"Firmware\",\"type\":1,\"sub_type\":0},{\"name\":\"Compatibility layer\",\"type\":2,\"sub_type\":0},{\"name\":\"Translator\",\"type\":3,\"sub_type\":1},{\"name\":\"GPUdriver\",\"type\":3,\"sub_type\":2},{\"name\":\"DXVK\",\"type\":3,\"sub_type\":3},{\"name\":\"VKD3D\",\"type\":3,\"sub_type\":4}]}"
    goto :build

    :resp_vtouch
    const-string v4, "{\"code\":200,\"msg\":\"Success\",\"data\":{\"start_type\":1,\"audio_driver\":1,\"component_ids\":[7,8,25,345,48],\"container\":{\"blurb\":\"\",\"display_name\":\"proton10.0-arm64x-2\",\"download_url\":\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/wine_proton10.0-arm64x-2.tar.zst\",\"file_md5\":\"6dcb13706c9c7720b074ee020ce39bbc\",\"file_name\":\"wine_proton10.0-arm64x-2.tar.zst\",\"file_size\":\"216807973\",\"framework\":\"arm64X\",\"framework_type\":\"proton\",\"id\":2,\"is_steam\":1,\"logo\":\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/45e60d211d35955bd045aabfded4e64b.png\",\"name\":\"proton10.0-arm64x-2\",\"sub_data\":{\"sub_file_name\":\"6dcb13706c9c7720b074ee020ce39bbc.tzst\",\"sub_download_url\":\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/6dcb13706c9c7720b074ee020ce39bbc.tzst\",\"sub_file_md5\":\"439b7ec0ae13685aee76a10904ebccf4\"},\"version\":\"1.0.3\",\"version_code\":4},\"container_id\":2,\"controller\":{\"dinput\":false,\"xinput\":true,\"xboxLayout\":false,\"vibration\":true},\"cpu_limitations\":0,\"directx_panel\":0,\"environment\":\"\",\"launch_windowed_mode\":0,\"start_param\":\"\",\"video_memory\":0,\"translations\":{\"box64\":{\"AlignedAtomics\":\"0\",\"BigBlock\":\"2\",\"Box64AVX\":\"0\",\"CallRet\":\"0\",\"CpuType\":\"0\",\"DF\":\"1\",\"DIV0\":\"0\",\"Dirty\":\"0\",\"Dynarec\":\"1\",\"FastNan\":\"1\",\"FastRound\":\"1\",\"IgnoreINT3\":\"0\",\"NativeFlags\":\"1\",\"Pause\":\"0\",\"RDTSC1GHZ\":\"0\",\"SafeFlags\":\"0\",\"StrongMem\":\"0\",\"VolatileMetadataBox64\":\"1\",\"Wait\":\"1\",\"WeakBarrier\":\"0\",\"X87Double\":\"0\"},\"fex\":{\"HalfBarrierTSOEnabled\":\"1\",\"HideHypervisorBit\":\"0\",\"MaxInst\":\"5000\",\"MemcpySetTSOEnabled\":\"0\",\"MonoHacks\":\"1\",\"Multiblock\":\"0\",\"SMCChecks\":\"mtrack\",\"SmallTSCScale\":\"1\",\"TSOEnabled\":\"1\",\"VectorTSOEnabled\":\"0\",\"VolatileMetadata\":\"1\",\"X87ReducedPrecision\":\"1\"}}},\"time\":\"0\"}"
    goto :build

    :resp_component_list
    const-string v4, "{\"code\":200,\"msg\":\"Success\",\"data\":{\"list\":\"[{\\\"blurb\\\":\\\"\\\",\\\"display_name\\\":\\\"Fex-20260321\\\",\\\"download_url\\\":\\\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/e41acf1248a8e48411ce2b7f8c73dc65.tzst\\\",\\\"file_md5\\\":\\\"e41acf1248a8e48411ce2b7f8c73dc65\\\",\\\"file_name\\\":\\\"e41acf1248a8e48411ce2b7f8c73dc65.tzst\\\",\\\"file_size\\\":10922243,\\\"gpu_range\\\":\\\"\\\",\\\"id\\\":1103,\\\"logo\\\":\\\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/45e60d211d35955bd045aabfded4e64b.png\\\",\\\"name\\\":\\\"Fex-20260321\\\",\\\"type\\\":1,\\\"version\\\":\\\"1.0.0\\\",\\\"version_code\\\":1},{\\\"blurb\\\":\\\"\\\",\\\"display_name\\\":\\\"Turnip_v26.1.0_R5\\\",\\\"download_url\\\":\\\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/36e67b87b7597fb049edf3d18b62e353.tzst\\\",\\\"file_md5\\\":\\\"36e67b87b7597fb049edf3d18b62e353\\\",\\\"file_name\\\":\\\"36e67b87b7597fb049edf3d18b62e353.tzst\\\",\\\"file_size\\\":3101921,\\\"gpu_range\\\":\\\"\\\",\\\"id\\\":1104,\\\"logo\\\":\\\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/45e60d211d35955bd045aabfded4e64b.png\\\",\\\"name\\\":\\\"Turnip_v26.1.0_R5\\\",\\\"type\\\":2,\\\"version\\\":\\\"1.0.0\\\",\\\"version_code\\\":1},{\\\"blurb\\\":\\\"\\\",\\\"display_name\\\":\\\"\\\",\\\"download_url\\\":\\\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/dxvk-v2.4.1-async.tzst\\\",\\\"file_md5\\\":\\\"d4303adb6e1844bfc5807ba8b01236da\\\",\\\"file_name\\\":\\\"dxvk-v2.4.1-async.tzst\\\",\\\"file_size\\\":9150064,\\\"gpu_range\\\":\\\"\\\",\\\"id\\\":259,\\\"logo\\\":\\\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/45e60d211d35955bd045aabfded4e64b.png\\\",\\\"name\\\":\\\"dxvk-v2.4.1-async\\\",\\\"type\\\":3,\\\"version\\\":\\\"1.1.0\\\",\\\"version_code\\\":1073},{\\\"blurb\\\":\\\"\\\",\\\"display_name\\\":\\\"\\\",\\\"download_url\\\":\\\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/vkd3d-2.12.tzst\\\",\\\"file_md5\\\":\\\"4f3e99438281f7749cb2b8b2412c9d10\\\",\\\"file_name\\\":\\\"vkd3d-2.12.tzst\\\",\\\"file_size\\\":2643215,\\\"gpu_range\\\":\\\"\\\",\\\"id\\\":7,\\\"logo\\\":\\\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/45e60d211d35955bd045aabfded4e64b.png\\\",\\\"name\\\":\\\"vkd3d-2.12\\\",\\\"type\\\":4,\\\"version\\\":\\\"1.1.1\\\",\\\"version_code\\\":1},{\\\"blurb\\\":\\\"\\\",\\\"display_name\\\":\\\"\\\",\\\"download_url\\\":\\\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/base.tzst\\\",\\\"file_md5\\\":\\\"3d5c31b1346985d582f04d239004b4d7\\\",\\\"file_name\\\":\\\"base.tzst\\\",\\\"file_size\\\":40612198,\\\"gpu_range\\\":\\\"\\\",\\\"id\\\":8,\\\"logo\\\":\\\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/45e60d211d35955bd045aabfded4e64b.png\\\",\\\"name\\\":\\\"base\\\",\\\"type\\\":5,\\\"version\\\":\\\"1.0.0\\\",\\\"version_code\\\":1},{\\\"blurb\\\":\\\"\\\",\\\"display_name\\\":\\\"\\\",\\\"download_url\\\":\\\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/steam_9866233.tar.zst\\\",\\\"file_md5\\\":\\\"250a0996b2949022c44f274baa525411\\\",\\\"file_name\\\":\\\"steam_9866233.tar.zst\\\",\\\"file_size\\\":41821882,\\\"gpu_range\\\":\\\"\\\",\\\"id\\\":334,\\\"logo\\\":\\\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/45e60d211d35955bd045aabfded4e64b.png\\\",\\\"name\\\":\\\"steam_9866233\\\",\\\"type\\\":7,\\\"version\\\":\\\"1.0.0\\\",\\\"version_code\\\":1}]\"},\"time\":\"0\"}"
    goto :build

    :resp_all_component_list
    const-string v4, "{\"code\":200,\"msg\":\"Success\",\"data\":{\"list\":\"[{\\\"display_name\\\":\\\"Fex-20260321\\\",\\\"download_url\\\":\\\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/e41acf1248a8e48411ce2b7f8c73dc65.tzst\\\",\\\"file_md5\\\":\\\"e41acf1248a8e48411ce2b7f8c73dc65\\\",\\\"file_name\\\":\\\"e41acf1248a8e48411ce2b7f8c73dc65.tzst\\\",\\\"file_size\\\":10922243,\\\"id\\\":1103,\\\"is_ui\\\":1,\\\"logo\\\":\\\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/45e60d211d35955bd045aabfded4e64b.png\\\",\\\"name\\\":\\\"Fex-20260321\\\",\\\"type\\\":1,\\\"version\\\":\\\"1.0.0\\\",\\\"version_code\\\":1},{\\\"display_name\\\":\\\"Turnip_v26.1.0_R5\\\",\\\"download_url\\\":\\\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/36e67b87b7597fb049edf3d18b62e353.tzst\\\",\\\"file_md5\\\":\\\"36e67b87b7597fb049edf3d18b62e353\\\",\\\"file_name\\\":\\\"36e67b87b7597fb049edf3d18b62e353.tzst\\\",\\\"file_size\\\":3101921,\\\"id\\\":1104,\\\"is_ui\\\":1,\\\"logo\\\":\\\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/45e60d211d35955bd045aabfded4e64b.png\\\",\\\"name\\\":\\\"Turnip_v26.1.0_R5\\\",\\\"type\\\":2,\\\"version\\\":\\\"1.0.0\\\",\\\"version_code\\\":1},{\\\"display_name\\\":\\\"\\\",\\\"download_url\\\":\\\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/dxvk-v2.4.1-async.tzst\\\",\\\"file_md5\\\":\\\"d4303adb6e1844bfc5807ba8b01236da\\\",\\\"file_name\\\":\\\"dxvk-v2.4.1-async.tzst\\\",\\\"file_size\\\":9150064,\\\"id\\\":259,\\\"is_ui\\\":1,\\\"logo\\\":\\\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/45e60d211d35955bd045aabfded4e64b.png\\\",\\\"name\\\":\\\"dxvk-v2.4.1-async\\\",\\\"type\\\":3,\\\"version\\\":\\\"1.1.0\\\",\\\"version_code\\\":1073},{\\\"display_name\\\":\\\"\\\",\\\"download_url\\\":\\\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/vkd3d-2.12.tzst\\\",\\\"file_md5\\\":\\\"4f3e99438281f7749cb2b8b2412c9d10\\\",\\\"file_name\\\":\\\"vkd3d-2.12.tzst\\\",\\\"file_size\\\":2643215,\\\"id\\\":7,\\\"is_ui\\\":1,\\\"logo\\\":\\\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/45e60d211d35955bd045aabfded4e64b.png\\\",\\\"name\\\":\\\"vkd3d-2.12\\\",\\\"type\\\":4,\\\"version\\\":\\\"1.1.1\\\",\\\"version_code\\\":1},{\\\"display_name\\\":\\\"\\\",\\\"download_url\\\":\\\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/base.tzst\\\",\\\"file_md5\\\":\\\"3d5c31b1346985d582f04d239004b4d7\\\",\\\"file_name\\\":\\\"base.tzst\\\",\\\"file_size\\\":40612198,\\\"id\\\":8,\\\"is_ui\\\":1,\\\"logo\\\":\\\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/45e60d211d35955bd045aabfded4e64b.png\\\",\\\"name\\\":\\\"base\\\",\\\"type\\\":5,\\\"version\\\":\\\"1.0.0\\\",\\\"version_code\\\":1},{\\\"display_name\\\":\\\"\\\",\\\"download_url\\\":\\\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/steam_9866233.tar.zst\\\",\\\"file_md5\\\":\\\"250a0996b2949022c44f274baa525411\\\",\\\"file_name\\\":\\\"steam_9866233.tar.zst\\\",\\\"file_size\\\":41821882,\\\"id\\\":334,\\\"is_ui\\\":1,\\\"logo\\\":\\\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/45e60d211d35955bd045aabfded4e64b.png\\\",\\\"name\\\":\\\"steam_9866233\\\",\\\"type\\\":7,\\\"version\\\":\\\"1.0.0\\\",\\\"version_code\\\":1}]\"},\"time\":\"0\"}"
    goto :build

    :resp_container_list
    const-string v4, "{\"code\":200,\"msg\":\"Success\",\"data\":[{\"display_name\":\"proton10.0-arm64x-2\",\"download_url\":\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/wine_proton10.0-arm64x-2.tar.zst\",\"file_md5\":\"6dcb13706c9c7720b074ee020ce39bbc\",\"file_name\":\"wine_proton10.0-arm64x-2.tar.zst\",\"file_size\":\"216807973\",\"framework\":\"arm64X\",\"framework_type\":\"proton\",\"id\":2,\"is_steam\":1,\"logo\":\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/45e60d211d35955bd045aabfded4e64b.png\",\"name\":\"proton10.0-arm64x-2\",\"sub_data\":{\"sub_file_name\":\"6dcb13706c9c7720b074ee020ce39bbc.tzst\",\"sub_download_url\":\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/6dcb13706c9c7720b074ee020ce39bbc.tzst\",\"sub_file_md5\":\"439b7ec0ae13685aee76a10904ebccf4\"},\"version\":\"1.0.3\",\"version_code\":4}],\"time\":\"0\"}"
    goto :build

    :resp_default_component
    const-string v4, "{\"code\":200,\"msg\":\"Success\",\"data\":{\"container\":null,\"gpu\":null,\"dxvk\":{\"blurb\":\"\",\"display_name\":\"\",\"download_url\":\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/dxvk-async-1.10.3.tzst\",\"file_md5\":\"e6041eb8b5e8596e33bf0da1b9a4342f\",\"file_name\":\"dxvk-async-1.10.3.tzst\",\"file_size\":7850661,\"id\":24,\"logo\":\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/45e60d211d35955bd045aabfded4e64b.png\",\"name\":\"dxvk-1.10.3-async\",\"type\":3,\"version\":\"1.1.0\",\"version_code\":7},\"vkd3d\":{\"blurb\":\"\",\"display_name\":\"\",\"download_url\":\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/vkd3d-2.12.tzst\",\"file_md5\":\"4f3e99438281f7749cb2b8b2412c9d10\",\"file_name\":\"vkd3d-2.12.tzst\",\"file_size\":2643215,\"id\":7,\"logo\":\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/45e60d211d35955bd045aabfded4e64b.png\",\"name\":\"vkd3d-2.12\",\"type\":4,\"version\":\"1.1.1\",\"version_code\":1},\"translator\":{\"blurb\":\"\",\"display_name\":\"\",\"download_url\":\"\",\"file_md5\":\"\",\"file_name\":\"\",\"file_size\":0,\"id\":0,\"logo\":\"\",\"name\":\"\",\"type\":0,\"version\":\"\",\"version_code\":0},\"steamClient\":{\"blurb\":\"\",\"display_name\":\"\",\"download_url\":\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/steam_9866233.tar.zst\",\"file_md5\":\"250a0996b2949022c44f274baa525411\",\"file_name\":\"steam_9866233.tar.zst\",\"file_size\":41821882,\"id\":334,\"logo\":\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/45e60d211d35955bd045aabfded4e64b.png\",\"name\":\"steam_9866233\",\"type\":7,\"version\":\"1.0.0\",\"version_code\":1}},\"time\":\"1775364117\"}"
    goto :build

    :resp_imagefs_detail
    const-string v4, "{\"code\":200,\"msg\":\"Success\",\"data\":{\"id\":1,\"version\":\"1.3.3\",\"version_code\":23,\"name\":\"Firmware\",\"logo\":\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/45e60d211d35955bd045aabfded4e64b.png\",\"upgrade_msg\":\"\",\"blurb\":\"\",\"download_url\":\"https://github.com/The412Banner/bannerhub-api/releases/download/Components/imagefs.zst\",\"file_md5\":\"27fd516411780c91dace321dd3b73d66\",\"file_size\":\"168943620\",\"file_name\":\"imagefs.zst\",\"display_name\":\"Firmware\"},\"time\":\"1775364117\"}"
    goto :build

    :resp_empty_arr
    const-string v4, "{\"code\":200,\"msg\":\"\",\"time\":\"0\",\"data\":[]}"
    goto :build

    :resp_empty_obj
    const-string v4, "{\"code\":200,\"msg\":\"\",\"time\":\"0\",\"data\":{}}"

    # ── Build mock OkHttp Response ────────────────────────────────────────────
    :build
    const-string v3, "application/json; charset=utf-8"
    invoke-static {v3}, Lokhttp3/MediaType;->parse(Ljava/lang/String;)Lokhttp3/MediaType;
    move-result-object v3

    invoke-static {v3, v4}, Lokhttp3/ResponseBody;->create(Lokhttp3/MediaType;Ljava/lang/String;)Lokhttp3/ResponseBody;
    move-result-object v5

    new-instance v3, Lokhttp3/Response$Builder;
    invoke-direct {v3}, Lokhttp3/Response$Builder;-><init>()V

    invoke-virtual {v3, v0}, Lokhttp3/Response$Builder;->request(Lokhttp3/Request;)Lokhttp3/Response$Builder;

    sget-object v6, Lokhttp3/Protocol;->HTTP_1_1:Lokhttp3/Protocol;
    invoke-virtual {v3, v6}, Lokhttp3/Response$Builder;->protocol(Lokhttp3/Protocol;)Lokhttp3/Response$Builder;

    const/16 v6, 0xc8
    invoke-virtual {v3, v6}, Lokhttp3/Response$Builder;->code(I)Lokhttp3/Response$Builder;

    const-string v6, "OK"
    invoke-virtual {v3, v6}, Lokhttp3/Response$Builder;->message(Ljava/lang/String;)Lokhttp3/Response$Builder;

    invoke-virtual {v3, v5}, Lokhttp3/Response$Builder;->body(Lokhttp3/ResponseBody;)Lokhttp3/Response$Builder;

    invoke-virtual {v3}, Lokhttp3/Response$Builder;->build()Lokhttp3/Response;
    move-result-object v3
    return-object v3

.end method
