local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
  spec = {
    -- no config plugins
    "folke/neodev.nvim",
    "folke/tokyonight.nvim",
    "igorgue/danger",
    "nvim-lua/plenary.nvim",
    "github/copilot.vim",

    -- much config plugins
    { "folke/neoconf.nvim", cmd = "Neoconf" },
    {
      "folke/which-key.nvim",
      keys = { { "<leader>?", "<cmd>WhichKey<cr>", desc = "Help" } },
    },
    {
      "williamboman/mason.nvim",
      opts = {
        pip = {
          upgrade_pip = true,
        },
        ui = {
          border = "single",
          winhighlight = "Normal:Normal,FloatBorder:VertSplit,CursorLine:CursorLine,Search:Search",
        },
      },
    },
    {
      "echasnovski/mini.surround",
      keys = {
        { "S", [[:<C-u>lua MiniSurround.add('visual')<cr>]], desc = "Add Surrounding", mode = "x" },
      },
    },
    {
      "numToStr/Comment.nvim",
      event = { "BufReadPost", "BufNewFile" },
      config = true,
    },
    {
      "nvimtools/none-ls.nvim",
      config = function()
        local none_ls = require("null-ls")
        local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
        local sources = { none_ls.builtins.formatting.stylua }

        none_ls.setup({
          sources = sources,
          on_attach = function(client, bufnr)
            if client.supports_method("textDocument/formatting") then
              vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })

              vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                  vim.lsp.buf.format({ bufnr = bufnr })
                end,
              })
            end
          end,
        })
      end,
    },
    {
      "L3MON4D3/LuaSnip",
      build = "make install_jsregexp",
      config = function()
        local ls = require("luasnip")

        ls.setup({})

        vim.keymap.set({ "i" }, "<C-j>", function()
          ls.expand()
        end, { silent = true })
        vim.keymap.set({ "i", "s" }, "<C-j>", function()
          ls.jump(1)
        end, { silent = true })
        vim.keymap.set({ "i", "s" }, "<C-k>", function()
          ls.jump(-1)
        end, { silent = true })

        vim.keymap.set({ "i", "s" }, "<cr>", function()
          if ls.choice_active() then
            ls.change_choice(1)
          end
        end, { silent = true })
      end,
    },
    {
      "nvim-telescope/telescope.nvim",
      dependencies = {
        "kkharji/sqlite.lua",
        "nvim-telescope/telescope-smart-history.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
        "danielfalk/smart-open.nvim",
        "nvim-telescope/telescope-fzy-native.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      },
      -- stylua: ignore
      enabled = not vim.o.diff,
      opts = function()
        local actions = require("telescope.actions")
        local themes = require("telescope.themes")

        return {
          defaults = {
            preview = {
              treesitter = false,
            },
            prompt_prefix = "  ",
            selection_caret = "  ",
            mappings = {
              i = {
                ["<esc>"] = actions.close,
                ["<C-c>"] = actions.close,
                ["<C-j>"] = actions.cycle_history_next,
                ["<C-k>"] = actions.cycle_history_prev,
                ["<C-b>"] = actions.preview_scrolling_up,
                ["<C-f>"] = actions.preview_scrolling_down,
              },
            },
            layout_config = {
              prompt_position = "top",
            },
            history = {
              path = vim.fn.stdpath("data") .. "/smart_history.sqlite3",
              cycle_wrap = true,
              limit = 100,
            },
            borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
          },
          extensions = {
            fzf = {
              fuzzy = true,
              override_generic_sorter = true,
              override_file_sorter = true,
              case_mode = "smart_case",
            },
            fzy_native = {
              override_generic_sorter = false,
              override_file_sorter = true,
            },
            ["ui-select"] = {
              themes.get_dropdown({
                borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
              }),
            },
          },
        }
      end,
      config = function(_, opts)
        local telescope = require("telescope")

        telescope.setup(opts)

        telescope.load_extension("ui-select")
        telescope.load_extension("smart_open")
        telescope.load_extension("fzy_native")
        telescope.load_extension("fzf")
      end,
      keys = {
        { "<leader>/",        "<cmd>Telescope live_grep<cr>",                     desc = "Find In Files" },
        { "<leader>ff",       "<cmd>Telescope find_files<cr>",                    desc = "Find Files" },
        { "<leader>fg",       "<cmd>Telescope git_files<cr>",                     desc = "Find Git Files" },
        { "<leader>fs",       "<cmd>Telescope smart_open<cr>",                    desc = "Smart Open" },
        { "<leader><leader>", "<cmd>Telescope smart_open<cr>",                    desc = "Smart Open" },
        { "<leader>ss",       "<cmd>Telescope lsp_document_symbols<cr>",          desc = "Goto Symbol" },
        { "<leader>sS",       "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Goto Symbol (Workspace)" },
      },
    },
  },
  ui = {
    border = "single",
  },
})

-- vim.cmd("colorscheme tokyonight-night")
vim.cmd("colorscheme danger")

