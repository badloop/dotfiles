return {
	"nvim-treesitter/nvim-treesitter",
	init = function(plugin)
		-- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
		-- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
		-- no longer trigger the **nvim-treeitter** module to be loaded in time.
		-- Luckily, the only thins that those plugins need are the custom queries, which we make available
		-- during startup.
		require("lazy.core.loader").add_to_rtp(plugin)
		require("nvim-treesitter.query_predicates")
	end,
	dependencies = {
		"nvim-treesitter/nvim-treesitter-context",
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	enabled = true,
	build = ":TSUpdate",
	event = { "VeryLazy" },
	opts_extend = { "ensure_installed" },
	---@type TSConfig
	---@diagnostic disable-next-line: missing-fields
	opts = {
		ensure_installed = {
			"bash",
			"css",
			"dockerfile",
			"git_config",
			"gitcommit",
			"gitignore",
			"go",
			"html",
			"javascript",
			"json",
			"jsonc",
			"lua",
			"make",
			"markdown",
			"markdown_inline",
			"python",
			"query",
			"regex",
			"rust",
			"sql",
			"toml",
			"tsx",
			"typescript",
			"yaml",
			"xml",
			"c",
			"diff",
			"jsdoc",
		},
		sync_install = false,
		auto_install = true,
		highlight = {
			enable = true,
		},
		indent = {
			enable = true,
		},
		rainbow = {
			enable = true,
		},
		playground = {
			enable = true,
			disable = {},
			updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
			persist_queries = false, -- Whether the query persists across vim sessions
			keybindings = {
				toggle_query_editor = "o",
				toggle_hl_groups = "i",
				toggle_injected_languages = "t",
				toggle_anonymous_nodes = "a",
				toggle_language_display = "I",
				focus_language = "f",
				unfocus_language = "F",
				update = "R",
				goto_node = "<cr>",
				show_help = "?",
			},
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					-- You can use the capture groups defined in textobjects.scm
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
				},
			},
			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				goto_next_start = { ["]m"] = "@function.outer", ["]]"] = "@class.outer" },
				goto_next_end = { ["]M"] = "@function.outer", ["]["] = "@class.outer" },
				goto_previous_start = { ["[m"] = "@function.outer", ["[["] = "@class.outer" },
				goto_previous_end = { ["[M"] = "@function.outer", ["[]"] = "@class.outer" },
			},
			swap = {
				enable = true,
				swap_next = { ["<leader>>"] = "@parameter.inner" },
				swap_previous = { ["<leader><"] = "@parameter.outer" },
			},
			lsp_interop = {
				enable = true,
				peek_definition_code = {
					["gD"] = "@function.outer",
				},
			},
		},
	},
	config = function(_, opts)
		if type(opts.ensure_installed) == "table" then
			---@type table<string, boolean>
			local added = {}
			opts.ensure_installed = vim.tbl_filter(function(lang)
				if added[lang] then
					return false
				end
				added[lang] = true
				return true
			end, opts.ensure_installed)
		end
		require("nvim-treesitter.configs").setup(opts)
	end,
}
