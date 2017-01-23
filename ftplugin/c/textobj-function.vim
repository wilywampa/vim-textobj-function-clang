if !exists('*TextobjFunctionCSelect')
    function! TextobjFunctionCSelect(obj)
        return textobj#function#clang#select(a:obj)
    endfunction
endif

let b:textobj_function_select = function('TextobjFunctionCSelect')

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'unlet b:textobj_function_select'
