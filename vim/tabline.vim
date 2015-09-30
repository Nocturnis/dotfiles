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
      else
        let paths = []
        for i in range(len(info_list))
          call add(paths, info_list[i].title)
        endfor
        let collapsed_paths = CollapsePaths(paths)
        for i in range(len(info_list))
          let info_list[i].title = collapsed_paths[i]
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

" Given a list of paths, collapses common elements into ..., always keeping
" the filename intact.  Assumes all paths are the same length.
" ex:
" ['src/org/foo/bar/Baz.java', 'test/org/foo/bar/Baz.java']
" => ['src/.../Baz.java', 'test/.../Baz.java']
function! CollapsePaths(paths)
  let paths_split = []
  for path in a:paths
    call add(paths_split, split(fnamemodify(path, ':h'), '/'))
  endfor
  let common_elements = paths_split[0]
  let common = []
  for i in range(len(common_elements))
    call add(common, 1)
  endfor
  for apath in paths_split
    for i in range(len(common_elements))
      let common_element = common_elements[i]
      let element = apath[i]
      if element != common_element
        let common[i] = 0
      endif
    endfor
  endfor
  let result = []
  for j in range(len(paths_split))
    let bpath = paths_split[j]
    let result_path = ''
    for i in range(len(bpath))
      let element = bpath[i]
      if !common[i]
        if len(result_path) > 0
          let result_path = result_path . '/'
        endif
        let result_path = result_path . element
      else
        if i == 0 || !common[i - 1]
          if len(result_path) > 0
            let result_path = result_path . '/'
          endif
          let result_path = result_path . '...'
        endif
      endif
    endfor
    if len(result_path) > 0
      let result_path = result_path . '/'
    endif
    let result_path = result_path . fnamemodify(a:paths[j], ':t')
    call add(result, result_path)
  endfor
  return result
endfunction

" Returns a list with all the duplicates in list removed.  The ordering of the
" result is arbitrary.
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

" Strips the non-printed characters (highlighting etc.) from the given string.
function! StripNonPrinted(str)
  let result = substitute(a:str, '%#[a-zA-Z0-9]\+#', '', 'g')
  let result = substitute(result, '%[0-9]\+T', '', 'g')
  let result = substitute(result, '%X', '', 'g')
  return result
endfunction

function! Tabline()
  let buffer_filepaths = []
  for i in range(bufnr('$') + 1)
    if bufexists(i) && buflisted(i) && bufloaded(i)
      let bufname = bufname(i)
      if bufname != ''
        call add(buffer_filepaths, fnamemodify(bufname, ':p'))
      endif
    endif
  endfor
  let shortened_filepaths = ShortenFilepaths(buffer_filepaths)

  let s = ''
  let tabs = []
  let totaltablinelength = 0
  let numtabs = tabpagenr('$')
  for i in range(numtabs)
    let tabnr = i + 1
    let winnr = tabpagewinnr(tabnr)
    let buflist = tabpagebuflist(tabnr)
    let buftitles = []
    for j in range(len(buflist))
      let bufnr = buflist[j]
      let bufname = bufname(buflist[j])
      let longbufname = fnamemodify(bufname, ':p')
      let buftitle = ''
      if tabnr == tabpagenr()
        if j == winnr() - 1
          let buftitle .= "%#TabLineSel#"
        else
          let buftitle .= "%#TabLineSelFaded#"
        endif
      endif
      if bufname == ''
        let buftitle .= '[No Name]'
      elseif has_key(shortened_filepaths, longbufname)
        let buftitle .= shortened_filepaths[longbufname]
      else
        let buftitle .= fnamemodify(bufname, ':t')
      endif
      let bufmodified = getbufvar(bufnr, "&mod")
      if tabnr == tabpagenr()
        let buftitle .= "%#TabLineSelFaded#"
      endif
      if bufmodified
        let buftitle .= '*'
      endif
      " let buftitle .= (tabnr == tabpagenr() ? (j + 1) . '/' . winnr() : '')

      if buftitle != '__Tagbar__'
        call add(buftitles, buftitle)
      endif
    endfor
    let tabname = join(buftitles, ', ')

    let tab = ''
    let tab .= '%' . tabnr . 'T'
    let tab .= (tabnr == tabpagenr() ? '%#TabLineNumSel#' : '%#TabLineNum#')
    let tab .= ' ' . tabnr
    let tab .= (tabnr == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
    let tab .= ' '
    let tab .= tabname
    let tab .= ' '
    let tab .= '%X'
    let totaltablinelength += len(StripNonPrinted(tab)) + 1
    call add(tabs, tab)
  endfor
  if totaltablinelength > &columns
    let direction = 1
    let leftindex = tabpagenr() - 1
    let rightindex = tabpagenr() - 1
    let spaceremaining = &columns - len(StripNonPrinted(tabs[leftindex]))
    let spilledonce = 0
    let lefttabsremaining = 0
    let righttabsremaining = 0
    while spaceremaining > 0 && (leftindex > 0 || rightindex < numtabs - 1)
      let tabtoadd = ''
      if direction == -1
        if leftindex == 0
          let direction = -direction
          continue
        endif
        let tabtoadd = tabs[leftindex - 1]
      else
        if rightindex == numtabs - 1
          let direction = -direction
          continue
        endif
        let tabtoadd = tabs[rightindex + 1]
      endif
      let tabsize = len(StripNonPrinted(tabtoadd))
      let moretabssize = 0
      if leftindex > 0
        let moretabssize = 9
      endif
      if rightindex < numtabs - 1
        let moretabssize += len(numtabs . "") + 8
      endif
      if spaceremaining > (tabsize + 1 + moretabssize)
        if direction == -1
          let leftindex -= 1
        else
          let rightindex += 1
        endif
        let spaceremaining -= tabsize + 1
      elseif !spilledonce
        let spilledonce = 1
      else
        break
      endif
      let direction = -direction
      " echom leftindex . " : " . rightindex . ", " . spaceremaining . " remaining"
    endwhile
    let s = ''
    let leftemptyspace = 0
    let rightemptyspace = 0
    let moretabssize = 0
    if leftindex > 0
      let moretabssize = 9
    endif
    if rightindex < numtabs - 1
      let moretabssize += len(numtabs . "") + 8
    endif
    if leftindex > 0 && rightindex < numtabs - 1
      let leftemptyspace = (spaceremaining - moretabssize) / 2
      let rightemptyspace = spaceremaining - moretabssize - leftemptyspace
    elseif leftindex > 0
      let leftemptyspace = spaceremaining - moretabssize
    elseif rightindex < numtabs - 1
      let rightemptyspace = spaceremaining - moretabssize
    endif
    let lefttabsremaining = leftindex
    let righttabsremaining = numtabs - 1 - rightindex
    if lefttabsremaining > 0
      let s .= '%#TabLineMore# <- 1... '
    endif
    let s .= '%#TabLineFill#'
    for i in range(leftemptyspace)
      let s .= ' '
    endfor
    let s .= join(tabs[leftindex : rightindex], '%#TabLineFill# ')
    let s .= "%#TabLineFill#"
    for i in range(rightemptyspace)
      let s .= ' '
    endfor
    if righttabsremaining > 0
      let s .= '%#TabLineMore# ...' . numtabs . ' -> '
    endif
    return s
  else
    let s = join(tabs, '%#TabLineFill# ')
    let s .= '%#TabLineFill#'
    return s
  endif

endfunction

set tabline=%!Tabline()
