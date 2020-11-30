" TODO: 1. 把现在的高亮写在gruvbox_material里
" =========================================
"{{{ 异步加载其他vimrc
function MySourceVim() abort
    exec 'source ~/.config/nvim/async-load.vim'
endfunction

augroup MyLazyLoadingVimrc
    autocmd!
    autocmd User CocNvimInit call coc#add_command('custom.sourceVim', 'call MySourceVim()') | call CocActionAsync('runCommand', 'vim.custom.sourceVim')
augroup end
"}}}
" =========================================
"{{{可自行调整的全局配置

" 设置nvr (neovim-remote 用于在内嵌终端使用outer nvim打开文件) {{{
" editor定义在~/.config/utilities/bin 是可执行的bash文件
let $GIT_EDITOR = 'editor'
augroup setting_for_nvr
    autocmd!
    autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete  " 用于nvr提交git信息
augroup end
"}}}
let g:enable_front_end_layer = 1  " 前端Layer, 启动所有前端相关插件
let g:enable_file_autosave = 1  " 是否自动保存
let g:disable_laggy_plugins_for_large_file = 0  " 在启动参数里设置为1就可以加快打开速度
set updatetime=400  " 检测CursorHold事件的时间间隔,影响性能的主要因素
let g:default_colorscheme_mode = 0
let g:all_colorschemes = ['gruvbox-material', 'quantum', 'forest-night',
            \ ]
let g:lightline_schemes = ['gruvbox_material','quantum', 'forest_night',
            \ ]


let mapleader='<space>'  " 此条命令的位置应在插件之前
let g:mapleader = "\<Space>"
let g:maplocalleader = ','
" 进入git commit buffer在normal模式按<tab>可以显示预设补全, 可以按数字 1...n 快速选择
let g:My_commit_completion_source = ['refactor: ', 'fix: ',
                \  'feat: ', 'docs: ', 'test: ',
                \  'perf: ', 'chore: ', 'revert: ',
                \ ]
let g:My_commit_completion_source_with_emoji = ['🔧 refactor: ', '🔨 fix: ',
                \  '🎉 feat: ', '📝 docs: ', '🏁 test: ',
                \  '⚡ perf: ', '💦 chore: ', '⏪ revert: ',
                \ ]

" style基本用不上, 以及虽然Angular团队把chore改成了ci和build但是对于更通用的提
" 交来说，chore是有存在必要的
" style: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)

" let g:My_commit_completion_source = ['🔧 refactor: ', '🔨 fix: ', '💦 chore: ',
"                 \ '🍻 improvement: ', '🎉 feat: ', '🍦 style: ',  '📝 docs: ',
"                 \ '🏁 test: ', '⚡ perf: ', '⏪ revert: ', '☕ build: ', '🐳 ci: ',
"                 \ ]

" 👀 🐮 🐼 📖 ⚓ 🚧 ✈ 🚀 🔥 ❄ 🎁 🎃 ✨ 🎯 💎 🔔 🎵 🎶 💡 📝 💊 ⚠ ❓ ‼ ❗
" ✅ 🉑 ⏰




let g:in_transparent_mode = 0 " 初始并不在透明模式

"{{{ Disable Preloaded Plugins
let g:loaded_remote_plugins = 1  " remote plugins 在自定义的async-load.vim中才加载
let g:loaded_getscript = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_gzip = 1
let g:loaded_LogiPat = 1
let g:loaded_logipat = 1
let g:loaded_man = 1
let g:loaded_matchit = 1
let g:loaded_matchparen = 1
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
let g:loaded_netrwFileHandlers = 1
let g:loaded_netrwSettings = 1
let g:loaded_rrhelper = 1
let g:loaded_spellfile_plugin  = 1
let g:loaded_tar = 1
let g:loaded_tarPlugin = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_2html_plugin = 1
let g:loaded_vimball = 1
let g:loaded_vimballPlugin = 1
let g:loaded_zip = 1
let g:loaded_zipPlugin = 1
"}}}
"}}}
" =========================================


