return {
    logLevel = "OFF", -- TRACE, DEBUG, INFO, WARN, ERROR, OFF
    default = { -- default config
        name = "default",
        methods = { -- input method for each os
            {
                os = "darwin", -- os type base on vim.loop.os_uname().sysname
                cmd = "im-select", -- command to switch input method (must install it first)
                input = "com.apple.keylayout.ABC", -- input method name
            },
        },
    },
    lang = {
        cjk = { -- config name (what ever you want)
            name = "cjk", -- lang name (what ever you want)
            ranges = { -- codepoint range(I use https://www.lddgo.net/en/string/cjk-unicode, you can define your own range)
                { 0x4E00, 0x9FFF },
                { 0x3400, 0x4DBF },
                { 0x20000, 0x2A6DF },
                { 0x2A700, 0x2B73F },
                { 0x2B740, 0x2B81F },
                { 0x2B820, 0x2CEAF },
                { 0x2CEB0, 0x2EBEF },
                { 0x30000, 0x3134A },
                { 0x31350, 0x323AF },
                -- cjk symbols and punctuation
                { 0x3000, 0x303F },
            },
            methods = { -- input method for each os
                {
                    os = "darwin",
                    cmd = "im-select",
                    input = "im.rime.inputmethod.Squirrel.Hans", -- I use [Rime](https://github.com/rime/squirrel)
                },
            },
        },
    },
}
