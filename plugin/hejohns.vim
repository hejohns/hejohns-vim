if exists('g:loaded_hejohns') || &compatible
    finish
else
    let g:loaded_hejohns = v:true
endif

" global (vimrc) settings
set encoding=utf8
scriptencoding utf8
syntax on
try
    colorscheme solarized
catch
    colorscheme desert
endtry
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
if has('wildignore') " why do we need 'wildignore' ?
    silent! set wildoptions=pum
endif
" default spell on
" (dumb but non autocmd gets clobbered by other syntax files)
augroup spell_default_on
    autocmd!
    " VimEnter for first window, WinNew for the rest
    if exists('##VimEnter')
        autocmd VimEnter * setlocal spell spelllang=en
    endif
    if exists('##WinNew')
        autocmd WinNew * setlocal spell spelllang=en
    endif
    " sourcing one of the syntax files screws up the hi colors
    " (eg solarized)
    if exists('##SourcePost')
        autocmd  SourcePost * call s:set_spell_colors()
    endif
    if exists('##VimEnter')
        autocmd VimEnter * call s:set_spell_colors()
    endif
augroup END
set shortmess-=S
set smarttab
inoremap kj <ESC>
inoremap jk <C-w>
" this is tricky...
function! s:lk() abort
    let l:orig_line = getline('.')
    let l:orig_cursorpos = charcol('.')
    "if (charcol('$') == 1) || (charcol('.') + 1 == charcol('$'))
    "    call setline('.', l:orig_line .. 'lk')
    "    startinsert!
    "    return
    "endif
    " avoid remappings
    "normal! alk
    call setline('.', strcharpart(l:orig_line, 0, l:orig_cursorpos) .. 'lk' .. strcharpart(l:orig_line, l:orig_cursorpos))
    " NOTE: setcursorcharpos(0, charcol('.')) moves the cursor when col > 61?????
    call setcursorcharpos(line('.'), l:orig_cursorpos + 2)
    "call setcharpos('.', [0, line('.'), l:orig_cursorpos + 2, 0])
    " try to stop the weirdness
    "stopinsert
    call setcursorcharpos(line('.'), charcol('.') - 1)
    "call setcharpos('.', [0, line('.'), charcol('.') - 1, 0])
    if strlen(system('aspell list', expand('<cword>')))
        call setline('.', l:orig_line)
        call setcursorcharpos(line('.'), l:orig_cursorpos + 2)
        "call setcharpos('.', [0, line('.'), l:orig_cursorpos + 2, 0])
    else
        startinsert
        call setcursorcharpos(line('.'), charcol('.') + 2)
        "call setcharpos('.', [0, line('.'), charcol('.') + 2, 0])
    endif
endfunction
inoremap lk <ESC>:call <SID>lk()<CR>
" this is so stupid
" but may be necessary since I'm pretty sure LaTeXtoUnicode sometimes destroys my inoremap <buffer> <TAB>
inoremap <expr> <TAB> hejohns#deoplete_is_running() ? "\<C-o>" .. ":call MyDeopleteConf()" .. "\<CR>" : "\<C-n>"
inoremap <expr> <S-TAB> hejohns#deoplete_is_running() ? "\<C-o>" .. ":call MyDeopleteConf()" .. "\<CR>" : "\<C-p>"
" the df and fd mappings were originally for a standard QWERTY keyboard where
" <BS> and <DEL> are hard to reach, but I don't need these on a kinesis
" Advantage 2
"
" mnemonic ;ret ;"remap toggle"
noremap ;ret :call hejohns#remap_toggle()<CR>
"noremap DK kdd
"noremap DJ jddk
" ; is my main n leader
noremap ;; :update<CR>
" recover normal ; behavior
map ;f <Plug>Sneak_;
" to be more mnemonic consistent
map ;b <Plug>Sneak_,
noremap ;m :bnext<CR>
"noremap ;N :bNext<CR>
noremap ;n :bprevious<CR>
" https://stackoverflow.com/a/2084221
noremap ;: :OverCommandLine<CR>
" spell stuff
noremap ;son :setlocal spell spelllang=en<CR>:call s:set_spell_colors()<CR>
noremap ;soff :setlocal spell spelllang=<CR>
noremap <expr> ;st (&spelllang == '' ? ':set spelllang=en<CR>' : ':set spelllang=""<CR>')
" spell fix
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
" # Command Delview (and it's abbreviation 'delview')
command Delview call hejohns#delete_view() | set foldmethod=indent | set foldcolumn=0 | set foldlevel=99
" avoid BufWinLeave and mkview on :q
command DelviewHard call hejohns#delete_view() | set foldmethod=indent | set foldcolumn=0 | set foldlevel=99 | noautocmd q
" Lower-case user commands: http://vim.wikia.com/wiki/Replace_a_builtin_command_using_cabbrev
cabbrev delview <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Delview' : 'delview')<CR>

