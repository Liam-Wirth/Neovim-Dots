-- Starts jdtls for the current Java buffer and wires in Bemol's
-- Brazil-generated workspace folders. Sourced automatically by Neovim
-- (ftplugin/<filetype>.lua convention) whenever a `java` buffer is opened.
--
-- Prerequisite: run `bemol --watch --verbose` from your Brazil workspace
-- root (`toolbox install bemol` if you don't have it) so `.bemol/` exists
-- with real classpath info. Without it, jdtls will still start but won't
-- know about Brazil dependencies.

local jdtls = require("jdtls")
local jdtls_setup = require("jdtls.setup")

local home = os.getenv("HOME")
local mason_packages = home .. "/.local/share/nvim/mason/packages"
local path_to_lombok = mason_packages .. "/jdtls/lombok.jar"

-- Reads Bemol's generated workspace-folder list and adds each one to the
-- LSP client's workspace folders (Brazil packages don't share a single
-- root_dir the way a typical Maven/Gradle project does).
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

-- Root: prefer the Bemol-marked workspace root; fall back to common
-- Java project markers for non-Brazil Java code.
local root_markers = { ".bemol", "settings.gradle", "settings.gradle.kts", "pom.xml", "build.gradle", ".git" }
local root_dir = jdtls_setup.find_root(root_markers)
if not root_dir then
   return
end

local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = home .. "/.cache/jdtls/workspace/" .. project_name

-- jdtls itself requires Java 21+ to run, regardless of what version the
-- project being edited targets. This only applies on Amazon-managed
-- machines where Corretto lives at this fixed path; elsewhere, whatever
-- JAVA_HOME/PATH is already configured takes over.
if vim.g.is_amazon_machine and (not vim.env.JAVA_HOME or vim.env.JAVA_HOME == "") then
   local corretto21 = "/usr/lib/jvm/java-21-amazon-corretto"
   if vim.fn.isdirectory(corretto21) == 1 then
      vim.env.JAVA_HOME = corretto21
   end
end

-- `jdtls` must be the Mason-installed wrapper script on $PATH (requires
-- Python 3.9+ to run -- the eclipse.jdt.ls launcher script's own shebang
-- resolves whatever `python3` is first on PATH). Amazon Linux 2's system
-- python3 is 3.7, which is too old; prepend a newer interpreter (installed
-- via `uv python install 3.11`) to PATH for just this spawned process so
-- system Python is untouched. Only relevant on Amazon machines with this
-- exact stale-Python problem; harmless no-op elsewhere.
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
         -- jdtls runs on Java 21. On an Amazon-managed machine, also
         -- register the Corretto versions actually available so it can
         -- compile/analyze older-targeted Brazil packages correctly; on
         -- a personal machine these paths simply won't exist and jdtls
         -- falls back to whatever JDK the project's build file specifies.
         configuration = vim.g.is_amazon_machine and {
            runtimes = {
               { name = "JavaSE-21", path = "/usr/lib/jvm/java-21-amazon-corretto", default = true },
               { name = "JavaSE-17", path = "/usr/lib/jvm/java-17-amazon-corretto" },
               { name = "JavaSE-11", path = "/usr/lib/jvm/java-11-amazon-corretto" },
            },
         } or nil,
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
