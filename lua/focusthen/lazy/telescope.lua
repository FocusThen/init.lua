return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope", -- Only load when Telescope command is used
  keys = {
    { "<leader>pf", function() require("telescope.builtin").find_files() end, desc = "Find files" },
    { "<C-p>", function() require("telescope.builtin").git_files() end, desc = "Git files" },
    { "<leader>ps", function() require("telescope.builtin").live_grep() end, desc = "Live grep" },
    { "<leader>vh", function() require("telescope.builtin").help_tags() end, desc = "Help tags" },
    { "<leader>sb", function() require("telescope.builtin").git_branches() end, desc = "Git branches" },
    { "<leader>pws", function()
      local word = vim.fn.expand("<cword>")
      require("telescope.builtin").grep_string({ search = word })
    end, desc = "Grep word under cursor" },
    { "<leader>pWs", function()
      local word = vim.fn.expand("<cWORD>")
      require("telescope.builtin").grep_string({ search = word })
    end, desc = "Grep WORD under cursor" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
  },

  config = function()
    local actions = require("telescope.actions")

    require("telescope").setup({
      defaults = {
        mappings = {
          i = {
            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
          },
        },
      },
      extensions = {
        wrap_results = true,
        fzf = {},
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
      },
    })

    pcall(require("telescope").load_extension, "ui-select")
  end,
}
