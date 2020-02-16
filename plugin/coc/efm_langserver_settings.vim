"=============================================================================
" File: efm_langserver_settings.vim
" Author: Tsuyoshi CHO
" Created: 2020-01-11
"=============================================================================

scriptencoding utf-8

if exists('g:loaded_coc_efm_langserver_settings')
\ || !executable('efm-langserver')
  finish
endif
let g:loaded_coc_efm_langserver_settings = 1

let s:config_dir  = expand('<sfile>:h:h:h') . '/config/efm-langserver'
let s:config_file = expand(s:config_dir . '/config.yaml')
let s:settings    = json_decode(join(readfile(s:config_dir
\                                   . '/settings.json'), "\n"))

let s:whitelist = []
for s:data in s:settings
  if executable(s:data.cmd)
    call extend(s:whitelist, s:data.whitelist)
  endif
endfor

unlet s:config_dir s:settings

function s:coc_efm_langserver_setup() abort
  let userconfig = get(g:, 'coc_user_config', {})
  let userconfig['languageserver'] = get(userconfig,'languageserver', {})
  let userconfig['languageserver']['efm'] = {
  \  'command': 'efm-langserver',
  \  'args': ['-c=' . s:config_file],
  \  'filetypes': s:whitelist
  \}

  call coc#config('languageserver',userconfig.languageserver)
endfunction

augroup coc-efm-langserver-settings-init
  autocmd!
  autocmd VimEnter *
  \ if get(g:, 'did_coc_loaded', 0)
  \ | call s:coc_efm_langserver_setup()
  \ | endif
  autocmd VimEnter * autocmd! coc-efm-langserver-settings-init
augroup END

" EOF
