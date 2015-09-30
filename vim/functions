fu! StripTrailingWhitespaces()
  " last search and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  
  " remove trailing whitespaces
  %s/\s\+$//e
  
  " restore previous search history and cursor position
  let @/=_s
  call cursor(l, c)
endf

function! CloseHiddenBuffers()
  " figure out which buffers are visible in any tab
  let visible = {}
  for t in range(1, tabpagenr('$'))
    for b in tabpagebuflist(t)
      let visible[b] = 1
    endfor
  endfor
  " close any buffer that's loaded and not visible
  for b in range(1, bufnr('$'))
    if bufloaded(b) && !has_key(visible, b)
      exe 'bd ' . b
    endif
  endfor
endfun

function! SetLineLength(length)
  let b:linelength = a:length
  call SetColorColumn()
endfunction
function! SetColorColumn()
  if !exists('b:linelength')
    let b:linelength = 100
  endif
  exec "set colorcolumn=" . (b:linelength + 1)
endfunction
command! -nargs=1 LineLength call SetLineLength(<args>)
