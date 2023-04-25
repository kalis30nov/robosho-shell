script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

echo -e "\e[36m  >>>>>>>>>> Copying repo file  <<<<<<<<< \e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo
echo -e "\e[36m >>>>>>>>>> Installing Mongo package <<<<<<<<< \e[0m"
yum install mongodb-org -y

echo -e "\e[36m >>>>>>>>>> Update IP in config file <<<<<<<<< \e[0m"
sed -i 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf

echo -e "\e[36m >>>>>>>>>> Enable service  <<<<<<<<< \e[0m"
systemctl enable mongod

echo -e "\e[36m >>>>>>>>>> Restart service <<<<<<<<< \e[0m"
systemctl restart mongod
