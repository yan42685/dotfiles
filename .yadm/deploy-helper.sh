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
    sudo apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl git

    echo "==================== setuping basic packages..."
    sudo apt install -y nodejs npm python-pip python3-pip zsh lua5.3
    # 更新pip和pip3版本
    pip install --upgrade pip
    pip3 install --upgrade pip

    # 更新node版本
    sudo npm cache clean -f
    sudo npm install -g n
    sudo n stable

    # 为将来npm授权
    sudo chown -R $USER /usr/local/bin
    sudo chown -R $USER /usr/local/lib
    sudo chown -R $USER /usr/local/man

    # 安装pyenv
    if ! command -v pyenv >/dev/null 2>&1; then
        bash ~/installers/pyenv-installer.sh
        export PATH=~/.pyenv/bin:$PATH
        export PYENV_ROOT=~/.pyenv
        eval "$(pyenv init -)"
    fi


    echo "==================== installing via snap..."
    sudo snap install nvim --classic
    sudo snap install ccls --classic
    sudo snap install universal-ctags

    echo "==================== installing applications"
    sudo apt install -y trash-cli nnn gdb-dashboard
    # 安装zeal
    sudo add-apt-repository ppa:zeal-developers/ppa -y
    sudo apt-get update
    sudo apt-get install -y zeal --fix-missing

    echo "==================== installing linter and checker"
    npm install -g eslint
    npm install -g prettier
    python3 -m pip install pylint
    python3 -m pip install autopep8
    apt install cppcheck -y
    npm install -g clang-format

    echo "==================== installing neovim-remote"
    pip3 install neovim-remote

    if ! command -v gtags >/dev/null 2>&1; then
        echo "==================== installing GNU GLOBAL (gtags)"
        # 安装依赖
        sudo apt install -y libncurses5-dev libncursesw5-dev
        wget https://ftp.gnu.org/pub/gnu/global/global-6.6.tar.gz
        tar xvf global-6.6.tar.gz
        cd global-6.6/ && ./configure && make
        sudo make install
        cd ~ && rm -r global-6.6/ && rm global-6.6.tar.gz
    fi


    if ! command -v rg >/dev/null 2>&1; then
        echo "==================== installing riggrep"
        curl -LO https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb
        sudo dpkg -i ripgrep_11.0.2_amd64.deb
        rm ripgrep_11.0.2_amd64.deb
    fi

    echo "==================== installing tmux"
    # gawk　是tmux-finger插件的依赖
    sudo apt install -y gawk tmux
    # 安装tpm
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

    if [ ! -d "~/.zgen" ]; then
        echo "==================== installing zgen..."
        git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
    fi

    if ! command -v fzf>/dev/null 2>&1; then
        # NOTE: 最好放在最后，因为需要手动确认配置
        echo "==================== Installing fzf"
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
    fi

    echo "==================== Installing neovim plugins with vim-plug..."
    nvim "+PlugUpdate" "+PlugClean!" "+PlugUpdate" "+qall"

    if ! command -v alacritty >/dev/null 2>&1; then
        echo "==================== Installing alacritty"
        # 添加ppa
        sudo add-apt-repository ppa:mmstick76/alacritty -y
        # 添加缺失的public key
        sudo apt update 2>&1 1>/dev/null | sed -ne 's/.*NO_PUBKEY //p' | while read key; do if ! [[ ${keys[*]} =~ "$key" ]]; then sudo apt-key adv --keyserver hkp://pool.sks-keyservers.net:80 --recv-keys "$key"; keys+="$key"; fi; done
        sudo apt-get update
        sudo apt install -y alacritty
    fi

    echo "==================== 更换默认bash为zsh..."
    chsh -s /bin/zsh

}

confirm_reboot() {
    echo -n "Are you sure to reboot now? (y/n):"
    read crm
    if [ "$crm"x = "y"x ]; then
        echo "rebooting"
        \reboot
    fi
}

deploy() {
    echo "========================================================="
    echo "==================== starting bootstrap ================="
    echo "========================================================="
    echo ""

    # 可能因为网络原因导致部署不完整，所以设置了自动重新部署三次
    deploy_times=0
    while [[ $deploy_times -le 3 ]]
    do
        let deploy_times++
        echo "============ 第 ${deploy_times} 次部署开始 (3 次后自动退出) ============"
        setup_ubuntu_environment

        bash ~/.yadm/check_commands.sh
        #　判断上次命令返回值　如果命令和文件存在则代表全部安装完成
        if [[ $? == 0 ]]; then
            break;
        fi

        echo
        echo "========== missing commands or files =========="
        echo "============== need to redeploy =========="
        echo ""
        echo "=============================================="
        echo "================ redeploying ================="
        echo "=============================================="
        echo ""
    done

    echo "============ 第 ${deploy_times} 次部署结束 ============"
}




if [ "$system_type" = "Linux" ]; then
    deploy

    echo "==================== 需要重启系统使终端和shell配置生效"
    confirm_reboot
fi
