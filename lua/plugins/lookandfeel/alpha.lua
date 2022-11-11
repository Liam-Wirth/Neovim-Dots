-- Safe require alpha. No point in continuing if alpha is not present
local present, alpha = pcall(require, "alpha")
if not present then
  return
end

local function button(sc, txt, keybind)
  local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")

  local opts = {
    position = "center",
    text = txt,
    shortcut = sc,
    cursor = 5,
    width = 36,
    align_shortcut = "right",
    hl = "AlphaButtons",
  }

  if keybind then
    opts.keymap = { "n", sc_, keybind, { noremap = true, silent = true } }
  end

  return {
    type = "button",
    val = txt,
    on_press = function()
      local key = vim.api.nvim_replace_termcodes(sc_, true, false, true)
      vim.api.nvim_feedkeys(key, "normal", false)
    end,
    opts = opts,
  }
end


local function footer()
  local date = os.date("  %d/%m/%Y ")
  local time = os.date("  %H:%M:%S ")
  local plugins = "  " .. "41 ish".. " plugins "

  local v = vim.version()
  local version = "  v" .. v.major .. "." .. v.minor .. "." .. v.patch

  return date .. time .. plugins .. version
end


local options = {
  header = {
    type = "text",
    val = {
      [[                                                                       ]],
      [[  ██████   █████                   █████   █████  ███                  ]],
      [[ ░░██████ ░░███                   ░░███   ░░███  ░░░                   ]],
      [[  ░███░███ ░███   ██████   ██████  ░███    ░███  ████  █████████████   ]],
      [[  ░███░░███░███  ███░░███ ███░░███ ░███    ░███ ░░███ ░░███░░███░░███  ]],
      [[  ░███ ░░██████ ░███████ ░███ ░███ ░░███   ███   ░███  ░███ ░███ ░███  ]],
      [[  ░███  ░░█████ ░███░░░  ░███ ░███  ░░░█████░    ░███  ░███ ░███ ░███  ]],
      [[  █████  ░░█████░░██████ ░░██████     ░░███      █████ █████░███ █████ ]],
      [[ ░░░░░    ░░░░░  ░░░░░░   ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░  ]],
      [[                                                                       ]],
    },    -- val = require("custom.tables.headers").banners.sharp,
    opts = {
      position = "center",
      hl = "AlphaHeader",
    },
  },

  buttons = {
    type = "group",
    val = {
      button("SPC n", "  New File",     ":ene <BAR> startinsert <CR>"),
      button("SPC f", "  Find File",    ":Telescope find_files<CR>"),
      button("SPC r", "  Recent File",  ":Telescope oldfiles<CR>"),
      button("SPC w", "  Find Word",    ":Telescope live_grep<CR>"),
      button("SPC b", "  Bookmarks",    ":Telescope marks<CR>"),
      button("SPC t", "  Themes",       ":Telescope themes<CR>"),
      button("SPC s", "  Settings",     ":e $MYVIMRC | :cd %:p:h | :split . | :wincmd w | :pwd<CR>"),
      button("SPC q", "  Exit Neovim",  ":qa<CR>"),
    },
    -- opts = { spacing = 1 },
  },

  footer = {
    type = "text",
    val = footer(),
    opts = {
      position = "center",
      hl = "Constant",
    },
  },
}


local padd = vim.fn.max({ 2, vim.fn.floor(vim.fn.winheight(0) * 0.2) })

alpha.setup {
  layout = {
    { type = "padding", val = padd },
    options.header,
    { type = "padding", val = 1 },
    options.buttons,
    { type = "padding", val = 1 },
    options.footer,
  },
  opts = {},
}
