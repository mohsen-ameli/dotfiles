-------------------------------------------------------------------------------------
---------------------------------- OPTIONS ------------------------------------------
-------------------------------------------------------------------------------------
vim.opt.number = true
vim.opt.wrap = false
vim.opt.scrolloff = 5
vim.opt.showmode = false
vim.opt.termguicolors = true
vim.opt.mousemoveevent = true
vim.opt.ignorecase = true
vim.opt.whichwrap = "h,l,<,>,[,]"
vim.opt.cursorline = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true

-- add space to the left of the line numbers
vim.wo.signcolumn = "yes"

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.o.undofile = true

-------------------------------------------------------------------------------------
---------------------------------- PLUGINS ------------------------------------------
-------------------------------------------------------------------------------------
local plugins = {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
	},
	{ "numToStr/Comment.nvim" },
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		lazy = false,
		build = ":TSUpdate",
	},
	{ "nvim-telescope/telescope.nvim" },
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
	},
	{
		"mason-org/mason-lspconfig.nvim",
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
	{ "stevearc/conform.nvim" },
	{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ "petertriho/nvim-scrollbar" },
	{ "jiangmiao/auto-pairs" },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{ "lewis6991/gitsigns.nvim" },
}

-------------------------------------------------------------------------------------
---------------------------------- LAZY.NVIM PLUGIN MANAGER--------------------------
-------------------------------------------------------------------------------------
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
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
	spec = {
		plugins,
	},
	install = { colorscheme = { "habamax" } },
	checker = { enabled = true, notify = false },
})

-------------------------------------------------------------------------------------
---------------------------------- AUTO DARK MODE -----------------------------------
-------------------------------------------------------------------------------------
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
local color_scheme = vim.fn.system({ "cat", "/etc/theme" })

if color_scheme == "dark\n" then
	vim.cmd.colorscheme("tokyonight-moon")
	lualine_conf.options.theme = "tokyonight"
else
	vim.cmd.colorscheme("tokyonight-day")
	lualine_conf.options.theme = "tokyonight-day"
end

----------------------------------------------------------------------------------------
--------------------------------- PLUGIN SETUP -----------------------------------------
----------------------------------------------------------------------------------------
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

vim.opt.termguicolors = true
require("bufferline").setup({
	options = {
		hover = { enabled = true, delay = 0, reveal = { "close" } },
		separator_style = { "", "" },
		indicator = {
			style = "underline",
		},
	},
})

require("scrollEOF").setup()

-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

-- LSP
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

-------------------------------------------------------------------------------------
----------------------------------- KEYMAPS    --------------------------------------
-------------------------------------------------------------------------------------
vim.api.nvim_set_keymap("n", "<C-b>", ":NvimTreeFindFileToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader><Leader>", "<cmd>:source $MYVIMRC<CR>", { desc = "Reload Neovim config" })
vim.keymap.set("n", "<C-s>", "<cmd>:w<CR>", {})
vim.keymap.set("n", "<C-_>", "gcc", { remap = true })
vim.keymap.set("v", "<C-_>", "gcgv", { remap = true })
vim.keymap.set("v", "<", "<gv", {})
vim.keymap.set("v", ">", ">gv", {})
vim.keymap.set("v", "<S-Tab>", "<gv", {})
vim.keymap.set("v", "<Tab>", ">gv", {})

-------------------------------------------------------------------------------------------------------------
----------------------------------- CLOSE NVIM WHEN THE EDITOR IS THE LAST BUFFER ---------------------------
-------------------------------------------------------------------------------------------------------------
-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close
vim.api.nvim_create_autocmd({ "QuitPre" }, {
	callback = function()
		vim.cmd("NvimTreeClose")
	end,
})
