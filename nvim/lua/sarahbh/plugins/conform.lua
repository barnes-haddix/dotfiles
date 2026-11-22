-- formatting: prettier for js/ts/react (and web files), everything else falls back to the lsp formatter
return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  config = function()
    local conform = require("conform")

    -- filetypes that get prettier (installed through mason, see mason.lua)
    local prettier_fts = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "json",
      "jsonc",
      "css",
      "html",
    }

    local formatters_by_ft = {}
    for _, ft in ipairs(prettier_fts) do
      formatters_by_ft[ft] = { "prettier" }
    end

    conform.setup({
      formatters_by_ft = formatters_by_ft,
      -- format on save only for the filetypes above (c/cpp already format on save in lspconfig.lua)
      format_on_save = function(bufnr)
        if not vim.tbl_contains(prettier_fts, vim.bo[bufnr].filetype) then
          return
        end
        return { timeout_ms = 1000, lsp_format = "never" }
      end,
    })
  end,
}
