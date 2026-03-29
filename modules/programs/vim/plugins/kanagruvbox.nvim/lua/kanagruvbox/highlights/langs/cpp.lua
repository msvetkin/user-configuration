-- C++ specific highlight overrides.
--
-- Three layers, applied in increasing priority:
--   1. Legacy vim C++ syntax groups  (cppXxx)   — always present, most granular for keywords
--   2. Treesitter @-groups           (@keyword.modifier etc.) — present when TS parser loaded
--   3. clangd LSP semantic tokens    (@lsp.typemod.X.Y) — highest priority, most accurate
--
-- Gruvbox reference:
--   template / typename  → cppStructure  → GruvboxAqua    → cpp_structure (#6A9589)
--   requires             → cppStatement  → GruvboxRed     → cpp_statement (#E46876)
--   constexpr/static/…  → cppStorageClass→ GruvboxOrange  → cpp_storage   (#FFA066)
--   explicit/virtual/…  → cppModifier   → GruvboxYellow  → cpp_modifier  (#C0A36E)
local M = {}

local function hi(name, val)
  vim.api.nvim_set_hl(0, name, val)
end

function M.set(p)
  -- ── Layer 1: legacy vim C++ syntax groups ─────────────────────────────
  -- These fire even without treesitter and provide the finest keyword split.
  hi("cppStructure",    { fg = p.cpp_structure })        -- template, typename
  hi("cppStatement",    { fg = p.cpp_statement })        -- requires
  hi("cppStorageClass", { fg = p.cpp_storage })          -- constexpr, consteval, constinit,
                                                         -- static, extern, inline, mutable
  hi("cppModifier",     { fg = p.cpp_modifier })         -- explicit, virtual, override, final,
                                                         -- noexcept (as specifier)

  -- ── Layer 2: treesitter (best-effort — TS groups are less granular) ───
  -- nvim-treesitter C++ grammar puts most specifiers under @keyword.modifier.
  -- We can't split constexpr vs explicit at this level, so we leave
  -- @keyword.modifier pointing to `keyword` (oniViolet) from syntax.lua
  -- and rely on the legacy groups above + clangd tokens below for precision.

  -- `requires` has its own treesitter capture in newer grammars
  hi("@keyword.requires",  { fg = p.cpp_statement })    -- C++20 requires-clause / requires-expr

  -- template keyword (captured separately in some grammars)
  hi("@keyword.template",  { fg = p.cpp_structure })

  -- ── Layer 3: clangd LSP semantic tokens ───────────────────────────────

  -- Standard library types look slightly different from user-defined ones
  hi("@lsp.typemod.type.defaultLibrary",      { fg = p.builtin })
  hi("@lsp.typemod.class.defaultLibrary",     { fg = p.builtin })
  hi("@lsp.typemod.struct.defaultLibrary",    { fg = p.builtin })

  -- Static methods: italic to distinguish from regular instance methods
  hi("@lsp.typemod.method.static",            { fg = p.func,      italic = true })
  hi("@lsp.typemod.function.static",          { fg = p.func,      italic = true })

  -- Virtual methods: italic (can be overridden by subclasses)
  hi("@lsp.typemod.method.virtual",           { fg = p.func,      italic = true })

  -- Member variables: distinct blue tint from plain locals
  hi("@lsp.typemod.variable.classScope",      { fg = p.member })

  -- const variables / parameters: bold signals immutability
  hi("@lsp.typemod.variable.readonly",        { fg = p.constant,  bold = true })
  hi("@lsp.typemod.parameter.readonly",       { fg = p.parameter, bold = true })

  -- Enum members are always readonly constants
  hi("@lsp.typemod.enumMember.readonly",      { fg = p.constant })

  -- Global-scope macros: extra bold to catch eye (think MACRO_NAME usage)
  hi("@lsp.typemod.macro.globalScope",        { fg = p.macro,     bold = true })

  -- Template type parameters (T, typename T): italic yellow distinguishes
  -- them from concrete types at instantiation sites
  hi("@lsp.typemod.type.functionScope",       { fg = p.type,      italic = true })

  -- auto-deduced variables: subtle italic hint that the type is inferred
  hi("@lsp.typemod.variable.deduced",         { fg = p.variable,  italic = true })

  -- Deprecated symbols: strikethrough regardless of kind
  hi("@lsp.typemod.function.deprecated",      { fg = p.func,      strikethrough = true })
  hi("@lsp.typemod.method.deprecated",        { fg = p.func,      strikethrough = true })
  hi("@lsp.typemod.type.deprecated",          { fg = p.type,      strikethrough = true })
  hi("@lsp.typemod.variable.deprecated",      { fg = p.variable,  strikethrough = true })
end

return M
