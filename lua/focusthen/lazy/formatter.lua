return {
  "mhartington/formatter.nvim",
  config = function()
    local util = require("formatter.util")
    local formatter = function(parser)
      if not parser then
        return {
          exe = "prettier",
          args = {
            "--stdin-filepath",
            util.escape_path(util.get_current_buffer_file_path()),
          },
          stdin = true,
          try_node_modules = true,
        }
      end

      return {
        exe = "prettier",
        args = {
          "--stdin-filepath",
          util.escape_path(util.get_current_buffer_file_path()),
          "--parser",
          parser,
        },
        stdin = true,
        try_node_modules = true,
      }
    end

    require("formatter").setup({
      logging = true,
      log_level = vim.log.levels.WARN,
      filetype = {
        html = {
          formatter,
        },
        json = {
          formatter,
        },
        jsonc = {
          formatter,
        },
        css = {
          formatter,
        },
        javascript = {
          formatter,
        },
        typescript = {
          formatter,
        },
        cs = {
          require("formatter.filetypes.cs").clangformat,
        },
        lua = {
          require("formatter.filetypes.lua").stylua,
        },
      },
    })
  end,
}
