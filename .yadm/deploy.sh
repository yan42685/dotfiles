# 这里设置 git config --system 代理是为了加速 clone　
# 并且和 --global 不同，可以避免生成~/.gitconfig 导致的 clone 时有已存在文件的异常
sudo git config --system http.https://github.com.proxy socks5://127.0.0.1:6543
sudo apt install yadm -y
yadm clone https://github.com/yan42685/dotfiles --no-bootstrap
sudo git config --system --unset http.proxy
bash ~/.yadm/deploy-helper.sh

