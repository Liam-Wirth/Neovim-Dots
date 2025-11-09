local ret = {
   "nvim-lualine/lualine.nvim",
   event = { "BufReadPost", "BufNewFile" },
   dependencies = { "meuter/lualine-so-fancy.nvim" },
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

      -- Gruvbox colors for the lualine theme
      local colors = {
         fg = "#ebdbb2",
         bg = "#282828",
         yellow = "#d79921",
         green = "#98971a",
         cyan = "#83a598",
         orange = "#d65d0e",
         purple = "#b16286",
         magenta = "#d3869b",
         grey = "#928374",
         blue = "#458588",
         red = "#cc241d",
         treesitter = "#8ec07c", -- Green color for Tree-sitter icon
      }

      -- Mode Colors
      local mode_color = {
         n = colors.green,
         i = colors.blue,
         v = colors.purple,
         [''] = colors.purple,
         V = colors.purple,
         c = colors.orange,
         no = colors.red,
         s = colors.orange,
         S = colors.orange,
         [''] = colors.orange,
         ic = colors.yellow,
         R = colors.red,
         Rv = colors.magenta,
         cv = colors.red,
         ce = colors.red,
         r = colors.cyan,
         rm = colors.cyan,
         ["r?"] = colors.cyan,
         ["!"] = colors.red,
         t = colors.red,
      }

      -- Function to return filetype icon and name separately
      local function filetype_with_icons()
         local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color_by_filetype(vim.bo.filetype)
         local ts_icon = nil
         if vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] then
            ts_icon = "󰔱" -- Tree-sitter icon
         end
         local ft = vim.bo.filetype or "no ft"

         -- Setting this as a global variable so that I can use it in other segments while only calling this function once
         vim.g.ft_icon = ft_icon
         vim.g.ft_color = ft_color
         vim.g.ts_color = "#afdb89"
         return ft_icon, ft, ft_color, ts_icon
      end

      local config = {
         options = {
            globalstatus = true,
            icons_enabled = true,
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            disabled_filetypes = { "alpha", "dashboard", "NvimTree", "packer", "Outline", "TelescopePrompt" },
            theme = {
               normal = {
                  a = { fg = colors.fg, bg = colors.bg },
                  b = { fg = colors.fg, bg = colors.bg },
                  c = { fg = colors.fg, bg = colors.bg },
               },
               inactive = {
                  a = { fg = colors.grey, bg = colors.bg },
                  b = { fg = colors.grey, bg = colors.bg },
                  c = { fg = colors.grey, bg = colors.bg },
               }
            }
         },
         sections = {
            lualine_a = {
               {
                  function() return "▊" end,
                  color = function() return { fg = mode_color[vim.fn.mode()], bg = mode_color[vim.fn.mode()] } end,
                  padding = { left = -1, right = -1 }
               },
               {
                  function()
                     ---@format disable-next
                     local mode_name = {
                        n = "NORMAL", i = "INS", v = "VIS", [''] = "V-BL",
                        V = "V-LN", c = "COMM", no = "Pending", s = "SEL",
                        S = "SEL-L", [''] = "SEL-B", ic = "IN-C", R = "REP",
                        Rv = "V-REP", cv = "VI-E", ce = "EX", r = "PROM",
                        rm = "MORE", ["r?"] = "?", ["!"] = "SHELL", t = "TERM"
                     }
                     local mode = mode_name[vim.fn.mode()] or "Unknown"
                     local total_width = 4
                     local mode_length = #mode
                     if mode_length > total_width then
                        mode = mode:sub(1, total_width)
                     end
                     local padding = math.max(total_width - mode_length, 0)
                     local left_padding = math.floor(padding / 2)
                     local right_padding = padding - left_padding
                     return string.rep(" ", left_padding) .. mode .. string.rep(" ", right_padding)
                  end,
                  color = function()
                     return { fg = colors.fg, bg = mode_color[vim.fn.mode()], gui = "bold" }
                  end,
                  padding = { right = 1 }
               }

            },
            lualine_b = {
               {
                  "branch",
                  icon = require('util.glyphs').git.Branch,
                  color = { fg = colors.green },
               },
               {
                  "diff",
                  symbols = { added = " ", modified = "󰝤 ", removed = " " },
                  diff_color = {
                     added = { fg = colors.green },
                     modified = { fg = colors.orange },
                     removed = { fg = colors.red },
                  },
                  cond = conditions.hide_in_width,
               },
            },
            lualine_c = {
               {
                  "fancy_cwd",
                  cond = conditions.buffer_not_empty,
                  color = { fg = colors.magenta, gui = "bold" },
                  path = 0,
               },
               {
                  "diagnostics",
                  sources = { "nvim_diagnostic" },
                  symbols = { error = " ", warn = " ", info = " " },
                  diagnostics_color = {
                     color_error = { fg = colors.red },
                     color_warn = { fg = colors.yellow },
                     color_info = { fg = colors.cyan },
                  },
                  on_click = function() vim.cmd("Trouble diagnostics") end,
               },
            },
            lualine_x = {
               {
                  function()
                     local ft_icon, ft, ft_color, ts_icon = filetype_with_icons()

                     local result = (ft_icon or "")
                     return result
                  end,
                  color = function()
                     local _, _, ft_color = filetype_with_icons()
                     return { fg = ft_color or colors.fg, bg = colors.bg }
                  end,
               },
               {
                  function()
                     local msg = "No Active Lsp"
                     local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
                     local clients = vim.lsp.get_clients()

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
                  color = { fg = colors.fg, gui = "bold" },
               },
               {
                  "fileformat",
                  fmt = string.upper,
                  icons_enabled = true,
                  color = { fg = colors.green, gui = "bold" },
               },
               {
                  function()
                     if vim.g.copilot_enabled == 1 then
                        return "󱚣"
                     else
                        return "󱚧"
                     end
                  end,
                  color = function()
                     if vim.g.copilot_enabled == 1 then
                        return { fg = colors.green, gui = "bold" }
                     else
                        return { fg = colors.red, gui = "bold" }
                     end
                  end,
                  cond = conditions.hide_in_width,
               }
            },
            lualine_y = {
               {
                  "progress",
                  color = { fg = colors.fg, gui = "bold" },
                  padding = { right = 0, left = 0 }
               },
               {
                  "fancy_location",
               }
            },
            lualine_z = {
               {
                  function() return "▊" end,
                  color = function() return { fg = mode_color[vim.fn.mode()], bg = colors.bg } end,
                  padding = { left = 1 },
               },
            },
         },
         extensions = { "neo-tree", "lazy" }
      }
      return config
   end,
}


if not vim.g.vscode then
   return ret
else
   return {} -- in vscode there is no need for lualine
end
