## 这是什么以及适用条件

- 这是自动化部署自用软件及其依赖、配置的项目，方便迁移到新的虚拟机 / 实体机
- 应该只能用于 Ubuntu 18.04 刚安装好的纯净镜像 （想要不出问题最好用 18.04 而不是更高版本的，已知 18.04.5 由于系统内核的问题导致 fzf preview 功能失效，显示 Failed to read /dev/tty 从而 fzf-tab 无法使用）

## 部署前的准备

- 包管理器 (apt) 换源
- 设置永不自动锁屏　 Settings-Power-Blank Screen 的值为 never
-
- 安装必备软件 `sudo apt install -y git curl wget unzip yadm`
- 安装 v2rayA 设置代理加速后续安装过程（可选）

  1.  安装

      ```bash
      wget https://raw.fastgit.org/yan42685/dotfiles/master/.installers/v2rayA-installer.sh
      bash v2rayA-installer.sh
      rm v2rayA-installer.sh
      # 复制这行注释可以让倒数第二行命令自动执行，否则会停留在缓冲区
      ```

  2.  配置代理端口
      <details><summary>浏览器访问 localhost:2017 并参考图示设置</summary><br>

      ![代理设置步骤 1](https://raw.fastgit.org/yan42685/dotfiles/master/.config/images/README/v2rayA-settings-step1.png)
      ![代理设置步骤 2](https://raw.fastgit.org/yan42685/dotfiles/master/.config/images/README/v2rayA-settings-step2.png)
      ![代理设置步骤 3](https://raw.fastgit.org/yan42685/dotfiles/master/.config/images/README/v2rayA-settings-step3.png)
      ![代理设置步骤 4](https://raw.fastgit.org/yan42685/dotfiles/master/.config/images/README/v2rayA-settings-step4.png)

      </details>

## 自动部署命令

```bash
yadm clone https://hub.fastgit.org/yan42685/dotfiles --no-bootstrap
bash ~/.my-scripts/deploy.sh
# 复制这行注释可以让倒数第二行命令自动执行，否则会停留在缓冲区
```

<!-- 如果 fastgit 有问题了就用下面的 -->
<!-- # 这里设置 git config --system 代理是为了加速 clone　 -->
<!-- # 并且和 --global 不同，可以避免生成~/.gitconfig 导致的 clone 时有已存在文件的异常 -->
<!-- sudo git config --system http.https://github.com.proxy socks5://127.0.0.1:6543 -->
<!-- sudo git config --system https.https://github.com.proxy socks5://127.0.0.1:6543 -->
<!-- sudo git config --system --unset http.proxy -->
<!-- sudo git config --system --unset https.proxy -->

## 部署后手动操作部分

- 安装 Haskell 相关环境（可选）

```bash
  echo "============== Installing Haskell and Language Server..."
  # ghcup 是安装开发环境的工具，stack 是 build 工具 （虽然他们都能安装 ghc)

  curl -sSL https://get.haskellstack.org/ | sh
  stack setup # 安装 ghc 编译器
  stack install hlint # linter
  stack install brittany # formatter
  stack install intero # repl
  # NOTE: 需要用 gen-hie > hie.yaml 生成配置文件，否则 lsp 会报错
  stack install implicit-hie

  # 安装 lsp 并提供可执行的 ghc 编译器
  curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

```

- 设置搜狗输入法
<details><summary>具体步骤</summary><br>

![步骤 1](https://raw.fastgit.org/yan42685/dotfiles/master/.config/images/README/set-sogoupinyin1.png)
![步骤 2](https://raw.fastgit.org/yan42685/dotfiles/master/.config/images/README/set-sogoupinyin2.png)
![步骤 3](https://raw.fastgit.org/yan42685/dotfiles/master/.config/images/README/set-sogoupinyin3.png)
![步骤 4](https://raw.fastgit.org/yan42685/dotfiles/master/.config/images/README/set-sogoupinyin4.png)

</details>

- 在 github 设置 ssh-key 为 `cat ${HOME}/.ssh/id_rsa.pub` 命令输出的值
- 系统设置 dock autohide

## 其他问题

- 有时因为网络原因，zgen 安装 zsh 插件出了问题，导致 zsh 打开是原生 bash 的效果，这时需要 `rm -rf $HOME/.zgen && git clone https://github.com/tarjoilija/zgen.git ${HOME}/.zgen && source $HOME/.zshrc`
- tmux 不显示网速，原因是 tmux 插件未安装，进入 tmux 后按 <C-Space>I 即可
- 出现其他问题 99% 的原因是部署时网速不好

<br>
<details><summary>其他说明</summary>

- dotfiles 里的.local/share/nvim/site/autoload/plug.vim 是 vim-plug 插件管理器的源文件，意味着不会更新 vim-plug 了
- 为了避免 npm install -g 安装到 /usr/local/lib 里导致的普通用户权限问题，本配置默认将 npm 包安装到 \$HOME/.npm-packages 里
- 用 fastgit 可以加速 git clone 和 wget 下载 [FastGit 传送门](https://doc.fastgit.org/zh-cn/guide.html#web-%E7%9A%84%E4%BD%BF%E7%94%A8)

</details>
```
