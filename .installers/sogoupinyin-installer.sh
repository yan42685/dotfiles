# 卸载ibus。
sudo apt-get remove -y ibus
# 清除ibus配置。
sudo apt-get purge -y ibus
# 卸载顶部面板任务栏上的键盘指示。
sudo apt-get remove -y indicator-keyboard

# 安装fcitx输入法框架
sudo apt install -y fcitx-table-wbpy fcitx-config-gtk
# 切换为 Fcitx输入法 需要重启系统才能生效
im-config -n fcitx

# 下载搜狗输入法 wget 选项-c支持断点续传 -O重命名
SOUGOU_DOWNLOAD_URL="http://cdn2.ime.sogou.com/dl/index/1571302197/sogoupinyin_2.3.1.0112_amd64.deb?st=zTdx7WU20EVTRSdunSacmA&e=1598260619&fn=sogoupinyin_2.3.1.0112_amd64.deb"
wget -c ${SOUGOU_DOWNLOAD_URL} -O sougoupinyin.deb

# 设置dpkg安装时不用确认
sudo dpkg-reconfigure debconf -f noninteractive -p critical
# 安装搜狗输入法(会报错 是正常的)
sudo dpkg -i sougoupinyin.deb
# 修复损坏缺少的包
sudo apt-get install -y -f
rm sougoupinyin.deb
