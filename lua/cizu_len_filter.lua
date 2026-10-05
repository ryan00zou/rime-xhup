local function cizu_c6_filter(input, env)
    local pure_code = (env.engine.context.input or ""):gsub("[^%a]", "")

    if #pure_code >= 5 then
        for cand in input:iter() do yield(cand) end
        return
    end

    for cand in input:iter() do
        local is_cizu_completion =
            cand.type == "completion" and
            cand.comment ~= nil and
            cand.comment ~= ""
        if is_cizu_completion then
        else
            yield(cand)
        end
    end
end

return { filter = cizu_c6_filter }