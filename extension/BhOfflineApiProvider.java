package com.xj.winemu.sidebar;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import okhttp3.Interceptor;
import okhttp3.MediaType;
import okhttp3.Protocol;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.ResponseBody;

/**
 * BannerHub Offline — pre-baked API response interceptor.
 *
 * Intercepts OkHttp requests to known GameHub API paths and returns
 * static JSON responses so the dashboard renders without network access.
 * Local imported games still come from Room DB; this just feeds the
 * surrounding UI shell (top platform tabs, user info, empty card lists).
 */
public class BhOfflineApiProvider implements Interceptor {

    private static final MediaType JSON = MediaType.parse("application/json; charset=utf-8");

    // Minimal valid responses for each endpoint the dashboard needs on launch.
    private static final Map<String, String> RESPONSES = new HashMap<>();

    static {
        // Empty list helper
        final String EMPTY = "{\"code\":200,\"msg\":\"\",\"time\":\"0\",\"data\":[]}";
        final String EMPTY_OBJ = "{\"code\":200,\"msg\":\"\",\"time\":\"0\",\"data\":{}}";

        // ── Core launch endpoints ──────────────────────────────────────────────

        // Base app info (cloud_game_switch=2 disables cloud game prompts)
        RESPONSES.put("/base/getBaseInfo",
            "{\"code\":200,\"msg\":\"Success\",\"data\":{\"cloud_game_switch\":2,\"guide_info_img\":\"\",\"guide_storage_img\":\"\"},\"time\":\"0\"}");

        // User info — empty data is fine, app treats unauthenticated as guest
        RESPONSES.put("/user/info", EMPTY_OBJ);

        // Top platform tabs — one PC tab so the dashboard shell renders
        RESPONSES.put("/card/getTopPlatform",
            "{\"code\":200,\"msg\":\"\",\"time\":\"0\",\"data\":[{\"id\":13,\"name\":\"PC Emulator\",\"icon\":\"\",\"type\":7,\"back_img\":\"\"}]}");

        // Home card list — empty; locally imported games come from Room DB
        RESPONSES.put("/card/getIndexList", EMPTY);

        // News, CTS, game icon lists — empty
        RESPONSES.put("/card/getCtsList", EMPTY);
        RESPONSES.put("/card/getNewsList", EMPTY);
        RESPONSES.put("/card/getGameIcon", EMPTY);
        RESPONSES.put("/card/getGameCircleList", EMPTY);

        // Simulator component tab list
        RESPONSES.put("/simulator/getTabList",
            "{\"code\":200,\"msg\":\"\",\"time\":\"0\",\"data\":[{\"name\":\"Firmware\",\"type\":1,\"sub_type\":0},{\"name\":\"Compatibility layer\",\"type\":2,\"sub_type\":0},{\"name\":\"Translator\",\"type\":3,\"sub_type\":1},{\"name\":\"GPUdriver\",\"type\":3,\"sub_type\":2},{\"name\":\"DXVK\",\"type\":3,\"sub_type\":3},{\"name\":\"VKD3D\",\"type\":3,\"sub_type\":4}]}");

        // Upgrade check — empty data = no upgrade available
        RESPONSES.put("/upgrade/getAppUpgradeApk", EMPTY_OBJ);

        // Device list — empty
        RESPONSES.put("/devices/getDevicesList", EMPTY);

        // Misc endpoints that get called during init
        RESPONSES.put("/game/checkLocalHandTourGame", EMPTY_OBJ);
        RESPONSES.put("/game/userVideoNum", EMPTY_OBJ);
        RESPONSES.put("/game/getDnsIpPool", EMPTY);
        RESPONSES.put("/game/getGameCircleList", EMPTY);
        RESPONSES.put("/heartbeat/game/getUserPlayTimeList", EMPTY);
        RESPONSES.put("/cloud/game/check_user_timer", EMPTY_OBJ);
        RESPONSES.put("/email/login", EMPTY_OBJ);
    }

    @Override
    public Response intercept(Chain chain) throws IOException {
        Request request = chain.request();
        // Only intercept GET requests (safe to stub; POST = side-effects)
        if (!request.method().equals("GET")) {
            return chain.proceed(request);
        }
        String path = request.url().encodedPath();
        String body = RESPONSES.get(path);
        if (body != null) {
            return new Response.Builder()
                .request(request)
                .protocol(Protocol.HTTP_1_1)
                .code(200)
                .message("OK")
                .body(ResponseBody.create(JSON, body))
                .addHeader("X-BhOffline", "true")
                .build();
        }
        // Unknown endpoint — try the network (will fail gracefully offline)
        return chain.proceed(request);
    }
}
