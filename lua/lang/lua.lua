local utils = require("utils")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.expandtab = true

    vim.lsp.start({
      name = "lua-language-server",
      filetypes = { "lua" },
      cmd = { "lua-language-server" },
      root_dir = vim.fn.getcwd(),
      settings = {
        Lua = {
          completion = {
            keywordSnippet = "Disable",
          },
        },
      },
    })
  end,
})

utils.map_complete()
