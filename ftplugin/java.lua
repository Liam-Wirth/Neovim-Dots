-- Starts jdtls for the current Java buffer and wires in Bemol stuff
--

local jdtls = require("jdtls")
local jdtls_setup = require("jdtls.setup")

local home = os.getenv("HOME")
local mason_packages = home .. "/.local/share/nvim/mason/packages"
local path_to_lombok = mason_packages .. "/jdtls/lombok.jar"

local function add_bemol_workspace_folders()
   local bemol_dir = vim.fs.find({ ".bemol" }, { upward = true, type = "directory" })[1]
   if not bemol_dir then
      return
   end

   local file = io.open(bemol_dir .. "/ws_root_folders", "r")
   if not file then
      return
   end

   local existing = vim.lsp.buf.list_workspace_folders()
   for line in file:lines() do
      if line ~= "" and not vim.tbl_contains(existing, line) then
         vim.lsp.buf.add_workspace_folder(line)
      end
   end
   file:close()
end

local root_markers = { ".bemol", "settings.gradle", "settings.gradle.kts", "pom.xml", "build.gradle", ".git" }
local root_dir = jdtls_setup.find_root(root_markers)
if not root_dir then
   return
end

local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = home .. "/.cache/jdtls/workspace/" .. project_name

-- jdtls itself requires Java 21+ to run, regardless of what version the
if vim.g.is_amazon_machine and (not vim.env.JAVA_HOME or vim.env.JAVA_HOME == "") then
   local corretto21 = "/usr/lib/jvm/java-21-amazon-corretto"
   if vim.fn.isdirectory(corretto21) == 1 then
      vim.env.JAVA_HOME = corretto21
   end
end

local jdtls_cmd = { "jdtls" }
if vim.fn.filereadable(path_to_lombok) == 1 then
   table.insert(jdtls_cmd, "--jvm-arg=-javaagent:" .. path_to_lombok)
end
vim.list_extend(jdtls_cmd, { "-data", workspace_dir })

local cmd_env = nil
if vim.g.is_amazon_machine then
   local uv_python_bin = home .. "/.local/share/uv/python/cpython-3.11-linux-x86_64-gnu/bin"
   if vim.fn.isdirectory(uv_python_bin) == 1 then
      cmd_env = { PATH = uv_python_bin .. ":" .. (vim.env.PATH or "") }
   end
end

-- Register JDKs for jdtls to analyze projects with. The build system vends each
-- package's build JDK under <workspace_root>/env/JDK<N>-*/runtime/jdk-<N>;
-- prefer that (e.g. a package targets a JDK, which isn't installed system-wide)
-- and mark it default. Fall back to the system Corretto installs. Any path
-- that doesn't exist is filtered out so a missing runtime never errors jdtls.
local function workspace_jdk_runtime()
   local bemol = vim.fs.find({ ".bemol" }, { upward = true, path = root_dir, type = "directory" })[1]
   if not bemol then
      return nil
   end
   local ws_root = vim.fn.fnamemodify(bemol, ":h")
   local jdk = vim.fn.glob(ws_root .. "/env/JDK*-*/runtime/jdk-*", true, true)[1]
   local major = jdk and jdk:match("jdk%-(%d+)")
   if not (jdk and major and vim.fn.isdirectory(jdk) == 1) then
      return nil
   end
   return { name = "JavaSE-" .. major, path = jdk, default = true }
end

local runtimes = {
   { name = "JavaSE-21", path = "/usr/lib/jvm/java-21-amazon-corretto" },
   { name = "JavaSE-17", path = "/usr/lib/jvm/java-17-amazon-corretto" },
   { name = "JavaSE-11", path = "/usr/lib/jvm/java-11-amazon-corretto.x86_64" },
}
local ws_runtime = workspace_jdk_runtime()
if ws_runtime then
   table.insert(runtimes, 1, ws_runtime)
else
   runtimes[1].default = true
end
runtimes = vim.tbl_filter(function(r)
   return vim.fn.isdirectory(r.path) == 1
end, runtimes)

local config = {
   name = "jdtls",
   cmd = jdtls_cmd,
   cmd_env = cmd_env,

   root_dir = root_dir,

   capabilities = {
      workspace = {
         configuration = true,
      },
      textDocument = {
         completion = {
            completionItem = {
               snippetSupport = true,
            },
         },
      },
   },

   settings = {
      java = {
         configuration = (#runtimes > 0) and { runtimes = runtimes } or nil,
         references = {
            includeDecompiledSources = true,
         },
         sources = {
            organizeImports = {
               starThreshold = 9999,
               staticStarThreshold = 9999,
            },
         },
         format = {
            enabled = true,
         },
      },
   },

   -- Add Bemol's workspace folders once the client attaches.
   on_attach = add_bemol_workspace_folders,

   init_options = {
      bundles = {},
   },
}

jdtls.start_or_attach(config)
