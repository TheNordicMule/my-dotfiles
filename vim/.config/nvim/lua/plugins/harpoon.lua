return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	keys = {
		{
			"<leader>ma",
			function()
				local harpoon = require("harpoon")
				harpoon:list():add()
			end,
		},
		{
			"<leader>mm",
			function()
				local harpoon = require("harpoon")
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end,
		},
		{
			"<leader>1",
			function()
				local harpoon = require("harpoon")
				harpoon:list():select(1)
			end,
		},
		{
			"<leader>2",
			function()
				local harpoon = require("harpoon")
				harpoon:list():select(2)
			end,
		},
		{
			"<leader>3",
			function()
				local harpoon = require("harpoon")
				harpoon:list():select(3)
			end,
		},
		{
			"<leader>4",
			function()
				local harpoon = require("harpoon")
				harpoon:list():select(4)
			end,
		},
		{
			"<leader>5",
			function()
				local harpoon = require("harpoon")
				harpoon:list():select(5)
			end,
		},
	},
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()
	end,
}
