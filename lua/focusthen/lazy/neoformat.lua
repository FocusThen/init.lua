return {
  'sbdchd/neoformat',
  config = function()
    vim.keymap.set("n", "<leader>f", "<cmd>Neoformat prettier<CR>", { silent = true })
  end
}
