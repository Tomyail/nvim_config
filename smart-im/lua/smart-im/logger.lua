local M = {}
local log_level = "OFF"
local lovel_list = { "TRACE", "DEBUG", "INFO", "WARN", "ERROR", "OFF" }
local using_notify = false

M.set_using_notify = function(value)
    using_notify = value
end
M.set_log_level = function(level)
    if vim.tbl_contains(lovel_list, level) then
        log_level = level
    end
end

M.tbl_indexof = function(tbl, obj)
    for i, v in ipairs(tbl) do
        if v == obj then
            return i
        end
    end
    return -1
end
M.is_level_enabled = function(level)
    return M.tbl_indexof(lovel_list, level) >= M.tbl_indexof(lovel_list, log_level)
end
M.print_msg = function(level, msg)
    if M.is_level_enabled(level) then
        local output = "[" .. level .. "] " .. msg
        if using_notify then
            vim.notify(output)
        -- vim.notify(output, M.tbl_indexof(lovel_list, level) - 1)
        else
            print(output)
        end
    end
end
M.debug = function(msg)
    M.print_msg("DEBUG", msg)
end

M.info = function(msg)
    M.print_msg("INFO", msg)
end

M.warn = function(msg)
    M.print_msg("WARN", msg)
end

M.error = function(msg)
    M.print_msg("ERROR", msg)
end

return M
