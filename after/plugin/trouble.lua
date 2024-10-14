-- local t = require("trouble")

vim.keymap.set("n", "<leader>tq", "<cmd>TroubleToggle quickfix<cr>",
  {silent = true, noremap = true}
)
-- vim.keymap.set("n", "<leader>tt", function()
--     t.toggle()
-- end)
--
-- vim.keymap.set("n", "[t", function()
--     t.next({skip_groups = true, jump = true});
-- end)
--
-- vim.keymap.set("n", "]t", function()
--     t.previous({skip_groups = true, jump = true});
-- end)
