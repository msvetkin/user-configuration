{ pkgs, ... }:

let
  plugins = {
    ctrlsf = pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "ctrlsf";
      src = pkgs.fetchFromGitHub {
        owner = "dyng";
        repo = "ctrlsf.vim";
        rev = "32236a8b376d9311dec9b5fe795ca99d32060b13";
        hash = "sha256-td8eE5t1t5xBAxYq19U5fQXMXS1ZIxAzl2Q6nsIRR6Q=";
      };
      extraConfig = ''
        let g:ctrlsf_search_mode = 'async'
        let g:ctrlsf_default_view_mode = 'compact'
        let g:ctrlsf_auto_focus = {
              \ "at": "done",
              \ "duration_less_than": 1000
              \ }
        nmap     <C-F>f <Plug>CtrlSFPrompt
        vmap     <C-F>f <Plug>CtrlSFVwordPath
        vmap     <C-F>F <Plug>CtrlSFVwordExec
        nmap     <C-F>n <Plug>CtrlSFCwordPath
        nmap     <C-F>p <Plug>CtrlSFPwordPath
        nnoremap <C-F>o :CtrlSFOpen<CR>
        nnoremap <C-F>t :CtrlSFToggle<CR>
        inoremap <C-F>t <Esc>:CtrlSFToggle<CR>
      '';
    };
    vim-fswitch = pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "vim-fswitch";
      src = pkgs.fetchFromGitHub {
        owner = "derekwyatt";
        repo = "vim-fswitch";
        rev = "94acdd8bc92458d3bf7e6557df8d93b533564491";
        hash = "sha256-LMNptjApgqBd7RMyKEWG/bQ2ahtglKr5Rf3LuDge044=";
      };
      extraConfig = ''
        augroup mycppfiles
          au!
          au BufEnter *.h let b:fswitchdst  = 'cpp,cc,C'
          au BufEnter *.h let b:fswitchlocs = 'reg:/include/src/,reg:/include.*/src/'
        augroup END
      '';
    };
  };

  pluginsExtraConfig = builtins.concatStringsSep "\n" (
    builtins.map (item: item.extraConfig) (builtins.attrValues plugins)
  );
