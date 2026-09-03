return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		local ts = require("nvim-treesitter")

		-- Parsers to install up front (idempotent — no-op if already installed).
		-- `install` takes a list of languages and runs in the background.
		local ensure_installed = {
			"bash",
			"css",
			"go",
			"html",
			"javascript",
			"json",
			"jsonc",
			"lua",
			"markdown",
			"markdown_inline",
			"prisma",
			"tsx",
			"typescript",
			"yaml",
		}
		ts.install(ensure_installed)

		-- Enable treesitter features per filetype via Neovim's built-in API.
		-- (The old `nvim-treesitter.configs` module API was removed on `main`.)
		--   - highlighting + folds: provided by Neovim (`vim.treesitter.start`)
		--   - indentation:          provided by nvim-treesitter (`indentexpr`)
		-- Folds are also covered by the global `foldexpr` set in core/options.lua.
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
			callback = function(args)
				local lang = vim.treesitter.language.get_lang(args.match) or args.match
				-- Start highlighting. If the parser isn't installed yet AND the
				-- language is one nvim-treesitter actually supports, kick off an
				-- install so it works on the next open. UI buffers (NeogitStatus,
				-- neo-tree, TelescopePrompt, ...) have no parser and are skipped
				-- silently instead of spamming "unsupported language" warnings.
				local ok = pcall(vim.treesitter.start, args.buf, lang)
				if not ok then
					if vim.list_contains(ts.get_available(), lang) then
						pcall(ts.install, { lang })
					end
					return
				end
				-- Indentation (nvim-treesitter provides the indentexpr).
				vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})

		-- nvim-ts-autotag ships its own setup (no longer a treesitter module).
		pcall(function()
			require("nvim-ts-autotag").setup({})
		end)
	end,
}