call plug#begin('~/.vim/plugged')
"{{{ gruvbox-material
Plug 'yan42685/gruvbox-material' " fork from https://github.com/sainnhe/gruvbox-material
"{{{ settings
let g:gruvbox_material_disable_italic_comment = 1
let g:gruvbox_material_enable_italic = 0
" BUG: 会导致部分配色异常并且暂时无解，比如signify的hunkdiff
let g:gruvbox_material_better_performance = 1  " 延迟加载，减少50%加载时间, 大概节约二十多毫秒
"}}}
"}}}

"{{{coc 生态系统, 补全框架
" coc-lists
nnoremap <leader>cl :CocList<cr>

" coc-git
" NOTE: 在CocConfig里关闭了gutter功能, 现在用的是signify的功能

" coc-explorer 文件树
"{{{
function ToggleCocExplorer()
    if &ft == 'startify'
        bd
    endif
  execute 'CocCommand explorer --toggle --width=35 --sources=buffer,file+ ' . getcwd()
endfunction
"}}}
nnoremap <silent> <leader>eo :call ToggleCocExplorer()<CR>
" 如果nvim 打开一个目录就自动打开coc-explorer
augroup Nvim_dir_auto_open_coc_explorer
  autocmd!
  autocmd VimEnter * sil! au! FileExplorer *
  autocmd BufEnter * let d = expand('%') | if isdirectory(d) | bd | call ToggleCocExplorer() | endif
augroup END

" 使用coc-yank (自带复制高亮)
nnoremap <silent> gy :<C-u>CocList --normal -A yank<cr>

" coc-translator  可以先输入再查词, 作为一个简单的英汉词典,
" view word history
nnoremap <leader>vw :CocList translation<cr>
nmap tt <Plug>(coc-translator-p)
vmap tt <Plug>(coc-translator-pv)

" coc-todolist
" 使用方法: 用:CocList todolist打开
" Filter your todo items and perform operations via <Tab>
" Use toggle to toggle todo status between active and completed
" Use edit to edit the description of a todo item
" Use preview to preview a todo item
" Use delete to delete a todo item
nnoremap <leader>tc :CocCommand todolist.create<cr>
nnoremap <leader>tl :CocList todolist<cr>
" clear all notifications
nnoremap <silent> <leader>tx :CocCommand todolist.clearRemind<cr>
nnoremap <leader>tu :CocCommand todolist.upload<cr>
" download todolist from gist
" nnoremap <leader>td :CocCommand todolist.download<cr>
" export todolist as a json/yaml file
" nnoremap <leader>te :CocCommand todolist.export<cr>


" COC自动补全框架
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"{{{

" 部分插件简介
"     coc-syntax coc-marketplace (用于查看所有的coc扩展)
"     coc-todolist (可以同步到gist,具体看github)
"     coc-emoji (仅在markdown里用:触发补全， 查表https://www.webfx.com/tools/emoji-cheat-sheet/)
"     coc-gitignore (按类型添加gitignore, 用法是在已有git初始化的文件夹内CocList gitignore)
"     coc-stylelint 检测css, wxss, scss, less, postcss, sugarss, vue NOTE: 非常建议自己为每个workspace建立配置文件，具体参看vscode对应的配置选项

" vim启动后自动异步安装的插件
let g:coc_global_extensions = [
  \ 'coc-snippets', 'coc-json', 'coc-html', 'coc-css', 'coc-tsserver',
  \ 'coc-python', 'coc-tabnine', 'coc-lists', 'coc-explorer', 'coc-yank',
  \ 'coc-stylelint', 'coc-sh', 'coc-dictionary', 'coc-word', 'coc-emmet',
  \ 'coc-syntax', 'coc-marketplace', 'coc-todolist', 'coc-emoji',
  \ 'coc-gitignore', 'coc-tag', 'coc-floaterm', 'coc-vetur', 'coc-browser',
  \ 'coc-markdownlint', 'coc-clangd', 'coc-git', 'coc-vimlsp', 'coc-fzf-preview',
  \ ]


set hidden  " 隐藏buff非关闭它, TextEdit might fail if hidden is not set.
set cmdheight=2  " 如果不设置为2，每次进入新buffer都需要回车确认...
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set shortmess+=c  " Don't pass messages to ins-completion-menu.
set signcolumn=yes:2  " 如果想要动态扩展，就改成auto:2

