"{{{ 复制当前文件的名字，绝对路径，目录绝对路径
function mylib#utils#copy_to_registers(text) abort
    let @" = a:text
    let @0 = a:text
    let @+ = a:text  " system clipboard on Linux
    let @* = a:text  " system clipboard on Windows
endfunction
"}}}
"{{{ 检查Vim运行性能,结果放在profile.log中,需要用两次 <leader>cp
let s:check_performance_enabled = 0
fun mylib#utils#check_performance()
    if s:check_performance_enabled == 0
        execute 'profile start profile.log'
        execute 'profile file *'
        execute 'profile func *'
        let s:check_performance_enabled = 1
    else
        execute 'profile stop'
        execute 'normal Q'
    endif
endf
"}}}
"{{{ 部分插件开关，提升大文件编辑体验 <F4>
function mylib#utils#faster_mode_for_large_file()
    " 开关spelunker拼写检查插件
    execute 'normal ZT'
    " 这个一般由于向VCS仓库中新增了大文件而导致的大面积column实时重绘, 所以需要关闭
    execute 'SignifyToggle'
    execute 'ALEToggleBuffer'
endfunction
"}}}
"{{{ 行号开关，用于鼠标复制代码用, 为方便复制 <F2>
function! mylib#utils#toggleColumnNumber()
  if(&relativenumber == &number)
    set relativenumber! number!
  elseif(&number)
    set number!
  else
    set relativenumber!
  endif
  set number?
endfunc
"}}}
""{{{ 查看highlighting group <F12>
function! mylib#utils#synstack()
    echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), ' -> ')
endfunction
"}}}
"{{{ 可以直接<leader>c1~9 选择特定主题 <leader>cj/k切换主题
fun mylib#utils#change_colorscheme(mode) abort
  let l:length = len(g:all_colorschemes)
  if a:mode < 0 || a:mode >= l:length
    echo 'failed to change colorscheme: invalid parameter'
    return ''
  endif
  if a:mode == 'next'
    if g:current_coloscheme_mode < l:length - 1
      let g:current_coloscheme_mode += 1
    else
      let g:current_coloscheme_mode = 0
    endif
  elseif a:mode == 'previous'
    if g:current_coloscheme_mode > 0
      let g:current_coloscheme_mode -= 1
    else
      let g:current_coloscheme_mode = l:length - 1
    endif
  else
    let g:current_coloscheme_mode = a:mode
  endif

  execute 'colorscheme ' . g:all_colorschemes[g:current_coloscheme_mode]
  let g:lightline.colorscheme = g:all_lightline_schemes[g:current_coloscheme_mode]

  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
  call mylib#highlight#render_custom_highlight()  " 恢复折叠和column的颜色
  set syntax=on  " 用于刷新syntax解决markdown奇奇怪怪的渲染
endf
"}}}
"{{{ 当有两个窗口时, 滚动另一个窗口 <c-j/k/d/e/gg/G>
function! mylib#utils#ScrollAnotherWindow(mode)
    if winnr('$') <= 1
        return
    endif
    noautocmd silent! wincmd p
    if a:mode == 1
        exec "normal! k"
    elseif a:mode == 2
        exec "normal! j"
    elseif a:mode == 3
        exec "normal! \<c-b>"
    elseif a:mode == 4
        exec "normal! \<c-f>"
    elseif a:mode == 5
        exec "normal! gg"
    elseif a:mode == 6
        exec "normal! G"
    endif
    noautocmd silent! wincmd p
endfunc
"}}}
