return {
  'akinsho/toggleterm.nvim',
  config = function()
    local Terminal = require('toggleterm.terminal').Terminal
    function Lazygit(cmd)
      return Terminal:new({
        cmd = cmd,
        dir = "git_dir",
        direction = "float",
        float_opts = {
          border = "double",
        },
        -- function to run on opening the terminal
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        end,
        -- function to run on closing the terminal
        on_close = function()
          vim.cmd("startinsert!")
        end,
      })
    end

    function LazyToggle(cmd)
      Lazygit(cmd):toggle()
    end


    vim.api.nvim_set_keymap("n", "<leader>gg", "<cmd>lua LazyToggle(\"lazygit\")<CR>",
      { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<leader>gl", "<cmd>lua LazyToggle(\"lazygit log\")<CR>",
      { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<leader>ld", "<cmd>lua LazyToggle(\"lazydocker\")<CR>",
      { noremap = true, silent = true })

    return true
  end
}
