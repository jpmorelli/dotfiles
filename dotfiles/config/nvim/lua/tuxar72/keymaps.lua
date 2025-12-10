local map = vim.keymap.set

map("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "File explorer" })
map("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live grep" })

