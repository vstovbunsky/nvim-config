require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

lspconfig.clangd.setup {
    cmd = { "clangd", "--compile-commands-dir=." },
    on_attach = function(client, bufnr)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })
    end,
    capabilities = capabilities,
    args = {
--        "--header-insertion=never",  -- Optional: Prevent clangd from automatically inserting headers
        "--enable-config",           -- Enable additional configuration
        "--std=c++23",               -- Ensure clangd knows you're using C++23
        "--header-insertion-decorators=0",
        "--background-index",        -- Index the entire workspace in the background
        "--compile-commands-dir=.",   -- Make sure clangd knows where to find the compile_commands.json
    }
}

-- EXAMPLE
--local servers = { "html", "cssls", "pyright", "tsserver" }
--local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
--for _, lsp in ipairs(servers) do
--  lspconfig[lsp].setup {
--    on_attach = nvlsp.on_attach,
--    on_init = nvlsp.on_init,
--    capabilities = nvlsp.capabilities,
--  }
--end

--require'lspconfig'.clangd.setup{
--    cmd = {"clangd", "--compile-commands-dir=."},
--    on_attach = function(client, bufnr)
--        -- Use your preferred keybinding for code actions
--        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })
--    end,
--    capabilities = capabilities,
--}

-- configuring single server, example: typescript
-- lspconfig.tsserver.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
