script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

component=catalouge
func_nodejs



echo -e "\e[36m>>>>>>>>>>>>>> Copy Mongo Repo<<<<<<<<<<<<<<<<<\e[0m"
rm -rf /etc/yum.repos.d/mongo.repo
cp /root/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>>>>>>>> Install Mongo Client <<<<<<<<<<<<<<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[36m>>>>>>>>>>>>>> Configure Mongo Schema <<<<<<<<<<<<<<<<<\e[0m"
mongo --host mongodb-dev.kalis30nov.online </app/schema/catalogue.js