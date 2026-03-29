local M = {}

local function hi(name, val)
  vim.api.nvim_set_hl(0, name, val)
end

function M.set(p)
  local ic = p.opts.italic_comments
  local ik = p.opts.italic_keywords

  -- ── Legacy syntax groups (fallback for non-treesitter filetypes) ──────
  hi("Comment",        { fg = p.comment,  italic = ic })
  hi("Constant",       { fg = p.constant })
  hi("String",         { fg = p.string_ })
  hi("Character",      { fg = p.string_ })
  hi("Number",         { fg = p.number })
  hi("Boolean",        { fg = p.constant })
  hi("Float",          { fg = p.number })
  hi("Identifier",     { fg = p.variable })
  hi("Function",       { fg = p.func })
  hi("Statement",      { fg = p.keyword,  italic = ik })
  hi("Conditional",    { fg = p.keyword,  italic = ik })
  hi("Repeat",         { fg = p.keyword,  italic = ik })
  hi("Label",          { fg = p.keyword })
  hi("Operator",       { fg = p.operator })
  hi("Keyword",        { fg = p.keyword,  italic = ik })
  hi("Exception",      { fg = p.keyword,  italic = ik })
  hi("PreProc",        { fg = p.macro })
  hi("Include",        { fg = p.macro })
  hi("Define",         { fg = p.macro })
  hi("Macro",          { fg = p.macro })
  hi("PreCondit",      { fg = p.macro })
  hi("Type",           { fg = p.type })
  hi("StorageClass",   { fg = p.keyword })
  hi("Structure",      { fg = p.type })
  hi("Typedef",        { fg = p.type })
  hi("Special",        { fg = p.special })
  hi("SpecialChar",    { fg = p.special })
  hi("Tag",            { fg = p.func })
  hi("Delimiter",      { fg = p.fg_dim })
  hi("SpecialComment", { fg = p.special,  italic = true })
  hi("Debug",          { fg = p.warning })
  hi("Underlined",     { underline = true })
  hi("Error",          { fg = p.error })
  hi("Todo",           { fg = p.warning,  bold = true })

  -- ── Treesitter (@-prefixed) ───────────────────────────────────────────

  -- Variables
  hi("@variable",              { fg = p.variable })
  hi("@variable.builtin",      { fg = p.builtin })
  hi("@variable.parameter",    { fg = p.parameter })
  hi("@variable.member",       { fg = p.member })

  -- Constants
  hi("@constant",              { fg = p.constant })
  hi("@constant.builtin",      { fg = p.constant,  bold = true })
  hi("@constant.macro",        { fg = p.macro })

  -- Strings
  hi("@string",                { fg = p.string_ })
  hi("@string.escape",         { fg = p.special })
  hi("@string.special",        { fg = p.special })
  hi("@string.special.url",    { fg = p.namespace, underline = true })

  -- Numbers
  hi("@number",                { fg = p.number })
  hi("@number.float",          { fg = p.number })
  hi("@boolean",               { fg = p.constant })

  -- Functions
  hi("@function",              { fg = p.func })
  hi("@function.builtin",      { fg = p.builtin })
  hi("@function.call",         { fg = p.func })
  hi("@function.macro",        { fg = p.macro })
  hi("@function.method",       { fg = p.func })
  hi("@function.method.call",  { fg = p.func })
  hi("@constructor",           { fg = p.type })

  -- Keywords
  hi("@keyword",               { fg = p.keyword,  italic = ik })
  hi("@keyword.conditional",   { fg = p.keyword,  italic = ik })
  hi("@keyword.repeat",        { fg = p.keyword,  italic = ik })
  hi("@keyword.return",        { fg = p.keyword,  italic = ik })
  hi("@keyword.exception",     { fg = p.keyword,  italic = ik })
  hi("@keyword.import",        { fg = p.macro })
  hi("@keyword.operator",      { fg = p.operator })
  hi("@keyword.type",          { fg = p.keyword })
  hi("@keyword.modifier",      { fg = p.keyword })  -- const, static, inline, volatile

  -- Types
  hi("@type",                  { fg = p.type })
  hi("@type.builtin",          { fg = p.type })
  hi("@type.definition",       { fg = p.type })
  hi("@type.qualifier",        { fg = p.keyword })  -- const, volatile

  -- Operators / punctuation
  hi("@operator",              { fg = p.operator })
  hi("@punctuation.bracket",   { fg = p.fg_dim })
  hi("@punctuation.delimiter", { fg = p.fg_dim })
  hi("@punctuation.special",   { fg = p.special })

  -- Namespaces
  hi("@module",                { fg = p.namespace })
  hi("@module.builtin",        { fg = p.namespace })
  hi("@namespace",             { fg = p.namespace })  -- legacy alias

  -- Comments
  hi("@comment",               { fg = p.comment,   italic = ic })
  hi("@comment.documentation", { fg = p.comment,   italic = true })
  hi("@comment.error",         { fg = p.error,     bold = true })
  hi("@comment.warning",       { fg = p.warning,   bold = true })
  hi("@comment.todo",          { fg = p.warning,   bold = true })
  hi("@comment.note",          { fg = p.info,      bold = true })

  -- Labels / tags
  hi("@label",                 { fg = p.func })
  hi("@tag",                   { fg = p.keyword })
  hi("@tag.attribute",         { fg = p.type })
  hi("@tag.delimiter",         { fg = p.fg_dim })

  -- Misc
  hi("@attribute",             { fg = p.macro })   -- [[nodiscard]], [[deprecated]]
  hi("@property",              { fg = p.member })
  hi("@diff.plus",             { fg = p.git_add })
  hi("@diff.minus",            { fg = p.git_delete })
  hi("@diff.delta",            { fg = p.git_change })
end

return M
