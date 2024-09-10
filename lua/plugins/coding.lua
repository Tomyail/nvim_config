return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      local compare = require("cmp.config.compare")
      local custom = {

        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i", "c" }),
          ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i", "c" }),
          -- ["<CR>"] = cmp.mapping({
          --   -- 在插入模式, 如果当前没有选择, 按下回车后是回车,如果当前有选择, 按下回车后是确认选择
          --   i = function(fallback)
          --     if cmp.visible() and cmp.get_active_entry() then
          --       cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
          --     else
          --       fallback()
          --     end
          --   end,
          --   -- 在选择模式, 按下回车后是确认选择
          --   s = cmp.mapping.confirm({ select = true }),
          --   -- 在命令模式, 按下回车后是确认选择, 并且会替换
          --   c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
          -- }),
        }),

        sorting = {
          priority_weight = 2,
          comparators = {
            compare.offset,
            compare.exact,
            compare.recently_used,
            compare.score,
            compare.locality,
            compare.kind,
            compare.length,
            compare.order,
          },
        },
      }

      local merged = vim.tbl_deep_extend("force", opts, custom)
      return merged
    end,
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
        filetypes = {
          markdown = true,
          yaml = true,
        },
        -- copilot_node_command = vim.fn.expand("$HOME") .. "/.asdf/installs/nodejs/18.19.0/bin/node", -- Node.js version must be > 18.x
      })
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    config = function(_, opts)
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-*",
        callback = function()
          -- Get current filetype and set it to markdown if the current filetype is copilot-chat
          local ft = vim.bo.filetype
          if ft == "copilot-chat" then
            vim.opt_local.relativenumber = false
            vim.opt_local.number = false
            vim.bo.filetype = "markdown"
          end
        end,
      })
      -- vim.api.nvim_create_autocmd("InsertEnter", {
      --   pattern = "copilot-*",
      --   callback = function()
      --     require("yasi").change_input_by_name("cjk")
      --   end,
      -- })

      local custom = {
        auto_insert_mode = true,
        -- model = 'gpt-4',
        prompts = {
          Explain = {
            prompt = "/COPILOT_EXPLAIN 将上述代码的解释写为文本段落",
          },
        },
      }
      local merged = vim.tbl_deep_extend("force", opts, custom)
      require("CopilotChat.integrations.cmp").setup()
      require("CopilotChat").setup(merged)
    end,
    keys = {
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      {
        "<leader>aa",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Toggle (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>ag",
        "<cmd>CopilotChatCommitStaged<CR>",
        desc = "CopilotChatCommitStaged(English)",
      },

      {
        "<leader>ae",
        "<cmd>CopilotChatExplain<CR>",
        mode = { "n", "v" },
        desc = "CopilotChatExplain",
      },

      {
        "<leader>af",
        "<cmd>CopilotChatFixDiagnostic<CR>",
        mode = { "n", "v" },
        desc = "CopilotChatFixDiagnostic",
      },

      {
        "<leader>ar",
        "<cmd>CopilotChatReview<CR>",
        mode = { "n", "v" },
        desc = "CopilotChatReview",
      },

      {
        "<leader>ad",
        "<cmd>CopilotChatDocs<CR>",
        mode = { "n", "v" },
        desc = "CopilotChatDocs",
      },

      {
        "<leader>aG",
        function()
          local chat = require("CopilotChat")
          local select = require("CopilotChat.select")
          chat.ask(
            "使用 commitizen convention 编写更改的提交标题。确保标题最多包含 50 个字符。 使用 gitcommit 语言将整个消息包装在代码块中,并用中文返回",
            {
              selection = function(source)
                return select.gitdiff(source, true)
              end,
            }
          )
        end,
        desc = "CopilotChatCommitStaged(中文)",
      },
      {
        "<leader>ap",
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
        end,
        desc = "show help",
      },
      { "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
      {
        "<leader>ax",
        function()
          return require("CopilotChat").reset()
        end,
        desc = "Clear (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>aq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input)
          end
        end,
        desc = "Quick Chat (CopilotChat)",
        mode = { "n", "v" },
      },
    },
  },
  -- {
  --   "yetone/avante.nvim",
  --   event = "VeryLazy",
  --   lazy = false,
  --   version = false, -- set this if you want to always pull the latest change
  --   opts = {
  --     provider = "copilot",
  --     -- add any opts here
  --   },
  --   -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  --   build = "make BUILD_FROM_SOURCE=true",
  --   -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  --   dependencies = {
  --     "stevearc/dressing.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     --- The below dependencies are optional,
  --     "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
  --     "zbirenbaum/copilot.lua", -- for providers='copilot'
  --     {
  --       -- support for image pasting
  --       "HakonHarnes/img-clip.nvim",
  --       event = "VeryLazy",
  --       opts = {
  --         -- recommended settings
  --         default = {
  --           embed_image_as_base64 = false,
  --           prompt_for_file_name = false,
  --           drag_and_drop = {
  --             insert_mode = true,
  --           },
  --           -- required for Windows users
  --           use_absolute_path = true,
  --         },
  --       },
  --     },
  --     {
  --       -- Make sure to set this up properly if you have lazy=true
  --       "MeanderingProgrammer/render-markdown.nvim",
  --       opts = {
  --         file_types = { "markdown", "Avante" },
  --       },
  --       ft = { "markdown", "Avante" },
  --     },
  --   },
  -- },
}
