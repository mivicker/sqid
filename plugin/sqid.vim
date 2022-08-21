if exists('g:loaded_quid') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

command! Quid lua require"quid".quid()

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_quid = 1
