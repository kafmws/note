rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
yum install ntp ntpdate -y
service ntpd stop #停止ntp服务
ntpdate us.pool.ntp.org #同步ntp时间
service ntpd start #启动ntp服务