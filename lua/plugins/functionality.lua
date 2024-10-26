return {
   {
      "nvim-pack/nvim-spectre",
      lazy = true,
      cmd = "Spectre",
      opts = { open_cmd = "noswapfile vnew" },
      keys = {
         { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
      },
   },
   {
      "lewis6991/gitsigns.nvim",
      lazy = true,
      event = { "BufReadPre", "BufNewFile", "BufEnter" },
      opts = {
         signs = {
            add = { text = "▎" },
            change = { text = "▎" },
            delete = { text = "" },
            topdelete = { text = "" },
            changedelete = { text = "▎" },
            untracked = { text = "▎" },
         },
         on_attach = function(buffer)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, desc)
               vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
            end

            -- stylua: ignore start
            map("n", "]h", gs.next_hunk, "Next Hunk")
            map("n", "[h", gs.prev_hunk, "Prev Hunk")
            map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
            map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
            map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
            map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
            map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
            map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
            map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
            map("n", "<leader>ghd", gs.diffthis, "Diff This")
            map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
            map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
         end,
      },
   },
   {
      "RRethy/vim-illuminate",
      lazy = true,
      event = { "BufReadPost", "BufNewFile" },
      opts = {
         delay = 200,
         large_file_cutoff = 2000,
         large_file_overrides = {
            providers = { "lsp" },
         },
      },
      config = function(_, opts)
         require("illuminate").configure(opts)

         local function map(key, dir, buffer)
            vim.keymap.set("n", key, function()
               require("illuminate")["goto_" .. dir .. "_reference"](false)
            end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
         end

         map("]]", "next")
         map("[[", "prev")

         -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
         vim.api.nvim_create_autocmd("FileType", {
            callback = function()
               local buffer = vim.api.nvim_get_current_buf()
               map("]]", "next", buffer)
               map("[[", "prev", buffer)
            end,
         })
      end,
      keys = {
         { "]]", desc = "Next Reference" },
         { "[[", desc = "Prev Reference" },
      },
   },
   {
      'akinsho/toggleterm.nvim',
      version = "*",
      lazy = true,
      event = { "BufReadPost", "BufNewFile" },
      keys = {
         vim.keymap.set("n", "<Leader>xf", '<Cmd>execute v:count . "ToggleTerm direction=float"<CR>', { silent = true }),
         vim.keymap.set("n", "<Leader>xh", '<Cmd>execute v:count . "ToggleTerm direction=horizontal"<CR>',
            { silent = true }),
         vim.keymap.set("n", "<Leader>xv", '<Cmd>execute v:count . "ToggleTerm direction=vertical"<CR>',
            { silent = true }),
         vim.keymap.set("n", "<Leader>xt", '<Cmd>execute v:count . "ToggleTerm direction=tab"<CR>', { silent = true }),
         vim.keymap.set("n", "<Leader>xb", "<Cmd>term<CR><Cmd>setlocal nonu nornu<CR>i", { silent = true }),
      },
      opts = {
         open_mapping = "<Leader>xh",
         insert_mappings = false,
         shade_terminals = false,
         size = function(term)
            if term.direction == "horizontal" then
               return vim.o.lines * 0.3
            elseif term.direction == "vertical" then
               return vim.o.columns * 0.5
            end
         end,
         highlights = {
            FloatBorder = {
               link = "FloatBorder",
            },
         },
      }
   },
   {
      'norcalli/nvim-colorizer.lua',
      lazy = true,
      event = { "BufReadPost", "BufNewFile" },
      config = function()
         require 'colorizer'.setup({
            'css',
            'javascript',
            html = { mode = 'background' },
         }, { mode = 'background' })
      end,
      keys = {
         "<leader>p", "<cmd>ColorizerToggle<CR>", desc = "Toggle Colorizer" } },
}
