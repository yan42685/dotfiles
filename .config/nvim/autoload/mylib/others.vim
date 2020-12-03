"function Settings_for_difftool_mode(){{{
" 对vim作为git difftoll的增强, <leader><leader>q 强制退出difftool
function mylib#others#Settings_for_difftool_mode() abort
    if &diff
        syn off  " 自动关闭语法高亮
        " 强制退出difftool, 不再自动唤起difftool
        noremap <leader><leader>q <esc>:cq<cr>
        noremap Q <esc>:qa<cr>
        " 在diff hunk之间跳转
        noremap gj ]c
        noremap gk [c
    endif
endfunction
"}}}