-- OPTIONS --
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.completeopt = "menuone,noinsert,noselect"
vim.opt.splitkeep = "screen"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.autowrite = true           -- Enable auto write
vim.opt.clipboard = "unnamedplus"  -- Sync with system clipboard
vim.opt.conceallevel = 3           -- Hide * markup for bold and italic
vim.opt.confirm = true             -- Confirm to save changes before exiting modified buffer
vim.opt.formatoptions = "jcroqlnt" -- tcqj
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.ignorecase = true      -- Ignore case
vim.opt.inccommand = "nosplit" -- preview incremental substitute
vim.opt.list = true            -- Show some invisible characters (tabs...
vim.opt.mouse = "a"            -- Enable mouse mode
vim.opt.pumblend = 10          -- Popup blend
vim.opt.pumheight = 10         -- Maximum number of entries in a popup
vim.opt.scrolloff = 4          -- Lines of context
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
vim.opt.shiftround = true      -- Round indent
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
vim.opt.showmode = true        -- show mode
vim.opt.sidescrolloff = 8      -- Columns of context
vim.opt.signcolumn = "auto"    -- Show or hide signcolumn
vim.opt.smartcase = true       -- Don't ignore case with capitals
vim.opt.smartindent = true     -- Insert indents automatically
vim.opt.spelllang = { "en" }
vim.opt.termguicolors = true   -- True color support
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 200               -- Save swap file and trigger CursorHold
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
vim.opt.winminwidth = 5                -- Minimum window width
vim.opt.wrap = false                   -- Disable line wrap
vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  -- fold = "⸱",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
vim.opt.listchars = {
  tab = "──",
  -- lead = " ",
  -- trail = "·",
  nbsp = "␣",
  -- "eol:↵",
  precedes = "«",
  extends = "»",
}

if vim.fn.has("nvim-0.10") == 1 then
  vim.opt.smoothscroll = true
end

vim.g.markdown_recommended_style = 0

local diagnostic_config = {
  underline = true,
  virtual_text = {
    spacing = 0,
    prefix = "●",
  },
  signs = true,
  update_in_insert = true,
  severity_sort = true,
}

vim.diagnostic.config(diagnostic_config)
vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, diagnostic_config)
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" })

-- AUTOCOMMANDS --

local wk = require("which-key")

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    wk.register({
      K = { vim.lsp.buf.hover, "Hover" },
      ["<leader>k"] = { vim.lsp.buf.signature_help, "Signature Help" },
    }, { buffer = args.buf })

    wk.register({
      r = { vim.lsp.buf.rename, "Rename" },
      a = { vim.lsp.buf.code_action, "Code Action" },
      d = { vim.lsp.diagnostic.show_line_diagnostics, "Show Line Diagnostics" },
      n = { vim.lsp.diagnostic.goto_next, "Next Diagnostic" },
      p = { vim.lsp.diagnostic.goto_prev, "Previous Diagnostic" },
      f = { vim.lsp.buf.formatting, "Format" },
      e = { vim.lsp.diagnostic.set_loclist, "Set Loclist" },
    }, { buffer = args.buf, prefix = "<leader>c", name = "code" })
  end,
})

-- KEYS --

-- unset keys

-- set keys
local function cr_in_plumvisible()
  if vim.fn.pumvisible() == 0 then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<cr>", true, true, true), "n", true)
    return
  end

  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-n>", true, true, true), "n", true)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-Y>", true, true, true), "n", true)
end

wk.register({
  g = { name = "+goto" },
  ["["] = { name = "+prev" },
  ["]"] = { name = "+next" },
  ["<leader>f"] = { name = "+files" },
  ["<leader>s"] = { name = "+search" },
  ["<leader><cr>"] = { name = "+applications" },
  z = { name = "+fold", mode = { "n", "v" } },
})

wk.register({
  ["<leader>?"] = { "<cmd>WhichKey<cr>", "Help", mode = { "n" } },
  ["<leader>l"] = { "<cmd>Lazy<cr>", "Lazy", mode = { "n" } },
  ["<C-Space>"] = { "<C-x><C-o>", "Omnicomplete", mode = { "i" } },
  ["<C-s>"] = { "<cmd>w<cr>", "Save" },
  ["<cr>"] = { cr_in_plumvisible, "Select Item", mode = { "i" } },
  ["<esc>"] = { "<cmd>nohlsearch<cr>", "Clear Search", mode = { "n" } },
})

wk.register({
  ["<C-k>"] = { "<C-w>k", "Go To Window Up", mode = { "n" } },
  ["<C-h>"] = { "<C-w>h", "Go To Window Left", mode = { "n" } },
  ["<C-j>"] = { "<C-w>j", "Go To Window Down", mode = { "n" } },
  ["<C-l>"] = { "<C-w>l", "Go To Window Right", mode = { "n" } },
})

-- ctrl+s to save on insert mode
wk.register({
  ["<C-s>"] = { "<cmd>w<cr><esc>", "Save", mode = { "i" } },
})
