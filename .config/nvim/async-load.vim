" =========================================
" 插件管理
" {{{主要插件简介
" 1. ALE         去除多余空格空行，lint, formatter
" 2. LeaderF     模糊查找
" 3. coc         补全框架, 重构，跳转定义，其他插件生态系统
" 4. Far         可视化替换
" 5. Spelunker   拼写检查
" NOTE: 对于使用了on或for来延迟加载的插件只有在加载了之后才能用 help 查看文档
"}}}

call plug#begin('~/.vim/plugged')
" {{{没有设置快捷键的，在后台默默运行的插件

" 主题配色
Plug 'tyrannicaltoucan/vim-quantum'
Plug 'sainnhe/forest-night'

" =================================
" 在大文件下会影响性能
" =================================
if g:disable_laggy_plugins_for_large_file == 0
    " 拼写检查
    Plug 'kamykn/spelunker.vim'
    "{{{
    set nospell  " 禁用默认的难看的高亮红色
    let g:spelunker_check_type = 2  " 只在window内动态check, 对大文件十分友好
    let g:spelunker_highlight_type = 2  " Highlight only SpellBad.
    let g:spelunker_white_list_for_user = ['refactor', 'vimrc', 'admin', 'username']
    let s:spelunker_filetype_blacklist = ['startify', 'far', 'vim-plug', 'vim', '', 'coc-explorer', 'zsh', 'json']  " 这里包括了文件类型的空的buffer
    let s:spelunker_buftype_blacklist = ['terminal','nowrite']  " 这里包括了文件类型的空的buffer
    augroup my_highlight_spellbad
        autocmd!
        let g:spelunker_disable_auto_group = 1
"{{{
        fun My_should_enable_spelunker()
            if index(s:spelunker_filetype_blacklist, &filetype) >= 0 || index(s:spelunker_buftype_blacklist, &buftype) >= 0 || &filetype == '' || &diff
                return 0
            endif
            return 1
        endf
"}}}
        " 用silent!的话即时不存在这个函数也不会报错，适用于--noplugin的情况
        autocmd CursorHold * if  My_should_enable_spelunker() | silent! call spelunker#check_displayed_words() | endif
    augroup end
    "}}}
endif
" ==================================
" ==================================

" 缩进虚线
Plug 'Yggdroot/indentLine', {'for': ['vue', 'html','javascript', 'python']}
"{{{ settings
let g:indentLine_fileType = ['vue','html', 'javascript','python']
let g:indentLine_bufTypeExclude = ['help', 'terminal']
let g:indentLine_char = '│'
"}}}


" 极大增强f和t查找能力 , f<cr>会重复上次搜索的字母, f会自动重复搜索
Plug 'rhysd/clever-f.vim'
"{{{
let g:clever_f_smart_case = 1  " smart case
let g:clever_f_chars_match_any_signs = 1  " 可以搜索所有的字符,比如;,.
let g:clever_f_repeat_last_char_inputs = ["\<CR>", "\<Tab>"]  " 使用上次的输入
let g:clever_f_mark_char_color = 'MyHack'
let g:clever_f_across_no_line = 1
"}}}

" 高亮书签marker
" 取消默认的快捷键{{{
let g:SignatureMap = {
\ 'Leader'             :  "m", 'PlaceNextMark'     :  "",  'ToggleMarkAtLine'   :  "",
\ 'PurgeMarksAtLine'   :  "", 'DeleteMark'         :  "",  'PurgeMarks'         :  "",
\ 'PurgeMarkers'       :  "", 'GotoNextLineAlpha'  :  "",  'GotoPrevLineAlpha'  :  "",
\ 'GotoNextSpotAlpha'  :  "", 'GotoPrevSpotAlpha'  :  "",  'GotoNextLineByPos'  :  "",
\ 'GotoPrevLineByPos'  :  "", 'GotoNextSpotByPos'  :  "",  'GotoPrevSpotByPos'  :  "",
\ 'GotoNextMarker'     :  "", 'GotoPrevMarker'     :  "",  'GotoNextMarkerAny'  :  "",
\ 'GotoPrevMarkerAny'  :  "", 'ListBufferMarks'    :  "",  'ListBufferMarkers'  :  ""
\ }
"}}}
Plug 'kshenoy/vim-signature'

" 异步实时显示HEX颜色，比如#245984
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
"{{{setings
let g:Hexokinase_optInPatterns = 'full_hex,triple_hex,rgb,rgba,hsl,hsla,colour_names'
"}}}

" 让. 可以重复插件的操作, 和surround是绝配
Plug 'tpope/vim-repeat'

" Undo到上次保存前的历史操作(使用undofile时)就发警告来提醒
Plug 'arp242/undofile_warn.vim'

" 140+种语言的语法高亮包
Plug 'sheerun/vim-polyglot'
let g:vue_pre_processors ='detect_on_enter' " 极大提升打开vue文件的性能 自动设置预处理器, 这是对整合进polyglot的 posva/vim-vue的设置



" coc-snippets是框架,这个是资源
Plug 'honza/vim-snippets'
"
" 自动进入粘贴模式
Plug 'ConradIrwin/vim-bracketed-paste'

" FIXME: this source invode vim function that could be quite slow, so make sure your coc.preferences.timeout is not too low, otherwise it may timeout.
Plug 'Shougo/neoinclude.vim' | Plug 'jsfaint/coc-neoinclude'

" 自动解决绝大部分编码问题
Plug 'mbbill/fencview', { 'on': [ 'FencAutoDetect', 'FencView' ] }

" 自动关闭标签, 额外功能: 插入模式<tag>|</tag> 光标处按>会自动空行
Plug 'alvan/vim-closetag', {'for': ['vue', 'html', 'javascript.jsx', 'typescript.tsx']}
"{{{
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.xml,*.jsx,*.tsx'
let g:closetag_filetypes = 'html,javascript.jsx,typescript.tsx,vue'
"}}}

" markdown代码内高亮
Plug 'plasticboy/vim-markdown', {'for': ['markdown', 'vimwiki']}
"{{{
let g:vim_markdown_fenced_languages = ['c++=cpp', 'viml=vim', 'bash=sh', 'ini=dosini', 'csharp=cs', 'vim', 'help']
"}}}

" 与tmux整合的插件
"{{{
if executable('tmux') && filereadable(expand('~/.zshrc')) && $TMUX !=# ''
    " 在tmux的pane间也能补全
    Plug 'wellle/tmux-complete.vim'
    let g:tmuxcomplete#trigger = ''
endif
"}}}

" 高亮与光标下单词相同的单词
Plug 'RRethy/vim-illuminate'
"{{{
" 选择不高亮的文件类型
let g:Illuminate_ftblacklist = [
            \ 'vim', 'text', 'markdown', 'css', 'help',
            \ 'coc-explorer', 'vista', 'qf', 'vimwiki', 'zsh',
            \ 'tmux', 'gitconfig', 'dosini',
            \ ]
"}}}

" 选择模式和行选择模式下可以用I A批量多行写入(修改了可视模式下I和A的映射)
Plug 'kana/vim-niceblock', {'on': ['<Plug>(niceblock-I)', '<Plug>(niceblock-A)']}
"{{{
omap I <Plug>(niceblock-I)
xmap I <Plug>(niceblock-I)
xmap A <Plug>(niceblock-A)
xmap A <Plug>(niceblock-A)
"}}}

" 新增很多方便的text object, 比如 , argument in( il( 并且可以计数比如光标在a时 (((a)b)c)  --d2ab--> (c )
Plug 'wellle/targets.vim'

" 自定义text-object 是vim-textobj-variable-segment插件的依赖
Plug 'kana/vim-textobj-user'

" ii ai 在python里很好用 NOTE: 这个插件是用函数做的映射，所以不能延迟加载
Plug 'michaeljsmith/vim-indent-object', {'for': ['python']}

" vic viC vac vaC Column单词自动快选择模式, 然后按I A多列添加字符
Plug 'coderifous/textobj-word-column.vim'  " NOTE:由于插件实现原因，不能延迟加载

" ( 前一个句子，)后一个句子的开头, g(去当前句子的结尾 g)去上个句子的结尾
" NOTE:由于插件实现原因，不能延迟加载, 但是插件会自动根据文件类型加载
Plug 'reedes/vim-textobj-sentence'
"{{{
omap ix <Plug>(textobj-xmlattr-attr-i)
omap ax <Plug>(textobj-xmlattr-attr-a)
xmap ix <Plug>(textobj-xmlattr-attr-i)
xmap ax <Plug>(textobj-xmlattr-attr-a)
augroup textobj_sentence
  autocmd!
  autocmd FileType markdown silent! call textobj#sentence#init()
  autocmd FileType textile,text silent! call textobj#sentence#init()
augroup end
"}}}

" iv av variabe-text-object 部分删除变量的名字 比如camel case: getJiggyY 以及 snake case: get_jinggyy
Plug 'Julian/vim-textobj-variable-segment', {'on': ['<Plug>(textobj-variable-i)', '<Plug>(textobj-variable-a)']}
"{{{
omap iv <Plug>(textobj-variable-i)
omap av <Plug>(textobj-variable-a)
xmap iv <Plug>(textobj-variable-i)
xmap av <Plug>(textobj-variable-a)
"}}}

" ix ax XML/HTML属性文本对象
Plug 'whatyouhide/vim-textobj-xmlattr', {'on': ['<Plug>(textobj-xmlattr-attr-i)', '<Plug>(textobj-xmlattr-attr-a)']}
"{{{
omap ix <Plug>(textobj-xmlattr-attr-i)
omap ax <Plug>(textobj-xmlattr-attr-a)
xmap ix <Plug>(textobj-xmlattr-attr-i)
xmap ax <Plug>(textobj-xmlattr-attr-a)
"}}}
"
" iz az
Plug 'somini/vim-textobj-fold', {'on': ['<Plug>(textobj-fold-i)', '<Plug>(textobj-fold-a)']}
"{{{
omap iz <Plug>(textobj-fold-i)
omap az <Plug>(textobj-fold-a)
xmap iz <Plug>(textobj-fold-i)
xmap az <Plug>(textobj-fold-a)
"}}}

" ciq diq yiq viq 最近的引号' ` "
Plug 'beloglazov/vim-textobj-quotes', {'on': ['<Plug>(textobj-quote-i)', '<Plug>(textobj-quote-a)']}
"{{{
omap iq <Plug>(textobj-quote-i)
omap aq <Plug>(textobj-quote-a)
xmap iq <Plug>(textobj-quote-i)
xmap aq <Plug>(textobj-quote-a)
"}}}

" ij aj 最近的()[]{}
Plug 'Julian/vim-textobj-brace', {'on': ['<Plug>(textobj-brace-i)', '<Plug>(textobj-brace-a)']}
"{{{
omap ij <Plug>(textobj-brace-i)
omap aj <Plug>(textobj-brace-a)
xmap ij <Plug>(textobj-brace-i)
xmap aj <Plug>(textobj-brace-a)
"}}}

" iu au 支持markdown的url  go打开连接(仅支持Linux)
Plug 'jceb/vim-textobj-uri', {'on': ['<Plug>(textobj-uri-uri-i)', '<Plug>(textobj-uri-uri-a)', '<Plug>TextobjURIOpen']}
" NOTE: 如果不设置到<Plug>TextobjURIOpen的映射，则插件会映射 go
"{{{
omap iu <Plug>(textobj-uri-uri-i)
omap au <Plug>(textobj-uri-uri-a)
xmap iu <Plug>(textobj-uri-uri-i)
xmap au <Plug>(textobj-uri-uri-a)
"}}}
nmap <silent> tu <Plug>TextobjURIOpen

" 自动隐藏搜索的高亮
Plug 'romainl/vim-cool'
"{{{
let g:CoolTotalMatches = 1
"}}}

" 实时预览substitute命令的情况
Plug 'markonm/traces.vim'


" python的indent折叠增强, 折叠import，折叠和预览doctring，
Plug 'tmhedberg/SimpylFold', {'for': [ 'python' ]}
"{{{
let g:SimpylFold_docstring_preview = 1
"}}}

" 异步自动生成tags
Plug 'jsfaint/gen_tags.vim'
"{{{
let g:gen_tags#verbose = 0  " 不提示信息
let g:gen_tags#gtags_auto_gen = 1
let g:gen_tags#gtags_auto_gen = 1
let g:gen_tags#ctags_opts = ['--c++-kinds=+px', '--c-kinds=+px']
let g:gen_tags#ctags_opts = ['-c', '--verbose']
" FIXME: 当项目文件的路径包含非ASCII字符时，使用pygments会报UnicodeEncodeError
let $GTAGSLABEL = 'native-pygments'
" let $GTAGSCONF = '/usr/local/share/gtags/gtags.conf'

"}}}

"  单词级对比,　diff模式自动启动, 高亮组是DiffText
Plug 'rickhowe/diffchar.vim', {'on': 'TDChar'}

"===========================================================================
"===========================================================================
"}}}

