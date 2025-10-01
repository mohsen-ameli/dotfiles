---------------------------------- OPTIONS     --------------------------------------
vim.opt.number = true
vim.opt.wrap = false
vim.opt.scrolloff = 5
vim.opt.showmode = false
vim.opt.termguicolors = true
vim.opt.mousemoveevent = true
vim.opt.ignorecase = true
vim.opt.whichwrap = "h,l,<,>,[,]"
vim.opt.cursorline = true

-- add space to the left of the line numbers
vim.wo.signcolumn = "yes"

-- set tab size to 2 spaces
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- use system keyboard for yank
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.o.undofile = true

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
		opts = {},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		lazy = false,
		build = ":TSUpdate",
	},
	{
		"nvim-telescope/telescope.nvim",
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
		dependencies = "nvim-tree/nvim-web-devicons",
	},
	{
		"Aasim-A/scrollEOF.nvim",
		event = { "CursorMoved", "WinScrolled" },
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {},
		dependencies = {
			{
				"mason-org/mason.nvim",
				opts = {
					ui = {
						icons = {
							package_installed = "✓",
							package_pending = "➜",
							package_uninstalled = "✗",
						},
					},
				},
			},
			"neovim/nvim-lspconfig",
		},
	},
	{ "github/copilot.vim" },
	{
		"stevearc/conform.nvim",
		opts = {},
	},
	{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ "petertriho/nvim-scrollbar" },
	{ "jiangmiao/auto-pairs" },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{ "lewis6991/gitsigns.nvim" },
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
		plugins,
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true, notify = false },
})

---------------------------------- AUTO DARK-MODE ----------------------------------------
local lualine_conf = {
	options = {
		theme = "tokyonight",
		section_separators = "",
		component_separators = "",
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { "filename" },
		lualine_x = { "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "" },
	},
}
local result = vim.fn.system({
	"busctl",
	"--user",
	"call",
	"org.freedesktop.portal.Desktop",
	"/org/freedesktop/portal/desktop",
	"org.freedesktop.portal.Settings",
	"ReadOne",
	"ss",
	"org.freedesktop.appearance",
	"color-scheme",
})
-- The result is in the form of "v u 0" for light and "v u 1" for dark
local color_scheme = result:match("u%s+(%d+)")

if color_scheme == "1" then
	vim.cmd.colorscheme("tokyonight-moon")
	lualine_conf.options.theme = "tokyonight"
else
	vim.cmd.colorscheme("tokyonight-day")
	lualine_conf.options.theme = "tokyonight-day"
end

--------------------------------- PLUGIN SETUP -------------------------------------
require("Comment").setup()

require("nvim-treesitter.configs").setup({
	ensure_installed = { "c", "lua", "vim", "python", "javascript", "java", "typescript", "latex", "bash" },
	sync_install = false,
	auto_install = true,
})

require("nvim-tree").setup({
	sort = {
		sorter = "case_sensitive",
	},
	view = {
		width = 40,
		side = "right",
	},
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = false,
	},
})

require("bufferline").setup({
	options = { hover = { enabled = true, delay = 0, reveal = { "close" } } },
})

require("scrollEOF").setup()

-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

require("mason-tool-installer").setup({
	ensure_installed = {
		-- LSP
		"lua-language-server",
		"bash-language-server",
		"vim-language-server",
		"pyright",
		"bashls",
		"cssls",
		"html",
		"java_language_server",
		"ltex",
		"clangd",
		-- Formatters
		"stylua",
		"prettierd",
		"beautysh",
		-- Linters
		"shellcheck",
		"editorconfig-checker",
		"json-to-struct",
		"misspell",
		"revive",
		"shellcheck",
		"shfmt",
		"staticcheck",
		"vint",
	},
	auto_update = true,
	integrations = {
		["mason-lspconfig"] = true,
		["mason-null-ls"] = false,
		["mason-nvim-dap"] = false,
	},
})
-- LSP no signs for warnings, error and stuff
-- vim.diagnostic.config({
-- 	signs = false,
-- })

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
		javascript = { "prettierd" },
		typescript = { "prettierd" },
		javascriptreact = { "prettierd" },
		typescriptreact = { "prettierd" },
		java = { "prettierd" },
		latex = { "latexindent" },
		html = { "prettierd" },
		css = { "prettierd" },
		scss = { "prettierd" },
		json = { "prettierd" },
		jsonc = { "prettierd" },
		sh = { "beautysh" },
	},
	format_after_save = {
		timeout_ms = 2500,
		lsp_fallback = true,
	},
})

require("gitsigns").setup()

require("scrollbar").setup({
	show = true,
	show_in_active_only = true,
	set_highlights = true,
	hide_if_all_visible = true,
	handle = {
		text = " ",
		blend = 0, -- Integer between 0 and 100. 0 for fully opaque and 100 to full transparent. Defaults to 30.
		color = "#494949",
		hide_if_all_visible = true,
	},
	marks = {
		Cursor = {
			text = " ",
		},
	},
})

require("lualine").setup(lualine_conf)

----------------------------------- KEYMAPS    --------------------------------------
vim.api.nvim_set_keymap("n", "<C-b>", ":NvimTreeFindFileToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader><Leader>", "<cmd>:source $MYVIMRC<CR>", { desc = "Reload Neovim config" })
vim.keymap.set("n", "<C-s>", "<cmd>:w<CR>", {})
vim.keymap.set("n", "<C-_>", "gcc", { remap = true })
vim.keymap.set("v", "<C-_>", "gcgv", { remap = true })
vim.keymap.set("v", "<", "<gv", {})
vim.keymap.set("v", ">", ">gv", {})
vim.keymap.set("v", "<S-Tab>", "<gv", {})
vim.keymap.set("v", "<Tab>", ">gv", {})

----------------------------------- CLOSE NVIM WHEN THE EDITOR IS THE LAST BUFFER ---------------------------
-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close
vim.api.nvim_create_autocmd({ "QuitPre" }, {
	callback = function()
		vim.cmd("NvimTreeClose")
	end,
})
