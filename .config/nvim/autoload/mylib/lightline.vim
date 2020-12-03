"{{{
function! mylib#lightline#File_change_status()
  " 防止--noplugin模式下报错
  if g:disable_laggy_plugins_for_large_file == 1
    return ''
  endif

  let l:symbols = ['+', '-', '~']
  let [added, modified, removed] = sy#repo#get_stats()
  let l:stats = [added, removed, modified]  " reorder
  let hunkline = ''
  for i in range(3)
    if l:stats[i] > 0
      let hunkline .= printf('%s%s ', l:symbols[i], l:stats[i])
    endif
  endfor
  if !empty(hunkline)
    let hunkline = printf('[%s]', hunkline[:-2])
  endif
  return winwidth(0) > 70 ? hunkline : ''
endfunction

function! mylib#lightline#gitbranch()
    let l:result = ''
    if &ft !~? 'vimfiler'
        let l:result = FugitiveHead() != '' ? '[' . FugitiveHead() . ']' : ''
    endif
    return winwidth(0) > 45 ? l:result : ''
endfunction

function! LightlineFileformat()
    let l:result = &fenc != "" ? &fenc : &enc
    let l:result = l:result . '[' . &ff . ']'
    return winwidth(0) > 70 ? l:result : ''
endfunction

function LightLineFiletype()
    if !exists('*WebDevIconsGetFileTypeSymbol')  " 判断是否启用devicon插件
        let l:result = &ft != "" ? &ft : "no ft"
    else
        let l:result = &ft != "" ? &ft . ' ' . WebDevIconsGetFileTypeSymbol() : "no ft"
    endif
    return winwidth(0) > 70 ? l:result : ''
endfunction

function! NearestMethodOrFunction() abort
  return winwidth(0) > 70 ? get(b:, 'vista_nearest_method_or_function', '') : ''
endfunction

function! Tab_num(n) abort
  return a:n
endfunction

function! RemoveLabelOnTopRight() abort
    return ""
endfunc

function! Get_session_name() abort
    let l:session_name = fnamemodify(v:this_session,':t:r')
    return l:session_name != '' ? '<' . l:session_name . '>' : ''
endfunction

function If_in_merge_or_diff_mode() abort
  if get(g:, 'mergetool_in_merge_mode', 0)  " merge模式
    return 'merge mode'
  endif
  if &diff
    return 'diff mode'  " diff模式
  endif
  return ''
endfunc

fun My_tab_name(tab_n)
    if exists('*WebDevIconsGetFileTypeSymbol') && exists('*lightline#tab#filename')
        let l:result = WebDevIconsGetFileTypeSymbol(lightline#tab#filename(a:tab_n)) . ' ' . lightline#tab#filename(a:tab_n)
    elseif exists('*lightline#tab#filename')
        let l:resutl = lightline#tab#filename(a:tab_n)
    else
        let l:result = expand('%:t')
    endif
    return l:result
endf
"}}}
