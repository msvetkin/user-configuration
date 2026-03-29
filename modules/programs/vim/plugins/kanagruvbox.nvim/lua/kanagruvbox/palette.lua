local M = {}

-- Kanagawa Wave base palette
local base = {
  -- Backgrounds (sumiInk scale)
  sumiInk0     = "#16161D",
  sumiInk1     = "#1F1F28",  -- default bg
  sumiInk2     = "#2A2A37",
  sumiInk3     = "#363646",
  sumiInk4     = "#54546D",

  -- Selection / UI backgrounds
  waveBlue1    = "#223249",
  waveBlue2    = "#2D4F67",

  -- Diff backgrounds
  winterGreen  = "#2B3328",
  winterYellow = "#49443C",
  winterRed    = "#43242B",
  winterBlue   = "#252535",

  -- Diff accent colors
  autumnGreen  = "#76946A",
  autumnRed    = "#C34043",
  autumnYellow = "#DCA561",

  -- Bright diagnostics
  samuraiRed   = "#E82424",
  roninYellow  = "#FF9E3B",

  -- Syntax palette (Kanagawa → Gruvbox semantic roles)
  --
  --  Gruvbox role   │ Kanagawa color     │ hex
  -- ────────────────┼────────────────────┼──────────
  --  keyword        │ oniViolet          │ #957FB8
  --  type           │ carpYellow         │ #E6C384  (gruvbox yellow → kanagawa gold)
  --  func/method    │ waveAqua2          │ #7AA89F  (gruvbox green → kanagawa teal)
  --  namespace      │ crystalBlue        │ #7E9CD8  (bright blue)
  --  macro          │ surimiOrange       │ #FFA066  (gruvbox orange → kanagawa orange)
  --  constant/enum  │ sakuraPink         │ #D27E99  (gruvbox red-orange → kanagawa pink)
  --  string         │ springGreen        │ #98BB6C  (gruvbox green)
  --  number         │ sakuraPink         │ #D27E99
  --  operator       │ springViolet2      │ #9CABCA
  --  parameter      │ springBlue         │ #7FB4CA
  --  member field   │ springBlue         │ #7FB4CA  (same hue, differentiated by context)
  --  builtin        │ waveAqua1          │ #6A9589  (muted teal for stdlib)
  --  special/escape │ surimiOrange       │ #FFA066

  oniViolet    = "#957FB8",
  carpYellow   = "#E6C384",
  boatYellow2  = "#C0A36E",
  waveAqua2    = "#7AA89F",
  waveAqua1    = "#6A9589",
  crystalBlue  = "#7E9CD8",
  springBlue   = "#7FB4CA",
  springViolet1= "#938AA9",
  springViolet2= "#9CABCA",
  surimiOrange = "#FFA066",
  sakuraPink   = "#D27E99",
  waveRed      = "#E46876",
  peachRed     = "#FF5D62",
  springGreen  = "#98BB6C",
  dragonBlue   = "#658594",
  fujiWhite    = "#DCD7BA",
  oldWhite     = "#C8C093",
  fujiGray     = "#727169",
}

function M.get(opts)
  local bg = opts.contrast == "hard" and base.sumiInk0
          or opts.contrast == "soft" and base.sumiInk2
          or base.sumiInk1

  return {
    raw = base,  -- expose raw palette for custom overrides

    -- Backgrounds
    bg          = bg,
    bg_dim      = base.sumiInk2,
    bg_gutter   = base.sumiInk3,
    bg_subtle   = base.sumiInk4,
    bg_visual   = base.waveBlue1,
    bg_search   = base.waveBlue2,
    bg_pmenu    = base.sumiInk2,
    bg_float    = base.sumiInk2,

    -- Diff
    diff_add    = base.winterGreen,
    diff_change = base.winterBlue,
    diff_delete = base.winterRed,
    diff_text   = base.winterYellow,

    -- Diagnostics
    error       = base.samuraiRed,
    warning     = base.roninYellow,
    info        = base.dragonBlue,
    hint        = base.waveAqua1,

    -- Foregrounds
    fg          = base.fujiWhite,
    fg_dim      = base.oldWhite,
    fg_subtle   = base.fujiGray,
    nontext     = base.sumiInk4,
    comment     = base.fujiGray,

    -- Semantic roles (Gruvbox-inspired granularity, Kanagawa colors)
    keyword     = base.oniViolet,     -- if / for / while / return / class
    type        = base.carpYellow,    -- types, classes, structs, typedefs
    func        = base.waveAqua2,     -- functions and methods
    namespace   = base.crystalBlue,   -- namespaces, modules
    macro       = base.waveRed,       -- macros, preprocessor directives (#include, #pragma, #define)
    constant    = base.sakuraPink,    -- constants, enum members
    string_     = base.springGreen,   -- string literals (trailing _ avoids Lua keyword)
    number      = base.sakuraPink,    -- numeric literals
    operator    = base.springViolet2, -- operators (+ - * :: -> etc.)
    parameter   = base.surimiOrange,  -- function parameters (orangish)
    variable    = base.fujiWhite,     -- local/global variables
    member      = base.boatYellow2,   -- struct/class field access (yellowish, darker than type)
    builtin     = base.waveAqua1,     -- stdlib / built-in types and functions
    special     = base.surimiOrange,  -- escape sequences, special chars
    error_fg    = base.waveRed,       -- inline error foreground

    -- C++ keyword roles — all map to oniViolet (purple) to match Kanagawa's aesthetic.
    -- Treesitter overrides requires/template individually; legacy cppXxx groups
    -- handle static_assert/nullptr (cppStatement → carpYellow) which treesitter misses.
    --
    --  legacy group     │ color               │ covers
    -- ──────────────────┼─────────────────────┼──────────────────────────────
    --  cppStructure     │ oniViolet (purple)   │ template, typename
    --  cppStatement     │ carpYellow (yellow)  │ static_assert, nullptr, this, new, delete
    --  cppStorageClass  │ oniViolet (purple)   │ constexpr, consteval, static, extern, inline
    --  cppModifier      │ oniViolet (purple)   │ explicit, virtual, override, final
    cpp_structure = base.oniViolet,   -- template, typename → purple
    cpp_statement = base.carpYellow,  -- static_assert, nullptr → yellowish (treesitter doesn't capture these)
    cpp_storage   = base.oniViolet,   -- constexpr, consteval, static, extern → purple
    cpp_modifier  = base.oniViolet,   -- explicit, virtual, override, final → purple

    -- UI
    border      = base.sumiInk4,
    cursor      = base.oldWhite,
    selection   = base.waveBlue1,
    match       = base.waveBlue2,
    line_nr     = base.fujiGray,
    cur_line    = base.sumiInk2,

    -- Git signs
    git_add     = base.autumnGreen,
    git_change  = base.autumnYellow,
    git_delete  = base.autumnRed,

    opts = opts,
  }
end

return M
