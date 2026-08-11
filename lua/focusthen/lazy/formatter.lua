return {
  "mhartington/formatter.nvim",
  cmd = { "Format", "FormatWrite" },
  keys = {
    { "<leader><leader>", "<cmd>Format<CR>", mode = { "n", "v" }, desc = "Format buffer" },
  },
  config = function()
    local util = require("formatter.util")

    local function resolve_oxfmt_exe()
      local bufname = vim.api.nvim_buf_get_name(0)
      local start = bufname ~= "" and vim.fs.dirname(vim.fn.fnamemodify(bufname, ":p")) or vim.fn.getcwd()
      start = vim.fs.normalize(vim.fn.fnamemodify(start, ":p")) .. "/"
      for dir in vim.fs.parents(start) do
        local candidate = dir .. "/node_modules/.bin/oxfmt"
        if vim.fn.filereadable(candidate) == 1 or vim.fn.executable(candidate) == 1 then
          return vim.fn.resolve(candidate)
        end
      end
      local global = vim.fn.exepath("oxfmt")
      return global ~= "" and global or "oxfmt"
    end

    -- oxfmt defaults are Prettier's: double quotes and semicolons. Projects that
    -- ship their own config keep winning; only config-less projects fall back to
    -- the personal defaults below.
    local OXFMT_CONFIG_NAMES = {
      ".oxfmtrc.json",
      ".oxfmtrc.jsonc",
      "oxfmt.config.ts",
      "oxfmt.config.mts",
    }
    local GLOBAL_OXFMT_CONFIG = vim.fn.expand("~/.config/oxfmt/oxfmtrc.json")

    local function has_project_oxfmt_config(abs_path)
      local found = vim.fs.find(OXFMT_CONFIG_NAMES, {
        upward = true,
        type = "file",
        path = vim.fs.dirname(abs_path),
      })
      return found[1] ~= nil
    end

    local oxfmt_formatter = function()
      return function()
        local file_path = util.get_current_buffer_file_path()
        if not file_path or file_path == "" then
          return nil
        end

        local abs_path = vim.fn.fnamemodify(file_path, ":p")
        local args = { "--stdin-filepath", abs_path }

        if not has_project_oxfmt_config(abs_path) and vim.fn.filereadable(GLOBAL_OXFMT_CONFIG) == 1 then
          vim.list_extend(args, { "--config", GLOBAL_OXFMT_CONFIG })
        end

        return {
          exe = resolve_oxfmt_exe(),
          args = args,
          stdin = true,
        }
      end
    end

    local function odinfmt_formatter()
      return function()
        return {
          exe = "odinfmt",
          args = { "-stdin" },
          stdin = true,
        }
      end
    end

    local function swiftformat_formatter()
      return function()
        local file_path = util.get_current_buffer_file_path()
        if not file_path or file_path == "" then
          return {
            exe = "swiftformat",
            stdin = true,
          }
        end
        return {
          exe = "swiftformat",
          args = { "--stdinpath", util.escape_path(vim.fn.fnamemodify(file_path, ":p")) },
          stdin = true,
        }
      end
    end

    require("formatter").setup({
      logging = true,
      log_level = vim.log.levels.WARN,
      filetype = {
        html = oxfmt_formatter(),
        json = oxfmt_formatter(),
        jsonc = oxfmt_formatter(),
        css = oxfmt_formatter(),
        javascript = oxfmt_formatter(),
        typescript = oxfmt_formatter(),
        tsx = oxfmt_formatter(),
        typescriptreact = oxfmt_formatter(),
        javascriptreact = oxfmt_formatter(),
        c = {
          require("formatter.filetypes.c").clangformat,
        },
        cpp = {
          require("formatter.filetypes.cpp").clangformat,
        },
        cs = {
          require("formatter.filetypes.cs").clangformat,
        },
        lua = {
          require("formatter.filetypes.lua").stylua,
        },
        go = {
          require("formatter.filetypes.go").gofmt,
        },
        elixir = {
          require("formatter.filetypes.elixir").mixformat,
        },
        ocaml = {
          require("formatter.filetypes.ocaml").ocamlformat,
        },
        odin = {
          odinfmt_formatter(),
        },
        rust = {
          require("formatter.filetypes.rust").rustfmt,
        },
        swift = {
          swiftformat_formatter(),
        },
        zig = {
          require("formatter.filetypes.zig").zigfmt,
        },
      },
    })
  end,
}

