local conform = require("conform")
vim.keymap.set({ "n", "v" }, "<Leader>ff", function()
  conform.format({
    lsp_fallback = true,
    async = false,
    timeout_ms = 1000,
  })
end, {})

return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    conform.setup({
      formatters_by_ft = {
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescriptreact = { "prettierd" },
        css = { "prettierd" },
        html = { "prettierd" },
        json = { "prettierd" },
        markdown = { "prettierd" },
      },
    })
    vim.keymap.set({ "n", "v" }, "<Leader>ff", function()
      conform.format({
        lsp_fallback = true,
      })
    end, {})
  end
}