" Make <tab> used for trigger completion, completion confirm, snippet expand and jump like VSCode.
" inoremap <silent> <expr> <TAB>
"       \ pumvisible() ? coc#_select_confirm() :
"       \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" 用于在空白行第一列按tab一步缩进到位
" FIXME: 没有添加到下面列表里的文件类型如果cc不能缩进，则tab也不能缩进了, 那么就需要在下面的list新增文件类型
let g:My_quick_tab_blacklist = ['markdown', 'text', 'vim', 'vimwiki', 'gitcommit', 'zsh', 'sh',
            \ 'snippets', 'gitconfig', 'crontab', 'vue']
" inoremap <silent> <expr> <TAB>
"       \ pumvisible() ? coc#_select_confirm() :
"       \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
"       \ <SID>check_back_space() ? (strwidth(getline('.')) == 0 && index(g:My_quick_tab_blacklist, &filetype) < 0 ? '<esc>cc' : '<tab>') :
"       \ coc#refresh()
inoremap <silent> <expr> <TAB>
      \ pumvisible() ? '<c-y>' :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? (strwidth(getline('.')) == 0 && index(g:My_quick_tab_blacklist, &filetype) < 0 ? '<esc>cc' : '<tab>') :
      \ coc#refresh()
" Use <cr> to confirm completion,
cnoremap <expr> <cr> pumvisible() ? "\<C-y><BS>" : "<CR>"
"{{{ s:Return_for_tag()
fun My_get_current_tag()
    return matchstr(matchstr(getline('.'),
                \ '<\zs\(\w\|=\| \|''\|"\)*>\%'.col('.').'c'), '^\a*')
endf
" Cleanly return after autocompleting an html/xml tag.
fun My_return_for_tag()
    " 下面这行不知道为什么用不了，这样就不能清除undo了
    " normal 'a<C-g>u'
    let tag = My_get_current_tag()
    " `<C-g>u` means break undo chain at current position
    return tag != '' && match(getline('.'), '</'.tag.'>') > -1 ?
                \ "\<C-g>u\<cr>\<esc>O" : "\<cr>"
endf
"}}}
inoremap <expr> <cr> pumvisible() ? '<C-y>' : My_return_for_tag()







augroup coc_completion_keybindings
    autocmd!
    " 用VimEnter事件做映射确保最后加载，覆盖插件的默认映射
    autocmd VimEnter * inoremap <silent><expr> <c-j>
        \ pumvisible() ? '<c-n>' :
        \ <SID>check_back_space() ? '<esc>a' :
        \ coc#refresh()
    autocmd VimEnter * inoremap <expr> <c-k> pumvisible() ? '<c-p>' : '<esc>a'

" <up>和<down> 可以根据已输入的字符补全历史命令
    autocmd VimEnter * cnoremap <expr> <c-j>
                            \ pumvisible() ? '<c-n>' : '<down>'
    autocmd VimEnter * cnoremap <expr> <c-k>
                            \ pumvisible() ? '<c-p>' : '<up>'

    " 补全时显示文档和详情
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

" 展示文档
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  endif
endfunction
"}}}
" <C-o>  切换到正常模式(q退出) <C-c>  - 关闭coclist

" 层进式范围选择
" NOTE: 暂时打算用回车映射到％　这样映射是为了在命令行按下<c-f>进入的buffer内，可以在normal模式按回车执行指令
" let g:coc_range_select_map_blacklist = ['vim', 'markdown']
" nmap <expr> <cr> index(g:coc_range_select_map_blacklist, &filetype) >=0 ? '<cr>' : '<Plug>(coc-range-select)'
" vmap <expr> <cr> index(g:coc_range_select_map_blacklist, &filetype) >=0 ? '<cr>' : '<Plug>(coc-range-select)'
" vmap <backspace> <Plug>(coc-range-select-backward)
"
" 在源文件与头文件之间切换
" nnoremap <silent> <leader>gh :CocCommand clangd.switchSourceHeader<cr>
nmap <expr> gh &diff? '<Plug>(MergetoolDiffExchangeLeft)' : '<esc>:CocCommand clangd.switchSourceHeader<cr>'
nmap <expr> gl &diff? '<Plug>(MergetoolDiffExchangeRight)' : '<esc>'


" TODO: 刷新补全列表，不知道对刷新 LSP 有没有作用
inoremap <silent> <expr> <c-tab> cocr#efresh()





