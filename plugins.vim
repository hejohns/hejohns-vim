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
" NOTE: 2025-04-07: ddc-source-lsp requires us to use vim-lsp instead
"Plug 'autozimu/LanguageClient-neovim', {
"    \ 'for': g:myLSLangs,
"    \ 'branch': 'next',
"    \ 'do': 'bash install.sh',
"    \ }
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
" for some reason, || doesn't work in the ternary (but && does)
let g:hejohns#vim_signify_pre = has('nvim') || has('patch-8.0.902')
Plug 'mhinz/vim-signify', g:hejohns#vim_signify_pre ? {} : {'tag': 'legacy'}
Plug 'LnL7/vim-nix', {'for': 'nix'}
Plug 'mbbill/undotree'
Plug 'tpope/vim-dispatch', {'for': ['tex', 'ocaml', 'c', 'cpp']} " NOTE: but we may want for more langs later
Plug 'vim-utils/vim-man', has('nvim') ? {'for': []} : {} " replaces ``builtin'' :Man ?
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
Plug 'https://github.com/Shougo/ddc-source-around', executable('deno') ? {} : {'for': []} " ddc source
Plug 'https://github.com/Shougo/ddc-source-line', executable('deno') ? {} : {'for': []} " ddc source
Plug 'https://github.com/LumaKernel/ddc-source-file', executable('deno') ? {} : {'for': []} " ddc source
Plug 'https://github.com/Shougo/ddc-source-cmdline', executable('deno') ? {} : {'for': []} " ddc source
Plug 'https://github.com/Shougo/ddc-source-cmdline_history', executable('deno') ? {} : {'for': []} " ddc source
Plug 'https://github.com/Shougo/ddc-source-input', executable('deno') ? {} : {'for': []} " ddc source
Plug 'https://github.com/Shougo/ddc-source-omni', executable('deno') ? {'for': []} : {'for': []} " ddc source
Plug 'https://github.com/matsui54/ddc-source-dictionary', executable('deno') ? {} : {'for': []} " ddc source
Plug 'https://github.com/Shougo/ddc-source-lsp', executable('deno') ? {} : {'for': []} " ddc source
Plug 'https://github.com/matsui54/ddc-source-buffer', executable('deno') ? {} : {'for': []} " ddc source
Plug 'https://github.com/Shougo/ddc-source-shell', executable('deno') ? {} : {'for': []} " ddc source
Plug 'https://github.com/Shougo/ddc-source-vim', executable('deno') ? {} : {'for': []} " ddc source
Plug 'https://github.com/Shougo/pum.vim', executable('deno') ? {} : {'for': []} " required by ddc-ui-pum
Plug 'https://github.com/Shougo/ddc-ui-pum', executable('deno') ? {} : {'for': []} " apparently required by a lot of ddc
Plug 'https://github.com/tani/ddc-fuzzy', executable('deno') ? {} : {'for': []} " ddc filter
Plug 'https://github.com/matsui54/denops-popup-preview.vim', executable('deno') ? #{} : {'for': []} " TODO: 2025-09-03: This might've been fixed upstream?
Plug 'https://github.com/prabirshrestha/vim-lsp'
Plug 'https://github.com/mattn/vim-lsp-settings'
Plug 'https://github.com/rhysd/vim-healthcheck' " vim-lsp supports vim-healthcheck, which hopefully makes it easier to debug lsp configuration issues (I didn't love this about LanguageClient)
Plug 'https://github.com/lambdalisue/vim-guise', executable('deno') ? {} : {'for': []}
Plug 'https://github.com/Shougo/ddt.vim', executable('deno') ? {} : {'for': []}
Plug 'https://github.com/Shougo/ddt-ui-shell', executable('deno') ? {} : {'for': []} " ddt ui
Plug 'https://github.com/Shougo/ddt-ui-terminal/', executable('deno') ? {} : {'for': []} " ddt ui
Plug 'https://github.com/markonm/traces.vim.git'
Plug 'https://github.com/Shougo/ddu.vim', executable('deno') ? {} : #{for: []}
Plug 'https://github.com/Shougo/ddu-ui-ff', executable('deno') ? {} : #{for: []} " ddu ui
Plug 'https://github.com/Shougo/ddu-ui-filer', executable('deno') ? {} : #{for: []} " ddu ui
Plug 'https://github.com/Shougo/ddu-kind-file', executable('deno') ? {} : #{for: []} " ddu kind
Plug 'https://github.com/Shougo/ddu-kind-word', executable('deno') ? {} : #{for: []} " ddu kind
Plug 'https://github.com/Shougo/ddu-filter-matcher_substring', executable('deno') ? {} : #{for: []} " ddu filter
Plug 'https://github.com/Shougo/ddu-source-action', executable('deno') ? {} : #{for: []} " ddu source
Plug 'https://github.com/Shougo/ddu-source-file', executable('deno') ? {} : #{for: []} " ddu source
Plug 'https://github.com/Shougo/ddu-source-file_rec', executable('deno') ? {} : #{for: []} " ddu source
" bundles ddu kind lsp and lsp_codeAction (why not split it off??)
Plug 'https://github.com/uga-rosa/ddu-source-lsp', executable('deno') ? {} : #{for: []} " ddu source
Plug 'https://github.com/shun/ddu-source-buffer', executable('deno') ? {} : #{for: []} " ddu source
Plug 'https://github.com/shun/ddu-source-rg', executable('deno') ? {} : #{for: []} " ddu source
Plug 'https://github.com/matsui54/ddu-source-help', executable('deno') ? {} : #{for: []} " ddu source
Plug 'https://github.com/Shougo/ddu-source-line', executable('deno') ? {} : #{for: []} " ddu source
" 2025-07-22: I don't find this to be super useful, but I'll leave this since
" it's harmless enough
Plug 'https://github.com/Shougo/ddu-commands.vim', executable('deno') ? {} : #{for: []}
Plug 'andymass/vim-matchup'
Plug 'https://github.com/rhysd/conflict-marker.vim'
