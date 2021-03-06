# NOTE:
#   1. 不要试图用修改.zshrc的方式使得gnome-terminal自动开启tmux, 因为那会导致gnome-terminal有时无法开启，最好的办法是只用Alacritty
#   2. alias会递归应用

# 想用root账户也使用，可以使用软连接.zhsrc  .config .vim 到/home目录下, 但是.zgen软连接好像会出错，那就复制过去好了
# 需要下载的软件: fzf, nnn, trash, lua
# NOTE: 对大部分命令行工具使用代理, 如果没有开启代理就不要设置
export http_proxy=socks5://127.0.0.1:6543
export https_proxy=$http_proxy
# NOTE: 这些是必须放在p10k-instant-prompt前面的命令{{{
# Disable flow control (ctrl+s, ctrl+q) to enable saving with ctrl+s in Vim
stty -ixon -ixoff
# }}}
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.{{{
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# }}}
# 环境变量 {{{
# pip默认安装位置
export PATH=$HOME/.local/bin:$PATH
# 自定义npm包安装的bin
# NOTE: bin目录写在PATH前面可以覆盖/usr/bin里旧的node
NPM_PREFIX=${HOME}/.npm-packages
# 更新npm的工具n
export N_PREFIX=${NPM_PREFIX}
export PATH=${NPM_PREFIX}/bin:${PATH}
# 自定义的可执行文件
chmod -R +x ${HOME}/.my-scripts/bin
export PATH=${HOME}/.my-scripts/bin:${PATH}
export PATH=${HOME}/.local/go/bin:${PATH}  # golang


export TERM=xterm-256color
export NNN_USE_EDITOR=1                                 # use the $EDITOR when opening text files
# 用于neovim终端里nvim使用新tab打开 editor在~/.my-scripts/bin/editor
# BUG: 不能用于在nvim内置终端使用crontab -e 原因未知
export EDITOR=editor
# 下面这条选项会让git的输出(比如branch, tag)用nvim来打开, 还有man的输出
export PAGER=editor
export MANPAGER=bat
export BROWSER="chromium"
export NNN_COLORS="2136"                        # use a different color for each context
export NNN_TRASH=1     # trash (needs trash-cli) instead of delete
export SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color? [Yes, No, Abort, Edit] "
export FuzzyFinder="fzf"

# }}}
# General settings{{{
set -o monitor
set +o nonotify
umask 077  # 新建文件的权限
setopt hist_save_no_dups hist_ignore_dups       # eliminate duplicate entries in history
# 设置自动修改命令
# setopt correctall                               # enable auto correction
setopt autopushd pushdignoredups                # auto push dir into stack and and don’t duplicate them
autoload -U promptinit && promptinit  # FIXME: 不太了解这句话的作用
# }}}
# {{{ 其他软件配置 (需要在插件加载之前)
# 为hub设置的补全
fpath=(~/.zsh/completions $fpath)
#}}}
# {{{ 插件配置: 需要放在插件加载之前
ZGEN_RESET_ON_CHANGE=(${HOME}/.zshrc)  # .zshrc修改时自动更新zgen
ZGEN_AUTOLOAD_COMPINIT=0  # 不要使用ZGEN的compinit
# git自动fetch的最小间隔（默认60秒）
GIT_AUTO_FETCH_INTERVAL=60 #in seconds
# zsh-autosuggestion
export ZSH_AUTOSUGGEST_USE_ASYNC="true"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"
FZ_HISTORY_CD_CMD="_zlua"  # NOTE: 必须在fz加载之前
# }}}
# {{{ completion settings
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# Set options
setopt MENU_COMPLETE       # press <Tab> one time to select item
# setopt COMPLETEALIASES     # complete alias
setopt COMPLETE_IN_WORD    # Complete from both ends of a word.
setopt ALWAYS_TO_END       # Move cursor to the end of a completed word.
setopt PATH_DIRS           # Perform path search even on command names with slashes.
setopt AUTO_MENU           # Show completion menu on a successive tab press.
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
setopt AUTO_PARAM_SLASH    # If completed parameter is a directory, add a trailing slash.
setopt EXTENDED_GLOB       # Needed for file modification glob modifiers with compinit
unsetopt FLOW_CONTROL      # Disable start/stop characters in shell editor.

# Use caching to make completion for commands such as dpkg and apt usable.
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${ZDOTDIR:-$HOME}/.cache/.zcompcache"

# Case-insensitive (all), partial-word, and then substring completion.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
unsetopt CASE_GLOB

# Group matches and describe.
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'

# fzf-tab配置
zstyle ":completion:*:git-checkout:*" sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# disable sort when completing options of any command
zstyle ':completion:complete:*:options' sort false
# use input as query string when completing zlua
zstyle ':fzf-tab:complete:_zlua:*' query-string input
zstyle ':fzf-tab:*:' prefix ''
# 这里是-1不是-a
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 -a --color=always $realpath'
#
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

# Fuzzy match mistyped completions.
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Increase the number of errors based on the length of the typed word. But make
# sure to cap (at 7) the max-errors to avoid hanging.
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'

# Don't complete unavailable commands.
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

# Array completion element sorting.
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Directories
export LSCOLORS=ExFxCxdxBxegedabagacad
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
# zstyle ':completion:*' list-colors 'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
zstyle ':completion:*' squeeze-slashes true

# History
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# Environment Variables
zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}

# Populate hostname completion. But allow ignoring custom entries from static
# */etc/hosts* which might be uninteresting.
zstyle -a ':prezto:module:completion:*:hosts' etc-host-ignores '_etc_host_ignores'

zstyle -e ':completion:*:hosts' hosts 'reply=(
    ${=${=${=${${(f)"$(cat {/etc/ssh/ssh_,~/.ssh/}known_hosts(|2)(N) 2> /dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ }
    ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2> /dev/null))"}%%(\#${_etc_host_ignores:+|${(j:|:)~_etc_host_ignores}})*}
    ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2> /dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'

# Don't complete uninteresting users...
zstyle ':completion:*:*:*:users' ignored-patterns \
    adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
    dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
    hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
    mailman mailnull mldonkey mysql nagios \
    named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
    operator pcap postfix postgres privoxy pulse pvm quagga radvd \
    rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs '_*'

# ... unless we really want to.
zstyle '*' single-ignored show

# Ignore multiple entries.
zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
zstyle ':completion:*:rm:*' file-patterns '*:all-files'

# auto rehash
zstyle ':completion:*' rehash true

#highlight prefix
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)*==34=34}:${(s.:.)LS_COLORS}")'

# Kill
zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids single

# Man
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true

# Media Players
zstyle ':completion:*:*:mpg123:*' file-patterns '*.(mp3|MP3):mp3\ files *(-/):directories'
zstyle ':completion:*:*:mpg321:*' file-patterns '*.(mp3|MP3):mp3\ files *(-/):directories'
zstyle ':completion:*:*:ogg123:*' file-patterns '*.(ogg|OGG|flac):ogg\ files *(-/):directories'
zstyle ':completion:*:*:mocp:*' file-patterns '*.(wav|WAV|mp3|MP3|ogg|OGG|flac):ogg\ files *(-/):directories'

# Mutt
if [[ -s "$HOME/.mutt/aliases" ]]; then
    zstyle ':completion:*:*:mutt:*' menu yes select
    zstyle ':completion:*:mutt:*' users ${${${(f)"$(<"$HOME/.mutt/aliases")"}#alias[[:space:]]}%%[[:space:]]*}
fi

# SSH/SCP/RSYNC
zstyle ':completion:*:(ssh|scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'
# }}}
# FIXME: 如果ohmyzsh的插件安装失败，那就把.zgen/robbyrussell这个文件夹删了，再zgen reset  下次进入终端会卡一段时间(重新下载robbyrussell) 然后就没问题了
# {{{ zgen 插件配置
source "${HOME}/.zgen/zgen.zsh"
# if the init scipt doesn't exist
if ! zgen saved; then
    echo "Creating a zgen save"

    zgen oh-my-zsh  # 加载oh-my-zsh的lib文件，但是不支持 DISABLE_LS_COLORS="true" 这样的 OMZ专属设置
    zgen load skywind3000/z.lua  # Windows下也能用, FIXME: 如果z.lua不生效，就先把~/.zgen/ohmyzsh/ohmyzsh-master/plugins/z给删掉
                                # NOTE: 必须放在fz之前加载
    zgen load changyuheng/fz    # 为z添加<tab>后的fuzzy补全列表, 并提供进入非历史目录的功能(即cd)
                                # NOTE: 需要在z之后source, 依赖fzf
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/sudo
    zgen oh-my-zsh plugins/vi-mode
    zgen oh-my-zsh plugins/command-not-found
    zgen oh-my-zsh plugins/extract
    zgen oh-my-zsh plugins/colorize
    zgen oh-my-zsh plugins/npm  # npm命令补全
    zgen oh-my-zsh plugins/zsh_reload  # src命令重新加载.zshrc .zshrc


    # NOTE: 没必要用crontab定义自动fetch, 这个插件提供的根据 zle-line-init 触发就足够用了,
    #       因为一般的工作流总是需要先 pull 再 push 的
    # 暂时关闭这个插件 因为可能有内存泄漏
    # zgen oh-my-zsh plugins/git-auto-fetch
    zgen load romkatv/powerlevel10k powerlevel10k
    zgen load zdharma/fast-syntax-highlighting
    zgen load zsh-users/zsh-autosuggestions
    # 用fzf自带的fzf-completion替代
    # zgen load zsh-users/zsh-completions
    zgen load zsh-users/zsh-history-substring-search
    zgen load djui/alias-tips  # 如果使用的不是缩写命令，会自动提醒你之前定义的alias
    zgen load urbainvaes/fzf-marks
    zgen load Aloxaf/fzf-tab
    zgen load hlissner/zsh-autopair
    zgen load peterhurford/git-it-on.zsh  # open your current folder, on your current branch, in GitHub or GitLab
                                          # NOTE: This was built on a Mac. 在Linux不一定有效, 并且只有当文件夹名字和远程仓库一致才有效
    zgen load StackExchange/blackbox  # 在VCS里选择性加密文件 you don't have to worry about storing your VCS repo on an untrusted server
    zgen load unixorn/autoupdate-zgen  # 自动更新zgen及相关插件


    # save all to init script
    zgen save
fi
# }}}

# =====================================

# 编译并运行源文件
alias rn='asynctask file-run'
# 查找命令 后面可接文件/目录名也可不接
alias rnf='asynctask -f'
alias note='editor ~/vimwiki/index.md'
# 搜索文件
alias fuzzy_file='fd --type file --follow --hidden --exclude .git . | fzf --preview "bat --style=numbers --color=always --line-range :500 {}"'
alias fuzzy_dir='fd --type directory --hidden --exclude .git . | fzf --preview "ls -1 -a --color=always {}"'
# 打开文件，如果取消fzf则不打开editor
alias vif='file=$(fuzzy_file) && [[ -n "$file" ]] && editor $file'
alias vid='directory=$(fuzzy_dir) && [[ -n "$directory" ]] && editor $directory'
alias vd='editor $PWD'
alias zd='directory=$(fuzzy_dir) && [[ -n "$directory" ]] && z $directory'
alias zf='directory=$(dirname $(fuzzy_file)) && [[ -n "$directory" ]] && z $directory'
alias zr='z -I -t .'  # 最近访问的路径
alias zz='z ~' # 根目录
alias zt='z ~/coding/test'  # 测试目录
alias rt='z -b' # 到项目根目录 root
alias zb='z -b -I' # 查找当前目录的父目录

alias vi='editor'
alias vinp='editor --noplugin'
# 检查性能，进入nvim后，输入:profile stop命令(或<leader>cp)再退出，然后查看profile.log文件 翻到最底部查看函数耗时统计
alias vicp="nvim -c 'profile start profile.log' -c 'profile file *' -c 'profile func *' -c 'let g:check_performance_enabled = 1'"
# 禁用部分大文件下十分影响性能的插件
alias vifast="nvim -c 'let g:disable_laggy_plugins_for_large_file = 1'"
alias en="editor ~/.config/nvim/init.vim"

alias dot='yadm'
alias nnn='PAGER= nnn'

alias ca='bat'
alias rm='trash'
alias cl="clear"
# 安全的cp和mv，防止误操作覆盖同名文件
alias mv='mv -i'
alias cp='cp -ip'
alias la='ls -a'
alias lf='ls -a | fzf'
# 如果有bat命令就alias
alias md='mkdir'
alias showkey='screenkey --no-detach' # 在前台运行而不是后台

alias now='echo $(date +%Y-%m-%d\ %H:%M:%S\ %A)'
# 比较两个文件
alias diff='editor -d'
alias ...='../..'
alias ....='../../..'
alias .....='../../../..'
alias ......='../../../../..'
# oh-my-zsh 会默认alias g="git"
command -v hub >/dev/null 2>&1 && alias git='hub'
alias zshrc='${=EDITOR} ~/.zshrc' # Quick access to the ~/.zshrc file

# {{{ 自定义快捷键
# 采纳补全建议, 如果需要在命令行下输入半角逗号，可以先随便输入一个字符，然后在vi模式下用r改成半角逗号
bindkey ',' autosuggest-accept
bindkey 'kj' vi-cmd-mode
bindkey '^h' beginning-of-line
bindkey '^l' end-of-line
bindkey '^k' history-substring-search-up
bindkey '^j' history-substring-search-down
bindkey ',' autosuggest-accept  # 采纳补全建议
bindkey -M vicmd 'H' vi-beginning-of-line
bindkey -M vicmd 'L' vi-end-of-line
bindkey -s '^e' '^[[3~'
# }}}

# {{{ 基本不用的alias

# print file sizes in human readable format
alias du='du -h'
alias df='df -h'
alias free='free -h'
# Improve od for hexdump
alias od='od -Ax -tx1z'
alias hexdump='hexdump -C'
# }}}
############################################################
# {{{ 自定义函数
# NOTE: 这些函数不可以在shell脚本里调用
# 在文件浏览器里打开
open() {
   nohup nautilus ${1:-$PWD} > /dev/null 2>&1 &
}
# 打开trashbin
openbin() {
   open trash://
}

killport() {
  port=$1
  if [ -z "$port" ]; then
    echo "请输入端口号"
    return
  fi
  fuser -k -n tcp $port
  echo "成功关闭端口号为 $port 的进程"
}
# {{{ toggle_auto_fetch()
toggle_auto_fetch() {
    `command git rev-parse --is-inside-work-tree 2>/dev/null` || return
    guard="`command git rev-parse --git-dir`/NO_AUTO_FETCH"

    (rm $guard 2>/dev/null &&
        echo "${fg_bold[green]}enabled${reset_color}") ||
        (touch $guard &&
        echo "${fg_bold[red]}disabled${reset_color}")
    }
# }}}
# {{{ git-update-tracted-dotfiles()
# 用于git更新追踪所有的dotfiles
git-update-tracted-dotfiles() {
cd ~
git add -f $(yadm ls | grep -v .local/share/fonts)
# 返回上次目录, 对于上次是z.lua跳转的也生效
cd - >/dev/null
}
# }}}
# {{{FuzzyFinder

# job to fore
job-fore() {
    JOB_ID=$(jobs | grep "[[[:digit:]]*]" | "$FuzzyFinder" | grep -o "[[[:digit:]]*]" | grep -o "[[:digit:]]*")
    fg %"$JOB_ID"
}

# job to back
job-back() {
    JOB_ID=$(jobs | grep "[[[:digit:]]*]" | "$FuzzyFinder" | grep -o "[[[:digit:]]*]" | grep -o "[[:digit:]]*")
    bg %"$JOB_ID"
}

# job kill
job-kill() {
    JOB_ID=$(jobs | grep "[[[:digit:]]*]" | "$FuzzyFinder" | grep -o "[[[:digit:]]*]" | grep -o "[[:digit:]]*")
    kill %"$JOB_ID"
}

# ps ls
ps-ls() {
    PROC_ID_ORIGIN=$(ps -alf | "$FuzzyFinder")
    if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
        PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
        echo "$PROC_ID_ORIGIN"
    fi
}

# ps ls all
ps-ls-all() {
    PROC_ID_ORIGIN=$(ps -elf | "$FuzzyFinder")
    if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
        PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
        echo "$PROC_ID_ORIGIN"
    fi
}

# ps info
ps-info() {
    PROC_ID_ORIGIN=$(ps -alf | "$FuzzyFinder")
    if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
        PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
        top -p "$PROC_ID"
    fi
}

# ps info all
ps-info-all() {
    PROC_ID_ORIGIN=$(ps -elf | "$FuzzyFinder")
    if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
        PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
        top -p "$PROC_ID"
    fi
}

# ps tree
ps-tree() {
    PROC_ID_ORIGIN=$(ps -alf | "$FuzzyFinder")
    if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
        PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
        pstree -p "$PROC_ID"
    fi
}

# ps tree all
ps-tree-all() {
    PROC_ID_ORIGIN=$(ps -elf | "$FuzzyFinder")
    if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
        PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
        pstree -p "$PROC_ID"
    fi
}

# ps kill
ps-kill() {
    PROC_ID_ORIGIN=$(ps -alf | "$FuzzyFinder")
    if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
        PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
        kill -9 "$PROC_ID"
    fi
}

# ps kill
ps-kill-all() {
    PROC_ID_ORIGIN=$(ps -elf | "$FuzzyFinder")
    if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
        PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
        kill -9 "$PROC_ID"
    fi
}
# }}}
# {{{ test_cmd_pre()
test_cmd_pre() {
    command -v "$1" >/dev/null
}
# }}}
# {{{ test_cmd()
test_cmd() {
    test_cmd_pre "$1" && echo 'yes' || echo 'no'
}
# }}}
# }}}

# {{{ 其他配置软件配置（需要放在插件加载之后)
# 解决ls命令出现奇怪背景色的问题{{{
# Change ls colours
LS_COLORS="ow=01;36;40" && export LS_COLORS
# }}}
# 解决zeal不能显示mdn文档的问题 {{{
zeal-docs-fix() {
    dirname="$HOME/.local/share/Zeal/Zeal/docsets"
    if [ -d $dirname  ];then
        pushd $dirname >/dev/null || return
        find . -iname 'react-main*.js' -exec rm '{}' \;
        popd >/dev/null || exit
    fi
}
zeal-docs-fix
#}}}
# {{{ 命令行浏览Reddit的工具: rtv
export RTV_EDITOR="vim"
export RTV_BROWSER="w3m"
export RTV_URLVIEWER="urlscan"
# }}}
# {{{fzf
# C-y是复制的快捷键 alt-j/k移动preview的一行， alt-e/d 移动preview的一页 c-a Toggle所有选项 c-f类似easymotion并选中
# C-i 选择
export FZF_DEFAULT_OPTS=" \
-m --height=60% \
--layout=reverse \
--border
--prompt='➤ ' \
--ansi \
--tabstop=4 \
--color=dark \
--color=bg:-1,hl:2,fg+:4,bg+:-1,hl+:2 \
--color=info:11,prompt:2,pointer:5,marker:1,spinner:3,header:11 \
--bind 'alt-k:preview-up,alt-j:preview-down,alt-e:preview-half-page-up,alt-d:preview-half-page-down,ctrl-a:toggle-all,ctrl-f:jump' \
--preview-window right:60%:wrap \
"
# }}}
# {{{fzf-marks
# Usage: mark fzm C-d
FZF_MARKS_FILE="$HOME/.cache/fzf-marks"
FZF_MARKS_COMMAND="fzf"
FZF_MARKS_COLOR_RHS="249"
# }}}
# Z.lua{{{
export _ZL_DATA="$HOME/.cache/.zlua"
export _ZL_MATCH_MODE=1  # 增强匹配模式
export _ZL_ROOT_MARKERS=".git,.svn,.hg,.root,package.json"  # 设定项目根目录列表
function _z() { _zlua "$@"; }  # 整合fz与zlua
# }}}
# {{{ git-alias
# git-extras 补全
source /home/alexyan/git-extras/etc/git-extras-completion.zsh
# 这个是git-extras的bin目录, 父目录是~/.my-scripts/deploy.sh中安装时定义的make install PREFIX
export PATH=$HOME/.local/git-extras/bin:$PATH
# }}}
# {{{ bat
# # bat默认用$PAGER，现在改为less
export BAT_PAGER="less"
export BAT_THEME="TwoDark"
# }}}
# {{{ fuzzy-git
# NOTE: fork from https://github.com/bigH/git-fuzzy
export PATH="$HOME/git-fuzzy/bin:$PATH"
# fuzzy-git默认配置
export FZF_DEFAULT_OPTS_MULTI=" \
    -m --height=100% \
    --layout=reverse \
    --prompt='➤ ' \
    --ansi \
    --tabstop=4 \
    --color=dark \
    --color=bg:-1,hl:2,fg+:4,bg+:-1,hl+:2 \
    --color=info:11,prompt:2,pointer:5,marker:1,spinner:3,header:11 \
    --bind='alt-k:preview-up,alt-j:preview-down,alt-e:preview-half-page-up,alt-d:preview-half-page-down,ctrl-a:toggle-all,ctrl-f:jump' \
    --preview-window down:60%:wrap \
    "


# TODO: fuzzy-git log不能处理 --graph 的情况
# export GF_LOG_MENU_PARAMS="--all --color=always --abbrev=12 --graph --topo-order --date=format:'%Y-%m-%d %H:%M:%S' --boundary \
#                 --pretty=format:'%C(yellow)%d%Creset %s %Cblue[%cn] %Cgreen%ad - %C(magenta)%h'"
# }}}
# {{{ forgit
source ~/.my-scripts/forgit.sh
# usage: glg ga gri gcf(checkout file) gsl gclean
#
#        gd v1.0
#        gd origin
#        gd f2d6f23
#        gd README.md
#        gd master README.md
#        gd HEAD~ src tests scripts
alias gri='forgit::rebase'
alias glg='forgit::log'
alias gs='git fuzzy status'  # NOTE: 这里用的是fuzzy-git的命令
alias gsl='forgit::stash::show'
alias gpi='forgit::cherry::pick'
alias gcl='forgit::clean'

# 搜索git仓库所有文件
alias git_fuzzy_file='fd --type file --follow --hidden --exclude .git . $(git root-dir) | fzf --preview "bat --style=numbers --color=always --line-range :500 {}"'
alias vigf='file=$(git_fuzzy_file) && [[ -n "$file" ]] && editor $file'
# 查看指定文件的log
alias glgf='file=$(git_fuzzy_file) && [[ -n "$file" ]] && glg $file'
alias gdf='file=$(git_fuzzy_file) && [[ -n "$file" ]] && git diff $file'


export FORGIT_COPY_CMD='xclip -selection clipboard'
export FORGIT_FZF_DEFAULT_OPTS=" \
    -m --height=100% \
    --layout=reverse \
    --prompt='➤ ' \
    --ansi \
    --tabstop=4 \
    --color=dark \
    --color=bg:-1,hl:2,fg+:4,bg+:-1,hl+:2 \
    --color=info:11,prompt:2,pointer:5,marker:1,spinner:3,header:11 \
    --bind='alt-k:preview-up,alt-j:preview-down,alt-e:preview-half-page-up,alt-d:preview-half-page-down,ctrl-a:toggle-all,ctrl-f:jump' \
    --preview-window down:60%:wrap \
    "

# <C-d> drop stash <C-p> pop stash <C-a> apply stash
FORGIT_STASH_FZF_OPTS='
--bind="ctrl-d:reload(git stash drop $(cut -d: -f1 <<<{}) 1>/dev/null && git stash list)"
--bind="ctrl-p:execute(git stash pop $(cut -d: -f1 <<<{}) 1>/dev/null)+abort+execute(echo Stash Poped: {})"
--bind="ctrl-a:execute(git stash apply $(cut -d: -f1 <<<{}) 1>/dev/null)+abort+execute(echo Stash Applied: {})"
'

# FORGIT_ADD_FZF_OPTS='
# --bind="alt-a:reload(echo {} | \"$RELOAD\")"
# '


# }}}



# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# zsh主题
source $HOME/.config/zsh/.zsh-theme-forest-night

# Created by `userpath` on 2020-03-18 21:41:57
export PATH=/root/.local/bin:$PATH
# pyenv
export PATH=~/.pyenv/bin:$PATH
export PYENV_ROOT=~/.pyenv
eval "$(pyenv init -)"
#}}}
[ -f "/home/alexyan/.ghcup/env" ] && source "/home/alexyan/.ghcup/env" # ghcup-env
