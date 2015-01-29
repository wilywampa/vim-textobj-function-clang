let b:textobj_function_select = function('textobj#function#clang#select')

call textobj#user#plugin('class', {
    \   '-': {
    \     'select-a-function': 'textobj#function#clang#select_ac',
    \     'select-a': '<buffer> ac',
    \     'select-i-function': 'textobj#function#clang#select_ic',
    \     'select-i': '<buffer> ic',
    \   },
    \ })

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'silent! unlet b:textobj_function_select'
