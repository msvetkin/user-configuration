local M = {}

local function hi(name, val)
  vim.api.nvim_set_hl(0, name, val)
end

function M.set(p)
  -- Core
  hi("Normal",       { fg = p.fg,        bg = p.bg })
  hi("NormalFloat",  { fg = p.fg,        bg = p.bg_float })
  hi("NormalNC",     { fg = p.fg_dim,    bg = p.bg })
  hi("SignColumn",   { fg = p.fg_subtle, bg = p.bg })
  hi("LineNr",       { fg = p.line_nr,   bg = p.bg })
  hi("CursorLineNr", { fg = p.fg_dim,    bold = true })
  hi("CursorLine",   { bg = p.cur_line })
  hi("CursorColumn", { bg = p.cur_line })
  hi("ColorColumn",  { bg = p.cur_line })
  hi("Folded",       { fg = p.fg_subtle, bg = p.bg_dim, italic = true })
  hi("FoldColumn",   { fg = p.fg_subtle, bg = p.bg })

  -- Statusline
  hi("StatusLine",   { fg = p.fg_dim,    bg = p.bg_gutter })
  hi("StatusLineNC", { fg = p.fg_subtle, bg = p.bg_dim })
  hi("WinBar",       { fg = p.fg_dim,    bg = p.bg })
  hi("WinBarNC",     { fg = p.fg_subtle, bg = p.bg })

  -- Splits / borders
  hi("VertSplit",    { fg = p.border })
  hi("WinSeparator", { fg = p.border })

  -- Popup menu
  hi("Pmenu",        { fg = p.fg_dim,  bg = p.bg_pmenu })
  hi("PmenuSel",     { fg = p.fg,      bg = p.bg_search, bold = true })
  hi("PmenuSbar",    { bg = p.bg_gutter })
  hi("PmenuThumb",   { bg = p.fg_subtle })

  -- Search / selection
  hi("Search",       { fg = p.bg,      bg = p.warning })
  hi("IncSearch",    { fg = p.bg,      bg = p.keyword,  bold = true })
  hi("CurSearch",    { fg = p.bg,      bg = p.warning,  bold = true })
  hi("Visual",       { bg = p.bg_visual })
  hi("VisualNOS",    { bg = p.bg_visual })
  hi("MatchParen",   { bg = p.match,   bold = true })

  -- Messages
  hi("ErrorMsg",     { fg = p.error })
  hi("WarningMsg",   { fg = p.warning })
  hi("ModeMsg",      { fg = p.fg_dim,  bold = true })
  hi("MoreMsg",      { fg = p.func })
  hi("Question",     { fg = p.func })

  -- Tabs
  hi("TabLine",      { fg = p.fg_subtle, bg = p.bg_dim })
  hi("TabLineSel",   { fg = p.fg,        bg = p.bg,     bold = true })
  hi("TabLineFill",  { bg = p.bg_dim })

  -- Misc
  hi("NonText",      { fg = p.nontext })
  hi("Whitespace",   { fg = p.nontext })
  hi("SpecialKey",   { fg = p.nontext })
  hi("EndOfBuffer",  { fg = p.nontext })
  hi("Title",        { fg = p.func,      bold = true })
  hi("Directory",    { fg = p.namespace })
  hi("Conceal",      { fg = p.fg_subtle })

  -- Spelling
  hi("SpellBad",     { undercurl = true, sp = p.error })
  hi("SpellCap",     { undercurl = true, sp = p.warning })
  hi("SpellRare",    { undercurl = true, sp = p.info })
  hi("SpellLocal",   { undercurl = true, sp = p.hint })

  -- Diff
  hi("DiffAdd",      { fg = p.git_add,    bg = p.diff_add })
  hi("DiffChange",   { fg = p.git_change, bg = p.diff_change })
  hi("DiffDelete",   { fg = p.git_delete, bg = p.diff_delete })
  hi("DiffText",     { fg = p.fg,         bg = p.diff_text })
  hi("Added",        { fg = p.git_add })
  hi("Changed",      { fg = p.git_change })
  hi("Removed",      { fg = p.git_delete })

  hi("QuickFixLine", { bg = p.bg_visual, bold = true })
end

return M
