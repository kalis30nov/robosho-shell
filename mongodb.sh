cp mongo.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org -y
systemctl enable mongod
systemctl start mongod
##sed command to replace the mongod.conf file
systemctl restart mongod
