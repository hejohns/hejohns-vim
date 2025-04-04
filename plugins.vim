" NOTE: THIS SHOULD ONLY EVER BE SOURCED EXACTLY ONCE
" between plug#begin and plug#end in vimrc
" (see https://github.com/hejohns/.rc/blob/master/rc/vimrc)
if exists('g:hejohns#plugins_sourced')
    echoerr '[hejohns-vim][error] plugins.vim was sourced multiple times?!'
endif
let g:hejohns#plugins_sourced = 1

"Plug 'https://github.com/xavierd/clang_complete.git', {'for': []}
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
Plug 'Shougo/deoplete.nvim', executable('deno') ? {'for': []} : (has('nvim') ? {'do': ':UpdateRemotePlugins'} : {})
Plug 'roxma/nvim-yarp', executable('deno') ? {'for': []} : (has('nvim') ? {'for': []} : {})
Plug 'roxma/vim-hug-neovim-rpc', executable('deno') ? {'for': []} : (has('nvim') ? {'for': []} : {})
if !has('nvim')
    " the path to python3 is obtained through executing `:echo exepath('python3')` in vim
    let g:python3_host_prog = exepath('python3')
endif
let g:deoplete#enable_at_startup = 1
Plug 'lervag/vimtex', {'for': 'tex'}
Plug 'JuliaEditorSupport/julia-vim' " we need this for the L2U commands
Plug 'https://github.com/tpope/vim-fugitive'
Plug 'jordwalke/vim-reasonml', {'for': 'reason'}
Plug 'scrooloose/syntastic', {'for': ['vim', 'pod']}
Plug 'osyo-manga/vim-over'
Plug 'alx741/vim-hindent', {'for': 'haskell'}
Plug 'tpope/vim-surround'
Plug 'rust-lang/rust.vim', {'for': 'rust'}
Plug 'mhinz/vim-signify', has('nvim') || has('patch-8.0.902') : {} ? {'tag': 'legacy'}
Plug 'LnL7/vim-nix', {'for': 'nix'}
Plug 'mbbill/undotree'
Plug 'tpope/vim-dispatch', {'for': ['tex', 'ocaml', 'c', 'cpp']} " NOTE: but we may want for more langs later
Plug 'vim-utils/vim-man', has('nvim') : {'for': []} ? {} " replaces ``builtin'' :Man ?
" I had performance problems with airline
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-repeat'
Plug 'mileszs/ack.vim'
Plug 'chrisbra/unicode.vim'
Plug 'itchyny/calendar.vim'
Plug 'tpope/vim-characterize'
Plug 'https://github.com/kshenoy/vim-signature'
" these plugins don't seem to support {'for': ['markdown', 'vimwiki']}
" -- they misbehave
"Plug 'vimwiki/vimwiki'
"Plug 'michal-h21/vim-zettel'
"Plug 'michal-h21/vimwiki-sync'
Plug 'altercation/vim-colors-solarized'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'lambdalisue/nerdfont.vim'
Plug 'Shougo/neco-vim', {'for': ['vim']} " denops and deoplete source
Plug 'Shougo/neco-syntax', executable('deno') ? {'for': []} : {} " deoplete source
Plug 'deoplete-plugins/deoplete-jedi', executable('deno') ? {'for': []} : {} " deoplete source
Plug 'deoplete-plugins/deoplete-dictionary', executable('deno') ? {'for': []} : {} " deoplete source
"Plug 'whonore/Coqtail', {'for': ['coq']}
Plug 'https://github.com/pangloss/vim-javascript', {'for': ['javascript']}
Plug 'vim-denops/denops.vim', executable('deno') ? {} : {'for': []}
Plug 'vim-denops/denops-shared-server.vim', executable('deno') ? {} : {'for': []}
Plug 'hejohns/denops-vim-plug-update.vim', executable('deno') ? {} : {'for': []}
Plug 'https://github.com/Shougo/ddc.vim', executable('deno') ? {} : {'for': []}
