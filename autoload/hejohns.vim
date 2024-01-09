scriptencoding utf8

" fold settings
" https://stackoverflow.com/a/54739345
function! hejohns#delete_view() abort
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
    " hejohns addition: vim gets stuck in diff mode a lot for some reason
    diffoff
endfunction

" LanguageClient-neovim
function! hejohns#enable_ft_specific() abort
    unlet g:myDisableFTSpecific
endfunction
function! hejohns#disable_ft_specific() abort
    let g:myDisableFTSpecific = 1
endfunction

" vimtex
function! hejohns#vimtex_options() abort
    if &filetype ==# 'tex' || &filetype ==# 'plaintex'
        if executable('latexmk')
            if executable('okular')
                let g:vimtex_view_general_viewer = 'okular'
                let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
            elseif executable('evince')
                let g:vimtex_view_general_viewer = 'evince'
            elseif executable('atril')
                let g:vimtex_view_general_viewer = 'atril'
            else
                silent !echo '[warning] no suitable pdf viewer found-- prepare for havoc'
            endif
            if executable('lualatex')
            " _ value modified
            let g:vimtex_compiler_latexmk_engines = {
                \ '_'                : '-pdflua',
                \ 'pdflatex'         : '-pdf',
                \ 'dvipdfex'         : '-pdfdvi',
                \ 'lualatex'         : '-lualatex',
                \ 'xelatex'          : '-xelatex',
                \ 'context (pdftex)' : '-pdf -pdflatex=texexec',
                \ 'context (luatex)' : '-pdf -pdflatex=context',
                \ 'context (xetex)'  : '-pdf -pdflatex=''texexec --xtx''',
                \}
            else
                silent !echo '[warning] please install lualatex'
            endif
            if !has('nvim')
                if has('clientserver')
                    if empty(v:servername) && exists('*remote_startserver')
                        silent! call remote_startserver('VIM')
                    endif
                else
                    silent !echo '[warning] need +clientserver for vimtex on (not n)vim'
                endif
            endif
        else
            silent !echo '[warning] vimtex requires latexmk.'
        endif
    let g:vimtex_syntax_conceal = {
                \ 'accents': 1,
                \ 'ligatures': 1,
                \ 'cites': 1,
                \ 'fancy': 1,
                \ 'spacing': 1,
                \ 'greek': 1,
                \ 'math_bounds': 1,
                \ 'math_delimiters': 1,
                \ 'math_fracs': 1,
                \ 'math_super_sub': 1,
                \ 'math_symbols': 1,
                \ 'sections': 0,
                \ 'styles': 1,
                \}
    let g:vimtex_syntax_conceal_cites = {
                \ 'type': 'brackets',
                \ 'icon': '📖',
                \ 'verbose': v:true,
                \}
    setlocal conceallevel=2
    setlocal concealcursor=
    " tex-conceal
    let g:tex_conceal='abdmgs'
    " ysiwc and such (:help vimtex)
    let b:surround_{char2nr('e')} = "\\begin{\1environment: \1}\n\t\r\n\\end{\1\1}"
    let b:surround_{char2nr('c')} = "\\\1command: \1{\r}"
    " shortcut for ysiwc
    nnoremap ;sc ysiwc
    endif
endfunction

" statusline
function! hejohns#statusline() abort
    " this probably doesn't significantly affect keystroke latency, but at
    " least try to make an effort
    if exists('g:myStatuslineUpdated') && g:myStatuslineUpdated
        let g:myStatuslineUpdated = 0
        let g:mystatusline = ''
        if exists('g:myTime')
            let g:mystatusline = '[' .. g:myTime .. ']' .. g:mystatusline
        endif
        if exists('g:myWeather')
            let g:mystatusline = '[' .. g:myWeather .. ']' .. g:mystatusline
        endif
    else
    endif
    return g:mystatusline
endfunction

