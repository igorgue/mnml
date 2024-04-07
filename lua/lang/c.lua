local utils = require("utils")
local attach = function()
  vim.bo.tabstop = 2
  vim.bo.softtabstop = 2
  vim.bo.shiftwidth = 2
  vim.bo.expandtab = true

  vim.lsp.start({
    name = "clangd",
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    cmd = { "clangd" },
    root_dir = vim.fn.getcwd(),
  })
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = attach,
})

attach()
utils.map_complete()
