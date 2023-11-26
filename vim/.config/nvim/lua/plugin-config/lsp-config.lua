local languages = require('format')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  -- TODO: uncomment
  -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<leader>ff', function() vim.lsp.buf.format { async = true } end, bufopts)
end

require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = { "tsserver", "pyright", "clangd", "gopls", "rust_analyzer", "lua_ls", "efm" },
  handlers = {
    function(server_name) -- default handler (optional)
      require("lspconfig")[server_name].setup {
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
        end,
      }
    end,

    -- efm setup
    ['efm'] = function(server_name)
      require("lspconfig")[server_name].setup {

        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          client.server_capabilities.documentFormattingProvider = true
          client.server_capabilities.document_formatting = true
          client.server_capabilities.goto_definition = false
        end,
        root_dir = function() return vim.fn.getcwd() end,
        settings = { languages = languages },
        filetypes = {
          "javascript", "javascriptreact", "javascript.jsx", "typescript",
          "typescript.tsx", "typescriptreact", "less", "scss", "css"
        }
      }
    end,

    -- lua ls setup
    ['lua_ls'] = function(server_name)
      -- setup needed for lua_ls
      local runtime_path = vim.split(package.path, ';')
      table.insert(runtime_path, "lua/?.lua")
      table.insert(runtime_path, "lua/?/init.lua")
      require("lspconfig")[server_name].setup {
        cmd = { '/opt/homebrew/bin/lua-language-server' },
        on_attach = function(client) on_attach(client) end,
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
              -- Setup your lua path
              path = runtime_path
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { 'vim' }
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
              -- disable the workspace prompt
              checkThirdParty = false,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = { enable = false }
          }
        }
      }
    end
  }
}


-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
