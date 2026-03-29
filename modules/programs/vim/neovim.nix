{ config, pkgs, ... }:
let
  clionColors = import ./clion-colors.nix;
  enableClionColors = false;
  kanagruvbox = pkgs.vimUtils.buildVimPlugin {
    name = "kanagruvbox-nvim";
    src = ./plugins/kanagruvbox.nvim;
  };
  vimFswitch = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "vim-fswitch";
    src = pkgs.fetchFromGitHub {
      owner = "derekwyatt";
      repo = "vim-fswitch";
      rev = "94acdd8bc92458d3bf7e6557df8d93b533564491";
      hash = "sha256-LMNptjApgqBd7RMyKEWG/bQ2ahtglKr5Rf3LuDge044=";
    };
  };
in {
  programs.neovim = {
    vimAlias = true;
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      # Colorschemes
      kanagruvbox
      vim-code-dark
      catppuccin-nvim
      tokyonight-nvim
      kanagawa-nvim
      onedark-nvim
      rose-pine
      nightfox-nvim
      gruvbox-nvim
      nordic-nvim
      edge
      sonokai

      # Treesitter
      nvim-treesitter
      nvim-treesitter-parsers.cpp
      nvim-treesitter-parsers.c
      nvim-treesitter-parsers.python
      nvim-treesitter-parsers.nix
      nvim-treesitter-parsers.toml
      nvim-treesitter-parsers.lua
      nvim-treesitter-parsers.rust
      nvim-treesitter-parsers.cmake

      # LSP / completion
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      cmp_luasnip

      # File explorer
      nvim-tree-lua
      nvim-web-devicons

      # Statusline
      lualine-nvim

      # Fuzzy finder
      plenary-nvim
      telescope-nvim
      telescope-fzf-native-nvim

      # Indent guides
      indent-blankline-nvim

      # Autopairs
      nvim-autopairs

      # Comments
      comment-nvim

      # Symbols outline (replaces tagbar)
      aerial-nvim

      # Git
      vim-fugitive

      # Alignment
      vim-easy-align

      # Move lines
      vim-move

      # Multi-cursor (successor to vim-multiple-cursors)
      vim-visual-multi

      # Text objects
      vim-indent-object

      # QML syntax (no treesitter grammar yet)
      vim-qml

      # Markdown TOC
      vim-markdown-toc

      # C++ header/source switching
      vimFswitch
    ];
    extraConfig = ''
      set autoindent
      set smartindent
      set smarttab
      set expandtab

      set shiftwidth=2
      set ts=2
      set softtabstop=2
      set textwidth=80

      au BufRead,BufNewFile *.py set tabstop=4 softtabstop=4 shiftwidth=4
      au BufRead,BufNewFile *.html set tabstop=4 softtabstop=4 shiftwidth=4
      au BufRead,BufNewFile *.qml set tabstop=4 softtabstop=4 shiftwidth=4

      set number
      syn on

      set noeb
      set encoding=utf-8

      filetype plugin indent on

      set noswapfile
      set nobackup
      set nowritebackup
      set updatetime=300
      set signcolumn=yes

      set shortmess+=tToOI

      set guifont=Liberation\ Mono:h16
      set guicursor+=n-v-c:blinkon0
      set guioptions-=r
      set guioptions-=R
      set guioptions-=b
      set guioptions-=l
      set guioptions-=L
      set guioptions-=T
      set guioptions-=m

      set ignorecase
      set smartcase
      set incsearch
      set hls
      map <F1> :nohl<CR>
      imap <F1> <ESC>:nohl<CR>

      " colorscheme set in initLua (gruvbox)

      set completeopt=menuone,noselect

      set clipboard=unnamedplus
      set iminsert=0

      highlight ExtraWhitespace ctermbg=red guibg=red
      match ExtraWhitespace /\s\+$/
      autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
      autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
      autocmd InsertLeave * match ExtraWhitespace /\s\+$/
      autocmd BufWinLeave * call clearmatches()

      imap <S-Tab> <Esc> :tabNext <CR>
      map <S-Tab> :tabNext <CR>
      imap <C-Tab> <Esc> :tabnext <CR>
      map <C-Tab> :tabnext <CR>
      map <C-S-PAGEUP> :tabmove -1 <CR>
      map <C-S-PAGEDOWN> :tabmove +1 <CR>

      map <F2> :wa<CR>
      imap <F2> <ESC>:wa<CR>

      vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

      let g:move_key_modifier = 'C'

      xmap ga <Plug>(EasyAlign)
      nmap ga <Plug>(EasyAlign)

      augroup mycppfiles
        au!
        au BufEnter *.h let b:fswitchdst  = 'cpp,cc,C'
        au BufEnter *.h let b:fswitchlocs = 'reg:/include/src/,reg:/include.*/src/'
      augroup END

      " Neovide
      let g:neovide_cursor_animation_length = 0
      let g:neovide_cursor_trail_size = 0
      let g:neovide_scroll_animation_length = 0
    '';
    initLua = ''
      -- Colorscheme
      require('kanagruvbox').setup({
        theme = "wave",
        overrides = function(colors)
          local p = colors.palette
          return {
            -- C++ keyword differentiation (Gruvbox-style granularity, Kanagawa colors)
            cppStructure    = { fg = p.springBlue },    -- template, typename   #7FB4CA
            cppStatement    = { fg = p.peachRed },      -- requires             #FF5D62
            cppStorageClass = { fg = p.autumnYellow },  -- constexpr, static…   #DCA561
            cppModifier     = { fg = p.boatYellow2 },   -- explicit, virtual…   #C0A36E
          }
        end,
      })
      vim.cmd('colorscheme kanagruvbox')

      -- Treesitter (v1 API)
      require('nvim-treesitter').setup()

      -- nvim-tree (replaces NERDTree)
      require('nvim-tree').setup {}
      vim.keymap.set('n', '<F11>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

      -- lualine (replaces vim-airline)
      require('lualine').setup {
        options = { powerline_fonts = true },
        extensions = { 'aerial', 'nvim-tree', 'fugitive' },
      }

      -- Telescope (replaces fzf-vim + ctrlsf)
      require('telescope').setup {}
      require('telescope').load_extension('fzf')
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<C-p>', builtin.git_files, { noremap = true, silent = true })
      vim.keymap.set('n', '<C-f>', builtin.find_files, { noremap = true, silent = true })
      vim.keymap.set('n', '<C-F>f', builtin.live_grep, { noremap = true, silent = true })
      vim.keymap.set('n', '<C-F>o', builtin.resume, { noremap = true, silent = true })

      -- indent-blankline (replaces indentLine)
      require('ibl').setup {}

      -- nvim-autopairs (replaces auto-pairs)
      require('nvim-autopairs').setup {}

      -- Comment.nvim (replaces nerdcommenter)
      require('Comment').setup {}

      -- aerial (replaces tagbar, LSP-based)
      require('aerial').setup {}
      vim.keymap.set('n', '<F12>', ':AerialToggle<CR>', { noremap = true, silent = true })

      -- LSP (nvim 0.11 API)
      vim.lsp.config('*', {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      })
      vim.lsp.enable({ 'clangd', 'rust_analyzer', 'pyright' })

      -- Show diagnostic float automatically when cursor rests on an error
      vim.api.nvim_create_autocmd('CursorHold', {
        callback = function()
          vim.diagnostic.open_float(nil, { focus = false, scope = 'cursor' })
        end,
      })

      vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, { silent = true })
      vim.keymap.set('n', ']g', vim.diagnostic.goto_next, { silent = true })
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { silent = true })
      vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, { silent = true })
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { silent = true })
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, { silent = true })
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { silent = true })
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { silent = true })
      vim.keymap.set('n', '<leader>ac', vim.lsp.buf.code_action, { silent = true })
      vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, { silent = true })
      vim.keymap.set('n', '<space>a', vim.diagnostic.setloclist, { silent = true })

      -- nvim-cmp (replaces coc completion)
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      cmp.setup {
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { 'i', 's' }),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<C-Space>'] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources(
          { { name = 'nvim_lsp' }, { name = 'luasnip' } },
          { { name = 'buffer' }, { name = 'path' } }
        ),
      }

      -- autopairs + cmp integration
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

      ${if enableClionColors then clionColors else ""}
    '';
  };

  programs.neovim.extraPackages = [
    pkgs.clang-tools
    pkgs.rust-analyzer
    pkgs.pyright
  ];

  home.packages = [
    pkgs.neovide
  ];

  programs.zsh.shellAliases = {
    gvim = "${pkgs.neovide}/bin/neovide";
  };
}
