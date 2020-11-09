# Utility Functions 可以在命令行直接使用
#
# 开关某个git仓库是否自动fetch NOTE: 本来是配合OMZ的git-auto-fetch插件使用，现在修改为和cronjob配合使用
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
# {{{ zcomp-gen ()
zcomp-gen () {
echo "[1] manpage  [2] help"
read -r var
if [[ "$var"x == ""x ]]; then
    var=1
fi
if [[ "$var"x == "1"x ]]; then
    TARGET=$(find -L /usr/share/man -type f -print -o -type l \
        -print -o  \( -path '*/\.*' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \) \
        -prune 2> /dev/null |\
        sed 's|\./||g' |\
        sed '1i [cancel]' |\
        fzf)
            if [[ "$TARGET"x == "[cancel]"x ]]; then
                echo ""
            else
                echo "$TARGET" | xargs -i sh ~/.zplugin/plugins/nevesnunes---sh-manpage-completions/gencomp-manpage {}
                zpcompinit
            fi
        elif [[ "$var"x == "2"x ]]; then
            TARGET=$(compgen -cb | sed '1i [cancel]' | fzf)
            if [[ "$TARGET"x == "[cancel]"x ]]; then
                echo ""
            else
                gencomp "$TARGET"
                zpcompinit
            fi
fi
}
# }}}

# 用于git更新追踪所有的dotfiles
git-update-tracted-dotfiles() {
    cd ~
    git add -f $(yadm ls | grep -v .local/share/fonts)
    # 返回上次目录, 对于上次是z.lua跳转的也生效
    cd - >/dev/null
}
