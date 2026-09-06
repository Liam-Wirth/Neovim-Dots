local vim = vim -- HACK: lol

local DEFAULT = vim.go.colorcolumn

local project = {
   java = { files = { "checkstyle.xml" }, pat = 'name="LineLength".-name="max"%s-value="(%d+)"', tool = 80 },
   lua = { files = { ".stylua.toml", "stylua.toml" }, pat = "column_width%s*=%s*(%d+)", tool = 120 },
   rust = { files = { "rustfmt.toml", ".rustfmt.toml" }, pat = "max_width%s*=%s*(%d+)", tool = 100 },
   python = { files = { "pyproject.toml", "setup.cfg", ".flake8", "ruff.toml" }, pat = "line[-_]length%s*=%s*(%d+)", tool = 88 },
   javascript = { files = { ".prettierrc", ".prettierrc.json", ".prettierrc.yaml", "prettier.config.js" }, pat = 'printWidth"?%s*[:=]%s*(%d+)', tool = 80 },
   typescript = { files = { ".prettierrc", ".prettierrc.json", ".prettierrc.yaml", "prettier.config.js" }, pat = 'printWidth"?%s*[:=]%s*(%d+)', tool = 80 },
}

local formatter_default = {
   black = 88,
   ruff = 88,
   rustfmt = 100,
   stylua = 120,
   prettier = 80,
   biome = 80,
}

local function project_limit(ft, dir)
   local spec = project[ft]
   if not spec then return nil end
   local file = vim.fs.find(spec.files, { upward = true, path = dir, type = "file" })[1]
   if not file then return nil end
   local ok, lines = pcall(vim.fn.readfile, file)
   if not ok then return spec.tool end
   local n = table.concat(lines, "\n"):match(spec.pat)
   return n and tonumber(n) or spec.tool
end

local function formatter_limit(buf)
   local ok, conform = pcall(require, "conform")
   if not ok then return nil end
   for _, f in ipairs(conform.list_formatters(buf)) do
      if formatter_default[f.name] then return formatter_default[f.name] end
   end
   return nil
end

local function apply(buf, win)
   if not (vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_win_is_valid(win)) then return end
   if vim.bo[buf].buftype ~= "" then return end -- skip terminals, help, quickfix, etc.

   local name = vim.api.nvim_buf_get_name(buf)
   local dir = name ~= "" and vim.fs.dirname(name) or vim.uv.cwd()

   local limit = vim.bo[buf].textwidth > 0 and vim.bo[buf].textwidth or nil
   limit = limit or project_limit(vim.bo[buf].filetype, dir)
   limit = limit or formatter_limit(buf)
   if not limit then
      vim.api.nvim_set_option_value("colorcolumn", DEFAULT, { scope = "local", win = win })
      return
   end

   vim.api.nvim_set_option_value("colorcolumn", tostring(limit), { scope = "local", win = win })
end

vim.api.nvim_create_autocmd({ "BufWinEnter", "FileType" }, {
   group = vim.api.nvim_create_augroup("DynamicColorColumn", { clear = true }),
   callback = function(ev)
      apply(ev.buf, vim.api.nvim_get_current_win())
   end,
})