" 需要知道用法的插件
" ---------------------------------------
" 通用功能插件
"{{{开关非常影响打开大文件性能的插件
if g:disable_laggy_plugins_for_large_file == 0
    " ALE静态代码检查和自动排版 NOTE: 默认禁用对log文件的fixer
    Plug 'dense-analysis/ale'
    "{{{
    let g:ale_set_highlights = 0  " 不要显示红色下划线
    let g:ale_sign_error = '✗'
    let g:ale_sign_warning = '⚡'

    " 不需要指定linters

    " 自动排版, 保存时自动删除末尾空白行和行末空格
    let g:ale_fixers = {
    \   '*': ['remove_trailing_lines', 'trim_whitespace'],
    \   'c': ['clang-format'],
    \   'cpp': ['clang-format'],
    \   'python': ['autopep8'],
    \   'html': ['prettier'],
    \   'css': ['prettier'],
    \   'scss': ['prettier'],
    \   'less': ['prettier'],
    \   'json': ['prettier'],
    \   'vue': ['prettier'],
    \   'yaml': ['prettier'],
    \   'markdown': ['prettier'],
    \   'javascript': ['prettier'],
    \   'typescript': ['prettier'],
    \   'flow': ['prettier'],
    \   'javascriptreact': ['prettier'],
    \   'typescriptreact': ['prettier'],
    \}
    " 极大提升打开log 文件的性能
    let g:ale_fix_on_save_ignore = {'log': ['remove_trailing_lines', 'trim_whitespace']}
    let g:ale_lint_on_text_changed = 'normal'
    " let g:ale_lint_delay = 3000  " 这个配置似乎不生效
    " 保存时自动排版
    let g:ale_fix_on_save = 1
    " 配置状态栏信息
    let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
    "}}}
endif
"}}}
"{{{ Git 相关
" 可视化merge NOTE: 恢复merge前的状态使用: git checkout --conflict=diff3 {file}
Plug 'samoshkin/vim-mergetool'
"{{{
let g:mergetool_layout = 'RmL'  " `local`, `base`, `remote`, `merged`
let g:mergetool_prefer_revision = 'unmodified'
" mergetool 模式关闭语法检查和语法高亮 FIXME: 可能是unknown filetype报错的原因
function s:on_mergetool_set_layout(split)
  set syntax=off
  set nospell
  if a:split["layout"] ==# 'RmL' && a:split["split"] ==# 'm'
      " 可自定义
      "
  endif
endfunction
let g:MergetoolSetLayoutCallback = function('s:on_mergetool_set_layout')

"}}}
nmap ,gmt <plug>(MergetoolToggle)
" 移动diff hunk NOTE: 不仅用于merge mode 也能用于diff mode
" 快捷键需要定义在coc那里, 因为还可以用gh跳转到头文件
" nmap <expr> gh &diff? '<Plug>(MergetoolDiffExchangeLeft)' : '<esc>'
" nmap <expr> gl &diff? '<Plug>(MergetoolDiffExchangeRight)' : '<esc>'

" 显示当前行的commit信息, o下一个commit，O上一个，d打开该commit在当前文件的diff hunks，
" D打开该commit的所有diff hunks
Plug 'rhysd/git-messenger.vim', {'on': '<Plug>(git-messenger)'}
"{{{
let g:git_messenger_no_default_mappings = v:true
"}}}
" 开启预览后光标始终进入popup window, 否则要再次使用快捷键才能让光标进入popup window
" let g:git_messenger_always_into_popup = v:true
nmap gc <Plug>(git-messenger)

" git
" G表示外部git命令 支持~/.gitconfig里定义的alias
" NOTE: 连续使用G会出一些bug，复杂命令最好用.gitconfig里的alias
" Plug 'tpope/vim-fugitive' " 在init.vim里启用了，这里仅做配置
" Gread就是清空暂存区 即checkout %    " 还有diffget和diffput可以使用
nnoremap <silent> ,ga :G add %:p<CR>
nnoremap <silent> ,gaa :G add -A<cr>
nnoremap <silent> ,gau :G add --update<CR>
nnoremap <silent> ,gap :G add --patch %<CR>
" {{{ fun My_toggle_coc_git_blame()
let g:My_coc_git_blame_show = 0
fun My_toggle_coc_git_blame()
    if g:My_coc_git_blame_show == 0
        call coc#config('git.addGBlameToVirtualText', v:true)
        let g:My_coc_git_blame_show = 1
    else
        call coc#config('git.addGBlameToVirtualText', v:false)
        let g:My_coc_git_blame_show = 0
    endif
endf
" }}}
nnoremap <silent> ,gb :call My_toggle_coc_git_blame()<cr>
nnoremap <silent> ,gc :G commit<cr>
nnoremap <silent> ,gca :G commit --all<cr>
" 不用编辑提交信息 git add --update && git commit --amend --no-edit
nnoremap <silent> ,gmu :G cmu --quiet<cr>
" 需要编辑提交信息 git add --update && git commit --amend
nnoremap <silent> ,gmue :G cmue --quiet<cr>
" 不用编辑提交信息 git add --all && git commit --amend --no-edit
nnoremap <silent> ,gma :G cma --quiet<cr>
" 不用编辑提交信息 git add --all && git commit --amend
nnoremap <silent> ,gmae :G cmae --quiet<cr>
" {{{  定义 autocmd User MyEnterDiffMode
" 定义进入diff的事件，然后当前窗口关闭syntax
augroup my_enter_diffMode
    autocmd!
    autocmd User MyEnterDiffMode normal zz
augroup end
"}}}
" [ 本文件内diff ]
" diff working directory与index (即暂存区) -y表示 在新tab中打开
nnoremap <silent> ,gd :G difftool % -y<cr><esc>:silent! doautocmd User MyEnterDiffMode<cr>
" diff index(staged) 与 local repository
nnoremap <silent> ,gD :G difftool --cached % -y<cr><esc>:silent! doautocmd User MyEnterDiffMode<cr>
" diff working directory与local repository (即HEAD)
nnoremap <silent> ,,gd :G difftool HEAD % -y<cr><esc>:silent! doautocmd User MyEnterDiffMode<cr>
" git status
" nnoremap <silent> ,gs :vert Git<cr>
nnoremap <silent> ,gs    :<C-u>CocCommand fzf-preview.GitStatus<CR>

" 重命名git项目下的文件
" This will:  Rename your file on disk.  Rename the file in git repo.
"             Reload the file into the current buffer.  Preserve undo history.
nnoremap ,gr :G add %<cr><esc>:Gmove <c-r>=expand('%:p:h')<cr>/

nnoremap <silent> ,ft :AsyncTask git-fetch<cr>
nnoremap <silent> ,ps :AsyncTask git-push<cr>
nnoremap <silent> ,pl :AsyncTask git-pull<cr>


" rebase的时候可以自动预览diff，而且现已在本配置文件设置了 I(pick) R(reword) E(edit) S(squash) F(fixup) D(drop)
Plug 'hotwatermorning/auto-git-diff', {'for': 'gitrebase'}
"}}}
"{{{编辑, 跳转功能增强
" 书签
Plug 'MattesGroeger/vim-bookmarks'
"{{{ settings
let g:bookmark_no_default_key_mappings = 1 " 取消默认快捷键
let g:bookmark_save_per_working_dir = 1 " 保存的bookmark在git仓库间隔离
let g:bookmark_auto_save = 1 " 自动持久化
let g:bookmark_center = 1 " 自动展示mark行到屏幕中心
let g:bookmark_show_toggle_warning = 1 " 显示删除annnotated bookmark时的提示
"{{{ 设置保存project bookmarks到
" 由于git submodule仓库并没有.git文件夹而是.git文件, 所以在子模块仓库中还是会保存文件到子模块根目录，而不是子模块的.git目录
" 　(子模块的.git文件夹集中管理在父仓库中)
function! g:BMWorkDirFileLocation()
    let filename = 'bookmarks'
    let location = ''
    if isdirectory('.git')
        " Current work dir is git's work tree
        let location = getcwd().'/.git'
    else
        " Look upwards (at parents) for a directory named '.git'
        let location = finddir('.git', '.;')
    endif
    if len(location) > 0
        return location.'/'.'vim-bookmarks-per-repository'
    else
        return getcwd().'/.'.'vim-bookmarks-per-repository'
    endif
endfunction
"}}}
"}}}
nmap <leader>mm <Plug>BookmarkToggle
nmap <Leader>ma <Plug>BookmarkAnnotate
nmap <Leader>mcl <Plug>BookmarkClearAll
nnoremap <leader>ml :CocCommand fzf-preview.Bookmarks<cr>

" 快速移动
Plug 'easymotion/vim-easymotion', {'on': '<Plug>(easymotion-bd-f)'}
" quick f
map <silent> qf <Plug>(easymotion-bd-f)

" easymotion可以根据中文拼音首字母跳转
Plug 'ZSaberLv0/vim-easymotion-chs'  " (不能延迟加载，否则easymotion不能正常使用)

" 获取同一文件内不同区块的文件类型，辅助caw.vim在 vue或html文件中自动改变注释格式
Plug 'Shougo/context_filetype.vim'

" 快速注释, 可以设置单行注释，单行盒形注释, 多行注释, 多行盒形注释
" 支持repeat
" TODO: 等issue修复了就可以延迟加载了
Plug 'tyru/caw.vim' " BUG: 延迟加载时有bug, 已经提issue了，还有个问题是不能注释空行，但只有这个注释的插件对vue注释的支持最好
"{{{ settings
let g:caw_no_default_keymappings = 1
autocmd FileType json,jsonc let b:caw_oneline_comment = '//' | let b:caw_wrap_multiline_comment = {'left': '//'}
"}}}
imap <c-_> <esc><Plug>(caw:hatpos:toggle)
nmap <c-_> <Plug>(caw:hatpos:toggle)
vmap <c-_> <Plug>(caw:hatpos:toggle)


" Vim-Surround快捷操作
Plug 'tpope/vim-surround'
"{{{
 " 让surround的快捷键可以用 `.` 重复
let s:key_mappings_of_surround = [
            \ "<leader>'", '<leader>"', '<leader>*', '<leader><leader>*', '<leader>)', '<leader>(',
            \ '<leader>[', '<leader>{', '<leader><', '<leader>>', '<leader>\|', '<leader>`',
            \ ",'", ',"', ',*', ',,*', ',(',
            \ ',)', ',[', ',{', ',<', ',>', ',\|', ',`'
            \ ]
for keymap in s:key_mappings_of_surround
    silent! call repeat#set(keymap, v:count)
endfor
" 让surround<cr>不显示^M字符，可以直接添加新行,  `char2nr("\<CR>")` == 13
let g:surround_13 = "\n\r\n"

"}}}
" {{{让cs修改的surround不包括空格
fun My_get_inverse_bracket(x)  "
    if a:x == '(' | return ')'
    elseif a:x == '[' | return ']'
    elseif a:x == '{' | return '}'
    elseif a:x == '<' | return '>'
    elseif  a:x == '>' | return '<'
    endif
endf
"
for x in ['(','[', '{', '<', "'", '"']
    for y in ['(', '[', '{', '<', '>']
        execute 'nmap cs' . x . y . ' cs' . x . My_get_inverse_bracket(y)
    endfor
