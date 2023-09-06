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
      --TODO: Register the directory names for a lot of my keybind groups here
      "folke/which-key.nvim",
      opts = {
         icons = {
            group = "󰋃  ",
         },
      },
      event = "BufReadPost",
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
   -- lsp symbol navigation for lualine. This shows where
   -- in the code structure you are - within functions, classes,
   -- TODO: Reinstall Barbecue and move this out of the statusline
   -- etc - in the statusline.
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
         }
      end,
   },
   --TODO: sync the glyphs used in this config with the glyphs that exist within util.glyphs
   "nvim-tree/nvim-web-devicons",

   {
      "akinsho/bufferline.nvim",
      opts = {
         options = {
            close_command = "bdelete! %d",       -- can be a string | function, | false see "Mouse actions"
            right_mouse_command = "bdelete! %d", -- can be a string | function | false, see "Mouse actions"
            left_mouse_command = "buffer %d",    -- can be a string | function, | false see "Mouse actions"
            middle_mouse_command = nil,          -- can be a string | function, | false see "Mouse actions"
            diagnostics = "nvim_lsp",
            always_show_bufferline = true,
            separator_style = "slant",
            offsets = {
               filetype = "Neo-Tree",
               text = "Neo-Tree",
               highlight = "Directory",
               text_align = "left",
            },
            hover = {
               enabled = true,
               delay = 2,
               reveal = { 'close' }
            },
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
      event = "VeryLazy",
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
               theme = {
                  -- We are going to use lualine_c an lualine_x as left and
                  -- right section. Both are highlighted by c theme .  So we
                  -- are just setting default looks o statusline
                  normal = { c = { fg = colors.fg, bg = colors.bg } },
                  inactive = { c = { fg = colors.fg, bg = colors.bg } },
               },
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
      event = 'VeryLazy',
      version = '2.*',
      config = function()
         require 'window-picker'.setup()
      end,
   }
}
