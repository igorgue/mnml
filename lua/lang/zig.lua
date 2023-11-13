local utils = require("utils")
local attach = function()
  vim.bo.tabstop = 4
  vim.bo.softtabstop = 4
  vim.bo.shiftwidth = 4
  vim.bo.expandtab = true

  vim.lsp.start({
    name = "zls",
    filetypes = { { "zig", "zir" } },
    cmd = { "zls" },
    root_dir = vim.fn.getcwd(),
    single_file_support = true,
  })
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "zig",
  callback = attach,
})

attach()
utils.map_complete()
utils.map_complete("@")
