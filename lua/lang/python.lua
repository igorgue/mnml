local utils = require("utils")
local attach = function()
  vim.bo.tabstop = 4
  vim.bo.softtabstop = 4
  vim.bo.shiftwidth = 4
  vim.bo.expandtab = true

  vim.lsp.start({
    name = "pyright",
    filetypes = { "python" },
    cmd = { "pyright-langserver", "--stdio" },
    root_dir = vim.fn.getcwd(),
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "openFilesOnly",
          useLibraryCodeForTypes = true,
        },
      },
    },
  })
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = attach,
})

attach()
utils.map_complete()
