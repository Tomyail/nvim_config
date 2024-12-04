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
local function find_in_map(table, fn)
    for _, v in pairs(table) do
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
    local ranges = {}
    local prev_pos = 0
    local prev_char = ""
    local str_len = string.len(str)

    -- 收集所有字符的位置和长度信息
    for pos, char in utf8.codes(str) do
        if prev_pos > 0 then  -- 跳过第一次循环
            table.insert(ranges, {
                start_idx = prev_pos,
                end_idx = pos - 1,
                char = prev_char
            })
        end
        prev_pos = pos
        prev_char = char
    end

    -- 处理最后一个字符
    if prev_pos > 0 then
        local last_char_len = str_len - prev_pos + 1
        table.insert(ranges, {
            start_idx = prev_pos,
            end_idx = prev_pos + last_char_len - 1,
            char = prev_char
        })
    end

    -- 查找光标所在的范围
    local found_range = nil
    for _, range in ipairs(ranges) do
        if col >= range.start_idx and col <= range.end_idx then
            found_range = range
            break
        end
    end
    
    return found_range, ranges
end

function M.os_name()
    return string.lower(vim.loop.os_uname().sysname)
end

function M.setup(config)
    local defaultConfig = require("yasi.config")
    local merged_config = vim.tbl_deep_extend("force", defaultConfig, config)
    M.config = merged_config

    logger.set_log_level(merged_config.logLevel)
    
    -- 记录上一次光标位置的变量
    local last_cursor_pos = { line = 0, col = 0 }
    
    -- 在光标移动时记录位置
    vim.api.nvim_create_autocmd("CursorMoved", {
        callback = function()
            local pos = vim.api.nvim_win_get_cursor(0)
            last_cursor_pos = { line = pos[1], col = pos[2] }
        end,
    })

    vim.api.nvim_create_autocmd("InsertLeave", {
        callback = function()
            change_input_by_os(merged_config.default)
        end,
    })

    vim.api.nvim_create_autocmd("InsertEnter", {
        callback = function()
            local current_line_content = vim.api.nvim_get_current_line()
            local current_pos = vim.api.nvim_win_get_cursor(0)
            local current_col = current_pos[2]
            
            -- 通过比较位置判断插入方式
            local is_forward = current_col > last_cursor_pos.col
            
            -- 确定要检查的位置
            local check_col = current_col
            if not is_forward then
                -- 对于向前插入（i键），检查前一个字符
                check_col = check_col - 1
            end
            
            -- 如果check_col小于1，说明是在行首插入
            if check_col < 1 then
                change_input_by_os(merged_config.default)
                return
            end
            
            local range = get_range(current_line_content, check_col)
            
            if range then
                local codepoint = utf8.codepoint(range.char)
                local msg = string.format("insert_type: %s, col_idx: %s, check_col: %s, char: %s, codepoint: %x", 
                    is_forward and "append" or "insert", current_col, check_col, range.char, codepoint)
                logger.debug(msg)
                
                local lang = get_matched_lang(merged_config.lang, codepoint)
                if lang then
                    change_input_by_os(lang)
                else
                    change_input_by_os(merged_config.default)
                end
            else
                -- 如果没有可检查的字符，使用默认输入法
                change_input_by_os(merged_config.default)
            end
        end,
    })
end

function M.change_input_by_name(name)
    local lang = find_in_map(M.config.lang, function(lang)
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


-- TODO: 支持ciw的时候判断删除的是不是中文,如果是也直接切换到中文

return M
