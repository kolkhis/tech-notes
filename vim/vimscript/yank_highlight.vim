
" Highlight on yank:
if v:version >= 801
    " Version needs to be 8.01+ for the TextYankPost 
    aug highlightYankedText
        au!
        au TextYankPost * call YankHighlight()
    aug end

    fu! YankHighlight()
        if v:event['operator'] == 'y'
            if (!exists('g:yanked_text_matches'))
                let g:yanked_text_matches = []
            endif

            let g:yank_match_id = matchadd('IncSearch', ".\\%>'\\[\\_.*\\%<']..")
            let g:yank_window_id = winnr()
            call add(g:yanked_text_matches, [g:yank_match_id, g:yank_window_id])
            call timer_start(100, 'DelYankHighlight')
        endif
    endf

    fu! DelYankHighlight(timer_id)
        while !empty(g:yanked_text_matches)
            let l:match = remove(g:yanked_text_matches, 0)
            let l:match_id = l:match[0]
            let l:window_id = l:match[1]
            try
                call matchdelete(l:match_id, l:window_id)
            endtry
        endwhile
    endf

endif

