#!/bin/sh
# fastgit代理地址
CLONE_DOMAIN="hub.fastgit.org"

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

    sudo apt install -y nodejs npm python-pip python3-pip zsh lua5.3 openjdk-8-jdk

    # 设置npm代理和 install -g 到本地用户防止权限问题
    npm config set registry https://registry.npm.taobao.org/
    NPM_PREFIX=${HOME}/.npm-packages
    mkdir -p ${NPM_PREFIX}
    npm config set prefix ${NPM_PREFIX}
    # 单独为n设置环境变量
    export N_PREFIX=${NPM_PREFIX}
    # export PATH 需要在.zshrc里也写一遍
    export PATH=${NPM_PREFIX}/bin:${PATH}

    # 更新node版本
    npm cache clean -f
    npm install -g n
    n stable
    # 更新PATH
    export PATH=$PATH

    # 更新pip和pip3版本
    python -m pip install --upgrade pip
    python3 -m pip install --upgrade pip
    # 使check_commands.sh找得到pip安装的包
    export PATH=${HOME}.local/bin:${PATH}

    # 安装pyenv
    if [ ! -d $HOME/.pyenv ] ; then
        bash ~/.installers/pyenv-installer.sh
    fi

    npm install -g typescript
    npm install -g ts-node  # 运行ts

    echo "==================== installing linter and formatter"
    npm install -g eslint
    npm install -g vim-language-server
    npm install -g prettier
    python3 -m pip install pylint --user
    python3 -m pip install autopep8 --user
    sudo apt install cppcheck -y
    npm install -g clang-format

    echo "==================== installing neovim-remote"
    python3 -m pip install neovim-remote --user

    echo "==================== installing via snap..."
    sudo snap install nvim --classic
    sudo snap install universal-ctags

    echo "==================== installing applications"
    sudo apt install -y gpick

    if [ ! -d ~/git-fuzzy ]; then
        echo "================== Installing git-fuzzy"
        git clone https://hub.fastgit.org/yan42685/git-fuzzy
    fi

    if ! command -v fd >/dev/null 2>&1; then
        # riggrep作者推荐用这个来搜索文件和目录，用riggrep来搜索文本
        echo "================== Installing fd..."
        wget -c https://download.fastgit.org/sharkdp/fd/releases/download/v8.1.1/fd_8.1.1_amd64.deb -O fd-amd64.deb
        sudo dpkg -i fd-amd64.deb
        rm fd-amd64.deb
    fi

    if ! command -v delta >/dev/null 2>&1; then
        echo "================== Installing delta..."
        wget -c https://download.fastgit.org/dandavison/delta/releases/download/0.4.4/git-delta_0.4.4_amd64.deb -O git-delta.deb
        sudo dpkg -i git-delta.deb
        rm git-delta.deb
    fi

    if ! command -v bat >/dev/null 2>&1; then
        echo "================== Installing bat..."
        wget -c https://download.fastgit.org/sharkdp/bat/releases/download/v0.16.0/bat_0.16.0_amd64.deb -O bat-amd64.deb
        sudo dpkg -i bat-amd64.deb
        rm bat-amd64.deb
    fi

    if ! command -v git-extras >/dev/null 2>&1; then
        echo "================== Installing git-extras..."
        git clone https://hub.fastgit.org/tj/git-extras.git
        cd git-extras
        # checkout the latest tag
        git checkout $(git describe --tags $(git rev-list --tags --max-count=1))
        # PREFIX是命令安装的目录
        make install PREFIX=$HOME/.local/git-extras
        cd ~
        rm -rf git-extras
        # 便于检查命令是否存在
        export PATH=$HOME/.local/git-extras/bin
    fi

    if ! command -v hub >/dev/null 2>&1; then
        echo "================== Installing hub..."
        wget -c https://download.fastgit.org/github/hub/releases/download/v2.14.2/hub-linux-amd64-2.14.2.tgz -O github-hub.tgz
        mkdir -p ~/github-hub;
        tar xf github-hub.tgz -C ~/github-hub --strip-components 1
        # 安装
        sudo ./github-hub/install
        # 设置补全 同时需要在.zshrc的autoload -U compinit && compinit之前写上fpath=(~/.zsh/completions $fpath)
        mkdir -p ~/.zsh/completions
        cp ~/github-hub/etc/hub.zsh_completion ~/.zsh/completions/_hub
        rm -rf github-hub && rm -rf github-hub.tgz
    fi

    sudo apt install -y trash-cli
    sudo apt install -y nnn
    # 安装zeal
    sudo add-apt-repository ppa:zeal-developers/ppa -y
    sudo apt-get update
    sudo apt-get install -y zeal --fix-missing

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

    if ! command -v clangd >/dev/null 2>&1; then
        echo "==================== Installing clangd"
        sudo apt install -y clangd-10
        # 设置clangd-10为默认的clangd
        sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-10 100
    fi

    if [ ! -d "$HOME/.zgen" ]; then
        echo "==================== installing zgen..."
        git clone https://${CLONE_DOMAIN}/tarjoilija/zgen.git "${HOME}/.zgen"
        # 新tab页安装zsh插件
        gnome-terminal --tab --title="zgen install zsh plugins" --command="zsh"
    fi

    echo "==================== installing tmux"
    if ! command -v tmux >/dev/null 2>&1; then
        # gawk　是tmux-finger插件的依赖
        sudo apt install -y gawk tmux
        git clone https://${CLONE_DOMAIN}/tmux-plugins/tpm ~/.tmux/plugins/tpm
        # 后台启动tmux 并用tpm安装tmux插件 new-session可以简化为new -d 必须在-s 之前
        echo "=================== Installing tpm and tmux-plugins in the background..."
        tmux new-session -d -s my-session '~/.tmux/plugins/tpm/bin/install_plugins; bash'
    fi

    if ! command -v fzf>/dev/null 2>&1; then
        echo "==================== Installing fzf"
        rm -rf $HOME/.fzf
        git clone --depth 1 https://${CLONE_DOMAIN}/junegunn/fzf.git ~/.fzf
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

    echo "==================== Installing Sogou Input Method ============="
    bash ${HOME}/.installers/sogoupinyin-installer.sh

    echo "==================== 系统设置 ================="
    echo ""
    echo "==================== 更换默认bash为zsh..."
    sudo usermod -s /usr/bin/zsh $(whoami)
    echo "==================== 生成SSH Key 并添加dotfile 远程仓库 =============="
    bash ${HOME}/.installers/ssh-key-installer.sh
    # 需要在github设置ssh-key
    yadm remote set-url origin git@github.com:yan42685/dotfiles.git


    if [ ! -f $HOME/.gnome-terminal-themes/themes/chalk.sh ]; then
        echo "==================== 安装gnome主题..."
        rm -rf $HOME/.gnome-terminal-themes/
        git clone https://${CLONE_DOMAIN}/Mayccoll/Gogh.git ${HOME}/.gnome-terminal-themes
        # necessary on ubuntu
        export TERMINAL=gnome-terminal
    fi
    bash ${HOME}/.gnome-terminal-themes/themes/chalk.sh
    # 设置默认profile, 用于后续设置主题
    # 要在gsettings之前, 因为gsettings可能会用到Default Profile
    bash ${HOME}/.my-scripts/set-Chalk-as-default-profile.sh


    echo "=================== 设置时区为上海..."
    timedatectl set-timezone Asia/Shanghai
    echo "=================== 设置桌面背景..."
    gsettings set org.gnome.desktop.background picture-uri "$HOME/.config/images/desktop-background/white-maple-black-background.png"
    echo "=================== 设置快捷栏dock样式..."
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
    echo "=================== 设置键盘响应速度..."
    gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 30
    gsettings set org.gnome.desktop.peripherals.keyboard delay 250
    echo "=================== 设置系统字体"
    gsettings set org.gnome.desktop.interface document-font-name 'Sans 11'
    gsettings set org.gnome.desktop.interface font-name 'Ubuntu 11'
    # gsettings set org.gnome.desktop.interface monospace-font-name 'Ubuntu Mono 13'
    gsettings set org.gnome.desktop.interface monospace-font-name 'SaurceCodePro NF 13'
    # 光标不跳动
    gsettings set org.gnome.desktop.interface cursor-blink 'false'
    echo "=================== 设置快捷键"
    # (查询gnome-terminal快捷键用　gsettings list-recursively | grep Terminal.Legacy.Keybindings)
    KEYBIDINGS_PATH=org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/
    gsettings set $KEYBIDINGS_PATH paste '<Alt>i'

    echo "==================== 设置背景透明度和字体"
    DEFAULT_PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default)
    DEFAULT_PROFILE=${DEFAULT_PROFILE:1:-1} # remove leading and trailing single quotes
    DEFAULT_PROFILE="org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${DEFAULT_PROFILE}/"
    gsettings set ${DEFAULT_PROFILE} use-transparent-background true
    gsettings set ${DEFAULT_PROFILE} background-transparency-percent 2
    # 使用自定义字体
    gsettings set ${DEFAULT_PROFILE} use-system-font false
    gsettings set ${DEFAULT_PROFILE} font 'SauceCodePro NF 13'


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

        # 使安装过程中添加的export PATH生效, 比如fzf安装时添加的.bashrc、.zshrc配置
        source $HOME/.bashrc
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
    # FIXME: 解决webpack导致系统wacher到达上限的问题，不确定有没有副作用
    echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl --system -p.

}

common_after_deploy() {
    echo "==================== 初始化配置文件的 git 仓库"
    cd $HOME
    git init
    # git add 除去字体
    git add -f $(yadm ls | grep -v .local/share/fonts)
    git commit -a -m "init"

    # 安装vim插件
    # NOTE: post执行脚本会卡一段时间，耐心等待就好
    nvim "+PlugUpdate" "+PlugClean!" "+PlugUpdate" "+qall"
}

# confirm_reboot() {
#     echo "==================== 需要重启系统使配置生效 =================="
#     echo -n "Are you sure to reboot now? (y/n):"
#     read crm
#     if [ "$crm"x = "y"x ]; then
#         echo "rebooting"
#         \reboot
#     fi
# }

reboot_in_3seconds() {
    echo "===================== deploy finished ======================="
    echo ""

    remain_seconds=5
    for i in {1..5}
    do
        echo "===================== system will reboot in ${remain_seconds} seconds... ======================="
        let remain_seconds--
        sleep 1
    done
    reboot
}

main() {
    if [ "$system_type" = "Linux" ]; then
        deploy_ubuntu
        common_after_deploy
        reboot_in_3seconds
    fi
}

main
