---------------------------------- OPTIONS     --------------------------------------
vim.opt.number = true
vim.opt.wrap = false

-- set tab size to 2 spaces
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- use system keyboard for yank
vim.opt.clipboard = 'unnamedplus'
vim.opt.termguicolors = true

vim.opt.showmode = false
vim.opt.termguicolors = true
vim.opt.mousemoveevent = true

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.whichwrap = "h,l,<,>,[,]"


------------------------------------ PLUGINS   --------------------------------------
local plugins = {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "numToStr/Comment.nvim",
    opts = {}
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = 'master',
    lazy = false,
    build = ":TSUpdate"
  },
  {
    "nvim-telescope/telescope.nvim"
  },
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons'
  }
}


------------------------------------- LAZY.NVIM PLUGIN MANAGER -------------------------------------
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
	plugins    
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true, notify = false },
})


---------------------------------- AUTO DARK-MODE ----------------------------------------
local result = vim.fn.system({
	"busctl", "--user", "call", "org.freedesktop.portal.Desktop", "/org/freedesktop/portal/desktop",
	"org.freedesktop.portal.Settings", "ReadOne", "ss", "org.freedesktop.appearance", "color-scheme"
	})
-- The result is in the form of "v u 0" for light and "v u 1" for dark
local color_scheme = result:match("u%s+(%d+)")

if color_scheme == "1" then
	vim.cmd.colorscheme("tokyonight-moon")
else
	vim.cmd.colorscheme("tokyonight-day")
end


--------------------------------- PLUGIN SETUP -------------------------------------
-- Comment
require('Comment').setup()

-- Tree Sitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "vim", "python", "javascript", "java", "typescript", "latex", "bash" },
  sync_install = false,
  auto_install = true,
}

-- Nvim Tree
require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 40,
    side = 'right'
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
})

-- Bufferline
require("bufferline").setup{
  options = { hover = { enabled = true, delay = 0, reveal = {'close'} }  }
}

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })


----------------------------------- KEYMAPS    --------------------------------------
vim.keymap.set("n", "<Leader><Leader>", "<cmd>:source<CR>", { desc = "Reload Neovim config" })
vim.keymap.set("n", '<C-s>', '<cmd>:w<CR>', { desc = 'Save' })
vim.keymap.set("n", '<C-_>', 'gcc', { desc = 'Comment', remap = true })
vim.keymap.set("v", '<C-_>', 'gc', { desc = 'Comment', remap = true })
vim.api.nvim_set_keymap("n", "<C-b>", ":NvimTreeFindFileToggle<CR>", { desc = "NeoTree toggle", noremap = true, silent = true })
vim.keymap.set("v", '<', '<gv', { remap = false })
vim.keymap.set("v", '>', '>gv', { remap = false })
vim.keymap.set("v", '<S-Tab>', '<gv', { remap = false })
vim.keymap.set("v", '<Tab>', '>gv', { remap = false })


----------------------------------- CLOSE NVIM WHEN THE EDITOR IS THE LAST BUFFER ---------------------------
-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close
vim.api.nvim_create_autocmd({"QuitPre"}, {
    callback = function() vim.cmd("NvimTreeClose") end,
})
