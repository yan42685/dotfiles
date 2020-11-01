missing_commands_count=0
missing_directories_count=0
missing_files_count=0
# 0 是 true  1 是false
is_missing=1


commands=(
node npm pip3 zsh lua5.3 nvim clangd ctags trash nnn zeal
eslint prettier pylint autopep8 cppcheck clang-format
gtags rg tmux alacritty
)

directories=(
$HOME/.tmux/plugins/tpm
# fzf比较特殊，不能检查命令
$HOME/.fzf
)

files=(
)

for cmd in ${commands[@]};
do
    if ! command -v $cmd >/dev/null 2>&1; then
        echo "command $cmd not exists!"
        let missing_commands_count++
    fi
done

for directory in ${directories[@]};
do
    if [ ! -d $directory ]; then
        echo "directory $directory not exists!"
        let missing_directories_count++
    fi
done

for file in ${files[@]};
do
    if [ ! -f $file ]; then
        echo "file $file not exists!"
        let missing_files_count++
    fi
done

if [[ $missing_commands_count != 0 ]]; then
    is_missing=0
    echo "Missing ${missing_commands_count} commands!"
fi

if [[ $missing_directories_count != 0 ]]; then
    is_missing=0
    echo "Missing ${missing_directories_count} directories!"
fi

if [[ $missing_files_count != 0 ]]; then
    is_missing=0
    echo "Missing ${missing_files_count} files!"
fi

if [[ $is_missing == 0 ]]; then
    # 用于后续$?处理
    exit 1
else
    echo ""
    echo "All packages are installed."
fi