" undo-persistence
" modified from undotree 's README
" and :help undo-persistence
if has('persistent_undo')
    let g:myUndodir = expand('~/.vim/undodir')
    " NOTE: could be more robust
    " eg if ~/.vim/undodir exists but is a regular file
    " some of the perl code below handles this somehow
    " But it really isn't worth fixing. I mean who would create g:myUndodir as
    " a regular file? Just manually delete it at that point
    if !isdirectory(g:myUndodir)
        if !mkdir(g:myUndodir, 'p', 0700)
            silent !echo '[error] undo-persistence: see NOTE s'
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
function! s:set_spell_colors() abort
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

" my perl stuff
" neovim perl provider
if has('nvim')
    let g:perl_host_provider = '/usr/bin/perl'
endif
if has('perl')
    if has('nvim')
        perl << EOF
        use strict;
        use warnings FATAL => 'all', NONFATAL => 'redefine';

        # NOTE: nvim's VIM::Eval does not dereference like vim does
        # TODO: The whole eval thing, as I've realized recently, is a total
        # mess. eg we use `exists()`, but assume the argument is a variable.
        # If you tried SEval('MyFunc()'), this will not work
        sub SEval($){
            VIM::DoCommand("let g:myPerl__ = exists('$_[0]')");
            my ($_success, $exists) = VIM::Eval('g:myPerl__');
            ($exists) ? VIM::Eval(shift) : return;
        }
        sub AEval($){
            VIM::DoCommand("let g:myPerl__ = exists('$_[0]')");
            my ($_success, $exists) = VIM::Eval('g:myPerl__');
            if($exists){
                my ($success, $e) = VIM::Eval(shift);
                ($success, "@$e");
            }
            else{
                return;
            }
        }
EOF
    " normal vim
    else
        perl << EOF
        use strict;
        use warnings FATAL => 'all', NONFATAL => 'redefine';

        sub SEval($){
            VIM::Eval(shift);
        }
        sub AEval($){
            VIM::Eval(shift);
        }
EOF
    endif

    " defined in vimrc since we need it there
    perl << EOF
    if(!defined &executable){
        die "do something";
    }
EOF
endif
" (keeping this here for future ref)
if has('perl')
    perl << EOF
    use strict;
    use warnings FATAL => 'all', NONFATAL => 'redefine';

    sub mySub{
        print (glob q(*.pl));
        VIM::Msg("Hello");
    }
EOF
    function! MyFunc()
        perl mySub
    endfunction
endif

