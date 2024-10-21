local colors = {
   bg = "#202328",
   fg = "#bbc2cf",
   yellow = "#ECBE7B",
   cyan = "#008080",
   darkblue = "#081633",
   green = "#98be65",
   orange = "#FF8800",
   violet = "#a9a1e1",
   magenta = "#c678dd",
   blue = "#51afef",
   red = "#ec5f67",
}
local modeColor = function()
   --Fuck you I dont care about the variable name this is a private variable
   local big_chungus = {
      n = colors.red,
      i = colors.green,
      v = colors.blue,
      [""] = colors.blue,
      V = colors.blue,
      c = colors.magenta,
      no = colors.red,
      s = colors.orange,
      S = colors.orange,
      [""] = colors.orange,
      ic = colors.yellow,
      R = colors.violet,
      Rv = colors.violet,
      cv = colors.red,
      ce = colors.red,
      r = colors.cyan,
      rm = colors.cyan,
      ["r?"] = colors.cyan,
      ["!"] = colors.red,
      t = colors.red,
   }
   return { fg = big_chungus[vim.fn.mode()] }
end
return {
   {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {

      },
      keys = {
         {
            "<leader>?",
            function()
               require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
         },
      },
      win = {
         border = "1"
      }
   },
   -- Better `vim.notify()`
   -- FIX: This literally just wont work
   {
      "rcarriga/nvim-notify",
      lazy = false,
      keys = {
         {
            "<leader>un",
            function()
               require("notify").dismiss({ silent = true, pending = true })
            end,
            desc = "Dismiss all Notifications",
         },
      },
      opts = {
         timeout = 3000,
         max_height = function()
            return math.floor(vim.o.lines * 0.75)
         end,
         max_width = function()
            return math.floor(vim.o.columns * 0.75)
         end,
      },
      init = function()
         -- when noice is not enabled, install notify on VeryLazy
         local Util = require("util.init")
         if not Util.has("noice.nvim") then
            Util.on_very_lazy(function()
               vim.notify = require("notify")
            end)
         end
      end,
   }, -- better vim.ui
   {
      "stevearc/dressing.nvim",
      lazy = true,
      init = function()
         ---@diagnostic disable-next-line: duplicate-set-field
         vim.ui.select = function(...)
            require("lazy").load({ plugins = { "dressing.nvim" } })
            return vim.ui.select(...)
         end
         ---@diagnostic disable-next-line: duplicate-set-field
         vim.ui.input = function(...)
            require("lazy").load({ plugins = { "dressing.nvim" } })
            return vim.ui.input(...)
         end
      end,
   },
   {
      "SmiteshP/nvim-navic",
      lazy = true,
      init = function()
         vim.g.navic_silence = true
         require("util").on_attach(function(client, buffer)
            if client.server_capabilities.documentSymbolProvider then
               require("nvim-navic").attach(client, buffer)
            end
         end)
      end,
      opts = function()
         return {
            separator = " ",
            depth_limit = 5,
            icons = require("util.glyphs").kind,
            highlight = true,
            click = true,
         }
      end,
   },
   --TODO: sync the glyphs used in this config with the glyphs that exist within util.glyphs
   "nvim-tree/nvim-web-devicons",

   {
      'nvim-focus/focus.nvim',
      version = '*',
      config = function()
         require("focus").setup({
            ui = {
               number = true,                     -- Display line numbers in the focussed window only
               relativenumber = false,            -- Display relative line numbers in the focussed window only
               hybridnumber = true,               -- Display hybrid line numbers in the focussed window only
               absolutenumber_unfocussed = false, -- Preserve absolute numbers in the unfocussed windows

               cursorline = true,                 -- Display a cursorline in the focussed window only
               cursorcolumn = false,              -- Display cursorcolumn in the focussed window only
               colorcolumn = {
                  enable = false,                 -- Display colorcolumn in the foccused window only
                  list = '+1',                    -- Set the comma-saperated list for the colorcolumn
               },
               signcolumn = true,                 -- Display signcolumn in the focussed window only
               winhighlight = true,               -- Auto highlighting for focussed/unfocussed windows
            }
         })
      end,
   },
   {
      "akinsho/bufferline.nvim",
      lazy = true,
      event = { "BufReadPost", "BufNewFile" },
      opts = {
         options = {
            close_command = "bdelete! %d",       -- can be a string | function, | false see "Mouse actions"
            right_mouse_command = "bdelete! %d", -- can be a string | function | false, see "Mouse actions"
            left_mouse_command = "buffer %d",    -- can be a string | function, | false see "Mouse actions"
            middle_mouse_command = nil,          -- can be a string | function, | false see "Mouse actions"
            diagnostics = "nvim_lsp",
            always_show_bufferline = true,
            --separator_style = "slant",
            offsets = {
               -- filetype = "Neo-Tree",
               -- text = "Neo-Tree",
               -- highlight = "Directory",
               -- text_align = "left",
               {
                  filetype = "neo-tree",
                  raw = " %{%v:lua.__get_selector()%} ",
                  highlight = { sep = { link = "WinSeparator" } },
                  separator = "┃",
               },

            },
            hover = {
               enabled = true,
               delay = 2,
               reveal = { 'close' }
            },
            config = function()
               require('transparent').clear_prefix('BufferLine')
               vim.g.transparent_groups = vim.list_extend(
                  vim.g.transparent_groups or {},
                  vim.tbl_map(function(v)
                     return v.hl_group
                  end, vim.tbl_values(require('bufferline.config').highlights))
               )
            end
         },
      },
   },
   --[[
  --+-------------------------------------------------+
| A | B | C                             X | Y | Z |
+-------------------------------------------------+
  --]]
   {
      "nvim-lualine/lualine.nvim",
      event = { "BufReadPost", "BufNewFile" },
      opts = function()
         local conditions = {
            buffer_not_empty = function()
               return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
            end,
            hide_in_width = function()
               return vim.fn.winwidth(0) > 80
            end,
            check_git_workspace = function()
               local filepath = vim.fn.expand("%:p:h")
               local gitdir = vim.fn.finddir(".git", filepath .. ";")
               return gitdir and #gitdir > 0 and #gitdir < #filepath
            end,
         }

         -- Config
         local config = {
            options = {
               -- Disable sections and component separators
               component_separators = "",
               section_separators = "",
               --theme = {
               --   -- We are going to use lualine_c an lualine_x as left and
               --   -- right section. Both are highlighted by c theme .  So we
               --   -- are just setting default looks o statusline
               --   normal = { c = { fg = colors.fg, bg = colors.bg } },
               --   inactive = { c = { fg = colors.fg, bg = colors.bg } },
               -- },
               require('transparent').clear_prefix('lualine')
            },
            disabled_filetypes = { statusline = { "dashboard", "alpha" } },
            sections = {
               -- these are to remove the defaults
               lualine_a = {},
               lualine_b = {},
               lualine_y = {},
               lualine_z = {},
               -- These will be filled later
               lualine_c = {},
               lualine_x = {},
            },
            inactive_sections = {
               -- these are to remove the defaults
               lualine_a = {},
               lualine_b = {},
               lualine_y = {},
               lualine_z = {},
               lualine_c = {},
               lualine_x = {},
            },

            extensions = { "neo-tree", "lazy" }
         }

         -- Inserts a component in lualine_c at left section
         local function ins_left(component)
            table.insert(config.sections.lualine_c, component)
         end

         -- Inserts a component in lualine_x at right section
         local function ins_right(component)
            table.insert(config.sections.lualine_x, component)
         end
         ins_left({
            function()
               return "▊"
            end,
            color = modeColor(),
            padding = { left = 0, right = 1 }, -- We don't need space before this
         })
         ins_left({
            -- mode component
            function()
               --return ""
               local mode_name = {
                  n = "Normal",
                  i = "Insert",
                  v = "Visual",
                  [''] = "Visual Block",
                  V = "Visual Line",
                  c = "Command",
                  no = "N-Operator Pending?",
                  s = "Select",
                  S = "Select-Line",
                  [''] = "Select-Block",
                  ic = "Insert-Completion",
                  R = "Replace",
                  Rv = "Visual Replace",
                  cv = "Vim EX",
                  ce = "Ex",
                  r = "Prompt",
                  rm = "More",
                  ['r?'] = "Confirm",
                  ['!'] = "Terminal",
                  t = "Terminal (Editing)",
               }
               return mode_name[vim.fn.mode()];
            end,
            color = modeColor(),
            padding = { right = 1 },
         })
         ins_left({
            -- filesize component
            "filesize",
            cond = conditions.buffer_not_empty,
         })
         ins_left({
            "filename",
            cond = conditions.buffer_not_empty,
            color = { fg = colors.magenta, gui = "bold" },
         })
         ins_left({ "location" })
         ins_left({ "progress", color = { fg = colors.fg, gui = "bold" } })
         ins_left({
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = " ", warn = " ", info = " " },
            diagnostics_color = {
               color_error = { fg = colors.red },
               color_warn = { fg = colors.yellow },
               color_info = { fg = colors.cyan },
            },
         })
         -- Insert mid section. You can make any number of sections in neovim :)
         -- for lualine it's any number greater then 2
         ins_left({
            function()
               return "%="
            end,
         })

         ins_left({
            -- Lsp server name .
            function()
               local msg = "No Active Lsp"
               local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
               local clients = vim.lsp.get_active_clients()
               if next(clients) == nil then
                  return msg
               end
               for _, client in ipairs(clients) do
                  local filetypes = client.config.filetypes
                  if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                     return client.name
                  end
               end
               return msg
            end,
            icon = " LSP:",
            color = { fg = "#ffffff", gui = "bold" },
         })
         --[[
      -- Add components to right sections
      ins_right({
        require('auto-session.lib').current_session_name(),
        fmt = string.upper, -- I'm not sure why it's upper case either ;)
        cond = conditions.hide_in_width,
        color = { fg = colors.green, gui = "bold" },
      })
--]]
         ins_right({
            "fileformat",
            fmt = string.upper,
            icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
            color = { fg = colors.green, gui = "bold" },
            padding = { left = 1 },
         })

         ins_right({
            "branch",
            icon = "",
            color = { fg = colors.violet, gui = "bold" },
         })

         ins_right({
            "diff",
            -- Is it me or the symbol for modified us really weird
            symbols = { added = " ", modified = "󰝤 ", removed = " " },
            diff_color = {
               added = { fg = colors.green },
               modified = { fg = colors.orange },
               removed = { fg = colors.red },
            },
            cond = conditions.hide_in_width,
         })
         ins_right({
            function()
               if vim.g.copilot_enabled == 1 then
                  return "󱚣" -- Icon when Copilot is enabled
               else
                  return "󱚧" -- Icon when Copilot is disabled
               end
            end,
            color = function()
               if vim.g.copilot_enabled == 1 then
                  return { fg = colors.green } -- Color when Copilot is enabled
               else
                  return { fg = colors.red }   -- Color when Copilot is disabled
               end
            end,
            cond = conditions.hide_in_width, -- Optional: hide if window width is too narrow
         })
         ins_right({
            function()
               return "▊"
            end,
            color = modeColor(),
            padding = { left = 1 },
         })
         return config
      end,
   },
   {
      's1n7ax/nvim-window-picker',
      name = 'window-picker',
      event = 'BufReadPost',
      version = '2.*',
      config = function()
         require 'window-picker'.setup()
      end,
   },
   {
      "xiyaowong/transparent.nvim",
      lazy = false,
      config = function()
         require("transparent").setup({ -- Optional, you don't have to run setup.
            groups = {                  -- table: default groups
               'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
               'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
               'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
               'SignColumn', 'CursorLineNr', 'EndOfBuffer',
            },
            {
               extra_groups = {
                  "NormalFloat",    -- plugins which have float panel such as Lazy, Mason, LspInfo
                  "NvimTreeNormal", -- NvimTree
                  "Neo-Tree",

               },
            },
            exclude_groups = {}, -- table: groups you don't want to clear
         })
      end
   },
   {
      "kevinhwang91/nvim-ufo",
      dependencies = "kevinhwang91/promise-async",
      opts = {
         -- INFO: Uncomment to use treeitter as fold provider, otherwise nvim lsp is used
         provider_selector = function(bufnr, filetype, buftype)
            return { "treesitter", "indent" }
         end,
         open_fold_hl_timeout = 400,
         close_fold_kinds = { "imports", "comment" },
         preview = {
            win_config = {
               border = { "", "─", "", "", "", "─", "", "" },
               -- winhighlight = "Normal:Folded",
               winblend = 0,
            },
            mappings = {
               scrollU = "<C-u>",
               scrollD = "<C-d>",
               jumpTop = "[",
               jumpBot = "]",
            },
         },
      },
      init = function()
         vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
         vim.o.foldcolumn = "1" -- '0' is not bad
         vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
         vim.o.foldlevelstart = 99
         vim.o.foldenable = true
      end,
      config = function(_, opts)
         local handler = function(virtText, lnum, endLnum, width, truncate)
            local newVirtText = {}
            local totalLines = vim.api.nvim_buf_line_count(0)
            local foldedLines = endLnum - lnum
            local suffix = ("  %d %d%%"):format(foldedLines, foldedLines / totalLines * 100)
            local sufWidth = vim.fn.strdisplaywidth(suffix)
            local targetWidth = width - sufWidth
            local curWidth = 0
            for _, chunk in ipairs(virtText) do
               local chunkText = chunk[1]
               local chunkWidth = vim.fn.strdisplaywidth(chunkText)
               if targetWidth > curWidth + chunkWidth then
                  table.insert(newVirtText, chunk)
               else
                  chunkText = truncate(chunkText, targetWidth - curWidth)
                  local hlGroup = chunk[2]
                  table.insert(newVirtText, { chunkText, hlGroup })
                  chunkWidth = vim.fn.strdisplaywidth(chunkText)
                  -- str width returned from truncate() may less than 2nd argument, need padding
                  if curWidth + chunkWidth < targetWidth then
                     suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                  end
                  break
               end
               curWidth = curWidth + chunkWidth
            end
            local rAlignAppndx =
                math.max(math.min(vim.opt.textwidth["_value"], width - 1) - curWidth - sufWidth, 0)
            suffix = (" "):rep(rAlignAppndx) .. suffix
            table.insert(newVirtText, { suffix, "MoreMsg" })
            return newVirtText
         end
         opts["fold_virt_text_handler"] = handler
         require("ufo").setup(opts)
         vim.keymap.set("n", "zR", require("ufo").openAllFolds)
         vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
         vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
         vim.keymap.set("n", "K", function()
            local winid = require("ufo").peekFoldedLinesUnderCursor()
            if not winid then
               -- vim.lsp.buf.hover()
               vim.cmd [[ Lspsaga hover_doc ]]
            end
         end)
      end,
   },
   {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      ---@module "ibl"
      ---@type ibl.config
      opts = {},
   }


}
