local M = {}
---@param colors KanagawaColors
---@param config? KanagawaConfig
function M.setup(colors, config)
    config = config or require("kanagruvbox").config
    local theme = colors.theme
    local palette = colors.palette
    return {
        -- ["@lsp.type.class"] = { link = "Structure" },
        -- ["@lsp.type.decorator"] = { link = "Function" },
        -- ["@lsp.type.enum"] = { link = "Structure" },
        -- ["@lsp.type.enumMember"] = { link = "Constant" },
        -- ["@lsp.type.function"] = { link = "Function" },
        -- ["@lsp.type.interface"] = { link = "Structure" },
        ["@lsp.type.macro"] = { link = "Macro" },
        ["@lsp.type.method"] = { link = "@function.method" },       -- Function
        ["@lsp.type.namespace"] = { link = "@module" },             -- Structure
        ["@lsp.type.parameter"] = { link = "@variable.parameter" }, -- Identifier
        -- ["@lsp.type.property"] = { link = "Identifier" },
        -- ["@lsp.type.struct"] = { link = "Structure" },
        -- ["@lsp.type.type"] = { link = "Type" },
        -- ["@lsp.type.typeParameter"] = { link = "TypeDef" },
        ["@lsp.type.variable"] = { fg = "none" }, -- Identifier
        ["@lsp.type.comment"] = { link = "Comment" },  -- Comment

        ["@lsp.type.const"] = { link = "Constant" },
        ["@lsp.type.comparison"] = { link = "Operator" },
        ["@lsp.type.bitwise"] = { link = "Operator" },
        ["@lsp.type.punctuation"] = { link = "Delimiter" },

        ["@lsp.type.selfParameter"] = { link = "@variable.builtin" },
        -- ["@lsp.type.builtinConstant"] = { link = "@constant.builtin" },
        ["@lsp.type.builtinConstant"] = { link = "@constant.builtin" },
        ["@lsp.type.magicFunction"] = { link = "@function.builtin" },

        ["@lsp.mod.readonly"] = { link = "Constant" },
        ["@lsp.mod.typeHint"] = { link = "Type" },
        -- ["@lsp.mod.defaultLibrary"] = { link = "Special" },
        -- ["@lsp.mod.builtin"] = { link = "Special" },

        ["@lsp.typemod.operator.controlFlow"] = { link = "@keyword.exception" }, -- rust ? operator
        ["@lsp.type.lifetime"] = { link = "Operator" },
        ["@lsp.typemod.keyword.documentation"] = { link = "Special" },
        ["@lsp.type.decorator.rust"] = { link = "PreProc" },

        ["@lsp.typemod.variable.global"] = { link = "Constant" },
        ["@lsp.typemod.variable.static"] = { link = "Constant" },
        ["@lsp.typemod.variable.defaultLibrary"] = { link = "Special" },

        ["@lsp.typemod.function.builtin"] = { link = "@function.builtin" },
        ["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },
        ["@lsp.typemod.method.defaultLibrary"] = { link = "@function.builtin" },

        ["@lsp.typemod.variable.injected"] = { link = "@variable" },

        ["@lsp.typemod.function.readonly"] = { fg = theme.syn.fun, bold = true },

        -- Standard library namespace (std::) vs user namespace (foo::):
        -- both resolve to @lsp.type.namespace → Type (waveAqua2 teal).
        -- crystalBlue (#7E9CD8) is a distinct proper blue vs teal — clear hue shift.
        ["@lsp.typemod.namespace.defaultLibrary"] = { fg = palette.crystalBlue },

        -- C++ semantic token overrides
        -- Template type parameter names (E, T, Error…): Type → waveAqua2 too close
        -- to cppStructure → springBlue. carpYellow gives clear contrast.
        ["@lsp.type.typeParameter"] = { fg = palette.carpYellow },

        -- Class member fields (error_, value_…): property → Identifier → carpYellow,
        -- collides with typeParameter. springBlue matches @variable.member semantics.
        ["@lsp.type.property"] = { fg = palette.springBlue },

        -- @lsp.mod.readonly paints ALL readonly tokens as Constant, making const-ref
        -- parameters indistinguishable from const methods. Restore per-kind colors.
        ["@lsp.typemod.parameter.readonly"] = { link = "@variable.parameter" },
        ["@lsp.typemod.method.readonly"]    = { fg = theme.syn.fun, bold = true },
    }
end

return M
--vim: fdm=marker
