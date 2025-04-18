return {
	{
		"tpope/vim-fugitive",
		keys = {
			{ "<leader>ga", "<cmd>Git add %<CR>" },
			{ "<leader>gs", "<cmd>Git<CR>" },
			{ "<leader>gb", "<cmd>Git blame<CR>" },
			{ "<leader>gr", "<cmd>Git restore %<CR>" },
			{ "<leader>gl", "<cmd>Git log<CR>" },
			{ "gp", "<cmd>!Git pull<CR>" },
			{ "dh", "<cmd>diffget //2<CR>" },
			{ "dl", "<cmd>diffget //3<CR>" },
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- 🧭 Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gs.nav_hunk("next")
					end
				end, { desc = "Next Git Hunk" })

				map("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gs.nav_hunk("prev")
					end
				end, { desc = "Previous Git Hunk" })

				-- ⚙️ Git Actions
				map("n", "<leader>ha", gs.stage_hunk, { desc = "Stage Hunk" })
				map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset Hunk" })
				map("v", "<leader>ha", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Stage Hunk (Visual)" })

				map("v", "<leader>hr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Reset Hunk (Visual)" })

				map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage Buffer" })
				map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
				map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset Buffer" })
				map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview Hunk" })
				map("n", "<leader>hb", function()
					gs.blame_line({ full = true })
				end, { desc = "Blame Line (Full)" })

				-- 🔠 Git Text Object
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select Git Hunk" })
			end,
		},
	},
}
