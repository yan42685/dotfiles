missing_count=0

commands=(
node npm pip3 zsh lua5.3 pyenv
nvim ccls ctags trash nnn zeal
gtags rg tmux fzf alacritty
)
for cmd in ${commands[@]};
do
    if ! command -v $cmd >/dev/null 2>&1; then
        echo "command $cmd not exists!"
        let missing_count++
    fi
done

if [[ $missing_count != 0 ]]; then
    echo "Missing ${missing_count} commands! "
else
    echo ""
    echo "All packages are installed."
fi
