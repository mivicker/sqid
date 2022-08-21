if exists('g:loaded_sqid') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

command! Sqid lua require"sqid".sqid()
