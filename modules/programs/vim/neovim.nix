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
      blink-cmp

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

      # Trailing whitespace
      mini-nvim

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

      set guifont=Liberation\ Mono:h12
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
      let g:neovide_position_animation_length = 0
    '';
    initLua = ''
      -- Window title: show cwd basename (useful in i3 tabbed mode)
      vim.o.title = true
      vim.api.nvim_create_autocmd({ 'VimEnter', 'DirChanged' }, {
        callback = function()
          vim.o.titlestring = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
        end,
      })

      -- Colorscheme
      require('kanagruvbox').setup({ theme = "wave" })
      vim.cmd('colorscheme kanagruvbox')

      -- Treesitter (v1 API)
      require('nvim-treesitter').setup()

      -- nvim-tree (replaces NERDTree) with NERDTree-compatible bindings
      require('nvim-tree').setup {
        on_attach = function(bufnr)
          local api = require('nvim-tree.api')
          local opts = function(desc)
            return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end

          -- Default bindings as base
          api.config.mappings.default_on_attach(bufnr)

          -- NERDTree-compatible overrides
          vim.keymap.set('n', 'i',     api.node.open.horizontal,       opts('Open: Horizontal Split'))
          vim.keymap.set('n', 's',     api.node.open.vertical,         opts('Open: Vertical Split'))
          vim.keymap.set('n', 't',     api.node.open.tab,              opts('Open: New Tab'))
          vim.keymap.set('n', 'x',     api.node.navigate.parent_close, opts('Close Directory'))
          vim.keymap.set('n', 'X',     api.tree.collapse_all,          opts('Collapse All'))
          vim.keymap.set('n', 'I',     api.tree.toggle_hidden_filter,  opts('Toggle Hidden Files'))
          vim.keymap.set('n', 'C',     api.tree.change_root_to_node,   opts('CD into Directory'))

          -- Remove conflicting defaults that were remapped above
          vim.keymap.del('n', '<C-x>', { buffer = bufnr })
          vim.keymap.del('n', '<C-v>', { buffer = bufnr })
          vim.keymap.del('n', '<C-t>', { buffer = bufnr })
          vim.keymap.del('n', 'W',     { buffer = bufnr })
          vim.keymap.del('n', 'H',     { buffer = bufnr })
        end,
      }
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
      local function live_grep_git_root(opts)
        local git_root = vim.trim(vim.fn.system('git rev-parse --show-toplevel'))
        opts = vim.tbl_extend('force', opts or {},
          vim.v.shell_error == 0 and { cwd = git_root } or {}
        )
        builtin.live_grep(opts)
      end
      vim.keymap.set('n', '<C-p>', builtin.git_files, { noremap = true, silent = true })
      vim.keymap.set('n', '<C-f>', builtin.find_files, { noremap = true, silent = true })
      vim.keymap.set('n', '<C-F>f', live_grep_git_root, { noremap = true, silent = true })
      vim.keymap.set('v', '<C-F>f', function()
        vim.cmd('noau normal! "vy"')
        local selected = vim.fn.getreg('v')
        live_grep_git_root({ default_text = selected })
      end, { noremap = true, silent = true })
      vim.keymap.set('n', '<C-F>o', builtin.resume, { noremap = true, silent = true })

      -- indent-blankline (replaces indentLine)
      require('ibl').setup {}

      -- nvim-autopairs (replaces auto-pairs)
      -- map_cr = false: let blink.cmp own <CR> for accepting completions
      require('nvim-autopairs').setup { map_cr = false }

      -- trailing whitespace highlight
      require('mini.trailspace').setup()
      vim.api.nvim_set_hl(0, 'MiniTrailspace', { bg = '#cc241d' })

      -- Comment.nvim (replaces nerdcommenter)
      require('Comment').setup {}

      -- aerial (replaces tagbar, LSP-based)
      require('aerial').setup {}
      vim.keymap.set('n', '<F12>', ':AerialToggle<CR>', { noremap = true, silent = true })

      -- LSP (nvim 0.11 API)
      vim.lsp.config('*', {
        capabilities = require('blink.cmp').get_lsp_capabilities(),
      })
      vim.lsp.enable({ 'clangd', 'rust_analyzer', 'pyright', 'cmake' })

      -- Set diagnostic configuration to control float display
      vim.diagnostic.config({
        update_in_insert = true,
        float = {
          source = 'if_many',    -- Display source if there are many sources
          border = 'rounded',    -- Border style (can be 'none', 'single', 'double', 'rounded', etc.)
          max_width = 120,       -- Maximum width of the float (can also control text wrapping here)
          max_height = 60,       -- Maximum height (control the number of lines shown)
        },
      })

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

      -- blink.cmp
      require('blink.cmp').setup({
        keymap = {
          preset = 'default',
          ['<Tab>']   = { 'select_next', 'fallback' },
          ['<S-Tab>'] = { 'select_prev', 'fallback' },
          ['<CR>']    = { 'select_and_accept', 'fallback' },
          ['<C-Space>'] = { 'show', 'fallback' },
        },
        completion = {
          list = { selection = { preselect = true, auto_insert = false } },
        },
        sources = { default = { 'lsp', 'snippets', 'buffer', 'path' } },
        signature = {
          enabled = true,
          window = { border = 'rounded' },
        },
      })

      ${if enableClionColors then clionColors else ""}
    '';
  };

  programs.neovim.extraPackages = [
    pkgs.clang-tools
    pkgs.rust-analyzer
    pkgs.pyright
    pkgs.cmake-language-server
  ];

  home.packages = [
    pkgs.neovide
    pkgs.xclip
  ];

  xdg.configFile."neovide/config.toml".text = ''
    [font]
    normal = [{ family = "Liberation Mono" }]
    size = 12.0
  '';

  programs.zsh.shellAliases = {
    gvim = "${pkgs.neovide}/bin/neovide --fork";
  };
}
