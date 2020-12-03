"{{{ let s:palette
let s:palette = {
      \ 'bg0':        ['#282828',   '235',  'Black'],
      \ 'bg1':        ['#302f2e',   '236',  'DarkGrey'],
      \ 'bg2':        ['#32302f',   '236',  'DarkGrey'],
      \ 'fg0':        ['#d4be98',   '223',  'White'],
      \ 'fg1':        ['#ddc7a1',   '223',  'White'],
      \ 'red':        ['#ea6962',   '167',  'Red'],
      \ 'orange':     ['#e78a4e',   '208',  'DarkYellow'],
      \ 'yellow':     ['#d8a657',   '214',  'Yellow'],
      \ 'green':      ['#a9b665',   '142',  'Green'],
      \ 'aqua':       ['#89b482',   '108',  'Cyan'],
      \ 'grey':       ['#868d80',   '109',  'Blue'],
      \ 'purple':     ['#d3869b',   '175',  'Magenta'],
      \ 'none':       ['NONE',      'NONE', 'NONE'],
      \ 'blue':       ['#399ce5', '175', 'Blue'],
      \ }
"}}}
" {{{ function! s:HL
function! s:HL(group, fg, bg, ...)
    let hl_string = [
          \ 'highlight', a:group,
          \ 'guifg=' . a:fg[0],
          \ 'guibg=' . a:bg[0],
          \ ]
    if a:0 >= 1
      if a:1 ==# 'undercurl'
        call add(hl_string, 'gui=undercurl')
        call add(hl_string, 'cterm=underline')
      else
        call add(hl_string, 'gui=' . a:1)
        call add(hl_string, 'cterm=' . a:1)
      endif
    else
      call add(hl_string, 'gui=NONE')
      call add(hl_string, 'cterm=NONE')
    endif
    if a:0 >= 2
      call add(hl_string, 'guisp=' . a:2[0])
    endif
    execute join(hl_string, ' ')
endfunction
"}}}

" 切换colorscheme时需要调用这个函数覆盖默认的设置
function mylib#highlight#render_custom_highlight() abort
    "{{{ TODO: FIXME: BUG: NOTE: HACK: 自定义标记配色
        highlight! MyTodo cterm=bold ctermbg=None  gui=bold guifg=#ff8700
        highlight! MyNote cterm=bold ctermbg=None  gui=bold guifg=#19dd9d
        highlight! MyFixme cterm=bold ctermbg=None  gui=bold guifg=#e697e6
        highlight! MyBug cterm=bold ctermbg=None  gui=bold guifg=#dd698c
        highlight! MyHack cterm=bold ctermbg=None  gui=bold guifg=#f4da9a
        highlight! link MyTip MyHack

    augroup highlight_my_keywords
        autocmd!
        autocmd Syntax * call matchadd('MyTodo',       '\W\zs\(TODO\|CHANGED\|XXX\|DONE\):')
        autocmd Syntax * call matchadd('MyNote',       '\W\zsNOTE:')
        autocmd Syntax * call matchadd('MyFixme',      '\W\zsFIXME:')
        autocmd Syntax * call matchadd('MyBug',        '\W\zs\(BUG\|DEPRECIATED\):')
        autocmd Syntax * call matchadd('MyHack',       '\W\zsHACK:')
        autocmd Syntax * call matchadd('MyTip',        '\W\zsTIP:')
    augroup end
    "}}}
    " {{{ 折叠，侧栏，Signature的mark标记，行号, ALE, Signify
    "             高亮组名     前景色         背景色
    call s:HL('FoldColumn', s:palette.grey, s:palette.bg2)
    call s:HL('Folded', s:palette.grey, s:palette.none)
    call s:HL('SignColumn', s:palette.fg0, s:palette.none)
    call s:HL('OrangeSign', s:palette.orange, s:palette.none)
    call s:HL('PurpleSign', s:palette.purple, s:palette.none)
    call s:HL('BlueSign', s:palette.blue, s:palette.none)
    " vsplit分割线
    highlight! VertSplit guifg=#658494 guibg=None
    " kshenoy/vim-signature 标记的配色
    hi! link SignatureMarkText OrangeSign
    hi! link SignatureMarkerText PurpleSign
    " highlight! LineNr guifg=#717172
    hi! LineNr guifg=#9d9d9d guibg=none
    hi! ALEErrorSign gui=bold guifg=#dd7186 guibg=none
    hi! ALEWarningSign gui=bold guifg=#d8a657 guibg=none
    hi! SignifySignAdd guifg=#87bb7c guibg=none
    hi! SignifySignDelete guifg=#dd7186 guibg=none
    hi! SignifySignChange guifg=#d5b875 guibg=none
    hi! DiffAdd guibg=#4e6053
    hi! DiffDelete guibg=#614b51
    hi! DiffChange guibg=#497783
    " 单词级对比
    hi! DiffText guifg=#aebbc5 guibg=#2d5377