"
" Note coc#float#scroll works on neovim >= 0.4.3 or vim >= 8.2.0750
nnoremap <silent><nowait><expr> <m-j> coc#float#has_scroll() ? coc#float#scroll(1) : "\<m-j>"
nnoremap <silent><nowait><expr> <m-k> coc#float#has_scroll() ? coc#float#scroll(0) : "\<m-k>"
inoremap <silent><nowait><expr> <m-j> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<esc>a"
inoremap <silent><nowait><expr> <m-k> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<del>"
" NeoVim-only mapping for visual mode scroll
" Useful on signatureHelp after jump placeholder of snippet expansion
vnoremap <nowait><expr> <m-j> coc#float#has_scroll() ? coc#float#nvim_scroll(1, 1) : "\<m-j>"
vnoremap <nowait><expr> <m-k> coc#float#has_scroll() ? coc#float#nvim_scroll(0, 1) : "\<m-k>"
" 触发鼠标悬浮事件
nnoremap <silent> tp :call CocActionAsync('doHover')<cr>
" 查看文档,并跳转
nnoremap <silent> <m-q> :call <SID>show_documentation()<CR>
nmap <silent> <leader>re <Plug>(coc-rename)
" 跳转到声明
nmap <silent> gD <Plug>(coc-declaration)
" 跳转到定义
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gm <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> ,re <Plug>(coc-refactor)
nmap <silent> gt <Plug>(coc-type-definition)
" 函数文本对象
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
" 可以用来import
nmap <leader>do <Plug>(coc-codeaction)
nnoremap <silent> <leader>sl :CocList sessions<cr>
" 重构
imap <silent> <c-m-v> <esc><Plug>(coc-codeaction)
nmap <silent> <c-m-v> <Plug>(coc-codeaction)
vmap <silent> <c-m-v> <Plug>(coc-codeaction-selected)
" FIXME: 如果不想显示ref的虚拟文本，需要在coc-setting里关闭codelents
nnoremap <leader>cc :CocCommand<cr>
nnoremap <leader>cg :CocConfig<cr>
" rename file
nnoremap <silent> <leader>rn :CocActionAsync('runCommand', 'workspace.renameCurrentFile')<cr>
"}}}

"{{{ Startify
" 启动页面
Plug 'mhinz/vim-startify'
"{{{
let g:startify_lists = [
            \ { 'type': 'sessions',  'header': ['   Sessions']       },
            \ { 'type': 'files',     'header': ['   MRU']            },
            \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
            \ ]

let g:startify_files_number = 15  " 首页显示的MRU文件数量
let g:startify_update_oldfiles = 1  " 自动更新文件
let g:startify_session_persistence = 1  " 持久化session
let g:startify_fortune_use_unicode = 1  " 首页banner使用utf-8字符编码
let g:startify_enable_special = 0  " 不显示<empty buffer> 和 <quit>
let g:startify_session_sort = 1  " Sort sessions by modification time (when the session files were written) rather than alphabetically.
" let g:startify_custom_indices = map(range(1,100), 'string(v:val)')  " index从1开始数起
let g:startify_custom_indices = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0',
            \'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i']  " index从1开始数起
" I got it from https://fsymbols.com/text-art/
let g:utf8_double_moon = [
            \ '┊┊┊┊      ' . '███████╗██╗     ██╗ ██████╗ ██████╗ ███████╗██████╗ ',
            \ '┊┊┊☆      ' . '██╔════╝██║     ██║ ██╔══██╗██╔══██╗██╔════╝██╔══██╗',
            \ '┊┊🌙  *   ' . '█████╗  ██║     ██║ ██████╔╝██████╔╝█████╗  ██║  ██║',
            \ '┊┊        ' . '██╔══╝  ██║     ██║ ██╔═══╝ ██╔═══╝ ██╔══╝  ██║  ██║',
            \ '┊☆ °      ' . '██║     ███████╗██║ ██║     ██║     ███████╗██████╔╝',
            \ '🌙        ' . '╚═╝     ╚══════╝╚═╝ ╚═╝     ╚═╝     ╚══════╝╚═════╝ ',
            \ ]

let g:startify_custom_header =
            \ 'startify#pad(g:utf8_double_moon)'
