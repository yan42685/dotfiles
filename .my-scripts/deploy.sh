#!/bin/sh

# 系统类型
system_type=$(uname -s)
# 包管理器名字
# pkg=

setup_ubuntu_environment() {

    echo "==================== updating packages..."
    sudo apt update
    sudo apt -y upgrade
    echo "==================== Installing required packages..."
    sudo apt install -y make cmake build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl

    echo "==================== setuping basic packages..."
    sudo apt install -y nodejs npm python-pip python3-pip zsh lua5.3
    # 更新pip和pip3版本
    python -m pip install --upgrade pip
    python3 -m pip install --upgrade pip

    # 更新node版本
    sudo npm cache clean -f
    sudo npm install -g n
    sudo n stable

    # 为将来npm授权
    sudo chown -R $USER /usr/local/bin
    sudo chown -R $USER /usr/local/lib
    sudo chown -R $USER /usr/local/man

    # 安装pyenv
    if [ ! -d $HOME/.pyenv ] ; then
        bash ~/.installers/pyenv-installer.sh
    fi

    echo "==================== installing via snap..."
    sudo snap install nvim --classic
    sudo snap install ccls --classic
    sudo snap install universal-ctags

    echo "==================== installing applications"
    sudo apt install -y trash-cli
    sudo apt install -y nnn
    # 安装zeal
    sudo add-apt-repository ppa:zeal-developers/ppa -y
    sudo apt-get update
    sudo apt-get install -y zeal --fix-missing

    echo "==================== installing linter and checker"
    npm install -g eslint
    npm install -g prettier
    python3 -m pip install pylint --user
    python3 -m pip install autopep8 --user
    apt install cppcheck -y
    npm install -g clang-format

    echo "==================== installing neovim-remote"
    python3 -m pip install neovim-remote --user

    if ! command -v gtags >/dev/null 2>&1; then
        echo "==================== installing GNU GLOBAL (gtags)"
        # 安装依赖
        sudo apt install -y libncurses5-dev libncursesw5-dev
        tar xvf $HOME/.installers/global-6.6.5.tar.gz
        cd global-6.6.5 && ./configure && make
        sudo make install
        cd ~ && rm -r $HOME/.installers/global-6.6.5
    fi


    if ! command -v rg >/dev/null 2>&1; then
        echo "==================== installing riggrep"
        sudo dpkg -i $HOME/.installers/ripgrep_11.0.2_amd64.deb
    fi

    echo "==================== installing tmux"
    # gawk　是tmux-finger插件的依赖
    sudo apt install -y gawk tmux
    # tmux插件管理器tpm
    if [[ ! -d $HOME/.tmux/plugins/tpm ]]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi

    if [ ! -d "$HOME/.zgen" ]; then
        echo "==================== installing zgen..."
        git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
    fi

    if ! command -v fzf>/dev/null 2>&1; then
        echo "==================== Installing fzf"
        rm -rf $HOME/.fzf
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --all
    fi

    if ! command -v alacritty >/dev/null 2>&1; then
        echo "==================== Installing alacritty"
        # 添加ppa
        sudo add-apt-repository ppa:mmstick76/alacritty -y
        # 添加缺失的public key
        sudo apt update 2>&1 1>/dev/null | sed -ne 's/.*NO_PUBKEY //p' | while read key; do if ! [[ ${keys[*]} =~ "$key" ]]; then sudo apt-key adv --keyserver hkp://pool.sks-keyservers.net:80 --recv-keys "$key"; keys+="$key"; fi; done
        sudo apt-get update
        sudo apt install -y alacritty --fix-missing
    fi

    echo "==================== 更换默认bash为zsh..."
    sudo usermod -s /usr/bin/zsh $(whoami)

    sudo apt autoremove -y
}

deploy_ubuntu() {
    echo "========================================================="
    echo "==================== starting bootstrap ================="
    echo "========================================================="
    echo ""

    # 可能因为网络原因导致部署不完整，所以设置了自动重新部署三次
    deploy_times=1
    while [[ $deploy_times -le 3 ]]
    do
        echo "============ 第 ${deploy_times} 次部署开始 (3 次后自动退出) ============"
        setup_ubuntu_environment
        echo "============ 第 ${deploy_times} 次部署结束 ============"
        let deploy_times++

        bash $HOME/.my-scripts/check_commands.sh
        #　判断上次命令返回值　如果命令和文件存在则代表全部安装完成
        if [[ $? == 0 ]]; then
            break;
        fi

        if [[ $deploy_times -lt 3 ]]; then
            echo ""
            echo "========== missing commands or files =========="
            echo "============== need to redeploy =========="
            echo ""
            echo "=============================================="
            echo "================ redeploying ================="
            echo "=============================================="
            echo ""
        fi
    done

}

common_after_deploy() {
    echo "==================== 初始化配置文件的 git 仓库"
    cd $HOME
    git init
    # git add 除去字体
    git add $(yadm ls | grep -v .local/share/fonts)
    git commit -a -m "init"

    # 安装vim插件
    # NOTE: post执行脚本会卡一段时间，耐心等待就好
    nvim "+PlugUpdate" "+PlugClean!" "+PlugUpdate" "+qall"
}

confirm_reboot() {
    echo "==================== 需要重启系统使配置生效 =================="
    echo -n "Are you sure to reboot now? (y/n):"
    read crm
    if [ "$crm"x = "y"x ]; then
        echo "rebooting"
        \reboot
    fi
}


if [ "$system_type" = "Linux" ]; then
    deploy_ubuntu
    common_after_deploy
    confirm_reboot
fi
