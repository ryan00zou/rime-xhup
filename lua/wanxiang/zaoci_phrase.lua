-- @amzxyz https://github.com/amzxyz/rime-wanxiang
-- 手动造词编码存储：确保 zaoci 造词后能用压缩编码查询
local ZaociPhrase = {}

local function parse_input_codes(raw_input, is_zaoci, is_zaoci_c6)
    local body = raw_input or ""
    if is_zaoci_c6 then
        if body:sub(1, 1) == "~" then
            body = body:sub(2)
        end
    elseif is_zaoci then
        if body:sub(1, 1) == "'" then
            body = body:sub(2)
        end
    end

    local char_groups = {}
    for group in body:gmatch("[^']+") do
        local codes = {}
        for c in group:gmatch(".") do
            table.insert(codes, c)
        end
        if #codes > 0 then
            table.insert(char_groups, codes)
        end
    end

    return char_groups
end

local function split_flat_codes(flat, text_len)
    if text_len <= 0 or #flat == 0 then return {} end
    local codes_per_char = math.floor(#flat / text_len)
    if codes_per_char <= 0 then return {} end
    local result = {}
    for i = 1, text_len do
        local group = {}
        for j = 1, codes_per_char do
            local idx = (i - 1) * codes_per_char + j
            if idx <= #flat then
                table.insert(group, flat[idx])
            end
        end
        table.insert(result, group)
    end
    return result
end

local function apply_formula_4char(char_codes)
    local n = #char_codes
    if n == 0 then return "" end
    if n == 1 then
        return table.concat(char_codes[1], "")
    elseif n == 2 then
        local c1, c2 = char_codes[1], char_codes[2]
        return (c1[1] or "") .. (c1[2] or "") .. (c2[1] or "") .. (c2[2] or "")
    elseif n == 3 then
        local c1, c2, c3 = char_codes[1], char_codes[2], char_codes[3]
        return (c1[1] or "") .. (c2[1] or "") .. (c3[1] or "") .. (c3[2] or "")
    else
        local c1, c2, c3, cn = char_codes[1], char_codes[2], char_codes[3], char_codes[n]
        return (c1[1] or "") .. (c2[1] or "") .. (c3[1] or "") .. (cn[1] or "")
    end
end

local function apply_formula_6char(char_codes)
    local n = #char_codes
    if n == 0 then return "" end
    if n == 1 then
        return table.concat(char_codes[1], "")
    elseif n == 2 then
        local c1, c2 = char_codes[1], char_codes[2]
        return (c1[1] or "") .. (c1[2] or "") .. (c2[1] or "") .. (c2[2] or "") .. (c1[3] or "") .. (c2[3] or "")
    elseif n == 3 then
        local c1, c2, c3 = char_codes[1], char_codes[2], char_codes[3]
        return (c1[1] or "") .. (c2[1] or "") .. (c3[1] or "") .. (c3[2] or "") .. (c1[3] or "") .. (c3[3] or "")
    else
        local c1, c2, c3, cn = char_codes[1], char_codes[2], char_codes[3], char_codes[n]
        return (c1[1] or "") .. (c2[1] or "") .. (c3[1] or "") .. (cn[1] or "") .. (c1[3] or "") .. (cn[3] or "")
    end
end

function ZaociPhrase.init(env)
    env.memory_4 = Memory(env.engine, env.engine.schema, "cizu")
    env.memory_6 = Memory(env.engine, env.engine.schema, "cizu_c6")

    if env.memory_4 or env.memory_6 then
        env._commit_conn = env.engine.context.commit_notifier:connect(function(ctx)
            ZaociPhrase.commit_handler(ctx, env)
        end)
    end
end

function ZaociPhrase.fini(env)
    if env._commit_conn then
        env._commit_conn:disconnect()
        env._commit_conn = nil
    end
    if env.memory_4 then
        env.memory_4:disconnect()
        env.memory_4 = nil
    end
    if env.memory_6 then
        env.memory_6:disconnect()
        env.memory_6 = nil
    end
end

function ZaociPhrase.func(input, env)
    for cand in input:iter() do
        yield(cand)
    end
end

function ZaociPhrase.commit_handler(ctx, env)
    if not ctx or not ctx.composition then return end

    local commit_text = ctx:get_commit_text() or ""
    local raw_input = ctx.input or ""

    if not raw_input or raw_input == "" then return end

    local is_zaoci = raw_input:find("'") ~= nil
    local is_zaoci_c6 = raw_input:find("^~") ~= nil

    if not is_zaoci and not is_zaoci_c6 then return end

    local text_len = utf8.len(commit_text)
    if text_len <= 1 then return end

    for _, cp in utf8.codes(commit_text) do
        if not ((cp >= 0x4E00 and cp <= 0x9FFF) or
                (cp >= 0x3400 and cp <= 0x4DBF)) then
            return
        end
    end

    local char_codes = parse_input_codes(raw_input, is_zaoci, is_zaoci_c6)

    if #char_codes == 1 and text_len > 1 then
        char_codes = split_flat_codes(char_codes[1], text_len)
    end

    if #char_codes == 0 then return end

    local compressed = ""
    if is_zaoci_c6 then
        compressed = apply_formula_6char(char_codes)
    else
        compressed = apply_formula_4char(char_codes)
    end

    if compressed == "" then return end

    local entry = DictEntry()
    entry.text = commit_text
    entry.weight = 1
    entry.custom_code = compressed .. " "

    local memory = nil
    if is_zaoci_c6 then
        memory = env.memory_6
    else
        memory = env.memory_4
    end

    if memory then
        memory:update_userdict(entry, 1, "")
    end
end

return ZaociPhrase