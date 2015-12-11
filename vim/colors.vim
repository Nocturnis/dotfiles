highlight TabLineFill             ctermfg=Black       ctermbg=Black       cterm=None
highlight TabLine                 ctermfg=DarkGray    ctermbg=Black       cterm=None
highlight TabLineNum              ctermfg=Yellow      ctermbg=Black       cterm=None
highlight TabLineSel              ctermfg=White       ctermbg=None        cterm=None
highlight TabLineSelFaded         ctermfg=DarkGray    ctermbg=None        cterm=None
highlight TabLineNumSel           ctermfg=LightBlue   ctermbg=None        cterm=None
highlight TabLineMore             ctermfg=Black       ctermbg=Yellow      cterm=None

highlight LineNr                  ctermfg=DarkGray    ctermbg=Black
highlight CursorLine                                  ctermbg=Black       cterm=None
highlight CursorLineNr            ctermfg=Gray        ctermbg=Black
highlight ColorColumn                                 ctermbg=DarkRed
highlight NonText                 ctermfg=White       ctermbg=Black
highlight SpecialKey              ctermfg=Black       ctermbg=None
highlight SignColumn                                  ctermbg=Black       cterm=None
highlight GitGutterAdd            ctermfg=DarkGreen   ctermbg=DarkGreen   cterm=None
highlight GitGutterChange         ctermfg=Yellow      ctermbg=Yellow      cterm=None
highlight GitGutterDelete         ctermfg=DarkRed     ctermbg=Black       cterm=None
highlight GitGutterChangeDelete   ctermfg=DarkRed     ctermbg=Yellow      cterm=None
highlight SignatureMarkText       ctermfg=White       ctermbg=DarkBlue
highlight SignatureMarkerText     ctermfg=White       ctermbg=DarkBlue
highlight EclimHighlightInfo      ctermfg=DarkBlue    ctermbg=Gray
highlight EclimHighlightWarning   ctermfg=DarkYellow  ctermbg=Gray
highlight EclimHighlightError     ctermfg=White       ctermbg=LightRed
highlight Search                  ctermfg=Black       ctermbg=Yellow

highlight IndentGuidesOdd                             ctermbg=None
highlight IndentGuidesEven                            ctermbg=Black

highlight PreProc                 ctermfg=DarkGray
highlight Constant                ctermfg=DarkMagenta
highlight Comment                 ctermfg=DarkCyan                        cterm=Reverse
highlight Operator                ctermfg=DarkGray
highlight Statement               ctermfg=Brown
highlight Type                    ctermfg=DarkGreen

" Java
highlight javaCommentTitle        ctermfg=DarkBlue    ctermbg=None        cterm=Reverse
highlight javaDocComment          ctermfg=Blue        ctermbg=None        cterm=None
highlight javaDocParam            ctermfg=Magenta     ctermbg=None        cterm=None
highlight javaDocTags             ctermfg=DarkCyan    ctermbg=None        cterm=None
highlight javaString              ctermfg=Magenta
highlight javaParen               ctermfg=LightCyan
highlight javaParenT              ctermfg=LightCyan
highlight javaParen1              ctermfg=LightRed
highlight javaParenT1             ctermfg=LightRed
highlight javaParen2              ctermfg=LightBlue
highlight javaParenT2             ctermfg=LightBlue
highlight javaObject              ctermfg=DarkBlue
highlight javaConstantName        ctermfg=LightRed

" Apollo
highlight apolloDocComment        ctermfg=Blue        ctermbg=None        cterm=None
highlight apolloDocParam          ctermfg=Magenta     ctermbg=None        cterm=None
highlight apolloDocTags           ctermfg=DarkCyan    ctermbg=None        cterm=None
highlight apolloObject            ctermfg=DarkBlue    ctermbg=None        cterm=None
highlight apolloString            ctermfg=Magenta     ctermbg=None        cterm=None
highlight apolloBracket           ctermfg=DarkGray    ctermbg=None        cterm=None
highlight apolloParen             ctermfg=DarkGray    ctermbg=None        cterm=None

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

" Coffeescript
highlight coffeeCurly             ctermfg=DarkGray
highlight coffeeBracket           ctermfg=DarkGray
highlight coffeeSpecialOp         ctermfg=DarkGray
highlight coffeeParen             ctermfg=DarkGray
highlight coffeeString            ctermfg=LightMagenta

" Python
highlight pythonString            ctermfg=Magenta
highlight pythonBuiltin           ctermfg=DarkMagenta
highlight pythonFunction          ctermfg=DarkGreen

" HTML
highlight htmlTag                 ctermfg=DarkGray
highlight htmlEndTag              ctermfg=DarkGray
highlight htmlEvent               ctermfg=LightBlue

" Soy
highlight soyBraces               ctermfg=Red
highlight soyEndCommand           ctermfg=Red
highlight soyTemplateName         ctermfg=None
highlight soyEqualInArg           ctermfg=DarkGray

" Proto
highlight pbString                ctermfg=Magenta

" Go
highlight goString                ctermfg=Magenta

" sh
highlight shDoubleQuote           ctermfg=Magenta
highlight shQuote                 ctermfg=Magenta
highlight shTestDoubleQuote       ctermfg=Magenta
highlight shFunctionKey           ctermfg=DarkGreen
highlight shFunction              ctermfg=None
highlight shVariable              ctermfg=DarkBlue
highlight shDerefSimple           ctermfg=LightBlue
highlight shDerefVar              ctermfg=LightBlue

" zsh
highlight zshString               ctermfg=LightMagenta

highlight DiffAdd                 ctermfg=Gray        ctermbg=DarkGreen   cterm=None
highlight DiffDelete              ctermfg=Gray        ctermbg=DarkRed     cterm=None
highlight DiffChange              ctermfg=DarkGray    ctermbg=Yellow      cterm=None
highlight DiffText                ctermfg=Gray        ctermbg=DarkGreen   cterm=None

highlight trailingWhitespace                          ctermbg=DarkRed
highlight ExtraWhitespace                             ctermbg=DarkRed
syn match ExtraWhitespace /\s\+$/

highlight StatusLine              ctermfg=White       ctermbg=DarkYellow  cterm=None
highlight StatusLineFaded         ctermfg=Yellow      ctermbg=DarkYellow  cterm=None
highlight StatusLineNC            ctermfg=White       ctermbg=DarkGray    cterm=None
highlight StatusLineNCFaded       ctermfg=None        ctermbg=DarkGray    cterm=None
highlight StatusLinePosition      ctermfg=Gray        ctermbg=DarkGray    cterm=None
highlight StatusLinePositionFaded ctermfg=None        ctermbg=DarkGray    cterm=None
highlight VertSplit               ctermfg=DarkGray    ctermbg=DarkGray    cterm=None

highlight MatchParen              ctermfg=White       ctermbg=Blue        cterm=None
highlight TagbarSignature         ctermfg=DarkBlue