"}}}
" {{{ startify启动页面
    hi! StartifyHeader gui=bold guifg=#87bb7c
    hi! StartifySection guifg=#7daea3
    hi! StartifyFile  gui=None guifg=#d8b98a
    hi! StartifyNumber gui=None guifg=#7daea3

"}}}
" {{{ Spelunker 拼写检查
    " spelunker 显示错误单词的颜色
    highlight! SpelunkerSpellBad cterm=undercurl ctermfg=247 gui=undercurl guifg=#9e9e9e
    highlight! SpelunkerComplexOrCompoundWord cterm=undercurl ctermfg=247 gui=undercurl guifg=#9e9e9e
"}}}
"{{{让JSONC的注释高亮正常
augroup enable_comment_highlighting_for_json
    autocmd!
    autocmd Filetype,BufWinEnter json set syntax=off | set syntax=on | syntax match Comment +\/\/.\+$+
augroup end
"}}}
"{{{ Vim-Which-Key高亮
highlight! WhichKey gui=None guifg=#c765c8
highlight! WhichKeySeperator gui=None guifg=#00b37d
highlight! WhichKeyGroup   gui=None guifg=#3397dd
highlight! WhichKeyDesc    gui=None  guifg=#5686dd
" 让弹窗背景自适应主题的背景色
highlight! WhichKeyFloating gui=None
"}}}
" {{{浮动终端配色
hi! FloatermNF guibg=None
hi! FloatermBorderNF guibg=None guifg=#828282
"}}}
" {{{ Illuminate相同单词高亮
hi link illuminatedWord Visual
"}}}
"{{{取消snippets文件前导空格高亮
hi! snipLeadingSpaces guibg=None
hi! link snipSippetFooterKeyword snipSnippetHeaderKeyword
"}}}
"{{{ vim-bookmarks
highlight! BookmarkSign guifg=#399ce5
highlight! BookmarkAnnotationSign guifg=#399ce5
"}}}
endfunction

"{{{ 切换透明模式, 需要预先设置好终端的透明度 <leader>tt
function s:Enable_transparent_scheme() abort
    call s:HL('FoldColumn', s:palette.grey, s:palette.none)
    call s:HL('Folded', s:palette.grey, s:palette.none)
    call s:HL('SignColumn', s:palette.none, s:palette.none)
    call s:HL('OrangeSign', s:palette.orange, s:palette.none)
    call s:HL('PurpleSign', s:palette.purple, s:palette.none)
    call s:HL('BlueSign', s:palette.none, s:palette.none)
endfunction

let g:in_transparent_mode = 0
function! mylib#highlight#toggle_transparent_background()
  if g:in_transparent_mode == 1
    let s:in_transparent_mode = 0
    set laststatus=2
    setlocal cursorline
    syn off | syn on
    " illuminate插件
    silent! IlluminationEnable
    call My_render_custom_highlight()
  else
    let g:in_transparent_mode = 1
    set laststatus=0
    setlocal nocursorline
    hi Normal guibg=NONE ctermbg=NONE
    silent! IlluminationDisable
    silent! NoMatchParen
    call s:Enable_transparent_scheme()
  endif
endfunction
"}}}
