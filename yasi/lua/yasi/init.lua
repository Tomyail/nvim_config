local M = {}
local utf8 = require("utf8")

local logger = require("yasi.logger")
logger.set_using_notify(true)

local function find_in_array(table, fn)
    for _, v in ipairs(table) do
        if fn(v) then
            return v
        end
    end
end
local function get_matched_lang(lang_config, codepoint)
    local is_code_point_in_ranges = function(code_point, ranges)
        return find_in_array(ranges, function(range)
            return code_point >= range[1] and code_point <= range[2]
        end)
    end
    for _, lang in pairs(lang_config) do
        if is_code_point_in_ranges(codepoint, lang.ranges) then
            return lang
        end
    end
end

local function change_input_by_os(lang)
    local methods = lang.methods
    local lang_name = lang.name
    local os_name = M.os_name()
    local target = find_in_array(methods, function(method)
        return method.os == os_name
    end)
    if target then
        if vim.fn.executable(target.cmd) == 1 then
            local command = string.format("%s %s", target.cmd, target.input)
            local status, exit_type, _ = os.execute(command)
            if status == 0 then
                local msg =
                    string.format("run command %s for lang: %s on os: %s successfully", command, lang_name, os_name)
                logger.debug(msg)
            else
                local msg = string.format("run command %s for lang: %s on os: %s failed", command, lang_name, os_name)
                logger.warn(msg)
            end
        else
            local msg = string.format(
                "Command %s not found in lang: %s for os : %s. please ensure command exist",
                target.cmd,
                lang_name,
                os_name
            )
            logger.warn(msg)
        end
    else
        local msg = string.format(
            "No matched input method find in lang: %s for os: %s. please check your config",
            lang_name,
            os_name
        )
        logger.warn(msg)
    end
end

local function get_range(str, col)
    -- lua's array index starts from 1!!
    local pre_p = 0
    local pre_c = ""
    local ranges = {}

    for p, c in utf8.codes(str) do
        local range = { start_idx = pre_p, end_idx = p, char = pre_c }
        table.insert(ranges, range)
        pre_p = p
        pre_c = c
    end
    table.insert(ranges, { start_idx = pre_p, end_idx = string.len(str), char = pre_c })
    table.remove(ranges, 1)

    return find_in_array(ranges, function(range)
        return col >= range.start_idx and col <= range.end_idx
    end)
end

function M.os_name()
    return string.lower(vim.loop.os_uname().sysname)
end

function M.setup(config)
    local defaultConfig = require("yasi.config")
    local merged_config = vim.tbl_deep_extend("force", defaultConfig, config)
    -- TODO validate config
    M.config = merged_config

    logger.set_log_level(merged_config.logLevel)
    vim.api.nvim_create_autocmd("InsertLeave", {
        callback = function()
            change_input_by_os(merged_config.default)
        end,
    })

    vim.api.nvim_create_autocmd("InsertEnter", {
        callback = function()
            local current_line_content = vim.api.nvim_get_current_line()
            local _line_idx, col_idx = unpack(vim.api.nvim_win_get_cursor(0))
            local range = get_range(current_line_content, col_idx)
            if range then
                local codepoint = utf8.codepoint(range.char)
                local msg = string.format("col_idx: %s, char: %s,  codepoint: %x", col_idx, range.char, codepoint)
                logger.debug(msg)
                local lang = get_matched_lang(merged_config.lang, codepoint)

                if lang then
                    change_input_by_os(lang)
                else
                    change_input_by_os(merged_config.default)
                end
            end
        end,
    })
end

function M.change_input_by_name(name)
    local lang = find_in_array(M.config.lang, function(lang)
        return lang.name == name
    end)
    if lang then
        change_input_by_os(lang)
    else
        local msg = string.format("No matched lang find for name: %s", name)
        logger.warn(msg)
    end
end

function M.change_to_default()
    change_input_by_os(M.config.default)
end

return M
