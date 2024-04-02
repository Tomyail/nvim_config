return {

  "hrsh7th/nvim-cmp",
  config = function(_plugin, opts)
    local cmp = require("cmp")
    local merged_opts = vim.tbl_deep_extend("force", {
      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i", "c" }),
        ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i", "c" }),
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-x>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<ESC>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping({
          -- 在插入模式, 如果当前没有选择, 按下回车后是回车,如果当前有选择, 按下回车后是确认选择
          i = function(fallback)
            if cmp.visible() and cmp.get_active_entry() then
              cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
            else
              fallback()
            end
          end,
          -- 在选择模式, 按下回车后是确认选择
          s = cmp.mapping.confirm({ select = true }),
          -- 在命令模式, 按下回车后是确认选择, 并且会替换
          c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
        }),
      }),
    }, opts)
    cmp.setup(merged_opts)
  end,
}