" LanguageClient-neovim
" (and any pip stuff)
" (and any filetype specific options)
if has('perl')
    function s:ft_specific(ft)
        augroup filetype_specific
            autocmd! * <buffer>
        augroup END
        call MyDeopleteConf()
        let g:myPerlArg = a:ft
        if !(exists('g:myDisableFTSpecific') && g:myDisableFTSpecific == 1)
            perl filetype_options
        endif
    endfunction
    function MyDeopleteConf()
        perl deoplete_options
    endfunction
    function MyDeopleteTab()
        if pumvisible()
            return "\<C-n>"
        elseif hejohns#deoplete_check_back_space()
            return "\<TAB>"
        else
            call deoplete#custom#option('auto_complete_popup', 'manual')
            let l:can_complete = deoplete#can_complete()
            call deoplete#custom#option('auto_complete_popup', 'auto')
            if l:can_complete
                return deoplete#complete()
            elseif has('nvim')
                return deoplete#manual_complete()
            else
                return ''
            endif
        endif
    endfunction
    function MyDeopleteSTab()
        if pumvisible()
            return "\<C-p>"
        elseif hejohns#deoplete_check_back_space()
            return "\<S-TAB>"
        else
            deoplete#custom#option('auto_complete_popup', 'manual')
            let l:can_complete = deoplete#can_complete()
            deoplete#custom#option('auto_complete_popup', 'auto')
            if l:can_complete
                return deoplete#complete()
            elseif has('nvim')
                return deoplete#manual_complete()
            else
                return ''
            endif
        endif
    endfunction
    perl << EOF
    use strict;
    use warnings FATAL => 'all', NONFATAL => 'redefine';

    my ($_success, $lsLangs) = AEval('g:myLSLangs');
    my @lsLangs = split(' ', $lsLangs);

    sub deoplete_options{ # TODO: this had no need to be perl
        VIM::DoCommand('let g:myPerlArg_ = deoplete#is_enabled()');
        ($_success, my $deopleteIs_enabled) = SEval('g:myPerlArg_');
        $deopleteIs_enabled //= 0;
        if($deopleteIs_enabled){
            # use deoplete so vim stops hanging on autocomplete
            # still needed for some reason even with g:deoplete#enable_at_startup
            VIM::DoCommand('call deoplete#enable()');
            # I'm pretty sure the julia L2U stuff (LaTeXtoUnicode) is triggering global inoremap sometimes
            VIM::DoCommand('inoremap <buffer> <expr> <TAB> MyDeopleteTab()');
            VIM::DoCommand('inoremap <buffer> <expr> <S-TAB> MyDeopleteSTab()');
            # deoplete-options-num_processes
            VIM::DoCommand("call deoplete#custom#var('around', {'range_above': 10000, 'range_below': 10000})");
            # NOTE: deoplete by default uses all sources?
            VIM::DoCommand("call deoplete#custom#option('sources', {'_': []})");
            VIM::DoCommand("call deoplete#custom#buffer_option('num_processes', 2)");
        }
    }

    my %no_LS_opt2ft = (
        'autocmd filetype_specific BufEnter <buffer> setlocal shiftwidth=2' =>
        ['haskell', 'cabal', 'cabalconfig', 'cabalproject', 'nix'],
        'autocmd filetype_specific BufWritePost <buffer> call hejohns#dispatch_on_BufWrite()' =>
        ['tex'],
        'nnoremap <buffer> <C-\>ll :let g:myDispatchToggle = (exists("g:myDispatchToggle") && g:myDispatchToggle) ? 0 : 1<CR>' =>
        ['tex'],
        'call hejohns#vimtex_options()' =>
        ['tex'],
        'nnoremap <buffer> <localleader>lt :call vimtex#fzf#run()<CR>' =>
        ['tex'],
        # TODO: some ft autocmd (not mine) needs to fire late to get vimtex conceal to work correctly
        # this hack ``just works''
        'setlocal filetype=tex' =>
        ['tex'],
        # vimtex-complete-auto
        "silent! call deoplete#custom#var('omni', 'input_patterns', {'tex': g:vimtex#re#deoplete})" =>
        ['tex'],
        # NOTE: julia unicode input doesn't play well w/ deoplete
        # when EnableL2U, autocomplete is sync and may hang vim
        # I can't find a easy way to dig into this problem
        # hopefully you (I) don't need async autocomplete and unicode input together too often...
        'call EnableL2U()' =>
        ['tex'],
        'call hejohns#initialize_clang_complete()' =>
        ['c', 'cpp'],
    );
    my %LS_opt2ft = (
        'nnoremap <buffer> ;ls :call LanguageClient_contextMenu()<CR>' =>
        [@lsLangs],
        'nnoremap <buffer> gd :call LanguageClient#textDocument_definition()<CR>' =>
        [(grep {!/^perl$/} @lsLangs)],
        'nnoremap <buffer> K :call LanguageClient#textDocument_hover()<CR>' =>
        [(grep {!/^perl$/} @lsLangs)],
        'autocmd filetype_specific BufWritePre *.go :call LanguageClient#textDocument_formatting_sync()' =>
        ['go'],
    );

    sub filetype_options{
        my $success;
        ($success, my $filetype) = SEval('g:myPerlArg');
        $filetype //= '';
        if($filetype eq 'plaintex'){
            VIM::DoCommand("silent !echo '[error] &ft plaintex should be masqueraded as tex'");
        }
        foreach my $k (keys %no_LS_opt2ft){
            if(grep {/^$filetype$/} @{$no_LS_opt2ft{$k}}){
                VIM::DoCommand($k);
            }
        }
        RETRY:
        ($success, my $ls_running) = SEval('g:myLSRunning');
        if($ls_running){
            # TODO: check LS executable is present or raise message
            # and maybe autoinstall? (if we nix it enough)
            foreach my $k (keys %LS_opt2ft){
                if(grep {/^$filetype$/} @{$LS_opt2ft{$k}}){
                    VIM::DoCommand($k);
                }
            }
        }
        else{
            my $success; #don't bother...
            ($success, my $lsLangs) = AEval('g:myLSLangs');
            my @lsLangs = split(' ', $lsLangs);
            push @lsLangs, qw(vim); # vim-vint requires pip install
            # NOTE: can't figure out why plaintex shows up
            # but it messes up the buffer local remappings
            VOID_EVAL_LAST_WARNINGS: {
                if($filetype && grep {/^$filetype$/} @lsLangs){
                    # https://github.com/jaredly/reason-language-server
                    # (which we're no longer using)
                    #my $pipHasNeovim = `pip3 list 2>&1 | grep 'neovim' 2>&1`;
                    #if($? >> 8){
                    #    my $pipSuccess = `pip3 install neovim 2>&1`;
                    #    if($? >> 8){
                    #        VIM::DoCommand("silent !echo '[warning] `pip3 install neovim` failed. Not using langauge server.'");
                    #        last VOID_EVAL_LAST_WARNINGS;
                    #    }
                    #}
                    #VIM::DoCommand('pythonx import neovim');
                    # enable autocomplete
                    VIM::DoCommand("let g:myLSRunning = 1");
                    VIM::DoCommand("command LSRename :call LanguageClient#textDocument_rename()<CR>");
                    VIM::DoCommand("command LSTDef :call LanguageClient#textDocument_typeDefinition()<CR>");
                    goto RETRY;
                }
            }
        }
    }
