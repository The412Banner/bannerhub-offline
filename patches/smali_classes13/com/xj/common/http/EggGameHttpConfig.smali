.class public final Lcom/xj/common/http/EggGameHttpConfig;
.super Ljava/lang/Object;
.source "r8-map-id-712846b76e3224c0169ce621759774aea144e14d75c3fb3c733f7f2b03c1bb19"


# annotations
.annotation build Landroidx/compose/runtime/internal/StabilityInferred;
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/xj/common/http/EggGameHttpConfig$Companion;
    }
.end annotation

.annotation runtime Lkotlin/Metadata;
.end annotation


# static fields
.field public static final a:Lcom/xj/common/http/EggGameHttpConfig$Companion;

.field public static final b:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 3

    .line 1
    .line 2
    new-instance v0, Lcom/xj/common/http/EggGameHttpConfig$Companion;

    .line 3
    const/4 v1, 0x0

    .line 4
    .line 5
    .line 6
    invoke-direct {v0, v1}, Lcom/xj/common/http/EggGameHttpConfig$Companion;-><init>(Lkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 7
    .line 8
    sput-object v0, Lcom/xj/common/http/EggGameHttpConfig;->a:Lcom/xj/common/http/EggGameHttpConfig$Companion;

    .line 9
    .line 10
    sget-object v0, Lcom/xj/common/config/Constants;->a:Lcom/xj/common/config/Constants;

    .line 11
    .line 12
    .line 13
    invoke-virtual {v0}, Lcom/xj/common/config/Constants;->c()Z

    .line 14
    move-result v0

    .line 15
    .line 16
    if-eqz v0, :cond_0

    .line 17
    .line 18
    const-string v0, "https://test-landscape-api.vgabc.com/"

    .line 19
    goto :goto_0

    .line 20
    .line 21
    :cond_0
    sget-object v0, Lcom/xj/common/config/AppConfig;->a:Lcom/xj/common/config/AppConfig$Companion;

    .line 22
    .line 23
    .line 24
    invoke-virtual {v0}, Lcom/xj/common/config/AppConfig$Companion;->l()Lcom/xj/common/config/ServerEnv;

    .line 25
    move-result-object v1

    .line 26
    .line 27
    sget-object v2, Lcom/xj/common/config/ServerEnv;->PRODUCT:Lcom/xj/common/config/ServerEnv;

    .line 28
    .line 29
    if-ne v1, v2, :cond_1

    .line 30
    .line 31
    const-string v0, "https://landscape-api.vgabc.com/"

    .line 32
    goto :goto_0

    .line 33
    .line 34
    .line 35
    :cond_1
    invoke-virtual {v0}, Lcom/xj/common/config/AppConfig$Companion;->l()Lcom/xj/common/config/ServerEnv;

    .line 36
    move-result-object v0

    .line 37
    .line 38
    sget-object v1, Lcom/xj/common/config/ServerEnv;->BETA:Lcom/xj/common/config/ServerEnv;

    .line 39
    .line 40
    if-ne v0, v1, :cond_2

    .line 41
    .line 42
    const-string v0, "https://landscape-api-beta.vgabc.com/"

    .line 43
    goto :goto_0

    .line 44
    .line 45
    :cond_2
    const-string v0, "https://dev-gamehub-api.vgabc.com/"

    .line 46
    .line 47
    :goto_0
    invoke-static {v0}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->getEffectiveApiUrl(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/xj/common/http/EggGameHttpConfig;->b:Ljava/lang/String;

    .line 48
    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 4
    return-void
.end method

.method public static synthetic a(Landroid/content/Context;Lokhttp3/OkHttpClient$Builder;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/common/http/EggGameHttpConfig;->d(Landroid/content/Context;Lokhttp3/OkHttpClient$Builder;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static final synthetic b()Ljava/lang/String;
    .locals 1

    .line 1
    .line 2
    sget-object v0, Lcom/xj/common/http/EggGameHttpConfig;->b:Ljava/lang/String;

    .line 3
    return-object v0
.end method

.method public static final d(Landroid/content/Context;Lokhttp3/OkHttpClient$Builder;)Lkotlin/Unit;
    .locals 11

    .line 1
    .line 2
    const-string v0, "$this$initialize"

    .line 3
    .line 4
    .line 5
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 6
    .line 7
    new-instance v0, Lcom/xj/common/http/MyErrorHandler;

    .line 8
    .line 9
    .line 10
    invoke-direct {v0}, Lcom/xj/common/http/MyErrorHandler;-><init>()V

    .line 11
    .line 12
    .line 13
    invoke-static {p1, v0}, Lcom/drake/net/okhttp/OkHttpBuilderKt;->d(Lokhttp3/OkHttpClient$Builder;Lcom/drake/net/interfaces/NetErrorHandler;)Lokhttp3/OkHttpClient$Builder;

    .line 14
    .line 15
    sget-object v0, Ljava/util/concurrent/TimeUnit;->SECONDS:Ljava/util/concurrent/TimeUnit;

    .line 16
    .line 17
    const-wide/16 v1, 0x1e

    .line 18
    .line 19
    .line 20
    invoke-virtual {p1, v1, v2, v0}, Lokhttp3/OkHttpClient$Builder;->connectTimeout(JLjava/util/concurrent/TimeUnit;)Lokhttp3/OkHttpClient$Builder;

    .line 21
    .line 22
    .line 23
    invoke-virtual {p1, v1, v2, v0}, Lokhttp3/OkHttpClient$Builder;->readTimeout(JLjava/util/concurrent/TimeUnit;)Lokhttp3/OkHttpClient$Builder;

    .line 24
    .line 25
    .line 26
    invoke-virtual {p1, v1, v2, v0}, Lokhttp3/OkHttpClient$Builder;->writeTimeout(JLjava/util/concurrent/TimeUnit;)Lokhttp3/OkHttpClient$Builder;

    .line 27
    .line 28
    new-instance v0, Lokhttp3/Cache;

    .line 29
    .line 30
    .line 31
    invoke-virtual {p0}, Landroid/content/Context;->getCacheDir()Ljava/io/File;

    .line 32
    move-result-object v1

    .line 33
    .line 34
    const-string v2, "getCacheDir(...)"

    .line 35
    .line 36
    .line 37
    invoke-static {v1, v2}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 38
    .line 39
    .line 40
    const-wide/32 v2, 0x8000000

    .line 41
    .line 42
    .line 43
    invoke-direct {v0, v1, v2, v3}, Lokhttp3/Cache;-><init>(Ljava/io/File;J)V

    .line 44
    .line 45
    .line 46
    invoke-virtual {p1, v0}, Lokhttp3/OkHttpClient$Builder;->cache(Lokhttp3/Cache;)Lokhttp3/OkHttpClient$Builder;

    .line 47
    const/4 v0, 0x0

    .line 48
    const/4 v1, 0x0

    .line 49
    const/4 v2, 0x2

    .line 50
    .line 51
    .line 52
    invoke-static {p1, v0, v1, v2, v1}, Lcom/drake/net/okhttp/OkHttpBuilderKt;->c(Lokhttp3/OkHttpClient$Builder;ZLjava/lang/String;ILjava/lang/Object;)Lokhttp3/OkHttpClient$Builder;

    # BannerHub Offline: register offline API interceptor first (short-circuits network for known paths)
    new-instance v0, Lcom/xj/winemu/sidebar/BhOfflineApiProvider;
    invoke-direct {v0}, Lcom/xj/winemu/sidebar/BhOfflineApiProvider;-><init>()V
    invoke-virtual {p1, v0}, Lokhttp3/OkHttpClient$Builder;->addInterceptor(Lokhttp3/Interceptor;)Lokhttp3/OkHttpClient$Builder;

    .line 53
    .line 54
    new-instance v0, Lcom/xj/common/http/interceptor/RemoveExtraSlashInterceptor;

    .line 55
    .line 56
    .line 57
    invoke-direct {v0}, Lcom/xj/common/http/interceptor/RemoveExtraSlashInterceptor;-><init>()V

    .line 58
    .line 59
    .line 60
    invoke-virtual {p1, v0}, Lokhttp3/OkHttpClient$Builder;->addInterceptor(Lokhttp3/Interceptor;)Lokhttp3/OkHttpClient$Builder;

    .line 61
    .line 62
    new-instance v3, Lcom/drake/net/interceptor/LogRecordInterceptor;

    .line 63
    const/4 v9, 0x6

    .line 64
    const/4 v10, 0x0

    .line 65
    const/4 v4, 0x0

    .line 66
    .line 67
    const-wide/16 v5, 0x0

    .line 68
    .line 69
    const-wide/16 v7, 0x0

    .line 70
    .line 71
    .line 72
    invoke-direct/range {v3 .. v10}, Lcom/drake/net/interceptor/LogRecordInterceptor;-><init>(ZJJILkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 73
    .line 74
    .line 75
    invoke-virtual {p1, v3}, Lokhttp3/OkHttpClient$Builder;->addInterceptor(Lokhttp3/Interceptor;)Lokhttp3/OkHttpClient$Builder;

    .line 76
    .line 77
    new-instance v0, Lcom/drake/net/cookie/PersistentCookieJar;

    .line 78
    .line 79
    .line 80
    invoke-direct {v0, p0, v1, v2, v1}, Lcom/drake/net/cookie/PersistentCookieJar;-><init>(Landroid/content/Context;Ljava/lang/String;ILkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 81
    .line 82
    .line 83
    invoke-virtual {p1, v0}, Lokhttp3/OkHttpClient$Builder;->cookieJar(Lokhttp3/CookieJar;)Lokhttp3/OkHttpClient$Builder;

    .line 84
    .line 85
    new-instance v0, Lcom/xj/common/http/interceptor/EggGameTokenInterceptor;

    .line 86
    .line 87
    .line 88
    invoke-direct {v0}, Lcom/xj/common/http/interceptor/EggGameTokenInterceptor;-><init>()V

    .line 89
    .line 90
    .line 91
    invoke-virtual {p1, v0}, Lokhttp3/OkHttpClient$Builder;->addInterceptor(Lokhttp3/Interceptor;)Lokhttp3/OkHttpClient$Builder;

    .line 92
    .line 93
    new-instance v0, Lcom/xj/common/http/interceptor/TokenRefreshInterceptor;

    .line 94
    .line 95
    .line 96
    invoke-direct {v0}, Lcom/xj/common/http/interceptor/TokenRefreshInterceptor;-><init>()V

    .line 97
    .line 98
    .line 99
    invoke-virtual {p1, v0}, Lokhttp3/OkHttpClient$Builder;->addInterceptor(Lokhttp3/Interceptor;)Lokhttp3/OkHttpClient$Builder;

    .line 100
    .line 101
    new-instance v1, Lcom/xj/common/http/interceptor/OfflineCacheInterceptor;

    .line 102
    const/4 v5, 0x2

    .line 103
    const/4 v6, 0x0

    .line 104
    .line 105
    const-wide/16 v3, 0x0

    .line 106
    move-object v2, p0

    .line 107
    .line 108
    .line 109
    invoke-direct/range {v1 .. v6}, Lcom/xj/common/http/interceptor/OfflineCacheInterceptor;-><init>(Landroid/content/Context;JILkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 110
    .line 111
    .line 112
    invoke-virtual {p1, v1}, Lokhttp3/OkHttpClient$Builder;->addInterceptor(Lokhttp3/Interceptor;)Lokhttp3/OkHttpClient$Builder;

    .line 113
    .line 114
    .line 115
    invoke-static {p1}, Lcom/xj/common/http/ChuckerUtilsKt;->b(Lokhttp3/OkHttpClient$Builder;)Lokhttp3/OkHttpClient$Builder;

    .line 116
    .line 117
    new-instance p0, Lcom/xj/common/http/GsonConverter;

    .line 118
    .line 119
    .line 120
    invoke-direct {p0}, Lcom/xj/common/http/GsonConverter;-><init>()V

    .line 121
    .line 122
    .line 123
    invoke-static {p1, p0}, Lcom/drake/net/okhttp/OkHttpBuilderKt;->a(Lokhttp3/OkHttpClient$Builder;Lcom/drake/net/convert/NetConverter;)Lokhttp3/OkHttpClient$Builder;

    .line 124
    .line 125
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 126
    return-object p0
.end method


# virtual methods
.method public final c(Landroid/content/Context;)V
    .locals 2

    .line 1
    .line 2
    const-string p0, "context"

    .line 3
    .line 4
    .line 5
    invoke-static {p1, p0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 6
    .line 7
    sget-object p0, Lcom/drake/net/NetConfig;->a:Lcom/drake/net/NetConfig;

    .line 8
    .line 9
    sget-object v0, Lcom/xj/common/http/EggGameHttpConfig;->b:Ljava/lang/String;

    .line 10
    .line 11
    new-instance v1, Lcom/xj/common/http/e;

    .line 12
    .line 13
    .line 14
    invoke-direct {v1, p1}, Lcom/xj/common/http/e;-><init>(Landroid/content/Context;)V

    .line 15
    .line 16
    .line 17
    invoke-virtual {p0, v0, p1, v1}, Lcom/drake/net/NetConfig;->l(Ljava/lang/String;Landroid/content/Context;Lkotlin/jvm/functions/Function1;)V

    .line 18
    return-void
.end method