"}}}
" Project(Session) index
nnoremap <leader>Si :Startify<cr>
nnoremap <leader>Ss :SSave .vim<left><left><left><left>
nnoremap <leader>Sl :CocList sessions<cr>
nnoremap <leader>Sc :SClose<cr>
" function Session_delete() {{{
function Session_delete() abort
    let l:session_name = input('Delete session (without .vim): ') . '.vim'
    execute 'SDelete! ' . l:session_name
    if &filetype == 'startify'
        " 刷新Startify页面
        execute 'Startify'
    endif
endfunction
"}}}
nnoremap <leader>Sd :call Session_delete()<cr>
"}}}
call plug#end()

" ==========================================
" 设置 Settings
" ==========================================
" {{{ 基础设置 Basic Settings
set scrolloff=100  " 让视角始终居中，在vim中好像有性能问题,但是在neovim中不清楚
set termguicolors  " 使用真色彩  NOTE: 此条设置应在colorscheme命令之前
exec 'colorscheme ' . g:all_colorschemes[g:default_colorscheme_mode]
set background=dark
filetype on  " 检测文件类型
filetype indent on  " 针对不同的文件类型采用不同的缩进格式
set tags=./.tags;,.tags  " 让ctags改名为.tags，不污染工作区
set confirm
set linebreak  " 一行文本超过window宽度会wrap，设置此项会让单词按语义分隔而不是按字母分隔
set guicursor+=a:blinkon0  " 仅在gvim生效, 取消cursor的闪烁, 终端下的vim需要自行修改终端cursor设置
set autowriteall  " edit, next等动作时自动写入
set tm=500
set clipboard+=unnamedplus
set clipboard+=unnamed
set shortmess=atI  " 启动的时候不显示那个援助乌干达儿童的提示
set noswapfile
set nobackup nowritebackup  " 取消备份文件
set updatecount =100  " FIXME:如果编辑大文件很慢那么考虑调大这个值 After typing this many characters the swap file will be written to disk
set cursorline  " 突出显示当前行
set diffopt+=vertical,algorithm:patience
set sessionoptions-=curdir  " curdir和sesdir不能同时存在, 后者可以保存多个project的buffer
set sessionoptions-=blank   " 这样加载Session就不会显示coc-explorer和Vista之类的空白页了
set sessionoptions+=localoptions,winpos,options,resize,sesdir
" set t_ti= t_te=  " 设置 退出vim后，内容显示在终端屏幕, 可以用于查看和复制, 不需要可以去掉,
                    " 好处：误删什么的，如果以前屏幕打开，可以找回
" set mouse=r  " 启用鼠标, 可以用右键使用系统剪切板来复制粘贴
set mouse=  " 禁用鼠标
set title  " change the terminal's title
set novisualbell  " 去掉输入错误的提示声音
set noerrorbells
set vb " 彻底禁止错误发出bell
set backspace=eol,start,indent  " Configure backspace so it acts as it should act
set whichwrap+=<,>,h,l
set synmaxcol=200  " 对于很长的行语法高亮很拖慢速度
set viminfo+=!  " 保存viminfo全局信息
set viminfo+='1000
set lazyredraw  " redraw only when we need to.
set wildmode=longest,full
set showbreak=⤷▶  " wrap line指示器
" set showbreak=↪
set virtualedit+=block  " 块选择模式可以把光标移动到没有字符的位置
set grepprg=rg\ --vimgrep






" {{{ 文件编码,格式 FileEncode Settings

