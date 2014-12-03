function! StatusLineMode(mode)
  let cmode=mode()
  if cmode == 'v' || cmode == 'V'
    highlight StatusLineMode ctermfg=Gray ctermbg=DarkBlue
    return 'Visual'
  elseif cmode == 'R'
    highlight StatusLineMode ctermfg=Yellow ctermbg=Brown
    return 'Replace'
  elseif cmode == 'i'
    highlight StatusLineMode ctermfg=LightGreen ctermbg=DarkGreen
    return 'Insert'
  else
    highlight StatusLineMode ctermfg=None ctermbg=DarkGray cterm=None
    return 'Normal'
  end
endfunction

function! Status(i)
  let s = ''
  let bufnr = tabpagebuflist()[a:i - 1]
  let fullpath = bufname(bufnr)
  let path = fnamemodify(fullpath, ':~:.:h')
  let filename = fnamemodify(fullpath, ':t')
  if winnr() == a:i
    let s .= '%#StatusLineMode# %{StatusLineMode(v:insertmode)} %#StatusLine#'
    let s .= ' '
    let s .= '%#StatusLineFaded#' . path . '/'
    let s .= '%#StatusLine#' . filename
    let s .= '%#StatusLineFaded#'
  else
    let s .= '%#StatusLineNC# '
    let s .= '%#StatusLineNCFaded#' . path . '/'
    let s .= '%#StatusLineNC#' . filename
    let s .= '%#StatusLineNCFaded#'
  end
  let s .= ' %m%r%h%w '
  if winnr() == a:i
    let s .= '%=%#StatusLinePositionFaded# #%#StatusLinePosition#%n  '
    let s .= '%#StatusLinePositionFaded#col %#StatusLinePosition#%v  '
    let s .= '%#StatusLinePositionFaded#line %#StatusLinePosition#%l %#StatusLinePositionFaded#/ %#StatusLinePosition#%L '
  end
  return s
endfunction

function! s:RefreshStatus()
  for nr in range(1, winnr('$'))
    call setwinvar(nr, '&statusline', '%!Status(' . nr . ')')
  endfor
endfunction

augroup status
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter,InsertEnter,InsertLeave * call <SID>RefreshStatus()
augroup END

" show the status line
set laststatus=2
