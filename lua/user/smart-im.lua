local M = {}

local utf8 = require("utf8")

function M.onInsertLeave() end

function M.onInsertEnter() end

function M.setup(config)
    local defaultConfig = {
        logLevel = "info",
        lang = {
            chinese = {
                range = {
                    { 19968, 40959 },
                    { 13312, 19903 },
                    { 131072, 173791 },
                    { 63744, 64255 },
                    { 12288, 12351 },
                },
                {
                    {
                        os = "darwin",
                        cmd = "im-select",
                        onMatch = "im.rime.inputmethod.Squirrel.Hans",
                        onLeave = "com.apple.keylayout.ABC",
                    },
                    {
                        os = "linux",
                        cmd = "ibus",
                        onMatch = "engine rime",
                        onLeave = "engine xkb:us::eng",
                    },
                },
            },
        },
    }

    local function get_character_at_cursor()
        local cur_pos = vim.api.nvim_win_get_cursor(0)
        local line = vim.api.nvim_get_current_line()
        -- +1 for same index
        local char_pos = cur_pos[2] + 1
        for p, t in utf8.codes(line) do
            if p == char_pos then
                return (utf8.codepoint(t))
            end
        end
        return nil
    end

    local function onInsertEnter()
        local x = get_character_at_cursor()
        print("x", x)
    end

    local function onInsertLeave() end

    vim.cmd([[ autocmd InsertLeave * lua onInsertLeave()]])
    vim.cmd([[ autocmd InsertEnter * lua onInsertEnter()]])
end

return {}
