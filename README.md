## 这是什么以及适用条件

- 这是自动化部署自用软件及其依赖、配置的项目，方便迁移到新的虚拟机 / 实体机
- 应该只能用于 Ubuntu 18.04 刚安装好的纯净镜像 （想要不出问题最好用 18.04 而不是更高版本的，已知 18.04.5 由于系统内核的问题导致 fzf preview 功能失效，显示 Failed to read /dev/tty 从而 fzf-tab 无法使用）

## 部署前的准备

- 包管理器 (apt) 换源
- 设置永不自动锁屏　 Settings-Power-Blank Screen 的值为 never
- 安装必备软件 `sudo apt install -y git curl wget unzip`
- 安装 qv2ray 并设置代理（仅用于加速，非必须）

  ```bash
     sudo snap install qv2ray
     mkdir -p $HOME/.config/qv2ray/vcore
     cd $HOME/.config/qv2ray/vcore
     wget https://github.com/v2fly/v2ray-core/releases/download/v4.31.3/v2ray-linux-64.zip
     unzip v2ray-linux-64.zip
     chmod +x v2ray v2ctl
     rm v2ray-linux-64.zip
     cd $HOME
     qv2ray
  ```

<!-- * 安装 v2rayL 设置代理（只用于加速下载，非必须） -->
<!--  -->
<!--   1. 下载并安装（默认开机自启动） `bash <(curl -s -L http://dl.thinker.ink/install.sh)` -->
<!--   2. 自定义 v2rayL 代理端口 (socks 端口与 dotfiles 里.gitconfig 代理端口一致） ![](https://github.com/yan42685/dotfiles/blob/master/.config/images/README/proxy-setting1.png) -->
<!--   3. 配置自己提前买到的服务器信息或订阅信息 -->
<!--   4. 设置系统代理为步骤 2 的 http 端口 ![](https://github.com/yan42685/dotfiles/blob/master/.config/images/README/proxy-setting2.png) -->

## 自动部署命令

```bash
# 这里设置 git config --system 代理是为了加速 clone　
# 并且和 --global 不同，可以避免生成~/.gitconfig 导致的 clone 时有已存在文件的异常
sudo git config --system http.https://github.com.proxy socks5://127.0.0.1:6543
sudo apt install yadm -y
yadm clone https://github.com/yan42685/dotfiles --no-bootstrap
sudo git config --system --unset http.proxy
bash ~/.my-scripts/deploy.sh
# 复制这行注释可以让倒数第二行命令自动执行，否则会停留在缓冲区
```

## 其他问题

- 有时因为网络原因，zgen 安装 zsh 插件出了问题，导致 zsh 打开是原生 bash 的效果，这时需要 `rm -rf $HOME/.zgen && git clone https://github.com/tarjoilija/zgen.git ${HOME}/.zgen && source $HOME/.zshrc`

<br>
<details>
<summary>其他说明</summary>

- dotfiles 里的.local/share/nvim/site/autoload/plug.vim 是 vim-plug 插件管理器的源文件，意味着不会更新 vim-plug 了
- 为了避免 npm install -g 安装到 /usr/local/lib 里导致的普通用户权限问题，本配置默认将 npm 包安装到 \$HOME/.npm-packages 里

</details>

<details>
<summary>手动部署详情</summary>

## 依赖

- pyenv

```bash
sudo apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev
xz-utils tk-dev libffi-dev liblzma-dev python-openssl git
```

```bash
git clone https://github.com/yyuu/pyenv.git ~/.pyenv
```

- python3, pip3
- node, npm
- snap
- zsh
- zgen
- nvim
- neovim-remote `pip3 install neovim-remote`
- lua
- trash
- ccls （from snap)
- universal ctags
- global
- NerdFont 终端字体：SauceCodePro NF
  (regular+bold+italic+bold italic) 或 DroidSansMono NF
- eslint prettier pylint autopep8 cppcheck clang-format
- rg
- fzf
- tmux (tmux-finger 插件依赖 gawk 包，`sudo apt install gawk`)

# 其他非必须工具推荐

- zeal 查看各种离线文档
- nnn 文件管理器
- bat 略好看的 cat
- 无道词典
- gdb-dashboard 更好看的 gdb
- 如果是用的 gnome-terminal, 可以考虑从`https://github.com/Mayccoll/Gogh`安装比较好看
  的主题（暂时用 material )
- asynctask (`mkdir ~/github && cd ~/github && git clone --depth 1 https://github.com/skywind3000/asynctasks.vim && ln -s ~/github/asynctasks.vim/bin/asynctask ~/.local/bin`)
- Alacritty （这个终端模拟器不能正常显示 emoji, 其他都挺好）
- syncthing.x64 （同步工具）
- Joplin 记笔记

## 如何在远程机器上使用本地 zsh

[https://github.com/rutchkiwi/copyzshell](https://github.com/rutchkiwi/copyzshell)

```bash
git clone https://github.com/rutchkiwi/copyzshell.git ~ZSH_CUSTOM/plugins/copyzshell
```

```bash
copyzshell <remote machine>
```

## 如何在远程机器上使用本地 vim

[https://unix.stackexchange.com/questions/202918/how-do-i-remotely-edit-files-via-ssh](https://unix.stackexchange.com/questions/202918/how-do-i-remotely-edit-files-via-ssh)

使用 sshfs 把远程文件夹 mount 到本地

</details>
