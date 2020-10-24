missing_commands_count=0
missing_files_count=0

commands=(
node npm pip3 zsh lua5.3 pyenv
nvim ccls ctags trash nnn zeal
gtags rg tmux fzf alacritty
)

files=(
~/.tmux/plugins/tpm
)

for cmd in ${commands[@]};
do
    if ! command -v $cmd >/dev/null 2>&1; then
        echo "command $cmd not exists!"
        let missing_commands_count++
    fi
done

for file in ${files[@]};
do
    if ! command -v $file>/dev/null 2>&1; then
        echo "file $file not exists!"
        let missing_files_count++
    fi
done


if [[ $missing_commands_count != 0 ]]; then
    echo "Missing ${missing_commands_count} commands!"
    if [[ $missing_files_count != 0 ]]; then
        echo "Missing ${missing_files_count} files!"
    fi
else
    echo ""
    echo "All packages are installed."
fi
