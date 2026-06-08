''
  -- CLion Dark theme highlight groups
  local hl = vim.api.nvim_set_hl

  -- Keywords: if, for, return, class, const, static, template...
  hl(0, '@keyword',               { fg = '#cf8e6d' })
  hl(0, '@keyword.return',        { fg = '#cf8e6d' })
  hl(0, '@keyword.operator',      { fg = '#cf8e6d' })
  hl(0, '@keyword.type',          { fg = '#cf8e6d' })
  hl(0, '@type.builtin',          { fg = '#cf8e6d' })
  hl(0, '@type.qualifier',        { fg = '#cf8e6d' })
  hl(0, '@storageclass',          { fg = '#cf8e6d' })

  -- Types
  hl(0, '@type',                  { fg = '#bcbec4' })
  hl(0, '@type.parameter',        { fg = '#16baac' })

  -- Functions: declarations are blue, free calls use identifier color
  hl(0, '@function',              { fg = '#56a8f5' })
  hl(0, '@function.call',         { fg = '#bcbec4' })
  hl(0, '@function.method',       { fg = '#57aaf7' })
  hl(0, '@function.method.call',  { fg = '#57aaf7' })

  -- Variables
  hl(0, '@variable',              { fg = '#bcbec4' })
  hl(0, '@variable.member',       { fg = '#c77dbb' })
  hl(0, '@variable.parameter',    { fg = '#bcbec4' })

  -- Constants and macros
  hl(0, '@constant',              { fg = '#c77dbb', bold = true })
  hl(0, '@constant.builtin',      { fg = '#cf8e6d' })
  hl(0, '@constant.macro',        { fg = '#c77dbb', bold = true })

  -- Strings and numbers
  hl(0, '@string',                { fg = '#6aab73' })
  hl(0, '@string.escape',         { fg = '#cf8e6d' })
  hl(0, '@number',                { fg = '#2aacb8' })
  hl(0, '@number.float',          { fg = '#2aacb8' })

  -- Comments
  hl(0, '@comment',               { fg = '#7a7e85' })
  hl(0, '@comment.documentation', { fg = '#5f826b', bold = true, italic = true })

  -- Punctuation and operators
  hl(0, '@operator',              { fg = '#bcbec4' })
  hl(0, '@punctuation.bracket',   { fg = '#bcbec4' })
  hl(0, '@punctuation.delimiter', { fg = '#bcbec4' })

  -- Namespace and attributes (e.g. [[nodiscard]])
  hl(0, '@namespace',             { fg = '#bcbec4' })
  hl(0, '@attribute',             { fg = '#b3ae60' })

  -- Preprocessor
  hl(0, '@keyword.directive',     { fg = '#cf8e6d' })
  hl(0, '@keyword.import',        { fg = '#cf8e6d' })

  -- Diagnostics
  hl(0, 'DiagnosticError',        { fg = '#fa6675' })
  hl(0, 'DiagnosticWarn',         { fg = '#f2c55c' })
  hl(0, 'DiagnosticInfo',         { fg = '#56a8f5' })
  hl(0, 'DiagnosticHint',         { fg = '#bcbec4' })
''
