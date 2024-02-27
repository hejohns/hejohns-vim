" NOTE: THIS SHOULD ONLY EVER BE SOURCED EXACTLY ONCE
" between plug#begin and plug#end in vimrc
" (see https://github.com/hejohns/.rc/blob/master/rc/vimrc)

Plug 'https://github.com/xavierd/clang_complete.git', {'for': ['c', 'cpp']}
Plug 'vim-perl/vim-perl', { 'for': 'perl', 'do': 'make clean carp dancer highlight-all-pragmas moose test-more try-tiny' }
Plug 'davidhalter/jedi-vim', {'for': 'python'}
Plug 'autozimu/LanguageClient-neovim', {
    \ 'for': g:myLSLangs,
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'junegunn/fzf', {'do': {-> fzf#install()}}
Plug 'junegunn/fzf.vim'
" handle both neovim and vim 8 with python
" https://github.com/junegunn/vim-plug/wiki/tips#conditional-activation
Plug 'Shougo/deoplete.nvim', has('nvim') ? {'do': ':UpdateRemotePlugins'} : {}
Plug 'roxma/nvim-yarp', has('nvim') ? {'for': []} : {}
Plug 'roxma/vim-hug-neovim-rpc', has('nvim') ? {'for': []} : {}
if !has('nvim')
    " the path to python3 is obtained through executing `:echo exepath('python3')` in vim
    let g:python3_host_prog = exepath('python3')
    let g:deoplete#enable_at_startup = 1
endif
Plug 'lervag/vimtex', {'for': 'tex'}
"Plug 'maxboisvert/vim-simple-complete'
Plug 'JuliaEditorSupport/julia-vim'
Plug 'https://github.com/tpope/vim-fugitive'
Plug 'jordwalke/vim-reasonml', {'for': 'reason'}
Plug 'scrooloose/syntastic'
Plug 'osyo-manga/vim-over'
Plug 'alx741/vim-hindent', {'for': 'haskell'}
Plug 'tpope/vim-surround'
Plug 'rust-lang/rust.vim', {'for': 'rust'}
" requires >= 8.0.902
Plug 'mhinz/vim-signify'
Plug 'LnL7/vim-nix', {'for': 'nix'}
Plug 'mbbill/undotree'
Plug 'tpope/vim-dispatch', {'for': ['tex', 'ocaml', 'c', 'cpp']} " NOTE: but we may want for more langs later
if !has('nvim')
    Plug 'vim-utils/vim-man' " replaces ``builtin'' :Man ?
endif
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-repeat'
Plug 'mileszs/ack.vim'
Plug 'chrisbra/unicode.vim'
Plug 'itchyny/calendar.vim'
Plug 'tpope/vim-characterize'
Plug 'https://github.com/kshenoy/vim-signature'
" these plugins don't seem to support {'for': ['markdown', 'vimwiki']}
" they misbehave
Plug 'vimwiki/vimwiki'
Plug 'michal-h21/vim-zettel'
Plug 'michal-h21/vimwiki-sync'
Plug 'altercation/vim-colors-solarized'
