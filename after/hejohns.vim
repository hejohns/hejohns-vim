if exists('g:loaded_hejohns_after') || &compatible
    finish
else
    let g:loaded_hejohns_after = v:true
endif

set spell
set spelllang=en

" undercurl not available on term usually
" apparantly nvim doesn't understand term or ctermul
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
