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
    " !has('nvim') -- neovim doesn't seem to like this for some reason
    if has('perl') && !has('nvim')
        perl << EOF
        use strict;
        use warnings FATAL => 'all', NONFATAL => 'redefine';

        chomp(my $time = `date '+%r'`);
        our $weather;
        $weather //= '⟳';
        our $weather_last_update;
        chomp(my $s_now = `date '+%s'`);
        $weather_last_update //= $s_now; # don't add curl to startup time
        our $curl_tmp; # "async" curl
        chomp($curl_tmp //= `mktemp --tmpdir tmp.vimrc.XXX`);
        if(($s_now - $weather_last_update) >= 20){
            $weather_last_update = $s_now;
            `cp $curl_tmp $curl_tmp.old`;
            `curl -s wttr.in?format=%p+%c%t > $curl_tmp &`;
            # TODO: maybe don't spam the statusline if curl returns error code
            chomp($weather = `cat $curl_tmp.old`);
            $weather = '⟳' if $weather eq '';
        }
        my $statusline = "[$weather][$time]";
        VIM::DoCommand("let g:mystatusline='$statusline'");
EOF
    endif
    return g:mystatusline
endfunction

" Emulate default statusline
function! hejohns#set_statusline() abort
    set statusline=%f\ %y%r%m%<\ %{FugitiveStatusline()}\ %{hejohns#statusline()}%=
    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*
    set statusline+=\ %-12.(%l,%c%V%)\ %P
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
