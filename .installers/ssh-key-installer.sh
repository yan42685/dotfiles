# 非交互式生成ssh-key, 自动覆盖以前的ssh
# 放在deploy.sh里会报静态检查错误，就单独放.sh文件里了
ssh-keygen -q -t rsa -b 4096 -N '' <<< ""$'\n'"y" 2>&1 >/dev/null
