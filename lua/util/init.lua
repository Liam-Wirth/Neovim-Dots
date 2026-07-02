local M = {}
-- TODO: this function seems rather broken, doesnt work if I open the buffer while already within the root dir
-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
local uv = vim.uv

local ROOT_MARKERS = {
   ".git",
   "pyproject.toml",
   "package.json",
   "Cargo.toml",
   "go.mod",
   "Makefile",
   "setup.cfg",
   "setup.py",
   "Pipfile",
}

local function dirname(p)
   if not p or p == "" then return nil end
   return vim.fs.dirname(p)
end

-- Always returns a directory string, either specifically to a pre-determined root file using all the markers I could think of
-- or has fallbacks to cwd
function M.get_root(bufnr)
   bufnr = bufnr or 0

   local fname = vim.api.nvim_buf_get_name(bufnr)
   local start = dirname(fname) or uv.cwd() or "."

   -- Searches upward for a "root marker"
   local found = vim.fs.find(ROOT_MARKERS, { path = start, upward = true })[1]
   if found then
      return dirname(found) or start
   end

   local git_top = vim.system({ "git", "-C", start, "rev-parse", "--show-toplevel" }, { text = true }):wait()
   if git_top and git_top.code == 0 and git_top.stdout then
      local line = git_top.stdout:gsub("%s+$", "")
      if line ~= "" then return line end
   end

   return start
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
         if vim.uv.fs_stat((opts.cwd or vim.uv.cwd()) .. "/.git") then
            opts.show_untracked = true
            builtin = "git_files"
         else
            builtin = "find_files"
         end
      end
      if opts.cwd and opts.cwd ~= vim.uv.cwd() then
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
function M.toggle_light_mode()
   local current_background = vim.o.background
   if current_background == "dark" then
      vim.opt.background = "light"
   else
      vim.opt.background = "dark"
   end
end

-- Simple function returns boolean based on the existence of a file
function M.file_exists(file)
   local f = io.open(file, "rb")
   if f then f:close() end
   return f ~= nil
end

return M
