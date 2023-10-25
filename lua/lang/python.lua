local utils = require("utils")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.expandtab = true

    vim.lsp.start({
      name = "pyright",
      filetypes = { "python" },
      cmd = { "pyright" },
      root_dir = vim.fn.getcwd(),
    })
  end,
})

utils.map_complete()
