" Shortens the given list of filepaths.  Uses the shortest tail possible
" without having any collisions.  Returns a dictionary from the full filepath
" to the shortened name.
function! ShortenFilepaths(filepaths)
  let filepaths = RemoveDuplicates(a:filepaths)
  let filename_to_title_info = {}

  for filepath in filepaths
    let filename = fnamemodify(filepath, ':t')
    let dir = fnamemodify(filepath, ':~:h')
    if !has_key(filename_to_title_info, filename)
      let filename_to_title_info[filename] = []
    endif
    call add(filename_to_title_info[filename], {'title': filename, 'remaining_path': dir, 'full_path': filepath})
  endfor

  for [filename, info_list] in items(filename_to_title_info)
    let disambiguated = len(info_list) == 1
    while !disambiguated
      let disambiguated = 1
      let title_set = {}
      for info in info_list
        if has_key(title_set, info.title)
          let disambiguated = 0
        endif
        let title_set[info.title] = 1
      endfor
      
      if !disambiguated
        for info in info_list
          let info.title = fnamemodify(info.remaining_path, ':t') . '/' . info.title
          let info.remaining_path = fnamemodify(info.remaining_path, ':h')
        endfor
      endif
    endwhile
  endfor

  let results = {}
  for [filename, info_list] in items(filename_to_title_info)
    for info in info_list
      let results[info.full_path] = info.title
    endfor
  endfor
  return results
endfunction

function! RemoveDuplicates(list)
  let d = {}
  for item in a:list
    let d[item] = 1
  endfor
  let result = []
  for [key, n] in items(d)
    call add(result, key)
  endfor
  return result
endfunction

function! Tabline()
  let buffer_filepaths = []
  for i in range(bufnr('$'))
    if bufexists(i) && buflisted(i)
      let bufname = bufname(i)
      if bufname != ''
        call add(buffer_filepaths, fnamemodify(bufname, ':p'))
      endif
    endif
  endfor
  let shortened_filepaths = ShortenFilepaths(buffer_filepaths)

  let s = ''
  for i in range(tabpagenr('$'))
    let tab = i + 1
    let winnr = tabpagewinnr(tab)
    let buflist = tabpagebuflist(tab)
    let buftitles = []
    for j in range(len(buflist))
      let bufnr = buflist[j]
      let bufname = bufname(buflist[j])
      let longbufname = fnamemodify(bufname, ':p')
      let buftitle = ''
      if bufname == ''
        let buftitle = '[No Name]'
      elseif has_key(shortened_filepaths, longbufname)
        let buftitle = shortened_filepaths[longbufname]
      else
        let buftitle = fnamemodify(bufname, ':t')
      endif
      let bufmodified = getbufvar(bufnr, "&mod")
      if bufmodified
        let buftitle .= '*'
      endif
      call add(buftitles, buftitle)
    endfor
    let tabname = join(buftitles, ', ')

    let s .= '%' . tab . 'T'
    let s .= (tab == tabpagenr() ? '%#TabLineNumSel#' : '%#TabLineNum#')
    let s .= ' ' . tab
    let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
    let s .= ' '
    let s .= tabname

    let s .= ' %#TabLineFill# '
  endfor

  let s .= '%#TabLineFill#'
  return s
endfunction

set tabline=%!Tabline()
