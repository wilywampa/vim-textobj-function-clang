let b:textobj_function_select = function('textobj#function#clang#select')

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'silent! unlet b:textobj_function_select'
