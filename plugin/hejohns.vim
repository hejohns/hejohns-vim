if exists('g:loaded_hejohns') || &compatible
    finish
else
    let g:loaded_hejohns = v:true
endif

" global (vimrc) settings
set encoding=utf8
scriptencoding utf8
syntax on
colorscheme solarized
set background=dark
set tags=tags
set autoindent
set expandtab
set tabstop=8
" default shiftwidth-- langauge specific below
set shiftwidth=4
set cindent
set formatoptions +=cro
set hlsearch
set nopaste
set foldmethod=indent
set foldcolumn=0
set foldlevel=99
set foldclose=all
set relativenumber
set number
" help file-searching
set tags=./tags;
set ruler
set vb
set autoread
set showcmd
set wrap
" for LanguageClient-neovim
set hidden
set timeoutlen=500
set laststatus=2
set wildmode=longest:full,full
if has('wildmenu')
    set wildmenu
endif
if has('wildignore')
    set wildoptions=pum
endif
" default spell on
" (dumb but non autocmd doesn't work for some reason)
augroup spell_default_on
    autocmd!
    autocmd VimEnter * setlocal spell spelllang=en
    autocmd WinNew * setlocal spell spelllang=en
    " sourcing one of the syntax files screws up the hi colors
    autocmd WinNew * call MySetSpellColors()
augroup END
set shortmess-=S
set smarttab
inoremap kj <ESC>
inoremap jk <C-w>
inoremap lk <ESC>ll
inoremap <TAB> <C-n>
inoremap <S-TAB> <C-p>
inoremap df <BS>
inoremap fd <DEL>
"noremap DK kdd
"noremap DJ jddk
" ; is my main n leader
noremap ;; :update<CR>
" recover normal ; behavior
noremap ;f ;
" to be more mnemonic consistent
noremap ;b ,
noremap ;n :bNext<CR>
" https://stackoverflow.com/a/2084221
noremap ;: :OverCommandLine<CR>
" spell stuff
noremap ;son :setlocal spell spelllang=en<CR>:call MySetSpellColors()<CR>
noremap ;soff :setlocal spell spelllang=<CR>
noremap <expr> ;st (&spelllang == '' ? ':set spelllang=en<CR>' : ':set spelllang=""<CR>')
noremap ;sf viw<ESC>a<C-X><C-s>
" I'm dumb
"noremap ;sf h/\s\\|\n<CR>:let @/ = ''<CR>i<C-X><C-s>
" https://stackoverflow.com/a/48721323
" + fix for single character word handling
if has('textobjects')
    noremap ;sw yiwwviwp?\s<CR>:let @/ = ''<CR>bviwp
    noremap ;sW yiWWviWp?\s<CR>:let @/ = ''<CR>bviWp
    noremap ;s{ ya{%/{<CR>:let @/ = ''<CR>va{p%?}<CR>:let @/ = ''<CR>va{p
    noremap ;s} ya}%/}<CR>:let @/ = ''<CR>va}p%?}<CR>:let @/ = ''<CR>va}p
else
    silent !echo '[warning] Need +textobjects to use ;sw[ap]'
endif
nnoremap Q gq
vnoremap Q gq
inoremap <C-Y> <ESC><C-Y>a
inoremap <C-E> <ESC><C-E>a
" <C-\> is my leader for infrequent keys
noremap <C-\>rn :set invrelativenumber<CR>
noremap <C-\>n :set invnumber<CR>
" vimdiff mappings (for git mergetool)
" https://vi.stackexchange.com/questions/2705/create-mappings-that-only-apply-to-diff-mode
" even though &diff is always set for some reason...
nnoremap <expr> gl &diff ? ':diffget LOCAL<CR>]c' : 'gl'
nnoremap <expr> gr &diff ? ':diffget REMOTE<CR>]c' : 'gr'
filetype detect
let g:tex_flavor = 'latex'
inoremap <C-\>^e ê
inoremap <C-\>"o ö
" https://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work
" Allow saving of files as sudo
cmap w!! w !sudo tee > /dev/null %

" fold settings
" https://stackoverflow.com/a/54739345
augroup remember_folds
    autocmd!
    autocmd BufWinLeave ?* mkview
    autocmd BufWinEnter ?* silent! loadview
augroup END
" # Function to permanently delete views created by 'mkview'
function! MyDeleteView()
    let path = fnamemodify(bufname('%'),':p')
    " vim's odd =~ escaping for /
    let path = substitute(path, '=', '==', 'g')
    if empty($HOME)
    else
        let path = substitute(path, '^'.$HOME, '\~', '')
    endif
    let path = substitute(path, '/', '=+', 'g') . '='
    " view directory
    let path = &viewdir.'/'.path
    call delete(path)
    echo 'Deleted: '.path
    " my addition: vim gets stuck in diff mode a lot for some reason
    diffoff
endfunction
" # Command Delview (and it's abbreviation 'delview')
command Delview call MyDeleteView() | set foldmethod=indent | set foldcolumn=0 | set foldlevel=99
command DelviewHard call MyDeleteView() | set foldmethod=indent | set foldcolumn=0 | set foldlevel=99 | noautocmd q
" Lower-case user commands: http://vim.wikia.com/wiki/Replace_a_builtin_command_using_cabbrev
cabbrev delview <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Delview' : 'delview')<CR>

" undo-persistence
" modified from undotree 's README
" and :help undo-persistence
if has('persistent_undo')
    let g:myUndodir = expand('~/.vim/undodir')
    " TODO: could be more robust
    " eg if ~/.vim/undodir exists but is a regular file
    " some of the perl code below handles this somehow
    if !isdirectory(g:myUndodir)
        if !mkdir(g:myUndodir, 'p', 0700)
            silent !echo '[error] undo-persistence: see TODO s'
        endif
    endif
    let &undodir=g:myUndodir
    " But undodir doesn't actually work
    set undodir=~/.vim/undodir
    func ReadUndo()
        " :(
        let undofile__ = g:myUndodir .. '/' .. expand('%:p:gs?/?%?.un~')
        let undofile_ = g:myUndodir .. '/' .. expand('%:p:gs?/?\\%?.un~')
        if filereadable(undofile__)
            silent execute "rundo" undofile_
        endif
    endfunc
    func WriteUndo()
        let undofile_ = g:myUndodir .. '/' .. expand('%:p:gs?/?\\%?.un~')
        execute 'wundo' undofile_
    endfunc
    augroup persistent_undo
        autocmd BufReadPost ?* call ReadUndo()
        autocmd BufWritePost ?* call WriteUndo()
    augroup END
else
    silent !echo '[warning] Need +persistent_undo'
endif

" more highlighting matches
call matchadd('Todo', '\<notes\?:\?\>\c')
call matchadd('Todo', '\<todo:\?\>\c')

" spell stuff cont
" undercurl not available on term usually
" apparantly nvim doesn't understand term or ctermul
function! MySetSpellColors()
    if !has('nvim')
        hi SpellBad term=underline cterm=underline ctermul=Red
        hi SpellCap term=underline cterm=underline ctermul=Blue
        hi SpellRare term=underline cterm=underline ctermul=Magenta
        hi SpellLocal term=underline cterm=underline ctermul=Cyan
    endif
    hi SpellBad gui=undercurl guisp=Red
    hi SpellCap gui=undercurl guisp=Blue
    hi SpellRare gui=undercurl guisp=Magenta
    hi SpellLocal gui=undercurl guisp=Cyan
endfunction
