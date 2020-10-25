missing_commands_count=0

commands=(
node npm pip3 zsh lua5.3 pyenv
ccls ctags trash nnn zeal
gtags rg tmux fzf alacritty
)

for cmd in ${commands[@]};
do
    if ! command -v $cmd >/dev/null 2>&1; then
        echo "command $cmd not exists!"
        let missing_commands_count++
    fi
done

is_missing=flase

if [[ $missing_commands_count != 0 ]]; then
    is_missing=true
    echo "Missing ${missing_commands_count} commands!"
fi

if [[ $is_missing ]]; then
    # 用于后续$?处理
    exit 1
else
    echo ""
    echo "All packages are installed."
fi
