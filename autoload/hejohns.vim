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
                my ($_success, $myDispatchToggle) = SEval('g:myDispatchToggle');
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