endfor
"}}}
" rename tag
nmap <leader>rt cstt
nmap ysw ysiw
nmap ysW ysiW
" 快速添加pair
" TIP: cswb == ysiwb, 用于<cword> 而<leader>{?}用于<cWORD>
nmap <leader>' :normal ysiW'<cr>gv<esc>
nmap <leader>" :normal ysiW"<cr>gv<esc>
nmap <leader>* :normal ysiW*<cr>gv<esc>
nmap <leader><leader>* :normal ysiW*<cr>:normal ysiW*<cr>gv<esc>
nmap <leader>) :normal ysiW)<cr>gv<esc>
nmap <leader>( :normal ysiW)<cr>gv<esc>
nmap <leader>[ :normal ysiW]<cr>gv<esc>
nmap <leader>] :normal ysiW[<cr>gv<esc>
nmap <leader>{ :normal ysiW}<cr>gv<esc>
" surround with <>
nmap <leader>< :normal ysiW><cr>gv<esc>
" surround with <tag></tag>
nmap <leader>> :normal ysiW<<cr>gv<esc>
" 这里对|进行了转义
nmap <leader>\| :normal ysiW\|<cr>gv<esc>
nmap <leader>` :normal ysiW`<cr>gv<esc>

vmap <leader>" S"gv<esc>
" visual添加surround同上{{{
vmap <leader>' S'gv<esc>
vmap <leader>* S*gv<esc>
vmap <leader><leader>* S*gvS*gv<esc>
vmap <leader>( S)gv<esc>
vmap <leader>) S)gv<esc>
vmap <leader>[ S]gv<esc>
vmap <leader>{ S}gv<esc>
vmap <leader>< S>gv<esc>
vmap <leader>> S<gv<esc>
vmap <leader>\| S\|gv<esc>
vmap <leader>` S`gv<esc>
"}}}
nmap ," :normal ds"<cr>
"{{{ 逗号删除surround
nmap ,' :normal ds'<cr>
nmap ,* :normal ds*<cr>
nmap ,,* :normal ds*<cr>:normal ds*<cr>
nmap ,( :normal ds(<cr>
nmap ,) :normal ds(<cr>
nmap ,[ :normal ds[<cr>
nmap ,] :normal ds[<cr>
nmap ,{ :normal ds{<cr>
nmap ,< :normal ds><cr>
nmap ,> :normal dst<cr>
nmap ,\| :normal ds\|<cr>
nmap ,` :normal ds`<cr>
"}}}


" 快速交换 cx{object} cxx行 可视模式用X  取消用cxc  可以用 . 重复上次命令
Plug 'tommcdo/vim-exchange', {'on': [ '<Plug>(Exchange)', '<Plug>(ExchangeLine)' ]}
nmap cx <Plug>(Exchange)
xmap X <Plug>(Exchange)
nmap cxc <Plug>(ExchangeClear)
nmap cxx <Plug>(ExchangeLine)

" 快速对齐文本
Plug 'junegunn/vim-easy-align', {'on': '<Plug>(EasyAlign)'}
" Start interactive EasyAlign in visual mode (e.g. vipga=)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip=)
nmap ga <Plug>(EasyAlign)

" 快速移动参数，数组里的元素 html, css, js中object属性
Plug 'AndrewRadev/sideways.vim', {'on': ['SidewaysLeft', 'SidewaysRight']}
nnoremap tl :SidewaysRight<cr>
nnoremap th :SidewaysLeft<cr>

" 驼峰跳转 FIXME: 修改了默认的b w e映射
" Plug 'bkad/CamelCaseMotion'
" "{{{
" let g:camelcasemotion_key = '<C-S-M-F12>'  " 禁用默认快捷键
" map <silent> w <Plug>CamelCaseMotion_w
" map <silent> b <Plug>CamelCaseMotion_b
" map <silent> e <Plug>CamelCaseMotion_e
" omap <silent> iw <Plug>CamelCaseMotion_iw
" xmap <silent> iw <Plug>CamelCaseMotion_iw
" " diw用CamelCase, ciw用原始的比较好
" nnoremap ciw ciw
" sunmap w
" sunmap b
" sunmap e
" "}}}

" 支持v:count 块选择模式整列的递增/减数字 <c-a> <c-x>
Plug 'triglav/vim-visual-increment', {'on': ['<Plug>(VisualIncrement)', '<Plug>(VisualDecrement)']}
set nrformats=alpha,hex,bin  " 支持数字，字母，十六进制, 二进制
vmap <c-a> <Plug>(VisualIncrement)
vmap <c-x> <Plug>(VisualDecrement)

" 移动选中文本, 支持v:count
Plug 'matze/vim-move', {'on': ['<Plug>MoveBlockDown', '<Plug>MoveBlockUp', '<Plug>MoveBlockLeft', '<Plug>MoveBlockRight']}
"{{{
let g:move_map_keys = 0  " 禁用默认快捷键
"}}}
let g:move_auto_indent = 0  " 禁止移动完成后自动缩进
vmap <m-down> <Plug>MoveBlockDown
vmap <m-up> <Plug>MoveBlockUp
vmap <m-left> <Plug>MoveBlockLeft
vmap <m-right> <Plug>MoveBlockRight

"}}}
"{{{ UI 相关


" Vista浏览tags, 函数，类 大纲
" NOTE: 可以为不同的文件类型设置不同的执行命令coc或ctags
Plug 'liuchengxu/vista.vim'
"{{{
let g:vista_default_executive = 'coc'
let g:vista_sidebar_width = 50
let g:vista_update_on_text_changed = 1
let g:vista_update_on_text_changed_delay = 500
" default: `['└ ', '│ ']`
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
" let g:vista_echo_cursor_strategy = 'floating_win'
let g:vista_executive_for = {
    \ 'vimwiki': 'markdown',
    \ 'pandoc': 'markdown',
    \ 'markdown': 'toc',
    \ }

let g:vista#renderer#enable_icon = 1  " Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
   "variable": '\uf71b',
  " function": '\uf794',

let g:vista#renderer#icons = {
\   'module': '',
\   'interface': '',
\   'class': '',
\   'constructor': '',
\   'method': '',
\   'field': '',
\   'enum': '',
\   'enum member': '',
\   'function': '',
\   'variable': '',
\   'property': '',
\   'constant': '',
\   'struct': '',
\  }
"}}}
" NOTE: 内置快捷键 p: preview     s: sort     q: close vista
" 两个感叹号是Toggle
nnoremap <leader>vo :Vista!!<cr>


" 查看uodo历史及持久化
Plug 'simnalamburt/vim-mundo', {'on': 'MundoToggle'}
" reference: https://vi.stackexchange.com/questions/6/how-can-i-use-the-undofile
" {{{
if !isdirectory($HOME."/.vim")
    call mkdir($HOME."/.vim", "", 0770)
endif
if !isdirectory($HOME."/.vim/undo-dir")
    call mkdir($HOME."/.vim/undo-dir", "", 0700)
endif
set undodir=~/.vim/undo-dir
set undofile
"}}}
nnoremap <leader>mo :MundoToggle<cr>

" 更方便地调整window
Plug 'simeji/winresizer', {'on': 'WinResizerStartResize'}
"{{{
let g:winresizer_gui_enable = 1  " gui的vim也能调整窗口大小
let g:winresizer_start_key = ''
let g:winresizer_gui_start_key = ''
let g:winresizer_vert_resize = 3  " 每次移动的步幅
"}}}
" usage: 进入resize模式后，hjkl可以调整窗口大小，enter确认，q取消, m移动模式，
" r调整窗口模式，f选择窗口模式
nnoremap <leader>wr :WinResizerStartResize<cr>
nnoremap <leader>wm :WinResizerStartResize<cr>m

" 多语言debug支持 FIXME: 这个插件还在开发阶段，可能会有很多bug
Plug 'puremourning/vimspector', {'do': './install_gadget.py --enable-c --enable-python', 'on': '<Plug>VimspectorContinue'}
"{{{
sign define vimspectorBP text=🔴 texthl=Normal
sign define vimspectorBPDisabled text=🔵 texthl=Normal
sign define vimspectorPC text=🔶 texthl=SpellBad
"}}}
" nmap <F5> :call vimspector#launch()<cr>
nmap <F5> <Plug>VimspectorContinue
nmap <F6> <Plug>VimspectorStepOver
nmap <F7> <Plug>VimspectorStepInto
nmap <F8> <Plug>VimspectorStepOut
nmap <F9> :call vimspector#ToggleBreakpoint()<cr>
nmap <F10> :VimspectorReset

" nmap <Plug>VimspectorContinue
" nmap <Plug>VimspectorStop
" nmap <Plug>VimspectorRestart
" nmap <Plug>VimspectorPause
" nmap <Plug>VimspectorToggleBreakpoint
" nmap <Plug>VimspectorAddFunctionBreakpoint

" 查看各个插件启动时间
Plug 'tweekmonster/startuptime.vim', { 'on': 'StartupTime' }
nnoremap <leader>ST :StartupTime<cr>
nnoremap <leader>PI :PlugInstall<cr>
nnoremap <leader>PC :PlugClean<cr>
nnoremap <leader>PS :PlugStatus<cr>

" keymap提示 NOTE: 不能延迟加载
Plug 'liuchengxu/vim-which-key'
"{{{
autocmd VimEnter * call which_key#register('<Space>', "g:which_key_map_space")
autocmd VimEnter * call which_key#register('<localleader>', "g:which_key_map_comma")
autocmd VimEnter * call which_key#register('g', "g:which_key_map_g")
autocmd VimEnter * call which_key#register('t', "g:which_key_map_t")
" 快捷键注释
"{{{ <Space> 快捷键注释
let g:which_key_map_space = {}
let g:which_key_map_space['0'] = 'toggle-sytax'
let g:which_key_map_space.a = {
            \ 'name': '+absolute-path',
            \ 'p': 'absolute-path-copy'
            \}
let g:which_key_map_space.b = {
    \ 'name': '+buffer/bookmark/build',
    \ 'd': 'buffer-close',
    \ }
let g:which_key_map_space.c = {
            \ 'name': '+comment/colors-scheme/coc-list',
            \ }
let g:which_key_map_space.d = {
            \ 'name': '+diff/directory',
            \ 'r': 'dir-path-copy',
            \}
let g:which_key_map_space.e = {
            \ 'name': '+edit/explorer',
            \ 'c': 'edit-c/cpp',
            \ 'h': 'edit-.h',
            \ 'n': 'edit-$VIMRC',
            \ 's': 'edit-snippets',
            \ 't': 'edit-tmux-config',
            \}
let g:which_key_map_space.g = {
            \ 'name': '+goto',
            \ 'w': 'goto-<cword>',
            \ 'W': 'goto-<cWORD>',
            \}
let g:which_key_map_space.m = {
            \ 'name': '+markdown/mergetool/marks',
            \}
let g:which_key_map_space.n = {
            \ 'name': '+filename',
            \ 'm': 'filename-copy',
            \}
let g:which_key_map_space.P = {
            \ 'name': '+Plug',
            \}
let g:which_key_map_space.r = {
            \ 'name': '+run/rename/rooter/rg/regex-search',
            \}
let g:which_key_map_space.s = {
            \ 'name': '+buffer-substitute/split/select',
            \ 's': 'split-horizontal',
            \ 'v': 'split-vertical',
            \ 'u': 'buffer-substitute-cword',
            \ 'U': 'buffer-substitute-cWORD',
            \}
let g:which_key_map_space.S = {
            \ 'name': '+startuptime'
            \}
let g:which_key_map_space.t = {
            \ 'name': '+todolist/transparent',
            \}
let g:which_key_map_space.u = {
            \ 'name': '+undo-tree',
            \}
let g:which_key_map_space.v = {
            \ 'name': '+view',
            \}

let g:which_key_map_space['w'] = {
      \ 'name': '+windows',
      \ 'o': 'window-full-screen',
      \ 's': 'window-swap',
      \ 'r': 'window-resize-mode',
      \ 'm': 'window-move-mode',
      \ }
"}}}
"{{{ "," 快捷键注释
let g:which_key_map_comma = {}
let g:which_key_map_comma.e = 'edit-file'
let g:which_key_map_comma.g = {
            \ 'name': '+git',
            \ 'd': 'diff-current-file',
            \ 'l': 'git-log',
            \ 's': 'git-status',
            \ 'u': 'undo-diff-hunk',
            \ 'r': 'git-rename',
            \}
let g:which_key_map_comma.p = {
            \ 'name': '+pull/push',
            \}
let g:which_key_map_comma.s = {
            \ 'name': '+buffer-substitute/sink',
            \ 'n': 'sink-mode (zen-mode)',
            \ 'u': 'buffer-substitute-cword',
            \ 'U': 'buffer-substitute-cWORD',
            \ 'r': 'regex-substitute',
            \}
let g:which_key_map_comma.w = 'write (save-buffer)'
"}}}
"{{{ "g" 快捷键注释
let g:which_key_map_g = {}
" HACK: 特殊字符就不能用 . 了，　只能用['']的形式
let g:which_key_map_g[';'] = 'last-edit-positon-normal-mode'
let g:which_key_map_g['/'] = 'last-buffer-grep'
let g:which_key_map_g['?'] = 'last-buffer-search'
let g:which_key_map_g.b = 'next-braket'
let g:which_key_map_g.c = 'line-commit-message'
let g:which_key_map_g.i = 'last-edit-positon-insert-mode'
let g:which_key_map_g.q = 'toggle-quickfix-window'
let g:which_key_map_g.y = 'yank-history'
"}}}
"{{{ "t" 快捷键注释
let g:which_key_map_t = {}
let g:which_key_map_t.h = 'swap-left'
let g:which_key_map_t.l = 'swap-right'
let g:which_key_map_t.j = 'join-line'
let g:which_key_map_t.t = 'translate-<cword>'
let g:which_key_map_t.u = 'open-URL'
"}}}
let g:which_key_display_names = { ' ': 'SPC', '<TAB>': 'TAB', }  " 定义快捷键的别名, key必须是大写字母
let g:which_key_run_map_on_popup = 1  " 每次popup自动更新词典，防止buffer local的keymap改变时vim-whichkey信息过时了
let g:which_key_use_floating_win = 1  " 使用浮动窗口,优点是在多窗口的时候兼容性很好
"}}}
let g:which_key_fallback_to_native_key = 1  " 如果没有自定义则不报警
nnoremap <silent> <leader> :<C-U>WhichKey '<Space>'<cr>
nnoremap <silent> <localleader> :<C-U>WhichKey ','<cr>
nnoremap <silent> g :WhichKey 'g'<cr>
" 在Visual模式显示WhichKey
vnoremap <silent> <leader> :<C-U>WhichKeyVisual '<space>'<cr>
vnoremap <silent> <localleader> :<C-U>WhichKeyVisual ','<cr>
vnoremap <silent> <expr> g coc#expandableOrJumpable() ? g : ':<C-U>WhichKeyVisual "g"<cr>'
augroup settings_whichkey_for_t  " 因为有插件映射了t所以这里要用autocmd来映射
    autocmd!
    autocmd VimEnter * nnoremap <silent> t :WhichKey 't'<cr>
    autocmd VimEnter * vnoremap <silent> t :WhichKeyVisual 't'<cr>
augroup end

" 为内置终端提供方便接口 NOTE:暂时被floaterm替代，以后唯一可能用的地方就是REPL吧
" Plug 'kassio/neoterm'
"{{{
let g:neoterm_autojump = 1  " 自动进入终端
let g:neoterm_autoinsert = 1  " 进入终端默认插入模式
let g:neoterm_use_relative_path = 1
let g:neoterm_autoscroll = 1
let g:neoterm_size = 10  " 调整terminal的大小
"}}}
" nnoremap <silent> <m-m> :botright Ttoggle<cr>
" tnoremap <silent> <m-m> <c-\><c-n>:Ttoggle<cr>
" nnoremap <silent> <m-j> :botright Topen<cr>
" inoremap <silent> <m-j> <esc>:botright Topen<cr>
" tnoremap <m-j> <c-\><c-n><c-w>j
" tnoremap <m-k> <c-\><c-n><c-w>k<esc>

" 浮动终端
Plug 'voldikss/vim-floaterm'  " NOTE: 作者不推荐延迟加载
"settings{{{
fun My_reset_floaterm_config()
    let g:floaterm_type = 'floating'   "　终端出现形式, 可选normal
    " let g:floaterm_type = 'normal'   "　终端出现形式, 可选normal
    " let g:floaterm_width = 0.9  " 默认0.6
    " let g:floaterm_height = 0.95  " 默认0.6
    let g:floaterm_winblend = 0  " 背景透明度百分比
    let g:floaterm_position = 'center'  " 浮动窗口位置
    " 从终端打开文件的方式 Available: 'edit', 'split', 'vsplit', 'tabe', 'drop'. Default: 'edit'
    let g:floaterm_open_command = 'edit'
    " 使用git commit时触发
    let g:floaterm_gitcommit = 'split'  " split vsplit tabe可选
endf
call My_reset_floaterm_config()

augroup fix_bug_in_floaterm_and_startify
    autocmd!
    autocmd User Startified setlocal buflisted
augroup end
"}}}
"Deprecated 映射{{{
" 向终端送去命令去除空白但保持缩进 NOTE: 不适用于浮动窗口，只能当 g:floaterm_type = 'normal'时才能用
" nnoremap <silent> ts :FloatermSend!<cr>
" vnoremap <silent> ts :FloatermSend!<cr>
" AsyncRun不支持多浮动终端的情况，不建议使用多个浮动终端
" nnoremap <silent> <m-n> :lcd %:p:h<cr>:FloatermNew<cr>
" tnoremap <silent> <m-n> <c-\><c-n>:FloatermNew<cr>
" nnoremap <silent> <m-j> :FloatermNext<cr>
" tnoremap <silent> <m-j> <c-\><c-n>:FloatermNext<cr>
" nnoremap <silent> <m-k> :FloatermPrev<cr>
" tnoremap <silent> <m-k> <c-\><c-n>:FloatermPrev<cr>
" tnoremap <m-h> <c-\><c-n><c-w>h
" tnoremap <m-l> <c-\><c-n><c-w>l
" 在浮动终端执行命令 -A表示自动预览
" nnoremap <silent> <leader>gt :CocList -A floaterm <cr>
"}}}
" 打开终端会自动跳转dir
inoremap <silent> <m-m> <esc>:lcd %:p:h<cr><esc>:FloatermToggle<cr>
"{{{ function My_toggle_floaterm_for_normal_mode()
function! My_toggle_floaterm_for_normal_mode()
    if &buftype != 'terminal'
        lcd %:p:h
    endif
    FloatermToggle
endfunction
"}}}
nnoremap <silent> <m-m> :call My_toggle_floaterm_for_normal_mode()<cr>
" 这里末尾加<esc>:echo <cr>是为了清空提示消息
tnoremap <silent> <m-m> <c-\><c-n>:FloatermToggle<cr><esc>:echo <cr>
"{{{ function My_toggle_full_screen_floterm
let g:My_full_screen_floterm_status = 0
function My_toggle_full_screen_floterm()
    if &buftype != 'terminal'
        echo "not in a float terminal"
    endif
    if g:My_full_screen_floterm_status == 0
        let g:My_full_screen_floterm_status = 1
        setlocal laststatus=0  " 不显示状态栏
        1000wincmd |  " 延长水平窗口
        1000wincmd _
        startinsert  " 进入插入模式
    else
        let g:My_full_screen_floterm_status = 0
        FloatermToggle
        FloatermToggle
        setlocal laststatus=2
    endif
endf
"}}}
" 浮动终端开关全屏模式
tnoremap <silent> <m-o> <c-\><c-n>:call My_toggle_full_screen_floterm()<cr><c-\><c-n>:echo <cr>a
nnoremap <silent> <m-o> <c-\><c-n>:call My_toggle_full_screen_floterm()<cr><c-\><c-n>:echo <cr>a
inoremap <silent> <m-c> <esc>:FloatermNew<cr>
nnoremap <silent> <m-c> :FloatermNew<cr>
tnoremap <silent> <m-c> <c-\><c-n>:FloatermNew<cr>
" 进入普通模式
tnoremap <m-n> <c-\><c-n>
tnoremap <silent> <c-d> <c-\><c-n>:silent! FloatermKill<cr><esc>:echo <cr>

" -快速选择tab和窗口, s交换窗口 ;选择本窗口 ][在tab间移动, 0第一个tab, x关掉tab
Plug 't9md/vim-choosewin', {'on': '<Plug>(choosewin)'}
"{{{
let g:choosewin_color_label = {'gui': ['#70ace5', 'black']}
let g:choosewin_color_label_current = {'gui': ['#70ace5', 'black']}
let g:choosewin_color_shade = {'gui': ['#70ace5', 'black']}
let g:choosewin_blink_on_land = 0  " 不要闪烁
"}}}
nmap <leader>wf <Plug>(choosewin)


"}}}
"{{{ Project 增强
" 切换到项目根目录
Plug 'airblade/vim-rooter'
"{{{
" let g:rooter_manual_only = 1  " 注释了这行代表开启自动Rooter
let g:rooter_resolve_links = 1  " resolve软硬链接
let g:rooter_silent_chdir = 1  " 静默change dir
"}}}
" 手动切换到项目根目录
nnoremap ,rt :Rooter<cr>:echo printf('Rooter to %s', FindRootDirectory())<cr>

" 作为fzf-preview的依赖
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

" preview快捷键 <C-v> - Open vsplit
"               <C-t> - Open tabedit
" NOTE: 1. 下面是coc的plugin: coc-fzf-preview
"       2. 总体功能不如leaderf, 但用于git status, vim-bookmarks，预览buffers挺不错
"{{{  settings
" floating window size ratio
let g:fzf_preview_floating_window_rate = 0.9
let g:fzf_preview_preview_key_bindings = 'ctrl-u:unix-line-discard'
let g:fzf_preview_default_fzf_options = {
            \ '--reverse': v:true, '--preview-window': 'wrap', '--border': v:true,
            \ '--color': 'fg:#bbccdd,fg+:#ddeeff,bg:#334455,preview-bg:#323d43,border:#778899',
            \ }

let g:fzf_preview_command = 'bat --color=always --theme=TwoDark --plain {-1}'  " Intalled bat
let g:fzf_preview_lines_command = 'bat --color=always --theme=TwoDark --plain {-1}'  " Intalled bat
" TODO: 设置ctrl-c不进行commit
let g:my_delta_config_for_fzf_preview = " | delta --no-gitconfig --inspect-raw-lines=false --theme=TwoDark" .
            \ " --plus-emph-style=\"#262626 bold #5f8078\"  --minus-emph-style=\"#262626 bold #9f365c\"" .
            \ " --whitespace-error-style=reverse 22 --plus-style=\"#282828 #87c095\" --minus-style=\"#121212 #d57b7f \""

let g:fzf_preview_git_status_preview_command = "[[ $(git diff -- {-1}) != \"\" ]] && git diff -- {-1} " . g:my_delta_config_for_fzf_preview . " || " .
                    \ "[[ $(git diff --cached -- {-1}) != \"\" ]] && git diff --cached -- {-1} \ " . g:my_delta_config_for_fzf_preview . " || " .
                    \ g:fzf_preview_command
let g:fzf_preview_filelist_command = 'rg --files --hidden --follow --no-messages -g \!"* *"' " Installed ripgrep
let g:fzf_preview_use_dev_icons = 1  " Require vim-devicons
let $FZF_PREVIEW_PREVIEW_BAT_THEME = 'TwoDark' " The theme used in the bat preview


augroup fzf_preview
  autocmd!
  autocmd User fzf_preview#initialized call s:fzf_preview_settings()
  autocmd VimEnter * call vista#RunForNearestMethodOrFunction() " 整合vista
augroup END

function! s:fzf_preview_settings() abort
  let g:fzf_preview_command = 'COLORTERM=truecolor ' . g:fzf_preview_command
  let g:fzf_preview_grep_preview_cmd = 'COLORTERM=truecolor ' . g:fzf_preview_grep_preview_cmd
endfunction

"}}}
nnoremap <silent> <Leader>bl     :<C-u>CocCommand fzf-preview.AllBuffers<CR>
" 只显示文件buffer(不预览当前buffer)
nnoremap <silent> <Leader>Bl     :<C-u>CocCommand fzf-preview.Buffers<CR>
nnoremap <silent> <Leader>gq     :<C-u>CocCommand fzf-preview.QuickFix<CR>

" 模糊搜索 弹窗后按<c-r>进行正则搜索模式, visual模式 '*' 查找函数依赖这个插件，所以不要延迟加载
Plug 'Yggdroot/LeaderF', {'do': './install.sh'}
"settings{{{
" let g:Lf_ShowDevIcons = 0  " 因为和devicon的整合在Startify的session里有bug，所以不显示devicon了
" 整合AsyncTask{{{
function! s:lf_task_source(...)
	let rows = asynctasks#source(&columns * 48 / 100)
	let source = []
	for row in rows
		let name = row[0]
		let source += [name . '  ' . row[1] . '  : ' . row[2]]
	endfor
	return source
endfunction


function! s:lf_task_accept(line, arg)
	let pos = stridx(a:line, '<')
	if pos < 0
		return
	endif
	let name = strpart(a:line, 0, pos)
	let name = substitute(name, '^\s*\(.\{-}\)\s*$', '\1', '')
	if name != ''
		exec "AsyncTask " . name
	endif
endfunction

function! s:lf_task_digest(line, mode)
	let pos = stridx(a:line, '<')
	if pos < 0
		return [a:line, 0]
	endif
	let name = strpart(a:line, 0, pos)
	return [name, 0]
endfunction

function! s:lf_win_init(...)
	setlocal nonumber
	setlocal nowrap
endfunction


let g:Lf_Extensions = get(g:, 'Lf_Extensions', {})
let g:Lf_Extensions.task = {
			\ 'source': string(function('s:lf_task_source'))[10:-3],
			\ 'accept': string(function('s:lf_task_accept'))[10:-3],
			\ 'get_digest': string(function('s:lf_task_digest'))[10:-3],
			\ 'highlights_def': {
			\     'Lf_hl_funcScope': '^\S\+',
			\     'Lf_hl_funcDirname': '^\S\+\s*\zs<.*>\ze\s*:',
			\ },
		\ }
" }}}

let g:Lf_RgConfig = [
      \ '--glob=!\.git/*', '--glob=!\.svn/*', '--glob=!\.hg/*',
      \ '--glob=!\.vscode/*', '--glob=!.ccls', '--glob=!.ccls-cache',
      \ "--glob=!node_modules", "--glob=!lib/*.js", "--glob=!target",
      \ "--glob=!tags", "--glob=!build", "--glob=!.git",
      \ "--glob=!.ccls-cache", '--glob=!**/.repo/*', '--glob=!**/GTAGS',
      \ '--glob=!**/GRTAGS', '--glob=!\.vim/undo\-dir/*', '--glob=!**/GPATH',
      \ '--glob=!**/tags', '--glob=!**/prj_tags', '--iglob=!**/obj/*',
      \ '--iglob=!**/out/*', '--multiline', '--hidden',
      \ ]

let g:Lf_RootMarkers = [ '.project', '.svn', '.git', '.idea', '.tasks', '.clang-format', ]

let g:Lf_WildIgnore = {
            \ 'dir': ['.svn','.git','.cache','.idea','node_modules','build', '.gradle','.hg','.vscode','.wine','.deepinwine','.oh-my-zsh','undo-dir'],
            \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
            \}

" popup的normal模式是否自动预览 FIXME: 如果觉得上下移动很慢的话就得关闭preview
"                               TIP: 不要按着j或<c-j>不动而是连续按j的话就不会显得很慢
let g:Lf_PreviewResult = {
        \ 'File': 1,
        \ 'Buffer': 1,
        \ 'Mru': 1,
        \ 'Tag': 1,
        \ 'BufTag': 1,
        \ 'Function': 1,
        \ 'Line': 1,
        \ 'Colorscheme': 1,
        \ 'Rg': 1,
        \ 'Gtags': 1
        \}

let g:Lf_WindowPosition = 'popup'  " 使用popup
let g:Lf_PopupWidth = 0.66
let g:Lf_PopupHeight = 0.4
let g:Lf_PreviewInPopup = 1  " <c-p>预览弹出窗口
let g:Lf_CursorBlink = 0  " 取消光标闪烁
let g:Lf_ShowHidden = 1  " 搜索结果包含隐藏文件
let g:Lf_IgnoreCurrentBufferName = 1  " 搜索文件时忽略当前buffer FIXME: 不确定这条选项会不会导致搜索不到文件
" let g:Lf_WindowHeight = 0.4  " 非popup窗口的高度
let g:Lf_HistoryNumber = 200  " default 100
let g:Lf_GtagsAutoGenerate = 1  " 有['.git', '.hg', '.svn']之中的文件时自动生成gtags
let g:Lf_RecurseSubmodules = 1  " show the files in submodules of git repository
let g:Lf_RgStorePattern = '+'  "　使用leaderf rg -e ... 搜索时会保存同含义的vim regex形式的正则表达式到+寄存器
let g:Lf_Gtagslabel =  "native-pygments"  " 如果不是gtags支持的文件类型，就用pygments作为补充
let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2"  }  " 分隔符样式
" let g:Lf_FollowLinks = 1  " 是否解析本为link的目录
let g:Lf_WorkingDirectoryMode = 'a'  " the nearest ancestor of current directory that contains one of directories
                                     " or files defined in |g:Lf_RootMarkers|. Fall back to 'c' if no such
                                     " ancestor directory found.
let g:Lf_ShortcutF = ''  " 这两项是为了覆盖默认设置的键位
let g:Lf_ShortcutB = ''
"}}}
nnoremap <silent> <leader>gt :Leaderf --nowrap task<cr>
" <C-t>新标签页打开, <C-l> vsplit <S-Insert>粘贴
let g:Lf_CommandMap = {
            \ '<C-]>':['<C-l>'],
            \ '<C-c>':['<C-d>', '<C-c>'],
            \}  " 搜索后<c-l>在右侧窗口打开文件
noremap <silent> <c-p> :Leaderf command<CR>
nnoremap <silent> <leader>gr :Leaderf mru<cr>
nnoremap <silent> <leader>gf :Leaderf file<cr>
nnoremap <silent> <leader>gs :Leaderf searchHistory<cr>
nnoremap <silent> gf :Leaderf function<cr>
nnoremap <silent> ,gt :Leaderf bufTag<cr>
" 项目下即时搜索
nnoremap <silent> <leader>rg :<C-U>Leaderf rg<cr>
" 项目下搜索词 -F是fix 即不是正则模式
nnoremap <silent> <Leader>gw :<C-U><C-R>=printf("Leaderf! rg -F %s", expand("<cword>"))<CR><cr>
nnoremap <silent> <Leader>gW :<C-U><C-R>=printf("Leaderf! rg -F %s", expand("<cWORD>"))<CR><cr>
xnoremap <silent> <leader>gw :<C-U><C-R>=printf("Leaderf! rg -F %s", leaderf#Rg#visual())<CR><cr>
xnoremap <silent> * :<C-U><C-R>=printf("Leaderf! rg -F --current-buffer %s", leaderf#Rg#visual())<CR><cr>
" buffer内即时搜索
nnoremap <silent> / :Leaderf rg --current-buffer<cr>
" 重复上次搜索, 会直接调用上次搜索结果的缓存
nnoremap <silent> g/ :Leaderf rg --recall<cr>
" buffer内搜索词
nnoremap <silent> gw :<C-U><C-R>=printf("Leaderf! rg -F --current-buffer %s", expand("<cword>"))<CR><cr>
nnoremap <silent> gW :<C-U><C-R>=printf("Leaderf! rg -F --current-buffer %s", expand("<cWORD>"))<CR><cr>
xnoremap <silent> gw :<C-U><C-R>=printf("Leaderf! rg -F --current-buffer %s", leaderf#Rg#visual())<CR><cr>
" 仅测试用, 不知道用不用得上
" 查看tag引用
nnoremap <leader>tr :<C-U><C-R>=printf("Leaderf! gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>
" 查看tag定义
nnoremap <leader>td :<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>

" 浏览marks
Plug 'Yggdroot/LeaderF-marks'
nnoremap <leader>gm :LeaderfMarks<cr>

" Project/buffer内替换 (默认搜索隐藏文件)
Plug 'brooth/far.vim'  " 因为奇怪的遮罩原因，不建议使用on来延迟加载
"{{{
let g:far#mode_open = {'regex': 0, 'case_sensitive': 0, 'word': 0, 'substitute': 1}  " 默认模式,是没有正则的
let g:far#source = 'rgnvim'  " 使用rg + nvim的异步API 作为搜索源 FIXME: 如果以后换了grep工具需要换这个选项
let g:far#enable_undo = 1  " 允许按u进行undo替换
let g:far#auto_write_replaced_buffers = 1  " 自动写入
let g:far#auto_delete_replaced_buffers = 1  " 自动关闭替换完成的buffer
let g:far#ignore_files = ['~/.config/nvim/far-vim-ignore-rule.txt'] " 自定义grep ignore规则
" 快捷键
let g:far#mapping = {
    \ 'replace_do': ['r'],
    \ 'expand_all': ['zm', 'zM'],
    \ 'collapse_all': ['zr', 'zR'],
    \ }
let g:far#default_file_mask = '%'  " 命令行默认遮罩(搜索的范围)
" 命令行补全资源
let g:far#file_mask_favorites = ['%', '**/*.*', '**/*.html', '**/*.js', '**/*.css', '**/*.c', '**/*.cpp',
            \'**/*.ts', '**/*.jsx', '**/*.tsx', '**/*.vue', '**/*.py', '**/*.java',
            \'**/*.md'
            \]
" 自定义快捷键提示样式
let g:far#prompt_mapping = {
    \ 'quit'           : { 'key' : '<esc>', 'prompt' : '<esc>' },
    \ 'regex'          : { 'key' : '<c-r>', 'prompt' : '<c-r>'  },
    \ 'case_sensitive' : { 'key' : '<c-a>', 'prompt' : '<c-a>'  },
    \ 'word'           : { 'key' : '<c-w>', 'prompt' : '<c-w>'  },
    \ 'substitute'     : { 'key' : '<c-f>', 'prompt' : '<c-f>'  },
    \ }
"}}}
" 定义far buffer的映射, NOTE: 如果自己的vimrc里有对应非递归映射(比如nnoremap zo)，则这个插件的映射会失效, 此外由于 插件bug导致不能映射zo  到za
" 快捷键r表示执行替换 q快速退出 x取消当前行 i激活当前行 t是toggle  他们的大写形式(X I T)表示全部行
" 其他用法: Farr交互式查找，并且可以转换成正则模式
" TIP: 已经预先复制好了要替换的内容，可以在命令行用<m-p>粘贴
" TIP: 可以用:3,10Far foo bar **/*.py 指定行和文件, 遮罩%表示本文件，*表示所有文件
" NOTE: 必须要先rooter再替换，否则会找不到文件
" buffer内替换
nnoremap ,su :let @0=expand('<cword>')<cr>:Far <c-r>=expand('<cword>')<cr>  %<left><left><c-f>i
nnoremap ,sU :let @0=expand('<cWORD>')<cr>:Far <c-r>=expand('<cWORD>')<cr>  %<left><left><c-f>i
" {{{Function: My_get_current_visual_text() 获取当前visual选择的文本
function My_get_current_visual_text() abort
    execute "normal! `<v`>y"
    return @"
endfunction
"}}}
xnoremap ,su :<c-u>Far <c-r>=My_get_current_visual_text()<cr>  %<left><left><c-f>i
" Project内替换
nnoremap ,Su :let @0=expand('<cword>')<cr>:Far <c-r>=expand('<cword>')<cr>  *<left><left><c-f>i
nnoremap ,SU :let @0=expand('<cWORD>')<cr>:Far <c-r>=expand('<cWORD>')<cr>  *<left><left><c-f>i
xnoremap ,Su :<c-u>Far <c-r>=My_get_current_visual_text()<cr>  *<left><left><c-f>i
" 交互式替换，按<c-r>可以改变匹配模式为正则 <c-f>在查找和替换模式之间切换
nnoremap ,sr :Farr<cr>


" 在quickfix窗口里编辑  " FIXME: 和quickr-preview有冲突
" Plug 'stefandtw/quickfix-reflector.vim'
" let g:qf_join_changes = 1  " 允许在同一个quickfix里undo多个文件

" 自动预览quickfix  FIXME: 和quickfix-reflector.vim有冲突
Plug 'ronakg/quickr-preview.vim', {'for': 'qf'}
let g:quickr_preview_keymaps = 0  " 禁用默认映射
let g:quickr_preview_on_cursor = 1  " 自动预览

" NOTE: 所有可以用AsyncRun的地方都能用AsyncTask替代，而asyncrun不能打开
"       floaterm，所以只用AsyncTask就好, 这个插件就当一下依赖包好了
" 异步运行，测试
Plug 'skywind3000/asyncrun.vim', { 'on': ['AsyncRun', 'AsyncStop', '<plug>(asyncrun-qftoggle)'] }
"settings{{{
" 任务完成自动打开qf{{{
augroup auto_open_quickfix
    autocmd!
    autocmd QuickFixCmdPost * botright copen 8 | nnoremap <c-j> :cnext<cr> | nnoremap <c-k> :cprevious<cr>
augroup end
"}}}
" {{{lazy load
augroup asyncrun
    au!
    au User asyncrun.vim nnoremap <silent> <plug>(asyncrun-qftoggle) :call asyncrun#quickfix_toggle(10)<cr>
augroup end
"}}}
let g:asyncrun_save = 1  " 运行前保存当前文件
"}}}
nmap gq <plug>(asyncrun-qftoggle)

" 类似VSCode的编译/测试/部署 任务工具
" 不能延迟加载, 因为和Leaderf整合了要用到asyctasks的函数
" 不能在lightline显示运行情况，因为没有类似asynctasks#status()这样的函数
Plug 'skywind3000/asynctasks.vim'
"settings{{{
" let g:asyncrun_open = 8  " 如果不设置就不会在运行时开启quickfix情况
let g:asyncrun_rootmarks = ['.git', '.svn', '.root', '.project', '.hg']
"用floaterm打开的函数{{{
function! s:runner_proc(opts)
    let curr_bufnr = floaterm#curr()
    if has_key(a:opts, 'silent') && a:opts.silent == 1
        FloatermHide!
    endif
    let cmd = 'cd ' . shellescape(getcwd())
    call floaterm#terminal#send(curr_bufnr, [cmd])
    call floaterm#terminal#send(curr_bufnr, [a:opts.cmd])
    stopinsert
    if &filetype == 'floaterm' && g:floaterm_autoinsert
        call floaterm#util#startinsert()
    endif
endfunction

let g:asyncrun_runner = get(g:, 'asyncrun_runner', {})
let g:asyncrun_runner.floaterm = function('s:runner_proc')
"}}}
" let g:asynctasks_term_pos = 'tab'  " 也可以是bottom
let g:asynctasks_term_pos = 'floaterm'
let g:asynctasks_term_rows = 10
let g:asynctasks_config_name = '.git/tasks.ini'
" 触发UIEnter事件方便自动修改quickfix的mapping{{{
function Async_build_file() abort
    execute 'AsyncTask file-build'
    doautocmd UIEnter
endfunc

function Async_run_file() abort
    execute 'AsyncTask file-run'
    doautocmd UIEnter
endfunc

function Async_build_project() abort
    execute 'AsyncTask project-build'
    doautocmd UIEnter
endfunc

function Async_run_project() abort
    execute 'AsyncTask project-run'
    doautocmd UIEnter
endfunc
"}}}
"}}}
noremap <silent> <leader><leader>e :AsyncTaskEdit<cr>
noremap <silent> <leader>bf :FloatermKill!<cr><esc>:call Async_build_file()<cr>
noremap <silent> <leader>rf :FloatermKill!<cr><esc>:call Async_run_file()<cr>
noremap <silent> <leader>bp :FloatermKill!<cr><esc>:call Async_build_project<cr>
noremap <silent> <leader>rp :FloatermKill!<cr><esc>:call Async_run_project<cr>

"}}}
"{{{杂项, 优化使用体验
"
" NOTE: 如果用snap安装nvim 会有nvim.desktop图标，这样从nvim打开的不是真正的firefox
"       解决办法是用其他不带桌面图标的方式安装nvim
" 打开链接  因为open-browser-github.vim依赖这个插件，所以on延迟加载里需要放上open-browser-github.vim的命令
Plug 'tyru/open-browser.vim', {'on': ['<Plug>(openbrowser-open)', 'OpenGithubFile',
                                    \ 'OpenGithubIssue', 'OpenGithubPullReq', 'OpenGithubProject']}
" settings {{{
" let g:openbrowser_browser_commands = [
"         \ {"name": "firefox",
"         \  "args": ["firefox", "{uri}"]},
"         \ ]
"}}}
 " Open URI under cursor.
nmap <leader>gl <Plug>(openbrowser-open)
" Open selected URI.
vmap <leader>gl <Plug>(openbrowser-open)
" https://www.douban.com

" TODO: 还不会用这个功能, 显示找不到User
" 打开文件对应github地址 (依赖open-browser.vim, git命令)
" 还有其他功能参考 https://github.com/tyru/open-browser-github.vim
Plug 'tyru/open-browser-github.vim', {'on': ['<Plug>(openbrowser-open)', 'OpenGithubFile', 'OpenGithubIssue',
                                           \ 'OpenGithubPullReq', 'OpenGithubProject']}
" Opens a specific file in github.com repository(it also opens in the current branch by default).
nnoremap ,gg :OpenGithubFile<cr>
" Opens a specific Issue. (可在命令后面设置数字)
nnoremap ,gi :OpenGithubIssue<cr>
nnoremap ,gp :OpenGithubPullReq<cr>
nnoremap ,gP :OpenGithubProject<cr>

"
" 编辑嵌套的代码，可以有独立的缩进和补全，使用场景: JS, Css在Html里面，
" Markdown内嵌代码，Vue组件，代码内嵌SQL
Plug 'AndrewRadev/inline_edit.vim', {'on': 'InlineEdit'}
nnoremap <leader>ei :InlineEdit<cr>a
xnoremap <leader>ei :InlineEdit<cr>a

" sudo for neovim  (原来的tee trick只对vim有用，对neovim无效)
Plug 'lambdalisue/suda.vim'
"{{{
" suda automatically switch a buffer name when the target file is not readable or writable.
let g:suda_smart_edit = 1
"}}}
"{{{suda.vim-usage
" :E filename  sudo edit
" :W       sudo edit
"}}}
command! -nargs=1 E SudaRead <args>
command! W SudaWrite %

" 用vim看man
Plug 'lambdalisue/vim-manpager', {'on': 'Man'}
augroup temporar_change_manpager_mapping
    autocmd!
    autocmd FileType man nmap <silent> <buffer> <C-j> ]t
    autocmd FileType man nmap <silent> <buffer> <C-k> [t
augroup end

" 显示搜索的的数量以及当前位置
Plug 'osyo-manga/vim-anzu', {'on': ['<Plug>(anzu-n-with-echo)', '<Plug>(anzu-N-with-echo)', '<Plug>(anzu-star-with-echo)', '<Plug>(anzu-sharp-with-echo)']}
nmap n <Plug>(anzu-n-with-echo)zv
nmap N <Plug>(anzu-N-with-echo)zv
nmap * <Plug>(anzu-star-with-echo)zv
nmap # <Plug>(anzu-sharp-with-echo)zv

" 优化bd体验，关闭buffer但是不关闭窗口
Plug 'mhinz/vim-sayonara', {'on': [ 'Sayonara','Sayonara!' ]}
nnoremap <silent> <leader>bd :Sayonara!<cr>

" 一键生成注释（15+种语言）NOTE: C、C++的注释依赖clang 但是似乎有bug 暂时不建议踩这个坑，c++随便注释下就好了
Plug 'kkoomen/vim-doge', {'do': { -> doge#install() }, 'on':['DogeGenerate']}
"{{{ settings
let g:doge_enable_mappings = 0  " 取消默认映射
let g:doge_mapping = ''
let g:doge_filetype_aliases = {
            \ 'javascript': [
            \     'javascript.jsx',
            \     'javascriptreact',
            \     'javascript.tsx',
            \     'typescriptreact',
            \     'typescript',
            \     'typescript.tsx',
            \     'vue'
            \ ],
            \ 'java': ['groovy'],
            \ }
"}}}
nnoremap <leader>cm :DogeGenerate<cr>

"  选择区域进行diff
Plug 'rickhowe/spotdiff.vim', {'on': 'Diffthis'}
let s:in_diff_hunk_status = 0
" diff two window
nnoremap <silent> <leader>df :windo diffthis<cr>:windo doautocmd User MyEnterDiffMode<cr><c-w>w
" diff selsct
vnoremap <silent> <leader>df :Diffthis<cr>
" diff close
nnoremap <silent> <leader>dc :windo diffoff<cr>:windo setlocal syntax=on<cr><c-w>w

" 查看各种离线API文档, 使用:Docset 参数<cr>可以指定当前buffer的文档(docset), 重置当前buffer文档
" 类型, 使用:Docset<cr>重置当前buffer为默认文档类型
Plug 'KabbAmine/zeavim.vim', {'on': ['<Plug>Zeavim', '<Plug>ZVVisSelection',
            \ '<Plug>ZVOperator', '<Plug>ZVKeyDocset', 'Docset']}
"{{{
" let g:zv_keep_focus = 0  " 打开zeal后是否focus vim, 默认是1
" 根据文件类型查找文档
let g:zv_file_types = {
            \   'help'                : 'vim',
            \   'javascript'          : 'javascript,nodejs',
            \   'python'              : 'python_3',
            \   '\v^(G|g)ulpfile\.js' : 'gulp,javascript,nodejs',
            \ }
"}}}
" 自动选择<cword>和文件类型
nmap <leader>z <Plug>Zeavim
vmap <leader>z <Plug>ZVVisSelection
" gz{motion/text-object}
nmap gz <Plug>ZVOperator
" 手动选择文档包名
nmap <leader><leader>z <Plug>ZVKeyDocset

" 精炼之后的Man :Tldr [command],    :TldrUpdateDocs
" NOTE: 安装插件后必须先用TldrUpdateDocs命令下载才行
Plug 'wlemuel/vim-tldr', {'on': ['Tldr', 'TldrUpdateDocs']}
nnoremap ,tl :Tldr<space>

"}}}
" ---------------------------------------
" Layer
"{{{前端 Layer
if g:enable_front_end_layer == 1


    " Node.js支持
    " Plug 'moll/vim-node', {'for': [ 'javascript', 'typescript', '*jsx', '*tsx' ]}

    " 实时预览html,css,js
    Plug 'turbio/bracey.vim', {'do': 'npm install --prefix server', 'on': 'Bracey'}
    " browser-open
    nnoremap <leader>bo :Bracey<cr>

    " ---- 颜色选择器 ----
    " 打开gpick面板
    nnoremap <leader>pc :AsyncTask gpick<cr>
    " 选择一次颜色就关闭
    nnoremap <leader>pco :AsyncTask gpick-once<cr>

    " 具体的snippets见 https://github.com/mlaursen/vim-react-snippets
    " Plug 'mlaursen/vim-react-snippets'

    " plug 模板引擎
    " Plug 'digitaltoad/vim-pug'

endif
"}}}
"{{{写作 Layer
" NOTE:　目前影响markdown排版的有pangu, ale里设置的prettier, lint是用的coc-markdownlint
" TIP: 尝试过语法检查插件, 不怎么好用，最好在vim里写完了再去专门的网站检查

" Sink沉浸写作模式
Plug 'junegunn/goyo.vim', {'on': 'Goyo'}
"{{{
nnoremap <silent> ,sn :Goyo<cr>
function! s:goyo_enter()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  execute 'normal ZT'
  execute 'ALEDisable'
  execute 'SignifyDisable'
  set noshowmode
  set shortmess+=c
  set noshowcmd
  Limelight
endfunction

function! s:goyo_leave()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  execute 'normal ZT'
  execute 'ALEEnable'
  execute 'SignifyEnable'
  set showmode
  set showcmd
  Limelight!
  call My_render_custom_highlight()  " 恢复折叠和column的颜色
endfunction
"}}}
augroup goyo_toggle_callback
    autocmd!
    autocmd! User GoyoEnter nested call <SID>goyo_enter()
    autocmd! User GoyoLeave nested call <SID>goyo_leave()
augroup end

" 模糊非视觉中心的字符
Plug 'junegunn/limelight.vim', {'on': 'Limelight'}

" MarkDown预览, 目前似乎只支持本地图片, 不支持在线的图片
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vimwiki']}
"{{{
let g:mkdp_command_for_global = 1  " 所有文件中可以使用预览markdown命令
"}}}
nmap <leader>mp <Plug>MarkdownPreviewToggle

" 运行markdown内代码
Plug 'dbridges/vim-markdown-runner', { 'on': ['MarkdownRunner', 'MarkdownRunnerInsert'] }
augroup My_markdown_run
    autocmd!
    autocmd FileType markdown nnoremap <buffer> <Leader>rf :MarkdownRunner<CR>
    autocmd FileType markdown nnoremap <buffer> <Leader>Rf :MarkdownRunnerInsert<CR>
augroup end

" 非常强大的插件, 插入模式<c-t>缩进，<c-d>反缩进 <leader>x 可以开关checkbox
" 自动填列表的1,2,3 还有a,b,c，enter或normal模式的o删除最后一个空的bullet
" 还可以自定义outline层级使用的标记，决定是否renumbered on change
Plug 'dkarter/bullets.vim', {'for': ['markdown', 'text', 'gitcommit', 'scratch'] }
"{{{
let g:bullets_enabled_file_types = ['markdown', 'text', 'gitcommit', 'scratch']
" let g:bullets_set_mappings = 0  " 禁用默认mapping
"}}}

" 添加标题和代码块折叠
Plug 'masukomi/vim-markdown-folding', {'for': 'markdown'}


" Todo List 和 笔记，文档管理
Plug 'vimwiki/vimwiki', {'on': 'VimwikiIndex'}  " NOTE: 使用延迟加载的话可能在session中有bug
" {{{
" 使用markdown而不是vimwiki的语法
let g:vimwiki_list = [{'path': '~/vimwiki/',
            \ 'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_folding='expr'
" 禁用table_mappings在insert mode 对<tab>的映射, 避免和coc的补全快捷键冲突
let g:vimwiki_key_mappings =
\ {
\   'all_maps': 1,
\   'global': 1,
\   'headers': 1,
\   'text_objs': 1,
\   'table_format': 1,
\   'table_mappings': 0,
\   'lists': 1,
\   'links': 1,
\   'html': 1,
\   'mouse': 0,
\ }

"}}}
nnoremap <leader>ew :VimwikiIndex<cr>

"　自动commit,push　vimwiki
Plug 'michal-h21/vimwiki-sync', { 'for': 'vimwiki', 'on': ['VimwikiIndex'] }


"}}}
" {{{其他语言 Layer

" Java增强语法高亮
Plug 'uiiaoo/java-syntax.vim', {'for': ['java']}
"}}}
" ---------------------------------------
"{{{打算以后再体验的插件
"

" 多光标插件有bug 用不了

" coc-import-cost (仅用于JS和TS)
" coc-css-block-comments
" coc-sql (lint和format, format似乎要手动, 看ale能不能自动调用这个插件自带的sql-formatter吧)

" 似乎是vim唯一的test插件, 支持CI
" Plug 'janko/vim-test'
"
" SQL Wrapper (不建议使用另一个插件vim-sql-workbench 因为太麻烦了)
" Plug 'joereynolds/SQHell.vim'

" 数据库接口(似乎只能查询)
" Plug 'tpope/vim-dadbod'
" 数据库接口的ui
" Plug 'kristijanhusak/vim-dadbod-ui'




" Github支持
"Plug 'junegunn/vim-github-dashboard'
" Gist　支持
" Plug 'mattn/vim-gist'

" 为不同的文件类型设置不同的tab expand 编码 EOF
"Plug 'editorconfig/editorconfig-vim'

" 快速创建表格
"Plug 'dhruvasagar/vim-table-mode'
" 生成Markdonw TOC
"Plug 'mzlogin/vim-markdown-toc'

" 自动生成作者、时间等信息
" Plug 'alpertuna/vim-header'

" 自定义正则表达式替换规则(即保存替换patterm)
" Plug 'AndrewRadev/switch.vim'





" ===========================================
" ============================================
" 以下插件目前看不到使用场景，作为尝鲜用的吧

" Vue支持
" coc-vetur

" 高亮多组选中单词, 缺点是需要重新映射n, N与anzu插件有冲突(当然可以选择不要next occurrence功能)
" Plug 'lfv89/vim-interestingwords'

" React NOTE: 因为有coc-tsserver了 不确定需不需要
" coc作者早期的插件，高亮以及缩进, js对jsx的适配
" Plug 'neoclide/vim-jsx-improve'

" 最新的 Stylus 语法高亮，可能被polyglot替代了
" Plug 'iloginow/vim-stylus'

" normal模式fcitx输入法自动切换到英文输入
" NOTE: 会把启动速度拖慢180ms左右, 而且延时启动会导致依赖的命令用不了, 只能特
" 定文件类型用了
" Plug 'lilydjwg/fcitx.vim', {'for': ['markdown', 'vimwiki']}

" NOTE: pencil这个插件不怎么好用, 不推荐

" 添加文件图标 NOTE: 需要放在startify之后才能在startify中生效
Plug 'ryanoasis/vim-devicons'
let g:webdevicons_enable_startify = 1

"}}}
call plug#end()

"==========================================
" 自定义快捷键 Hotkey
" ==========================================
" {{{重要的按键重定义
inoremap kj <esc>
cnoremap kj <c-c>
nnoremap ? /
" 去掉搜索高亮
nnoremap <silent> <leader>/ :nohls<cr>
" 重复上次搜索
nnoremap g? /<c-r>/<cr>
noremap ; :
" 打开或折叠一个fold
nmap zo za
" 打开或折叠所有的fold
nnoremap <expr> zzo &foldlevel ? 'zM' :'zR'
noremap ,; ;
nnoremap ,w :w<cr>
" 解决通过命令let @" = {text}设置的@" 不能被p正确粘贴的问题
nnoremap p ""p
vnoremap v <esc>
" 快速退出选择模式
xnoremap v <esc>
inoremap jj <esc>o
inoremap kk <esc>O
inoremap kkj k<esc>
" 快速在行末写分号并换行, 如果左边一个字符是分号则直接换行
inoremap <expr> ;; nr2char(strgetchar(getline('.')[col('.') - 2:], 0)) == ';' ? '<c-o>o' : '<esc>A;<esc>o'
inoremap <expr> ;j nr2char(strgetchar(getline('.')[col('.') - 2:], 0)) == ';' ? '<esc>jo' : '<c-o>A;<esc>jo'
inoremap <expr> ,, nr2char(strgetchar(getline('.')[col('.') - 2:], 0)) == ',' ? '<c-o>o' : '<esc>A,<esc>o'
inoremap        ,j <esc>jo
" 开关大小写
inoremap ;u <esc>viW~A
inoremap ;a <left>
inoremap ;d <right>
inoremap ;e <esc>Ea
inoremap ;b <esc>Bi
cnoremap ;a <left>
cnoremap ;d <right>


" 快速创建折叠marker, 避免受autopair的影响
imap <expr> ;z &foldmethod == 'marker' ? '<c-_>a<space>{{{<del><del><del>' : ';z'
imap <expr> ;x &foldmethod == 'marker' ? '<c-_>a<space>}}}<del><del><del>' : ';x'
" NOTE: 这里用imap是因为要借用auto-pairs插件提供的{}自动配对
imap [[ <esc>A<space>{<cr>
" 连接下一行
nnoremap tj J
" 废弃ZZ退出
noremap ZZ <nop>
"}}}
"{{{ 更便捷的移动以及视角居中
"set wrap之后，在折行之间也可以跳, 指定行数后会忽视wrap的行
nnoremap <silent> <expr> k
        \ v:count == 0 ? 'gk' : 'k'
vnoremap <silent> <expr> k
        \ v:count == 0 ? 'gk' : 'k'
nnoremap <silent> <expr> j
        \ v:count == 0 ? 'gj' : 'j'
vnoremap <silent> <expr> j
        \ v:count == 0 ? 'gj' : 'j'
" 在同一个折叠的首尾部跳转
nnoremap zj ]z
nnoremap zk [z
noremap J <C-f>
noremap K <C-b>
" 去上次修改的地方
nnoremap gi gi<esc>zvzzi
" goto previous/next change positon
nnoremap g, g,zv
nnoremap g; g;zv
nnoremap '' ``zv
nnoremap '. `.zv
" HACK: zv可以自动展开折叠
nnoremap <c-o> <c-o>zv
nnoremap <c-i> <c-i>zv
nnoremap u uzv
nnoremap <c-r> <c-r>zv
" 交换 ' `, 使得可以快速使用'跳到marked相同的位置
noremap ' `
noremap ` '
nnoremap H ^
nnoremap L $
vnoremap H ^
vnoremap L $h
noremap Y y$
nnoremap yh y^
nnoremap yl y$
nnoremap dh d0
nnoremap dl d$
nnoremap ch c0
nnoremap cl c$

" 命令行和插入模式增强
" (下三行废弃，因为在最后有功能更强的mapCmdPairs()函数实现)
" cnoremap ' ''<left>
" cnoremap " ""<left>
" cnoremap ( ()<left>
inoremap <c-e> <del>

cnoremap <c-h> <home>
cnoremap <c-l> <end>
cnoremap <c-e> <del>
cnoremap <m-p> <c-r>0

inoremap <c-h> <esc>I
inoremap <c-l> <esc>A
nnoremap <c-h> ^
nnoremap <c-l> $
inoremap <m-p> <c-r>0
nnoremap <m-p> "0p
"}}}
"{{{ Buffer Window Tab 操作
" Buffer操作
nnoremap <silent> <m-l> :bn<cr>
nnoremap <silent> <m-h> :bp<cr>
inoremap <silent> <m-l> <esc>:bp<cr>
inoremap <silent> <m-h> <esc>:bn<cr>

"{{{删除隐藏的buffer
let s:close_buffers_exclude_filetypes = ['floaterm', 'coc-explorer', 'vista', 'qf']

" CloseNoDisplayedBuffers: Close buffers which are not opened in window
function! DeleteHiddenBuffers() abort
  let l:visible = {}
  for t in range(1, tabpagenr('$'))
    for b in tabpagebuflist(t)
      let l:visible[b] = 1
    endfor
  endfor

  let l:count = 0
  for b in range(1, bufnr('$'))
    if index(s:close_buffers_exclude_filetypes, getbufvar(b, '&filetype')) > -1
      continue
    endif
    if bufexists(b) && !has_key(visible, b)
      try
        execute 'bwipeout' b
        let l:count += 1
      catch
      endtry
    endif
  endfor
  echo "Closed ".l:count." hidden buffers"
endfunc

"}}}
nnoremap <leader>bcl :call DeleteHiddenBuffers()<cr>

" Window操作
" 调整窗口布局
nnoremap <silent> <leader>wh :wincmd H<cr>
nnoremap <silent> <leader>wj :wincmd J<cr>
nnoremap <silent> <leader>wk :wincmd K<cr>
nnoremap <silent> <leader>wl :wincmd L<cr>
" swap to right
nnoremap <silent> <leader>ws <c-w>x<c-w>=
nnoremap <leader>w= <c-w>=
nnoremap <leader>we <c-w>=
" 窗口最大化 leaving only the help window open/maximized
nnoremap <leader>wo <c-w>o
nnoremap <leader>ss <c-w>s<c-w>w
noremap <silent> <leader>sv :wincmd v<cr>:wincmd w<cr>
noremap <silent> <leader>j :wincmd j<cr>
noremap <silent> <leader>k :wincmd k<cr>
noremap <silent> <leader>h :wincmd h<cr>
noremap <silent> <leader>l :wincmd l<cr>

" Tab操作
nnoremap <leader><leader>h gT
nnoremap <leader><leader>l gt

" functions {{{
function! TabCloseRight(bang)
    let cur=tabpagenr()
    while cur < tabpagenr('$')
        exe 'tabclose' . a:bang . ' ' . (cur + 1)
    endwhile
endfunction

function! TabCloseLeft(bang)
    while tabpagenr() > 1
        exe 'tabclose' . a:bang . ' 1'
    endwhile
endfunction
command! -bang Tabcloseright call TabCloseRight('<bang>')
command! -bang Tabcloseleft call TabCloseLeft('<bang>')
"}}}
nnoremap gxl :Tabcloseright<cr>
nnoremap gxh :Tabcloseleft<cr>
nnoremap gxo :tabonly<cr>
nnoremap t. :+tabmove<CR>
nnoremap t, :-tabmove<CR>
nnoremap <silent> <c-t> :tab split<cr>
" {{{Quit tab, even if it's just one
function! s:my_quit_tab()
  for bufnr in tabpagebuflist()
    if bufexists(bufnr)
      let winnr = bufwinnr(bufnr)
      exe winnr.'wincmd w'
      quit
    endif
  endfor
endfunction
"}}}
" nnoremap <c-w> :call <SID>my_quit_tab()<cr>
nnoremap <silent> <c-w> :tabclose<cr>
inoremap <silent> <c-t> <esc>:tab split<cr>
" normal模式下切换到确切的tab
for s:count_num in [1,2,3,4,5,6,7,8,9]
    exec 'nnoremap <leader>' . s:count_num . ' ' . s:count_num . 'gt'
endfor
"}}}
" 替换 (在当前buffer/当前选中范围){{{
" NOTE: 目前被far.vim插件替代, 不过同一文件内小范围的替换用这个方式还是更方便一些
" 当前buffer替换
nnoremap <leader>su :let @0=expand('<cword>')<cr>:%s/<c-r>=expand('<cword>')<cr>//gc<left><left><left>
nnoremap <leader>sU :let @0=expand('<cword>')<cr>:%s/<c-r>=expand('<cWORD>')<cr>//gc<left><left><left>
xnoremap  <leader>su :<c-u>%s/<c-r>=My_get_current_visual_text()<cr>//gc<left><left><left>
nnoremap <leader>rsu :%s/\v//gc<left><left><left><left>

" 范围内替换
xnoremap  <leader>Su :s///gc<left><left><left><left>
" 范围内正则替换
xnoremap <leader>rSu :s/\v//gc<left><left><left><left>
"}}}
"{{{修改默认快捷键到更令人舒适的行为

" cnoremap 命令模式的autopair{{{
function! s:cmdClosingPair (closing, opening)
    let pos  = getcmdpos()
    let line = getcmdline()
    let next = line[pos - 1]
    if next == a:closing
        return "\<Right>"
    elseif a:closing == a:opening
        return a:opening . a:closing . "\<Left>"
    else
        return a:closing
    end
endfunction

function! s:isAtEndOfCmdline ()
  return 1
    return getcmdpos() == 1+len(getcmdline())
endfunction

function! s:cmdDeletePair (char)
    let pos  = getcmdpos()
    let line = getcmdline()
    let char_before = line[pos - 2]
    let char_after  = line[pos - 1]
    if has_key(s:cmd_pairs, char_before)
      \ && s:cmd_pairs[char_before] == char_after
        return "\<Right>\<BS>\<BS>"
    else
        return a:char
    end
endfunction

function! s:mapCmdPairs()
    let s:cmd_pairs = {
    \'(': ')',
    \'[': ']',
    \'{': '}',
    \'"': '"',
    \"'": "'"
    \}
    for k in keys(s:cmd_pairs)
    let opening = k
    let closing = s:cmd_pairs[k]
    execute 'cnoremap ' . opening . ' ' . opening . closing .'<Left>'
    if closing == '"'
        execute "cnoremap <expr>" . closing . " <SID>cmdClosingPair('" . closing . "', '" . opening ."')"
    else
        execute 'cnoremap <expr>' . closing . ' <SID>cmdClosingPair("' . closing . '", "' . opening .'")'
    end
    endfor
    cnoremap <expr><BS>  <SID>cmdDeletePair("\<BS>")
    cnoremap <expr><C-h> <SID>cmdDeletePair("\<C-h>")
endfunction

call <SID>mapCmdPairs()
"}}}
"{{{ 更方便的跳转标记
let s:alphabet =['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k',
            \'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
            \'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N',
            \'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',]
for single_char in s:alphabet
    exec "nnoremap '" . single_char . ' `' . single_char . 'zv'
endfor
"}}}
" 调整缩进后自动选中，方便再次操作
vnoremap < <gv
vnoremap > >gv
nnoremap < <<
nnoremap > >>
" 让y复制后光标仍在原位
vnoremap y ygv<esc>
" 让normal模式的s不要污染无名寄存器, 因为一个字母没有必要覆盖之前的寄存器内容
" 同时visual模式s表示删除，x表示剪切
nnoremap s "_s
vnoremap s "_s
" 创建折叠自动在上下两行添上注释;  zc在创建折叠的同时也执行折叠
" S<cr>依赖surround.vim插件
vmap zf S<cr>gv<esc>o<esc>gvj:fold<cr>zjzkzc
"}}}
" {{{通过快捷键实现新功能

" TIP: g<c-g> 可以统计字数,行，字节，字符 会将汉字、标点、空格、英文字母都看做一个字, 还可以选择模式使用, 具体信息查看:h g^g
" TIP: 待映射快捷键: v? q? T? z?
" 重复上次执行的寄存器的命令
nnoremap <leader>r; @:
" 执行宏 q
nnoremap R @q
" 可以在选中的行执行宏　xnoremap <expr> <leader>@ ":norm! @".nr2char(getchar())."<CR>"
xnoremap <expr> R ":norm! @q<CR>"

" 转换成大写
nnoremap gu viWgUgv<esc>
vnoremap gu gUgv<esc>

" 退出系列 TODO: 关闭时:ALEDisableBuffer<cr>
noremap <silent> <leader>q :q<cr>
"{{{ 退出Vim并自动保存会话
" 如果当前不在Session中就保存到default.vim，否则保存当前Session
function Save_default_session_and_exit() abort
    let session_name = fnamemodify(v:this_session,':t')
    let session_name = session_name == '' ? 'default.vim' : session_name
    execute 'SSave! ' . session_name
    execute 'qa'
endfunction
"}}}
noremap <silent> Q <esc>:call Save_default_session_and_exit()<cr>

" toggle foldlevel=0 / foldlevel=1
" {{{function My_toggle_foldlevel()
let g:My_toggle_foldlevel_mode = 0
fun My_toggle_foldlevel()
    if g:My_toggle_foldlevel_mode == 0
        setlocal foldlevel=0
        let g:My_toggle_foldlevel_mode = 1
    else
        setlocal foldlevel=1
        let g:My_toggle_foldlevel_mode = 0
    endif
endf
"}}}
nnoremap <silent> z0 :call My_toggle_foldlevel()<cr>
" 快速调整折叠层级
for i in range(1, 10)
    execute 'nnoremap z' . i . ' :setlocal foldlevel=' . i . '<cr>zz'
endfor
nnoremap z- :setlocal foldlevel-=1 <Bar> call Info('&foldlevel = ' . &foldlevel)<CR>
nnoremap z+ :setlocal foldlevel+=1 <Bar> call Info('&foldlevel = ' . &foldlevel)<CR>

" 在markdown中调整conceallevel (visible)
nnoremap <expr> <silent> <leader>vi &conceallevel == 3 ? ':set conceallevel=0<cr>' : ':set conceallevel=3<cr>'

" HACK: 新发现，解锁v键映射
nnoremap vv ggVG

"}}}


" ==========================================
"{{{ 自定义命令 Commands
"{{{ Ctabs: Open all files in quickfix window in tabs
command! Ctabs call s:Ctabs()
function! s:Ctabs()
  let files = {}
  for entry in getqflist()
    let filename = bufname(entry.bufnr)
    let files[filename] = 1
  endfor

  for file in keys(files)
    silent exe "tabedit ".file
  endfor
endfunction
"}}}
"{{{ Gfiles: Open all git-modified files in tabs
command! Gfiles call s:Gfiles()
function! s:Gfiles()
  let files = split(system('git status -s -uall | cut -b 4-'), '\n')

  for file in files
    silent exe "tabedit ".file
  endfor
endfunction
"}}}
"{{{ Repeatable: Make the given command repeatable using repeat.vim
command! -nargs=* Repeatable call s:Repeatable(<q-args>)
function! s:Repeatable(command)
  exe a:command
  call repeat#set(':Repeatable '.a:command."\<cr>")
endfunction
"}}}
command! Chmodx :!chmod a+x %  " make current buffer executable
command! FixSyntax :syntax sync fromstart  " fix syntax highlighting
command! RefreshSyntax :set syntax=off | set syntax=on
command! OI :silent! call CocActionAsync('runCommand', 'editor.action.organizeImport')<cr>
"}}}
" ==========================================
"{{{ 新增功能 Utilities
"
"==========================================
" --------- 自动生效的功能 -----------
" {{{自动保存
function! s:Autosave(timed)
    if !&modifiable || mode() == 'c' || pumvisible()
        return
    endif
    let current_time = localtime()
    let s:last_update = get(s:, 'last_update', 0)
    let s:time_delta = current_time - s:last_update

    if a:timed == 0 || s:time_delta >= 1
        let s:last_update = current_time
        if &buftype != 'nofile'  " 不对非文件的buffer进行检测
            checktime  " checktime with autoread will sync files on a last-writer-wins basis.
        endif
        silent! doautocmd BufWritePre %  " needed for soft checks
        silent! update  " only updates if there are changes to the file.
        if a:timed == 0 || s:time_delta >= 4
            silent! doautocmd BufWritePost %  " Periodically trigger BufWritePost.
        endif
    endif
endfunction

if g:enable_file_autosave
    augroup WorkspaceToggle
        au! BufLeave,FocusLost,FocusGained * call s:Autosave(0)
        au! CursorHold * call s:Autosave(1)
    augroup END
endif
"}}}
"
" ------------------------------------
" --------需要主动了解的功能----------
" {{{对vim作为git difftoll的增强, <leader><leader>q 强制退出difftool
"function Settings_for_difftool_mode(){{{
function Settings_for_difftool_mode() abort
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
" 当把vim作为git的difftool时，设置 git config --global difftool.trustExitCode true && git config --global mergetool.trustExitCode true
" 在git difftool或git mergetool之后  可以用:cq进行强制退出diff/merge模式，而不会不停地recall another diff/merge file
augroup auto_syntax_off_on_nvim_as_mergetool
    autocmd!
    autocmd VimEnter * if (&filetype != 'startify') | call Settings_for_difftool_mode()
augroup end
"}}}
"{{{当有两个窗口时, 滚动另一个窗口 <c-j/k/d/e/gg/G>
"{{{ function
function! ScrollAnotherWindow(mode)
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
nnoremap <silent> <c-k> :call ScrollAnotherWindow(1)<CR>
nnoremap <silent> <c-j> :call ScrollAnotherWindow(2)<CR>
nnoremap <silent> <c-e> :call ScrollAnotherWindow(3)<CR>
nnoremap <silent> <c-d> :call ScrollAnotherWindow(4)<CR>
"}}}
"{{{ 快速编辑特定文件 <leader>e{?}
" 快速编辑init.vim
nnoremap <leader>en :e $MYVIMRC<CR>
" 快速编辑tmux配置文件
nnoremap <leader>et :e $HOME/.tmux.conf<cr>
" 编辑该文件类型的snippets

" 搜索并alternative文件(比如在c和头文件之间替换, 用于c/cpp和h文件不在同一目录的情况),　具体的可以自己定义字典
"{{{ function
function! Alternative()
    let name = expand("%:t:r")
    let extension = expand("%:e")
    let mapping = {"h": "c", "cpp": "h", 'c': 'h'}
    return name . '.' . get(mapping, extension, "")
endfunction
"}}}
noremap <silent> <leader>ea :<C-U><C-R>=printf("Leaderf file --input %s", Alternative())<CR><CR>
nnoremap <leader>es :CocCommand snippets.editSnippets<cr>
" 快速编辑同目录下的文件
nnoremap ,e :e <c-r>=expand('%:p:h')<cr>/
nnoremap ,E :tabedit <c-r>=expand('%:p:h')<cr>/
nnoremap ,n :!mkdir <c-r>=expand('%:p:h')<cr>/
"}}}
"{{{ 快速添加空白行 {v:count} ]或[<space>
"{{{ function
function! s:BlankUp(count) abort
    put!=repeat(nr2char(10), a:count)
    ']+1
endfunction

function! s:BlankDown(count) abort
    put =repeat(nr2char(10), a:count)
    '[-1
endfunction
"}}}
augroup my_new_blank
    autocmd!
    " 因为受到自带的ftplugin干扰，所以需要用这么麻烦的定义快捷键方式
    autocmd BufWinEnter * nnoremap <buffer> ]] :<c-u>call <sid>BlankDown(v:count1)<cr>
    autocmd BufWinEnter * nnoremap <buffer> [[ :<c-u>call <sid>BlankUp(v:count1)<cr>
    autocmd filetype vim nnoremap <buffer> ]] :<c-u>call <sid>BlankDown(v:count1)<cr>
    autocmd filetype vim nnoremap <buffer> [[ :<c-u>call <sid>BlankUp(v:count1)<cr>
augroup end
"}}}
" {{{ 切换colorscheme <leader>cj/k
"{{{ function
let g:current_coloscheme_mode = g:default_colorscheme_mode
fun My_change_colorscheme(mode) abort
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
    let g:lightline.colorscheme = g:lightline_schemes[g:current_coloscheme_mode]

    call lightline#init()
    call lightline#colorscheme()
    call lightline#update()
    call My_render_custom_highlight()  " 恢复折叠和column的颜色
    set syntax=on  " 用于刷新syntax解决markdown奇奇怪怪的渲染
endf
"}}}
" 可以直接<leader>c1~9 选择特定主题
for i in range(1, len(g:all_colorschemes))
    execute 'nnoremap <silent> <leader>c' . i . ' :call My_change_colorscheme(' . (i-1) . ')<cr>'
endfor
nnoremap <silent> <leader>cj :call My_change_colorscheme('next')<cr>
nnoremap <silent> <leader>ck :call My_change_colorscheme('previous')<cr>
"}}}
" {{{ 行号开关，用于鼠标复制代码用, 为方便复制 <F2>
"{{{ function
function! ToggleColumnNumber()
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
nnoremap <F2> :call ToggleColumnNumber()<cr>
" }}}
"{{{ 部分插件开关，提升大文件编辑体验 <F4>
"{{{ function
function Faster_mode_for_large_file()
    " 开关spelunker拼写检查插件
    execute 'normal ZT'
    " 这个一般由于向VCS仓库中新增了大文件而导致的大面积column实时重绘, 所以需要关闭
    execute 'SignifyToggle'
    execute 'ALEToggleBuffer'
endfunction
"}}}
nnoremap <F4> :call Faster_mode_for_large_file()<cr>
"}}}
" {{{查看highlighting group <F12>
"{{{ function
function! s:synstack()
    echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), ' -> ')
endfunction
"}}}
nnoremap <F12> :<C-u>call <SID>synstack()<CR>
"}}}
" 代码高亮开关 <leader>0{{{
nnoremap <leader>0 :exec exists('syntax_on') ? 'syn off' : 'syn on'<cr>
"}}}
" {{{ 切换透明模式, 需要预先设置好终端的透明度 <leader>tt
"{{{ function
function s:Enable_transparent_scheme() abort
    call s:HL('FoldColumn', s:palette.grey, s:palette.none)
    call s:HL('Folded', s:palette.grey, s:palette.none)
    call s:HL('SignColumn', s:palette.none, s:palette.none)
    call s:HL('OrangeSign', s:palette.orange, s:palette.none)
    call s:HL('PurpleSign', s:palette.purple, s:palette.none)
    call s:HL('BlueSign', s:palette.none, s:palette.none)
endfunction

let g:in_transparent_mode = 0
function! Toggle_transparent_background()
  if g:in_transparent_mode == 1
    let g:in_transparent_mode = 0
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
nnoremap <silent> <leader>tt :call Toggle_transparent_background()<CR>
"}}}
"{{{ 检查Vim运行性能,结果放在profile.log中,需要用两次 <leader>cp
"{{{ function
let g:check_performance_enabled = 0
fun Check_performance()
    if g:check_performance_enabled == 0
        execute 'profile start profile.log'
        execute 'profile file *'
        execute 'profile func *'
        let g:check_performance_enabled = 1
    else
        execute 'profile stop'
        execute 'normal Q'
    endif
endf
"}}}
nnoremap <leader>cp :call Check_performance()<cr>
"}}}
"{{{ 复制当前文件的名字，绝对路径，目录绝对路径
function Copy_to_registers(text) abort  "{{{
    let @" = a:text
    let @0 = a:text
    let @+ = a:text  " system clipboard on Linux
    let @* = a:text  " system clipboard on Windows
endfunction
"}}}
nnoremap <leader>yfn :call Copy_to_registers(expand('%:t'))<cr>:echo printf('filename yanked: %s', expand('%:t'))<cr>
nnoremap <leader>yap :call Copy_to_registers(expand('%:p'))<cr>:echo printf('absolute path yanked: %s', expand('%:p'))<cr>
nnoremap <leader>ydr :call Copy_to_registers(expand('%:p:h'))<cr>:echo printf('absolute dir yanked: %s', expand('%:p:h'))<cr>
nnoremap gl :lcd %:p:h<cr>:let mycurf=expand("<cfile>")<cr>:execute("e ".mycurf)<cr>
"}}}
"}}}
"{{{ 其他(最好置于末尾)
" remote plugin
source ~/.local/share/nvim/rplugin.vim  " 和let g:loaded_remote_plugins = 1对应，延迟加载remote plugin
SignifyEnableAll
"}}}
" ==========================================
"
"{{{ 空格触发abbrev
function! s:SetCommandAbbrs(from, to)
    exec 'cnoreabbrev <expr> '.a:from
                \ .' ((getcmdtype() ==# ":" && getcmdline() ==# "'.a:from.'")'
                \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfunc
call s:SetCommandAbbrs('ca', 'CocAction')
call s:SetCommandAbbrs('cc', 'CocConfig')
call s:SetCommandAbbrs('cl', 'CocList')
call s:SetCommandAbbrs('cm', 'CocCommand')
call s:SetCommandAbbrs('pc', 'PlugClean')
call s:SetCommandAbbrs('pi', 'PlugInstall')
call s:SetCommandAbbrs('pu', 'PlugUpdate')
call s:SetCommandAbbrs('st', 'StartupTime')
"}}}
