local utils = require("utils")

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
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
  end,
})

utils.map_complete()
