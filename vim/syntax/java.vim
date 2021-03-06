syntax match _Operator display "[-+&|<>=!\/~.,;:*%&^?{}]"
hi link _Operator Operator
syn cluster javaTop add=_Operator

syntax keyword _Expression new
hi link _Expression Statement

syn match javaObject /\<\u\w*\l\w*\>/ display
hi def link javaObject Type
syn cluster javaTop add=javaObject

syn match javaConstantName /\<\u[A-Z0-9_]*\u\>/ display
hi def link javaConstantName Constant
syn cluster javaTop add=javaConstantName