set fencs=utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1
set encoding=utf-8  " 设置新文件的编码为 UTF-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1  " 自动判断编码时，依次尝试以下编码：
set helplang=cn
set termencoding=utf-8  " 下面这句只影响普通模式 (非图形界面) 下的 Vim
set formatoptions+=m  " 如遇Unicode值大于255的文本，不必等到空格再折行
set formatoptions+=B  " 合并两行中文时，不在中间加空格
"}}}
" 设置wildmenu忽略的文件{{{
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem  " Disable output and VCS files
set wildignore+=*.dll,*.bak,*.exe,*.pyc,*.jpg,*.gif,*.png  " Disable binary files
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz  " Disable archive files
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*  " Ignore bundler and sass cache
set wildignore+=*/tmp/cache/assets/*/sprockets/*,*/tmp/cache/assets/*/sass/*  " Ignore rails temporary asset caches
set wildignore+=node_modules/*  " Ignore node modules
set wildignore+=*.swp,*~,._*  " Disable temp and backup files
set wildignorecase  " files or directoies auto completion is case insensitive
set completeopt-=menu  " 让Vim的补全菜单行为与一般IDE一致(参考VimTip1228)
set completeopt+=longest,menuone
"}}}
" {{{ 展示/排版等界面格式设置 Display Settings
set ruler  " 显示当前的行号列号
set showmode  " 左下角显示当前vim模式
set number  " 显示行号
set textwidth=0  " 打字超过一定长度也不会自动换行
set relativenumber number  " 相对行号: 行号变成相对，可以用 nj/nk 进行跳转
" set statusline=%<%f\ %h%m%r%=%k[%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",BOM\":\"\")}]\ %-14.(%l,%c%V%)\ %P
" " 命令行（在状态行下）的高度，默认为1，这里是2
set laststatus=2  " Always show the status line - use 2 lines for the status bar
"{{{ statusline Config
set statusline=
set statusline+=%#CursorLine#
set statusline+=\ %{mode()}
set statusline+=\ %*\  " Color separator + space
set statusline+=%{&paste?'[P]':''}
set statusline+=%{&spell?'[S]':''}
set statusline+=%r
set statusline+=%t
set statusline+=%m
set statusline+=%=
set statusline+=\ %y\  " file type
set statusline+=%#CursorLine#
set statusline+=\ %{&ff}\  " Unix or Dos
set statusline+=%*  " default color
set statusline+=\ %{strlen(&fenc)?&fenc:'none'}\  " file encoding
"}}}
set showmatch  " 括号配对情况, 跳转并高亮一下匹配的括号
set matchtime=2  " How many tenths of a second to blink when matching brackets
set hlsearch  " 高亮search命中的文本
set incsearch  " 打开增量搜索模式,随着键入即时搜索
set ignorecase  " 搜索时忽略大小写
set smartcase  " 有一个或以上大写字母时变成大小写敏感
set foldenable  " 代码折叠 zM全部折叠 zR全部打开 zo开关一个折叠
set smartindent  " Smart indent
set autoindent  " never add copyindent, case error   " copy the previous indentation on autoindenting
" tab相关变更
set tabstop=4  " 设置Tab键的宽度 (等同的空格个数)
set shiftwidth=4  " 每一次缩进对应的空格数
set softtabstop=4  " 按退格键时可以一次删掉 4 个空格
set smarttab  " insert tabs on the start of a line according to shiftwidth, not tabstop 按退格键时可以一次删掉 4 个空格
set expandtab  " 将Tab自动转化成空格[需要输入真正的Tab键时，使用 Ctrl+V + Tab]
set shiftround  " 缩进时，取整 use multiple of shiftwidth when indenting with '<' and '>'

" 防止tmux下vim的背景色显示异常
" Refer: http://sunaku.github.io/vim-256color-bce.html
if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

syntax on  " NOTE: 这条语句放在不同的地方会有不同的效果，经测试,放在这里是比较合适的
"}}}
"}}}
" {{{  对不同文件类型的设置 FileType Settings

" 具体编辑文件类型的一般设置，比如不要 tab 等
augroup My_settings_by_filetype
    autocmd!
    autocmd filetype python,ruby,snippets setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab ai
    autocmd filetype vue,javascript,typescript,javascript.jsx,typescript.tsx,html,css,xml,sass,scss setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab ai
    autocmd filetype COMMIT_EDITMSG setlocal textwidth=72  " GitHub 每行最多显示75字符
    autocmd BufRead,BufNewFile *.md,*.mkd,*.markdown,*.mkdn setlocal filetype=markdown
    autocmd BufRead,BufNewFile *.part setlocal filetype=html
    " autocmd BufRead,BufNewFile *.vue setlocal filetype=vue.html.javascript tabstop=2 shiftwidth=2 softtabstop=2 expandtab ai
    autocmd BufWinEnter *.php set mps-=<:>  " disable showmatch when use > in php
    " makefile 必须用tab来进行缩进
    autocmd FileType make setlocal noexpandtab shiftwidth=4 softtabstop=0 list listchars=tab:▸\ ,extends:❯,precedes:❮
    " 下两行是coc-tsserver这么要求的
    autocmd BufRead,BufNewFile *.jsx set filetype=javascript.jsx
    autocmd BufRead,BufNewFile *.tsx set filetype=typescript.tsx
    " NOTE: 如果js之类的大文件高亮渲染不同步 可以开启这两个可能影响性能的选项
    " autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
    " autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear"
    " HACK: 解决markdonw不能正常高亮的问题, 方法是试出来的，原因不明确, 不过影响也不大
    autocmd User StartifyBufferOpened if &ft == 'markdown' | set syntax=on | endif
    autocmd BufWinEnter,WinEnter,BufEnter * if &ft == 'markdown' | set syntax=on | endif
    " 在右边窗口打开help,man, q快速退出
    autocmd filetype man,help,tldr wincmd L | nnoremap <silent> <buffer> q :q!<cr>
    autocmd filetype fugitiveblame,fugitive nnoremap <silent> <buffer> q :q!<cr>
    " 自动优化import
    autocmd BufWritePre java :silent! call CocActionAsync('runCommand', 'editor.action.organizeImport')<cr>
    " autocmd BufWritePost *.ts,*.js silent! call CocActionAsync('runCommand', 'tsserver.organizeImports')
    " 隐藏buffer并不delete
    autocmd filetype gitconfig setlocal bufhidden=hide
    autocmd filetype gitcommit nnoremap <silent> <buffer> q :wq<cr>
    autocmd BufWinEnter,WinEnter,BufEnter gitcommit gg
    " commit buffer在normal模式按<tab>触发预设补全, 按数字键或者tab确认补全
"{{{ function for trigger_custom_completion_source

    " 可选参数mode: 表示每次从哪一列开始补全
    fun My_custom_completion_trigger(source, ...)
        let l:start_col = a:0 == '' ? col('.') : a:0
        call complete(a:0, a:source)

        " 快速选择
        inoremap <buffer> 1 <c-y><esc>:call Clear_buffer_mapping_for_number()<cr>a<space>
        inoremap <buffer> 2 <c-n><c-y><esc>:call Clear_buffer_mapping_for_number()<cr>a<space>
        inoremap <buffer> 3 <c-n><c-n><c-y><esc>:call Clear_buffer_mapping_for_number()<cr>a<space>
        inoremap <buffer> 4 <c-n><c-n><c-n><c-y><esc>:call Clear_buffer_mapping_for_number()<cr>a<space>
        inoremap <buffer> 5 <c-n><c-n><c-n><c-n><c-y><esc>:call Clear_buffer_mapping_for_number()<cr>a<space>
        inoremap <buffer> 6 <c-n><c-n><c-n><c-n><c-n><c-y><esc>:call Clear_buffer_mapping_for_number()<cr>a<space>
        inoremap <buffer> 7 <c-n><c-n><c-n><c-n><c-n><c-n><c-y><esc>:call Clear_buffer_mapping_for_number()<cr>a<space>
        inoremap <buffer> 8 <c-n><c-n><c-n><c-n><c-n><c-n><c-n><c-y><esc>:call Clear_buffer_mapping_for_number()<cr>a<space>
        inoremap <buffer> 9 <c-n><c-n><c-n><c-n><c-n><c-n><c-n><c-n><c-y><esc>:call Clear_buffer_mapping_for_number()<cr>a<space>
        " 映射<cr>选择补全项
        inoremap <buffer> <cr> <c-y><esc>:call Clear_buffer_mapping_for_number()<cr>a<space>

        return ''
    endf

    " 取消对数字和<cr>的映射
    fun Clear_buffer_mapping_for_number()
        for i in range(1, 9)
            execute 'iunmap <buffer>' . i
        endfor
        iunmap <buffer> <cr>
    endf
"}}}
    autocmd filetype gitcommit nnoremap <silent> <buffer> <expr> <tab> col('.') == 1 ? 'i<C-r>=My_custom_completion_trigger(g:My_commit_completion_source, 1)<cr>' : '<c-y>'
    autocmd filetype gitcommit imap <silent> <buffer> <expr> <tab> col('.') == 1 ? '<C-r>=My_custom_completion_trigger(g:My_commit_completion_source_with_emoji, 1)<cr>' : '<c-y>'

"{{{ 对gitrebase命令的Mapping
    let b:fugitive_rebase_commands="^(pick|reword|edit|squash|fixup|exec|drop)"
    autocmd FileType gitrebase nnoremap <buffer> <silent> I :s/\v<c-r>=b:fugitive_rebase_commands<cr>/pick/<cr>:nohlsearch<cr>
    autocmd FileType gitrebase nnoremap <buffer> <silent> R :s/\v<c-r>=b:fugitive_rebase_commands<cr>/reword/<cr>:nohlsearch<cr>
    autocmd FileType gitrebase nnoremap <buffer> <silent> E :s/\v<c-r>=b:fugitive_rebase_commands<cr>/edit/<cr>:nohlsearch<cr>
    autocmd FileType gitrebase nnoremap <buffer> <silent> S :s/\v<c-r>=b:fugitive_rebase_commands<cr>/squash/<cr>:nohlsearch<cr>
    autocmd FileType gitrebase nnoremap <buffer> <silent> F :s/\v<c-r>=b:fugitive_rebase_commands<cr>/fixup/<cr>:nohlsearch<cr>
    " autocmd FileType gitrebase nnoremap <buffer> <silent> X Oexec<space>
    autocmd FileType gitrebase nnoremap <buffer> <silent> D :s/\v<c-r>=b:fugitive_rebase_commands<cr>/drop/<cr>:nohlsearch<cr>
"}}}
augroup end

"}}}
"{{{ 自动命令设置 Autocmds Settings
augroup auto_actions_for_better_experience
    autocmd!
    " 自动source VIMRC
    autocmd BufWritePost $MYVIMRC nested source $MYVIMRC
    " 打开自动定位到最后编辑的位置, FIXME: 需要确认 .viminfo 当前用户有可写权限
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exec "normal! g'\" \| zz" | endif
    " 进入新窗口始终让viewport居中
    autocmd BufWinEnter * exec 'normal! zz'
    "{{{ <c-j><c-k>移动quickfix
    function List_is_opened(type) abort
        if a:type == "quickfix"
            let g:my_check_quickfix_ids = getqflist({"winid" : 1})
        endif
        return get(g:my_check_quickfix_ids, "winid", 0) != 0
    endfunction
    "
    function Change_mapping_for_quickfix() abort
        if List_is_opened("quickfix")
            nnoremap <silent> <c-j> :cnext<cr>
            nnoremap <silent> <c-k> :cprevious<cr>
            nnoremap <silent> q :cclose<cr>:normal! zz<cr>:doautocmd UILeave<cr>
        else
            nnoremap <c-j> :call ScrollAnotherWindow(2)<CR>
            nnoremap <c-k> :call ScrollAnotherWindow(1)<CR>
        endif
    endfunction
    "}}}
    autocmd QuickFixCmdPost,UIEnter,UILeave,WinEnter,WinLeave,BufLeave,BufEnter * call Change_mapping_for_quickfix()
    " 关闭quickfix时恢复快捷键q
    autocmd UILeave * nmap q q
    " 进入diff模式关闭语法高亮，离开时恢复语法高亮 FIXME: 不确定会不会有性能问题
    " autocmd User MyEnterDiffMode if (&filetype != '' && &diff) | windo setlocal syntax=off | windo setlocal wrap
    autocmd User MyEnterDiffMode if (&filetype != '' && &diff) | windo setlocal wrap
    " FIXME: 这里的set syntax=on可能会影响某些特殊的文件类型的高亮渲染, 所以必要时应该排除在外
    autocmd WinEnter,WinLeave * if (&filetype != '' && &syntax != 'on' && !&diff && &filetype != 'far')
                \ | set syntax=on | endif
    " 只在当前窗口显示corsorline
    autocmd WinLeave * if g:in_transparent_mode == 0 | setlocal nocursorline
    autocmd WinEnter * if g:in_transparent_mode == 0 | setlocal cursorline
    " 每次隐藏浮动窗口重置全屏状态
    autocmd WinLeave * if &filetype == 'floaterm' | let g:My_full_screen_floterm_status = 0 | setlocal laststatus=2 | endif

augroup end
"}}}
"{{{ 自定义高亮 Highlighting, 必须在使用colorscheme之后定义

" {{{ 基础调色盘
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
function My_render_custom_highlight() abort
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

call My_render_custom_highlight()
"}}}
