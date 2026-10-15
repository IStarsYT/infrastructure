-- NyxarWare Live Dynamic Manifest Resolver (ManifestDeX Primary)
-- Pure Lua with ZERO reliance on 'os' or 'io'
MANIFEST_CACHE = MANIFEST_CACHE or {}

function fetch_manifest_code(gid)
    if not gid then return nil end
    local s = tostring(gid)

    -- 1. RAM Cache (Current session cache)
    if MANIFEST_CACHE[s] then
        return MANIFEST_CACHE[s]
    end

    -- 2. Primary Provider: ManifestDeX (Ultra-Fast Live Resolution ~0.5s)
    if http_get then
        local b1, st1 = http_get("https://manifest.manifestdex.com/" .. s, {["User-Agent"] = "ManifestDeX/1.0"})
        if st1 == 200 and b1 then
            local c1 = b1:match("(%d+)")
            if c1 and #c1 >= 10 then
                MANIFEST_CACHE[s] = c1
                return c1
            end
        end

        -- 3. Fallback Provider 2: SteamRun
        local b2, st2 = http_get("https://manifest.steam.run/api/manifest/" .. s)
        if st2 == 200 and b2 then
            local c2 = b2:match('"content"%s*:%s*"([%d]+)"') or b2:match("(%d+)")
            if c2 and #c2 >= 10 then
                MANIFEST_CACHE[s] = c2
                return c2
            end
        end

        -- 4. Fallback Provider 3: OpenSteamTool
        local b3, st3 = http_get("https://manifest.opensteamtool.com/" .. s)
        if st3 == 200 and b3 then
            local c3 = b3:match("(%d+)")
            if c3 and #c3 >= 10 then
                MANIFEST_CACHE[s] = c3
                return c3
            end
        end

        -- 5. Fallback Provider 4: WUDRM
        local b4, st4 = http_get("http://gmrc.wudrm.com/manifest/" .. s)
        if st4 == 200 and b4 then
            local c4 = b4:match("(%d+)")
            if c4 and #c4 >= 10 then
                MANIFEST_CACHE[s] = c4
                return c4
            end
        end
    end

    return nil
end

function fetch_manifest_code_ex(app, depot, gid)
    return fetch_manifest_code(gid)
end
