function! StatusLineMode(mode)
  let cmode=mode()
  if cmode == 'v' || cmode == 'V'
    highlight StatusLineMode ctermfg=Gray ctermbg=DarkBlue
    return 'Visual'
  elseif cmode == 'R'
    highlight StatusLineMode ctermfg=Black ctermbg=Yellow
    return 'Replace'
  elseif cmode == 'i'
    highlight StatusLineMode ctermfg=Black ctermbg=Green
    return 'Insert'
  else
    highlight StatusLineMode ctermfg=Gray ctermbg=DarkGray cterm=None
    return 'Normal'
  end
endfunction

function! Status(i)
  let s = ''
  if winnr() == a:i
    let s .= '%#StatusLineMode# %{StatusLineMode(v:insertmode)} %#StatusLine#'
  else
    let s .= '%#StatusLineNC#'
  end
  let s .= ' %F%m%r%h%w '
  if winnr() == a:i
    let s .= '%=%#StatusLinePosition# col %v, line %l / %L '
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