EOF
else
    silent !echo '[warning] Need +perl to set filetype specific options'
    silent !echo '[warning] Need +perl to initialize language server correctly'
endif
augroup filetype_options
    autocmd!
    autocmd FileType plaintex setlocal filetype=tex
    " other plugins may clobber our mappings
    autocmd VimEnter,BufEnter * execute 'call s:ft_specific("' . &filetype . '")'
augroup END

" julia latex2unicode
" `let g:latex_to_unicode_tab = "off"` to disable julia tab completion
" `let g:latex_to_unicode_tab = "insert"` to only activate for insert
" `let g:latex_to_unicode_tab = "command"` to only activate for command
let g:latex_to_unicode_tab = 'on'
function EnableL2U()
    let g:latex_to_unicode_eager = 0
    let g:latex_to_unicode_auto = 1 " enable space driven auto completion
    let g:latex_to_unicode_file_types = '*' " on all
    call LaTeXtoUnicode#Init()
    call LaTeXtoUnicode#Enable()
endfunction
command L2UEnable call EnableL2U()
function DisableL2U()
    call LaTeXtoUnicode#Disable()
endfunction
command L2UDisable call DisableL2U()
nnoremap <C-\>lon :call EnableL2U()<CR>
nnoremap <C-\>loff :call DisableL2U()<CR>

