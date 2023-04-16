yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
dnf module enable redis:remi-6.2 -y
yum install redis -y
sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/g' /etc/redis.conf
sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/g' /etc/redis/redis.conf
systemctl enable redis
systemctl start redis