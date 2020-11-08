# NOTE: 1. 检查cron语法是否正确的网站： https://crontab.guru/
#       2. 因为cron默认所有输出都会保存在一个文件里, 时间长了会撑爆硬盘,
#          所以最好每个命令末尾加上 >/dev/null 2>&1

# cron_jobs=$(ls ~/.my-scripts/default-cronjob/)

cronjobs_path=~/.my-scripts/default-cronjob

#write out current crontab
crontab -l > mycron
#echo new cron into cron file
echo "* * * * * echo hello" >> mycron
#install new cron file
crontab mycron
rm mycron
