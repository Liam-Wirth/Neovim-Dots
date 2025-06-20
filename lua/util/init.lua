--NOTE:

local M = {}
-- TODO: this function seems rather broken, doesnt work if I open the buffer while already within the root dir
-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
function M.get_root()
   ---@type string?
   local path = vim.api.nvim_buf_get_name(0)
   path = path ~= "" and vim.loop.fs_realpath(path) or nil
   ---@type string[]
   local roots = {}
   if path then
      for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
         local workspace = client.config.workspace_folders
         local paths = workspace and vim.tbl_map(function(ws)
            return vim.uri_to_fname(ws.uri)
         end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
         for _, p in ipairs(paths) do
            local r = vim.loop.fs_realpath(p)
            if path:find(r, 1, true) then
               roots[#roots + 1] = r
            end
         end
      end
   end
   table.sort(roots, function(a, b)
      return #a > #b
   end)
   ---@type string?
   local root = roots[1]
   if not root then
      path = path and vim.fs.dirname(path) or vim.loop.cwd()
      ---@type string?
      root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
      root = root and vim.fs.dirname(root) or vim.loop.cwd()
   end
   ---@cast root string
   return root
end

function M.has(plugin)
   return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

---@param fn fun()
function M.on_very_lazy(fn)
   vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
         fn()
      end,
   })
end

--this will return a function that calls telescope.
-- cwd will default to lazyvim.util.get_root
-- for `files`, git_files or find_files will be chosen depending on .git
function M.telescope(builtin, opts)
   local params = { builtin = builtin, opts = opts }
   return function()
      builtin = params.builtin
      opts = params.opts
      opts = vim.tbl_deep_extend("force", { cwd = M.get_root() }, opts or {})
      if builtin == "files" then
         if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
            opts.show_untracked = true
            builtin = "git_files"
         else
            builtin = "find_files"
         end
      end
      if opts.cwd and opts.cwd ~= vim.loop.cwd() then
         opts.attach_mappings = function(_, map)
            map("i", "<a-c>", function()
               local action_state = require("telescope.actions.state")
               local line = action_state.get_current_line()
               M.telescope(
                  params.builtin,
                  vim.tbl_deep_extend("force", {}, params.opts or {}, { cwd = false, default_text = line })
               )()
            end)
            return true
         end
      end

      require("telescope.builtin")[builtin](opts)
   end
end

function M.on_attach(on_attach)
   vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
         ---@diagnostics ignore
         local buffer = args.buf
         local client = vim.lsp.get_client_by_id(args.data.client_id)
         on_attach(client, buffer)
      end,
   })
end

function M.fg(name)
   ---@type {foreground?:number}?
   local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name }) or vim.api.nvim_get_hl_by_name(name, true)
   local fg = hl and hl.fg or hl.foreground
   return fg and { fg = string.format("#%06x", fg) }
end

--super simple function that allows for easy toggling of light mode and darkmode
function M.togle_light_mode()
   local current_background = vim.opt.background
   if current_background == "dark" then
      vim.opt.background = "light"
   else
      vim.opt.background = "dark"
   end
end

-- toggle cmp completion
vim.g.cmp_toggle_flag = false -- initialize
local normal_buftype = function()
   return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
end
M.toggle_completion = function()
   local ok, cmp = pcall(require, "cmp")
   if ok then
      local next_cmp_toggle_flag = not vim.g.cmp_toggle_flag
      if next_cmp_toggle_flag then
         require("notify")("Completion On")
      else
         require("notify")("Completion Off")
      end
      cmp.setup({
         enabled = function()
            vim.g.cmp_toggle_flag = next_cmp_toggle_flag
            if next_cmp_toggle_flag then
               return normal_buftype
            else
               return next_cmp_toggle_flag
            end
         end,
      })
   else
      require("notify")("Completion Not Available")
   end
end

-- Simple function returns boolean based on the existence of a file
function M.file_exists(file)
    local f = io.open(file, "rb")
    if f then f:close() end
    return f ~= nil
end

if M.file_exists("~/.worklaptop") then
   vim.g.worklaptop = true
end





return M
