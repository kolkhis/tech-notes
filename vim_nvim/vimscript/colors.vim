syntax enable
hi clear

" General settings
set background=dark

" Basic txt/bg
hi Normal guifg=#B0C4DE guibg=#090B10
hi Cursor guifg=#FFCC00 guibg=#FFCC00

" Syntax
hi Constant guifg=#BB80B3
hi String guifg=#4DB6AC
hi Function guifg=#82AAFF
hi Statement guifg=#89DDFF
hi Comment guifg=#A1ACB3
hi Type guifg=#FFCB6B
hi PreProc guifg=#F07178

" select highlights
hi Search guibg=#F07178 guifg=#000000
hi Visual guifg=Black guibg=DarkRed
hi IncSearch guifg=Black guibg=DarkRed

" gutter
hi LineNr guifg=#546E7A
hi Special guifg=#F78C6C

" status line
let s:active_font_color = '#7286D3'
let s:inactive_font_color = '#144272'
let s:inactive_window = '#181D31'
let s:active_window = '#0A2647'
exe 'hi StatusLine guifg=' . s:active_window . ' guibg=' . s:active_font_color
exe 'hi StatusLineNC guifg=' . s:inactive_window . ' guibg=' . s:inactive_font_color
exe 'hi StatusLineTerm guifg=' . s:active_window . ' guibg=' . s:active_font_color

" tabs
exe 'hi TabLine guifg=' . s:inactive_font_color . ' guibg=' . s:inactive_window
exe 'hi TabLineFill guifg=' . s:inactive_window . ' guibg=' . s:active_font_color
exe 'hi TabLineSel guifg=' . s:active_font_color . ' guibg=' . s:active_window

" vsplit
let s:split_color = "#2B3A55"
exe 'hi VertSplit guifg=' . s:split_color . ' guibg=' . "NONE"

" other stuff
hi MatchParen guifg=#C792EA guibg=#000000
hi NonText guifg=#546E7A

" highlighting
hi helpHyperTextJump guifg=#82AAFF guibg=NONE
hi helpHyperTextEntry guifg=#89DDFF guibg=NONE

" netrw
hi netrwDir guifg=#82AAFF guibg=NONE
hi netrwClassify guifg=#89DDFF guibg=NONE
hi netrwLink guifg=#F07178 guibg=NONE
hi netrwSymLink guifg=#F07178 guibg=NONE
hi netrwExe guifg=#C3E88D guibg=NONE
hi netrwComment guifg=#A1ACB3 guibg=NONE
hi netrwListstyle guifg=#BB80B3 guibg=NONE
hi netrwCmdSep guifg=#C792EA guibg=NONE
hi netrwVersion guifg=#80CBC4 guibg=NONE


" folds
hi Folded guifg=#A1ACB3 guibg=#263238
hi FoldColumn guifg=#80CBC4 guibg=#263238
hi SignColumn guifg=NONE guibg=#263238

" popup menu
hi Pmenu guifg=#546E7A guibg=#121212
hi PmenuSel guifg=#80CBC4 guibg=#121212
hi PmenuSbar guifg=#A1ACB3 guibg=#263238
hi PmenuThumb guifg=#80CBC4 guibg=#121212

" misc
hi ModeMsg guifg=#80CBC4 guibg=NONE
hi MoreMsg guifg=#82AAFF guibg=NONE
hi QuickFixLine guifg=#FFFFFF guibg=#558EC0
hi Terminal guifg=#A1ACB3 guibg=#1E272C
hi Title guifg=#80CBC4 guibg=NONE
hi WarningMsg guifg=#F07178 guibg=NONE


let s:dark_ocean_bg = "#0a0c14"
" exe 'highlight Normal guifg=' . 'White' . ' guibg=' . s:dark_ocean_bg

let s:light_ocean_bg = "#0f111a"
exe 'highlight Normal guifg=' . 'White' . ' guibg=' . s:light_ocean_bg

let s:comments = "#626983"
let s:strings = "#b0d181"
" let s:strings = "#bce28c"
" let s:strings = "#8da86b"

exe 'hi String guifg=' . s:strings
exe 'hi Comment guifg=' . s:comments

com! LightMode exe 'highlight Normal guifg=' . 'White' . ' guibg=' . s:light_ocean_bg
com! DarkMode exe 'highlight Normal guifg=' . 'White' . ' guibg=' . s:dark_ocean_bg

com! LM LightMode
com! DM DarkMode