in
{
  enable = true;
  defaultEditor = true;
  plugins = [
     pkgs.vimPlugins.molokai
     pkgs.vimPlugins.vim-code-dark
     pkgs.vimPlugins.nerdtree
     pkgs.vimPlugins.nerdcommenter
     pkgs.vimPlugins.vim-nerdtree-tabs
     pkgs.vimPlugins.vim-airline
     pkgs.vimPlugins.vim-airline-themes
     pkgs.vimPlugins.vim-easy-align
     pkgs.vimPlugins.fzf-vim
     pkgs.vimPlugins.vim-indent-object
     pkgs.vimPlugins.vim-multiple-cursors
     pkgs.vimPlugins.python-mode
     #pkgs.vimPlugins.supertab
     pkgs.vimPlugins.tagbar
     #pkgs.vimPlugins.cocoa.vim
     # pkgs.vimPlugins.YouCompleteMe
     pkgs.vimPlugins.vim-qml
     pkgs.vimPlugins.vim-fugitive
     pkgs.vimPlugins.vim-move
     pkgs.vimPlugins.auto-pairs
     pkgs.vimPlugins.wildfire-vim
     pkgs.vimPlugins.indentLine
     pkgs.vimPlugins.ale
     pkgs.vimPlugins.vim-toml
     pkgs.vimPlugins.vim-nix
     pkgs.vimPlugins.vim-markdown-toc
  ] ++ builtins.attrValues plugins;
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

    set nocompatible
    set number
    syn on

    set noeb
    set t_Co=256
    set encoding=utf-8

    filetype plugin indent on

    set noswapfile
    set nobackup

    set shortmess+=tToOI

    set guifont=Liberation\ Mono:h16
    "set guifont=Liberation\ Mono\ 12
    set guicursor+=n-v-c:blinkon0
    "set guioptions+=e
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

    let g:molokai_original = 1
    let g:rehash256 = 1
    colorscheme codedark

    au InsertLeave * if pumvisible() == 0|silent! pclose|endif
    set completeopt=menuone,menu,longest

    set clipboard=unnamedplus
    set iminsert=0

    "set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯЖ;ABCDEFGHIJKLMNOPQRSTUVWXYZ:,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz

    highlight ExtraWhitespace ctermbg=red guibg=red
    match ExtraWhitespace /\s\+$/
    autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
    autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    autocmd InsertLeave * match ExtraWhitespace /\s\+$/
    autocmd BufWinLeave * call clearmatches()

    "function! s:insert_gates()
    "  let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
    "  execute "normal! i#ifndef " . gatename
    "  execute "normal! o#define " . gatename . " "
    "  execute "normal! Go#endif /* " . gatename . " */"
    "  normal! kk
    "endfunction
    "autocmd BufNewFile *.{h,hpp} call <SID>insert_gates()

    imap <S-Tab> <Esc> :tabNext <CR>
    map <S-Tab> :tabNext <CR>
    imap <C-Tab> <Esc> :tabnext <CR>
    map <C-Tab> :tabnext <CR>
    map <C-S-PAGEUP> :tabmove -1 <CR>
    map <C-S-PAGEDOWN> :tabmove +1 <CR>

    map <F2> :wa<CR>
    imap <F2> <ESC>:wa<CR>

    vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>


    map <F12> :TagbarToggle<CR>

    let g:ycm_clangd_uses_ycmd_caching = 0
    let g:ycm_clangd_binary_path = exepath("clangd")
    let g:ycm_goto_buffer_command = 'split'
    let g:ycm_show_diagnostics_ui = 0
    let g:ycm_enable_diagnostic_signs = 0
    let g:ycm_enable_diagnostic_highlighting = 0
    let g:ycm_max_num_candidates = 50
    let g:ycm_auto_trigger = 0

    set laststatus=2
    let g:airline_powerline_fonts = 1
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#show_splits = 0
    let g:airline#extensions#tabline#show_buffers = 0
    let g:airline#extensions#ale#enabled = 1
    let g:airline_theme='kolor'

    let Tlist_Auto_Open=0
    let Tlist_Use_Right_Window=1

    map <F11> :NERDTreeTabsToggle<CR>
    let NERDTreeIgnore = ['\.pyc$']
    let g:NERDTreeDirArrows=0
    let g:nerdtree_tabs_open_on_gui_startup=0
    let g:nerdtree_tabs_open_on_new_tab=0
    let g:nerdtree_tabs_autoclose=0

    let g:NERDSpaceDelims = 1
    let g:NERDAltDelims_c=1
    let g:NERDTrimTrailingWhitespace = 1
    let g:NERDCustomDelimiters = { 'pro': { 'left': '#' } }

    "let g:SuperTabDefaultCompletionType = "context"
    "let g:SuperTabContextDefaultCompletionType = "<c-n>"

    let g:UltiSnipsExpandTrigger = "<c-tab>"
    let g:UltiSnipsListSnippets = '<c-CR>'
    let g:UltiSnipsJumpForwardTrigger = "<c-tab>"
    let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

    let g:alternateRelativeFiles = 1
    let g:alternativeAlwaysCreateBuffer = 1

    map <SPACE> <Plug>(wildfire-fuel)
    vmap <C-SPACE> <Plug>(wildfire-water)

    let g:indentLine_char_list = ['|', '¦', '┆', '┊']

    xmap ga <Plug>(EasyAlign)
    nmap ga <Plug>(EasyAlign)

    let g:move_key_modifier = 'C'

    let g:AutoPairsShortcutFastWrap = '<C-e>'

    let g:pymode_rope = 0
    let g:pymode_python = 'python3'
    let g:pymode_doc = 0
    let g:pymode_doc_key = 'K'
    let g:pymode_lint = 1
    let g:pymode_lint_checkers = []
    let g:pymode_lint_cwindow = 1
    let g:pymode_lint_ignore="E501,W601,C0110,C0111"
    let g:pymode_lint_write = 0
    let g:pymode_virtualenv = 1
    let g:pymode_breakpoint = 1
    let g:pymode_breakpoint_key = '<leader>b'
    let g:pymode_syntax = 1
    let g:pymode_syntax_all = 1
    let g:pymode_syntax_indent_errors = g:pymode_syntax_all
    let g:pymode_syntax_space_errors = g:pymode_syntax_all
    let g:pymode_folding = 0
    let g:pymode_run = 0
    let g:pymode_options_colorcolumn = 0

    let g:ale_lint_on_insert_leave = 0
    let g:ale_linters_ignore = {'cpp': ['flawfinder', 'ccls', 'clang++']}

    let g:ctrlp_key_loop=1
    let g:ctrlp_max_files=2000000

    nnoremap <silent> <C-p> :GFiles<CR>
    nnoremap <silent> <C-f> :Files<CR>
  '' + pluginsExtraConfig;
}
