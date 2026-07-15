-- Falls back to a personal shared ESLint config (~/.config/eslint-fallback)
-- when a project has no ESLint config of its own, instead of nvim-lspconfig's
-- default behavior of not starting the eslint server at all.
local fallback_config_file = vim.fn.expand("~/.config/eslint-fallback/eslint.config.mjs")

local eslint_config_files = {
  ".eslintrc",
  ".eslintrc.js",
  ".eslintrc.cjs",
  ".eslintrc.yaml",
  ".eslintrc.yml",
  ".eslintrc.json",
  "eslint.config.js",
  "eslint.config.mjs",
  "eslint.config.cjs",
  "eslint.config.ts",
  "eslint.config.mts",
  "eslint.config.cts",
}

-- root_dir -> true if that root has no local eslint config (needs the fallback)
local fallback_dirs = {}

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        eslint = {
          root_dir = function(bufnr, on_dir)
            local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
            root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers, { ".git" } }
              or vim.list_extend(root_markers, { ".git" })

            -- exclude deno, same as nvim-lspconfig's default
            if vim.fs.root(bufnr, { "deno.json", "deno.jsonc", "deno.lock" }) then
              return
            end

            local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()
            local filename = vim.api.nvim_buf_get_name(bufnr)
            local has_local_config = vim.fs.find(eslint_config_files, {
              path = filename,
              type = "file",
              limit = 1,
              upward = true,
              stop = vim.fs.dirname(project_root),
            })[1] ~= nil

            -- unlike the default, always start the server, even with no local config
            fallback_dirs[project_root] = not has_local_config
            on_dir(project_root)
          end,
          before_init = function(_, config)
            local root_dir = config.root_dir
            if not root_dir then
              return
            end

            config.settings = config.settings or {}
            config.settings.workspaceFolder = {
              uri = root_dir,
              name = vim.fn.fnamemodify(root_dir, ":t"),
            }

            -- support Yarn2 (PnP) projects, same as nvim-lspconfig's default
            local pnp_cjs = root_dir .. "/.pnp.cjs"
            local pnp_js = root_dir .. "/.pnp.js"
            if type(config.cmd) == "table" and (vim.uv.fs_stat(pnp_cjs) or vim.uv.fs_stat(pnp_js)) then
              config.cmd = vim.list_extend({ "yarn", "exec" }, config.cmd)
            end

            if fallback_dirs[root_dir] then
              config.settings.options = {
                overrideConfigFile = fallback_config_file,
              }
              config.settings.nodePath = vim.fn.fnamemodify(fallback_config_file, ":h")
            end
          end,
        },
      },
    },
  },
}
