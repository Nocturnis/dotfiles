highlight TabLineFill             ctermfg=Black       ctermbg=Black       cterm=None
highlight TabLine                 ctermfg=DarkGray    ctermbg=Black       cterm=None
highlight TabLineNum              ctermfg=Yellow      ctermbg=Black       cterm=None
highlight TabLineSel              ctermfg=White       ctermbg=None        cterm=None
highlight TabLineSelFaded         ctermfg=DarkGray    ctermbg=None        cterm=None
highlight TabLineNumSel           ctermfg=LightBlue   ctermbg=None        cterm=None
highlight TabLineMore             ctermfg=Black       ctermbg=Yellow      cterm=None

highlight LineNr                  ctermfg=DarkGray    ctermbg=None
highlight CursorLine                                  ctermbg=Black       cterm=None
highlight CursorLineNr            ctermfg=Gray        ctermbg=None
highlight ColorColumn                                 ctermbg=DarkRed
highlight NonText                 ctermfg=Black
highlight SpecialKey              ctermfg=Black
highlight SignColumn                                  ctermbg=None        cterm=None
highlight GitGutterAdd            ctermfg=DarkGreen   ctermbg=DarkGreen   cterm=None
highlight GitGutterChange         ctermfg=Yellow      ctermbg=Yellow      cterm=None
highlight GitGutterDelete         ctermfg=DarkRed     ctermbg=None        cterm=None
highlight GitGutterChangeDelete   ctermfg=DarkRed     ctermbg=Yellow      cterm=None
highlight Search                  ctermfg=Black       ctermbg=Yellow

highlight PreProc                 ctermfg=DarkGray
highlight Constant                ctermfg=DarkMagenta
highlight Comment                 ctermfg=DarkCyan
highlight Operator                ctermfg=DarkGray
highlight Statement               ctermfg=Brown
highlight Type                    ctermfg=DarkGreen

" Java
highlight javaCommentTitle        ctermfg=DarkBlue
highlight javaDocComment          ctermfg=Blue
highlight javaDocParam            ctermfg=Magenta
highlight javaDocTags             ctermfg=DarkCyan
highlight javaString              ctermfg=Magenta
highlight javaParen               ctermfg=LightCyan
highlight javaParen1              ctermfg=LightRed
highlight javaParen2              ctermfg=LightBlue

" JavaScript
highlight javaScriptStringS       ctermfg=Magenta
highlight javaScriptStringD       ctermfg=Magenta
highlight javaScriptRegexpString  ctermfg=Blue
highlight javaScriptNumber        ctermfg=DarkMagenta
highlight javaScriptIdentifier    ctermfg=DarkGreen
highlight javaScriptFunction      ctermfg=DarkGreen
highlight javaScriptBraces        ctermfg=DarkGray
highlight javaScriptParens        ctermfg=DarkGray
" For JavaScript embedded in HTML script tags.
highlight javaScript              ctermfg=None

" Python
highlight pythonString            ctermfg=Magenta
highlight pythonBuiltin           ctermfg=DarkMagenta
highlight pythonFunction          ctermfg=DarkGreen

" HTML
highlight htmlTag                 ctermfg=DarkGray
highlight htmlEndTag              ctermfg=DarkGray
highlight htmlEvent               ctermfg=LightBlue

" Proto
highlight pbString                ctermfg=Magenta

" sh
highlight shDoubleQuote           ctermfg=Magenta
highlight shQuote                 ctermfg=Magenta
highlight shTestDoubleQuote       ctermfg=Magenta
highlight shFunctionKey           ctermfg=DarkGreen
highlight shFunction              ctermfg=None
highlight shVariable              ctermfg=DarkBlue
highlight shDerefSimple           ctermfg=LightBlue
highlight shDerefVar              ctermfg=LightBlue

highlight DiffAdd                 ctermfg=Gray        ctermbg=DarkGreen   cterm=None
highlight DiffDelete              ctermfg=Gray        ctermbg=DarkRed     cterm=None
highlight DiffChange              ctermfg=DarkGray    ctermbg=Yellow      cterm=None
highlight DiffText                ctermfg=Gray        ctermbg=DarkGreen   cterm=None

highlight trailingWhitespace                          ctermbg=DarkRed
highlight ExtraWhitespace                             ctermbg=DarkRed
match ExtraWhitespace /\s\+$/

highlight StatusLine              ctermfg=White       ctermbg=DarkMagenta cterm=None
highlight StatusLineFaded         ctermfg=Magenta     ctermbg=DarkMagenta cterm=None
highlight StatusLineNC            ctermfg=White       ctermbg=DarkGray    cterm=None
highlight StatusLineNCFaded       ctermfg=Gray        ctermbg=DarkGray    cterm=None
highlight StatusLinePosition      ctermfg=Gray        ctermbg=DarkGray    cterm=None
highlight StatusLinePositionFaded ctermfg=None        ctermbg=DarkGray    cterm=None

highlight MatchParen                                  ctermbg=White    cterm=Reverse
