return {
  -- override default plguns
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>w"] = {
          "<cmd>w!<cr>",
          "Save",
        },
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
    },
  },

  -- below are custom plugin
  {
    lazy = false,
    "tomyail/yasi.nvim",
    dependencies = {
      "uga-rosa/utf8.nvim",
    },
    opts = {
      lang = {
        cjk = {
          methods = {
            {
              os = "darwin",
              cmd = "im-select",
              input = "im.rime.inputmethod.Squirrel.Hans", -- I use [Rime](https://github.com/rime/squirrel)
            },
          },
        },
      },
    },
    config = function(_, opts)
      require("yasi").setup(opts)
      vim.api.nvim_create_autocmd("CmdlineEnter", {
        callback = function()
          local yasi = require("yasi")
          yasi.change_to_default()
        end,
      })
    end,
    dir = vim.fn.stdpath("config") .. "/yasi",
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    keys = {
      { "<leader>o", desc = "+Obsidian" },
      { "<leader>ot", "<cmd>ObsidianToday<cr>", desc = "ObsidianToday" },
      { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "ObsidianNew" },
    },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
    },
    opts = {
      templates = {
        subdir = "nvim_templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },
      daily_notes = {
        -- Optional, if you keep daily notes in a separate directory.
        -- folder = "journals/%Y/%m",
        folder = "journals",
        -- Optional, if you want to change the date format for the ID of daily notes.
        -- date_format = "%Y-%m-%d",
        -- Optional, if you want to change the date format of the default alias of daily notes.
        -- alias_format = "%B %-d, %Y",
        -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
        template = "日记.md",
      },
      note_frontmatter_func = function(note)
        if note.title then
          note:add_alias(note.title)
        end
        local out = { id = note.id, aliases = note.aliases, tags = note.tags }

        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end

        -- Add the create date and time to the frontmatter if they don't exist.
        --  because file's mtime is not reliable in some cases. For example, when you copy a file
        if not out.create_date then
          out.create_date = os.date("%Y-%m-%d")
        end
        if not out.create_time then
          out.create_time = os.date("%H:%M")
        end

        -- always update update_date and update_time
        out.update_date = os.date("%Y-%m-%d")
        out.update_time = os.date("%H:%M")

        return out
      end,
      note_path_func = function(spec)
        -- if spec's title exist using it, otherwise using id instead
        local identifier = spec.title and spec.title or tostring(spec.id)
        local path = spec.dir / identifier
        return path:with_suffix(".md")
      end,
      workspaces = {
        {
          name = "personal",
          path = function()
            local maybe_path = {
              "~/source/personal/obsidian/",
              "~/Source/obsidian/",
            }

            for _, path in ipairs(maybe_path) do
              if vim.fn.isdirectory(vim.fn.expand(path)) == 1 then
                return vim.fn.expand(path)
              end
            end
          end,
        },
      },
    },
  },
}
