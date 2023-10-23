local utils = require("utils")

vim.bo.tabstop = 2
vim.bo.softtabstop = 2
vim.bo.shiftwidth = 2
vim.bo.expandtab = true

vim.lsp.start({
  name = "clangd",
  filetypes = { "c" },
  cmd = { "clangd" },
  root_dir = vim.fn.getcwd(),
})

utils.map_complete()
