local wk = require("which-key")

local M = {}

M.map_complete = function(char)
  if char == nil then
    char = "."
  end

  wk.register({
    [char] = {
      function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(char, true, true, true), "n", true)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-x><C-o>", true, true, true), "n", true)
      end,
      "Omnicomplete",
      mode = { "i" },
    },
  }, { buffer = vim.api.nvim_get_current_buf() })
end

return M
