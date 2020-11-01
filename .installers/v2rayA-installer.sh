#!/bin/sh
# 这里使用了 fastgit 代理 raw.githubusercontent.com
# 安装 v2ray-core
curl -O https://cdn.jsdelivr.net/gh/v2rayA/v2rayA@master/install/go.sh
sudo bash go.sh && rm $HOME/go.sh
# 安装 v2rayA
wget -qO - https://raw.fastgit.org/v2rayA/v2raya-apt/master/key/public-key.asc | sudo apt-key add -
echo "deb https://raw.fastgit.org/v2rayA/v2raya-apt/master/ v2raya main" | sudo tee /etc/apt/sources.list.d/v2raya.list
sudo apt update
sudo apt install v2raya
sudo systemctl enable v2ray && sudo systemctl start v2ray
# 设置 snap 代理
sudo snap set system proxy.http="socks5://127.0.0.1:6543"
sudo snap set system proxy.https="socks5://127.0.0.1:6543"
# 打开设置界面
firefox -new-tab http://localhost:2017
