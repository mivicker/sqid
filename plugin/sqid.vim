if exists('g:loaded_sqid') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

command! Sqid lua require"sqid".sqid()

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_quid = 1
