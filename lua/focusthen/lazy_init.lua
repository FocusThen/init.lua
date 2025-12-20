local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = "focusthen.lazy",
    change_detection = { notify = false },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
                "man",
                "spellfile",
                "rplugin",
            },
        },
    },
})

-- Defer colorscheme loading until after UI is ready (faster startup)
vim.api.nvim_create_autocmd("UIEnter", {
    once = true,
    callback = function()
        ColorMyPencils("catppuccin")
    end,
})
