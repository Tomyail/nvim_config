# yasi.nvim

Yet another smart im. change input method depend in current cursor position's content

https://github.com/Tomyail/nvim_conf/assets/350722/f7ebff2c-7bab-43a4-9706-bbc228ba45ae


## Prerequisite

you need to install some tools to change input method. For example I use [im-select](https://github.com/daipeihust/im-select) to change input method in macOS.

## Install

### Lazy.nvim

```lua
return {
	{
		"tomyail/yasi.nvim",
		opts = {},
	},

}

```

## Configuration

### Default config

```lua
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
                    input = "com.apple.inputmethod.SCIM.ITABC",
                },
            },
        },
    },
}
```

### Change input for cjk

For example, I prefer to use [Rime](https://rime.im/) to input Chinese. Here is the config I use in lazy.nvim.

```lua
{

    "tomyail/yasi.nvim"
    opts = {
      lang = {
        cjk = {
          methods = {
            {
              os = "darwin",
              cmd = "im-select",
              input = "im.rime.inputmethod.Squirrel.Hans",
            },
          },
        },
      },
    },
}

```

### Change to default input when enter Command mode

```lua

require("yasi").setup(opts)
vim.api.nvim_create_autocmd("CmdlineEnter", {
    callback = function()
        local yasi = require("yasi")
        yasi.change_to_default()
    end,
})
```

## How it works

When you type in insert mode, this plugins will detect current cursor position's content, get the codepoint of the content, use the codepoint to find the config that tatch its range. If find the config, using the config's input method to change input method, otherwise using the default input method.

When you exit to normal mode, this plugins will change input method to default input method.
