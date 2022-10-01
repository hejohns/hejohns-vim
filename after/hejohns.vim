if exists('g:loaded_hejohns_after') || &compatible
    finish
else
    let g:loaded_hejohns_after = v:true
endif

" have spell on by default someting
augroup spell_default_on
    autocmd !
    " for first window, when Vim has just started
    " in /after since some other plugin clobbers spell/spelllang
    autocmd VimEnter * setlocal spell spelllang=en
    autocmd WinNew * setlocal spell spelllang=en
    " sourcing one of the syntax files screws up the hi colors
    autocmd SourcePost * call MySetSpellColors()
augroup END

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
