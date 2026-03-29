local M = {}

local function hi(name, val)
  vim.api.nvim_set_hl(0, name, val)
end

function M.set(p)
  -- ── Diagnostics ───────────────────────────────────────────────────────
  hi("DiagnosticError",             { fg = p.error })
  hi("DiagnosticWarn",              { fg = p.warning })
  hi("DiagnosticInfo",              { fg = p.info })
  hi("DiagnosticHint",              { fg = p.hint })
  hi("DiagnosticOk",                { fg = p.git_add })

  hi("DiagnosticUnderlineError",    { undercurl = true, sp = p.error })
  hi("DiagnosticUnderlineWarn",     { undercurl = true, sp = p.warning })
  hi("DiagnosticUnderlineInfo",     { undercurl = true, sp = p.info })
  hi("DiagnosticUnderlineHint",     { undercurl = true, sp = p.hint })

  hi("DiagnosticFloatingError",     { fg = p.error })
  hi("DiagnosticFloatingWarn",      { fg = p.warning })
  hi("DiagnosticFloatingInfo",      { fg = p.info })
  hi("DiagnosticFloatingHint",      { fg = p.hint })

  hi("DiagnosticSignError",         { fg = p.error })
  hi("DiagnosticSignWarn",          { fg = p.warning })
  hi("DiagnosticSignInfo",          { fg = p.info })
  hi("DiagnosticSignHint",          { fg = p.hint })

  hi("DiagnosticVirtualTextError",  { fg = p.error,   bg = p.diff_delete, italic = true })
  hi("DiagnosticVirtualTextWarn",   { fg = p.warning, bg = p.diff_text,   italic = true })
  hi("DiagnosticVirtualTextInfo",   { fg = p.info,    bg = p.diff_change, italic = true })
  hi("DiagnosticVirtualTextHint",   { fg = p.hint,    bg = p.diff_change, italic = true })

  -- ── LSP semantic token types ──────────────────────────────────────────
  -- Higher priority than treesitter — clangd/rust-analyzer tokens are precise.

  -- Types
  hi("@lsp.type.type",              { fg = p.type })
  hi("@lsp.type.class",             { fg = p.type })
  hi("@lsp.type.struct",            { fg = p.type })
  hi("@lsp.type.enum",              { fg = p.type })
  hi("@lsp.type.interface",         { fg = p.type })
  hi("@lsp.type.typeParameter",     { fg = p.type,      italic = true })  -- template params
  hi("@lsp.type.typedef",           { fg = p.type })
  hi("@lsp.type.concept",           { fg = p.type,      italic = true })  -- C++20 concepts

  -- Functions / methods
  hi("@lsp.type.function",          { fg = p.func })
  hi("@lsp.type.method",            { fg = p.func })

  -- Variables
  hi("@lsp.type.variable",          { fg = p.variable })
  hi("@lsp.type.parameter",         { fg = p.parameter })
  hi("@lsp.type.property",          { fg = p.member })

  -- Namespaces
  hi("@lsp.type.namespace",         { fg = p.namespace })

  -- Macros
  hi("@lsp.type.macro",             { fg = p.macro })

  -- Enum members
  hi("@lsp.type.enumMember",        { fg = p.constant })

  -- Operators / keywords
  hi("@lsp.type.operator",          { fg = p.operator })
  hi("@lsp.type.keyword",           { fg = p.keyword })
  hi("@lsp.type.comment",           { fg = p.comment })

  -- ── LSP semantic token modifiers ──────────────────────────────────────
  hi("@lsp.mod.static",             { italic = true })        -- static members
  hi("@lsp.mod.abstract",           { italic = true })
  hi("@lsp.mod.virtual",            { italic = true })        -- virtual methods
  hi("@lsp.mod.readonly",           { bold = true })          -- const / readonly
  hi("@lsp.mod.deprecated",         { strikethrough = true })

  -- ── References / hover ────────────────────────────────────────────────
  hi("LspReferenceText",            { bg = p.bg_gutter })
  hi("LspReferenceRead",            { bg = p.bg_gutter })
  hi("LspReferenceWrite",           { bg = p.bg_gutter, bold = true })
  hi("LspInlayHint",                { fg = p.fg_subtle, bg = p.bg_dim, italic = true })
  hi("LspCodeLens",                 { fg = p.fg_subtle, italic = true })
  hi("LspCodeLensSeparator",        { fg = p.border })
  hi("LspSignatureActiveParameter", { fg = p.parameter, bold = true, underline = true })
end

return M