" fugitive
" NOTE: I don't really use these...
"command GD vertical Gdiff
"command GS vertical Git

" syntastic
let g:syntastic_vim_checkers = ['vint']
let g:syntastic_mode_map = {
            \ 'mode': 'passive',
            \ 'active_filetypes': ['reason', 'vim', 'pod', 'rust'],
            \ 'passive_filetypes': []}
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" statusline
let g:mystatusline = ''
" Emulate default statusline
" if airline installed, will switch automatically
" :AirlineToggle
call hejohns#set_statusline()

" vim-airline
" airline has lots of cool extensions w/ other plugins
let g:airline_theme = 'solarized'
let g:airline_solarized_bg = 'dark'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
"let g:airline_statusline_ontop = 1
if has('nvim')
    let g:airline_section_y = '[%{strftime("%r")}]'
else
    let g:airline_section_y = '%{hejohns#statusline()}'
endif

" vim-signify
set updatetime=100
let g:signify_sign_change = '∂'
let g:mySignifyDiffToggle = 0
augroup signify_toggle
    autocmd!
augroup END
nnoremap ;sigp :call hejohns#signify_diff_toggle()<CR>
nnoremap ;sigt :SignifyToggle<CR>
nnoremap ;sigu :SignifyHunkUndo<CR>

" undotree
nnoremap ;u :UndotreeToggle<CR>

" not using this anymore, since deoplete has it's own autocomplete popup
" TODO: could try to use this when deoplete isn't running
" but doesn't seem worth it
"" vim-simple-complete
"" default g:vsc_completion_command is "\<C-N>"
"" try to hook it up w/ deoplete
"" (by not using it??)
"let g:vsc_completion_command = ""
"" try to let the other autocomplete plugins take care of tab
"let g:vsc_tab_complete = 0
"" hack to not have TabComplete
"let g:loaded_vim_simple_complete = 0
"call plug#load('vim-simple-complete')

" vim-sneak
let g:sneak#s_next = 1
let g:sneak#label = 1
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T
nmap s H<Plug>SneakLabel_s
nnoremap S H:call sneak#wrap('', 3, 0, 1, 2)<CR>

" fzf
" slowly learn the commands
command SearchBuffers Lines
command SearchBuffer BLines
if executable('bat') == 0
    silent !echo '[optional] Need `bat` for :Ag, :Lines, ...'
endif
if executable('ag') == 0
    silent !echo '[optional] Need `ag` for :Ag, :Lines, ...'
endif

" vimtex
" default g:vimtex_compiler_latexmk
" plus --shell-escape for \usepackage{svg}
let g:vimtex_compiler_latexmk = {
    \ 'build_dir' : '',
    \ 'callback' : 1,
    \ 'continuous' : 1,
    \ 'executable' : 'latexmk',
    \ 'hooks' : [],
    \ 'options' : [
    \   '-lualatex="lualatex --shell-escape"',
    \   '-verbose',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ],
    \}
if executable('inkscape') == 0
    silent !echo '[optional] Need `inkscape` for latex gifs'
endif

" ack.vim
if executable('ack') == 0
    silent !echo '[optional] Need `ack` for :Ack'
endif

" hindent-vim
if executable('hindent') == 0
    silent !echo '[optional] Need `hindent` for vim-hindent'
endif

" calendar.vim
let g:calendar_first_day = 'monday'
let g:myCalendarUrl = 'git@github.com:hejohns/cache_calendar.vim.git'
let g:myCalendarPath = expand('~/.cache/calendar.vim/')
command CalendarSync call hejohns#calendar_sync_pull()
autocmd VimLeave * call hejohns#calendar_sync_push()

" vimwiki and vim-zettel
let g:vimwiki_list = [{'syntax': 'markdown', 'ext': 'md'}]
let g:vimwiki_global_ext = 0
let g:zettel_format = 'hejohns-%file_no'
let g:zettel_date_format = '%Y-%m-%d'
let g:zettel_options = [{'template': expand('<sfile>:p:h:h') .. '/etc/zettel_template.tpl'}]
