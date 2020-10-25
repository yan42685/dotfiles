## 这是什么以及适用条件

- 这是自动化部署自用软件及其依赖、配置的项目，方便迁移到新的虚拟机 / 实体机
- 应该只能用于 Ubuntu 18.04 或以上版本

## 部署前的准备（只用于加速下载，非必须）

- 包管理器 (apt) 换源
- 安装 v2rayL 和设置 git 代理
  1. 下载并安装 以及设置 git 用于 github 的代理（端口与步骤 2 的 socks 一致） `bash <(curl -s -L http://dl.thinker.ink/install.sh) && git config http.https://github.com.proxy socks5://127.0.0.1:6543`
  2. 自定义 v2rayL 代理端口 ![](https://github.com/yan42685/dotfiles/blob/master/.config/images/proxy-setting1.png)
  3. 配置自己提前买到的服务器信息或订阅信息
  4. 设置系统代理为步骤 2 的 http 端口 ![](https://github.com/yan42685/dotfiles/blob/master/.config/images/proxy-setting2.png)
  5. 设置 v2rayL 自动启动（可选）

## 自动部署命令

`sudo apt install yadm -y && yadm clone https://github.com/yan42685/dotfiles --no-bootstrap && bash ~/.yadm/bootstrap.sh`

## 解决 nvim 和 tmux 状态栏乱码问题

设置 terminal 的字体为 SauceCodePro NF Regular
<br>

![Ubuntu18 设置 gnome-terminal 字体示例图](https://raw.githubusercontent.com/yan42685/dotfiles/master/.config/images/font-settting.png)

## 其他问题

- 初次打开 nvim 的 startify 页面，会显示无法读取 viminfo 的警告，下次打开就不会出现了
- 打开 zsh 会警告没有 zeal 相关的文件夹，这时只用开启一次 zeal 就会自动创建相关文件夹，下次就不会有警告了
- 有时因为网络原因，zgen 安装 zsh 插件出了问题，导致 zsh 打开是原生 bash 的效果，这时删除~/.zgen 然后去 github 再 clone 就好

<br>
<details>
<summary>其他详情</summary>

- dotfiles 里的.local/share/nvim/site/autoload/plug.vim 是 vim-plug 插件管理器的源文件，意味着不会更新 vim-plug 了

</details>

<br>
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
