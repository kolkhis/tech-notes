let M = {}

" Check current markdown line for a TODO item (`* [ ]`, `* [x]`, `* [_]`)
" If the current line is an ordered list item, convert it into a TODO item.
function! kolkhis#md_todo_handler()
    let line = getline('.')
    let mode = mode()
    if line ==# ''
        echo 'Problem encountered when parsing line'
        return
    endif
    if mode ==# 'n'
        if kolkhis#match_todo(line)
            exe "s/\(\*\|\d\.\) \[.\] //"
        elseif kolkhis#match_ul(line)
            norm! ^a [ ]
        elseif kolkhis#match_ol(line)
            exe "s/\(\d\.\) /\1 [ ] ]"
        else
            norm! I* [ ] 
        endif
    else
        if kolkhis#match_todo(line)
            norm! I
            exe "'<,'>s/\(\*\|\d\.\) \(\[ \]\|\[x\]\|\[_\]\) //"
        elseif kolkhis#match_ul(line)
            norm! I
            exe "'<,'>s/\* /* [ ] ]"
        elseif kolkhis#match_ol(line)
            norm! I
            exe "'<,'>s/\(\d\.\) /\1 [ ] ]"
        else
            norm! I
            exe "'<,'>s/^\(\s*\)\?\w/\1* [ ] \2/"
        endif
    endif
    echo line
endfunction

function! kolkhis#md_ul_handler()
    let mode = mode()
    let line = getline('.')
    if mode ==# 'n'
        if kolkhis#match_ul(line)
            exe "norm! ^2x" 
        elseif kolkhis#match_ol(line)
            exe "norm! ^3xI* "
        else
            norm! I* 
        endif
    else
        if kolkhis#match_ul(line)
            norm! I
            exe "'<,'>s/* //"
        elseif kolkhis#match_ol(line)
            norm! I
            exe "'<,'>s/^\(\s*\)\?\d\. /\1* /"
        else
            norm! I
            exe "'<,'>s/^\(\s*\)\?\(\w\)/\1* \2/"
        endif
    endif
endfunction

function! kolkhis#md_ol_handler()
    let mode = mode()
    let line = getline('.')
    if mode ==# 'n'
        if kolkhis#match_ol(line)
            exe "norm! ^3x"
        elseif kolkhis#match_ul(line)
            exe "norm! ^2xI1. "
        else
            norm! I1. 
        endif
    else
        if kolkhis#match_ol(line)
            norm! I
            exe "'<,'>s/\d\. //"
        elseif kolkhis#match_ul(line)
            norm! I
            exe "'<,'>s/^\(\s*\)\?\* /\11. /"
        else
            norm! I
            exe "'<,'>s/^\(\s*\)\?\(\w\)/\11. \2/"
        endif
    endif
endfunction

function! kolkhis#md_add_linebreaks()
    let mode = mode()
    if mode ==# 'n'
        exe "%s/\([^,\| \{2}\|`\{3}]$\)/\1  /"
    else
        exe "'<,'>s/\([^,\| \{2}\|`\{3}]$\)/\1  /"
    endif
endfunction


function! kolkhis#match_ol(line)
    return matchstr(a:line, '^\(\s*\)\?\d\+\. ')
endfunction

function! kolkhis#match_ul(line)
    return matchstr(a:line, '^\(\s*\)\?\* ')
endfunction

function! kolkhis#match_todo(line)
    return matchstr(a:line, '^\(\s*\)\?\(\*\|\d\.\) \(\[ \]\|\[x\]\|\[_\]\) ')  
endfunction



" Turn camelCase to snake_case, and vice versa
function! kolkhis#camel_snake_toggle()
    let cword = expand('<cword>')
    let camelCase = matchstr(cword, '^\l.*\(\u\)')
    let snake_case = matchstr(cword, '^\w.*\(_\)')
    let new_word = cword
    if snake_case !=# ''
        let all_caps =