" initialize statusline
function! hejohns#set_statusline() abort
    " Emulate default statusline in case the subsequent fancy features don't
    " exist
    set statusline=%f\ %y%r%m%<\ %{FugitiveStatusline()}\ %{hejohns#statusline()}%=
    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*
    set statusline+=\ %-12.(%l,%c%V%)\ %P
    " also because ^ took me forever to figure out
    " Now, the fancy stuff
    if has('channel') && has('job') && has('timers')
        let g:myWeather = '⟳'
        let g:myTime = '⟳'
        let g:myStatuslineUpdated = 1
        call hejohns#time_job()
        call hejohns#weather_job()
        call timer_start(5000, 'hejohns#time_timer_cb', {'repeat': -1})
        call timer_start(10000, 'hejohns#weather_timer_cb')
        call timer_start(600000, 'hejohns#weather_timer_cb', {'repeat': -1})
    endif
endfunction
function! hejohns#time_timer_cb(timer) abort
    " should never fail
    if job_status(g:myTimeJob) ==# 'dead'
        let g:myTime = trim(ch_read(g:myTimeJob))
        let g:myStatuslineUpdated = 1
        call hejohns#time_job()
    endif
endfunction
function! hejohns#weather_timer_cb(timer) abort
    " do this in the timer callback, rather than job exit_cb, so we can fail
    " the timer and stop it after a couple times
    if job_status(g:myWeatherJob) ==# 'dead'
        if job_info(g:myWeatherJob)['exitval'] == 0
            let g:myWeather = trim(ch_read(g:myWeatherJob))
            let g:myStatuslineUpdated = 1
            call hejohns#weather_job()
        else
            echoerr '[error] curl wttr.in dead but failed'
        endif
    elseif job_status(g:myWeatherJob) ==# 'fail'
            echoerr '[error] curl wttr.in failed'
    endif
endfunction
function! hejohns#time_job() abort
    let g:myTimeJob = job_start( ['date', '+%r'], {'out_mode': 'raw', 'drop': 'never'} )
endfunction
function! hejohns#weather_job() abort
    let g:myWeatherJob = job_start( ['curl', '-s', 'wttr.in?format=%p+%c%t'], {'out_mode': 'raw', 'drop': 'never'} )
endfunction

" vim-signify
function! hejohns#signify_diff_toggle() abort
    if g:mySignifyDiffToggle
        autocmd! signify_toggle User Signify
    else
        autocmd signify_toggle User Signify SignifyHunkDiff
    endif
    let g:mySignifyDiffToggle = !g:mySignifyDiffToggle
endfunction

" vim-dispatch
function! hejohns#dispatch_on_BufWrite() abort
    if &ft ==# 'tex'
        if has('perl')
            perl << EOF
            use strict;
            use warnings FATAL => 'all', NONFATAL => 'redefine';
            if(-e 'Makefile' || -e 'makefile'){
                my ($_success, $myDispatchToggle) = SEval("get(g:, 'myDispatchToggle', 0)");
                $myDispatchToggle //= 0;
                if($myDispatchToggle){
                    VIM::DoCommand(':Make');
                }
            }
EOF
        else
            silent !echo '[warning] Need +perl to :Make on BufWritePost'
        endif
    endif
endfunc

" deoplete
" deoplete-faq-config
function! hejohns#deoplete_check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col-1] =~# '\s'
endfunction

function! hejohns#deoplete_is_running() abort
    if exists('*deoplete#is_enabled')
        return deoplete#is_enabled()
    else
        return v:false
    endif
endfunction

" clang_complete
function! hejohns#initialize_clang_complete() abort
    " set g:clang_library_path with highest clang version available
    if has('perl')
        perl <<EOF
        use strict;
        use warnings FATAL => 'all', NONFATAL => 'redefine';

        my @clang_library_path = glob '/usr/lib/llvm-*/lib';
        @clang_library_path = sort {
            $a =~ m/usr\/lib\/llvm-(\d+)\/lib/ or die "Failed to match. $!";
            my $aN = $1;
            $b =~ m/usr\/lib\/llvm-(\d+)\/lib/ or die "Failed to match. $!";
            my $bN = $1;
            $aN <=> $bN;
        } @clang_library_path;
        if(@clang_library_path){
            my $clang_library_path;
            do {
                $clang_library_path = pop @clang_library_path;
            } while(defined($clang_library_path) && !-e "$clang_library_path/libclang.so");
            $clang_library_path //= '';
            my @clangCmds = split /\n/, <<~"__EOF"
                let g:clang_library_path = '$clang_library_path'
                set omnifunc='ClangComplete'
                set completefunc='ClangComplete'
                let g:clang_complete_auto = 1
                let g:clang_complete_copen = 1
                let g:clang_complete_pattern = 1
                __EOF
                ;
            map {VIM::DoCommand($_)} @clangCmds;
        }
EOF
    else
        silent !echo '[warning] Need +perl to initialize clang_complete correctly'
    endif
endfunction

" my remap toggles
function! hejohns#remap_toggle() abort
    if exists('g:myRemapToggle')
        if g:myRemapToggle
            inoremap df <BS>
            inoremap fd <DEL>
        else
            iunmap df
            iunmap fd
        endif
    else
        let g:myRemapToggle = 1
        call hejohns#remap_toggle()
        return
    endif
    let g:myRemapToggle = !g:myRemapToggle
endfunction

" calendar.vim
function! hejohns#calendar_sync_pull() abort
    if executable('git')
        if !exists('g:myCalenderSshAgent')
            call hejohns#calendar_ssh_agent()
        endif
        " clone git repo if needed
        call hejohns#calendar_create_cache_dir_if_needed()
        " git pull latest changes
        execute 'cd ' ..  g:myCalendarPath
        call hejohns#calendar_with_ssh_env('git pull')
        cd -
    else
        silent !echo '[optional] Need `git` for syncing calendar.vim'
    endif
    " finally, call the original calendar.vim
    Calendar
endfunction

function! hejohns#calendar_sync_push() abort
    if executable('git')
        try
            execute 'cd ' ..  g:myCalendarPath
        catch
            silent !echo '[warning] "' .. g:myCalendarPath .. '" may not exist'
            return
        endtry
        if strlen(system('git add -A -n')) && !v:shell_error
            if !exists('g:myCalenderSshAgent')
                call hejohns#calendar_ssh_agent()
            endif
            call system('git add -A .')
            call system('git commit -m "bump"')
            call hejohns#calendar_ssh_agent('git push')
        endif
        cd -
    endif
endfunction

function! hejohns#calendar_with_ssh_env(cmd) abort
    let l:ret = execute "call system('" .. g:myCalenderSshAgent .. ' ' .. a:cmd .. "')"
    return l:ret
endfunction

function! hejohns#calendar_ssh_agent() abort
    "if exists('$SSH_AUTH_SOCK') && exists('$SSH_AGENT_PID')
    "    let g:myCalenderSshAgent = 'SSH_AUTH_SOCK=' .. $SSH_AUTH_SOCK .. ' SSH_AGENT_PID=' .. $SSH_AGENT_PID .. ' '
    "else
        let g:myCalenderSshAgent = trim(join(systemlist('ssh-agent')))
        call hejohns#calendar_with_ssh_env('ssh-add')
    "endif
endfunction

" wrap this in a function, in case it errors, to protect plugin/hejohns.vim
function! hejohns#calendar_create_cache_dir_if_needed() abort
    " this is horrible but I don't feel like doing file tests in vimscript
    if finddir(g:myCalendarPath)
        try
            call readdir(g:myCalendarPath)
            execute 'cd ' .. g:myCalendarPath
            git
            git init
            git remote add
            cd -
        catch
            echoerr 'calendar.vim path "' .. g:myCalendarPath .. '" not readable. Update `g:myCalendarPath` or fix permissions.'
        endtry
    else
        " create cache directory for the first time
        call system('mkdir -p ' .. g:myCalendarPath)
        call hejohns#calendar_with_ssh_env('git clone ' .. g:myCalendarUrl .. ' ' .. g:myCalendarPath)
    endif
endfunction
