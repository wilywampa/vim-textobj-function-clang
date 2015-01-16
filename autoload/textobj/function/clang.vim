let g:textobj_function_clang_default_compiler_args = get(g:, 'textobj_function_clang_default_compiler_args', "")
let g:textobj_function_clang_include_headers = get(g:, 'textobj_function_clang_include_headers', 1)

function! s:prepare_temp_file()
    if g:textobj_function_clang_include_headers
        let temp_name = expand('%:p:h') . '/' . substitute(tempname(), '\W', '_', 'g') . (&filetype ==# 'c' ? '.c' : '.cpp')
        call writefile(getline(1, '$'), temp_name)
    else
        let temp_name = tempname() . (&filetype ==# 'c' ? '.c' : '.cpp')
        call writefile(map(getline(1, '$'), 'v:val =~# "^\\s*#include\\s*\\(<[^>]\\+>\\|\"[^\"]\\+\"\\)" ? "" : v:val'), temp_name)
    endif

    return temp_name
endfunction

function! textobj#function#clang#select(obj)
    let temp_name = s:prepare_temp_file()
    try
        let extent = libclang#location#function_extent(temp_name, line('.'), col('.'), get(b:, 'textobj_function_clang_default_compiler_args', g:textobj_function_clang_default_compiler_args))
    finally
        call delete(temp_name)
    endtry
    if empty(extent) || extent.start.file !=# extent.end.file
        return 0
    endif
    let pos = getpos('.')
    let start = [pos[0], extent.start.line, extent.start.column, pos[3]]
    let end = [pos[0], extent.end.line, extent.end.column, pos[3]]
    if a:obj ==# 'a'
        return ['V', start, end]
    else
        let view = winsaveview()
        let left = getpos("'<")
        let right = getpos("'>")
        try
            call cursor(extent.end.line, extent.end.column - 1)
            execute "normal! viB\<Esc>"
            let start[1:2] = getpos("'<")[1:2]
            let end[1:2] = getpos("'>")[1:2]
            return [(getline(extent.end.line) =~ '^\s*}' ? 'V' : 'v'), start, end]
        finally
            call winrestview(view)
            call setpos("'<", left)
            call setpos("'>", right)
        endtry
    endif
endfunction

function! textobj#function#clang#select_ac()
    let temp_name = s:prepare_temp_file()
    try
        let extent = libclang#location#class_extent(temp_name, line('.'), col('.'), get(b:, 'textobj_function_clang_default_compiler_args', g:textobj_function_clang_default_compiler_args))
    finally
        call delete(temp_name)
    endtry
    if empty(extent) || extent.start.file !=# extent.end.file
        return 0
    endif
    let pos = getpos('.')
    let start = [pos[0], extent.start.line, extent.start.column, pos[3]]
    let end = [pos[0], extent.end.line, extent.end.column, pos[3]]
    while end[1] < line('$') && nextnonblank(end[1] + 1) > end[1] + 1
        let end[1] += 1
    endwhile
    return ['V', start, end]
endfunction

function! textobj#function#clang#select_ic()
    let temp_name = s:prepare_temp_file()
    try
        let extent = libclang#location#class_extent(temp_name, line('.'), col('.'), get(b:, 'textobj_function_clang_default_compiler_args', g:textobj_function_clang_default_compiler_args))
    finally
        call delete(temp_name)
    endtry
    if empty(extent) || extent.start.file !=# extent.end.file
        return 0
    endif
    let pos = getpos('.')
    let start = [pos[0], extent.start.line, extent.start.column, pos[3]]
    let end = [pos[0], extent.end.line, extent.end.column, pos[3]]
    let view = winsaveview()
    let left = getpos("'<")
    let right = getpos("'>")
    try
        call cursor(extent.end.line, extent.end.column - 1)
        execute "normal! viB\<Esc>"
        let start[1:2] = getpos("'<")[1:2]
        let end[1:2] = getpos("'>")[1:2]
        return [(getline(extent.end.line) =~ '^\s*}' ? 'V' : 'v'), start, end]
    finally
        call winrestview(view)
        call setpos("'<", left)
        call setpos("'>", right)
    endtry
endfunction

