syntax match _Operator display "[-+&|<>=!\/~.,;:*%&^?{}]"
hi link _Operator Operator
syntax keyword _Expression new
hi link _Expression Statement

syn match javaObject /\<\u\w*\l\w*\>/ display
hi def link javaObject Type
