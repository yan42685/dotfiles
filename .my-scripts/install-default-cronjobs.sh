# DEPRECIATED: 本脚本尚未放入~/.my-scripts/deploy.sh 因为Oh-My-Zsh自带的git-auto-fetch插件足够用了

# NOTE: 1. 检查cron语法是否正确的网站： https://crontab.guru/
#       2. 因为cron默认所有输出都会保存在一个文件里, 时间长了会撑爆硬盘,
#          所以最好每个命令末尾加上 >/dev/null 2>&1

REDIRECT_TO_NULL=" >/dev/null 2>&1"
cronjobs_path=~/.my-scripts/default-cronjobs

#write out current crontab
crontab -l > mycron
#echo new cron into cron file


# 每分钟自动fetch有git仓库的目录
# TODO: 不知道为什么auto fetch不生效
# echo "* * * * * zsh $cronjobs_path/git-auto-fetch.zsh"$REDIRECT_TO_NULL >> mycron


#install new cron file
crontab mycron
rm mycron
