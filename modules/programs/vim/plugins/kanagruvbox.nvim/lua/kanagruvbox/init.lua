local M = {}

M.options = {
  contrast         = "medium",  -- "soft" | "medium" | "hard"
  transparent      = false,
  italic_comments  = true,
  italic_keywords  = false,
}

function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

function M.load()
  if vim.version().minor < 8 then
    vim.notify("kanagruvbox: requires Neovim 0.8+", vim.log.levels.WARN)
    return
  end

  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end

  vim.o.termguicolors  = true
  vim.g.colors_name    = "kanagruvbox"

  local p = require('kanagruvbox.palette').get(M.options)

  require('kanagruvbox.highlights.editor').set(p)
  require('kanagruvbox.highlights.syntax').set(p)
  require('kanagruvbox.highlights.lsp').set(p)
  require('kanagruvbox.highlights.langs.cpp').set(p)
end

return M
