script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

echo -e "\e[36m>>>>>>>>>>>>>> Install GoLang <<<<<<<<<<<<<<<<<\e[0m"
cho -e "\e[36m>>>>>>>>>>>>>> Install GoLang <<<<<<<<<<<<<<<<<\e[0m" &>> /tmp/roboshop.log
yum install golang -y &>> /tmp/roboshop.log

fun_user_prereq

echo -e "\e[36m>>>>>>>>>>>>>> Download dependencies <<<<<<<<<<<<<<<<<\e[0m"
echo -e "\e[36m>>>>>>>>>>>>>> Download dependencies <<<<<<<<<<<<<<<<<\e[0m" &>> /tmp/roboshop.log
cd /app &>> /tmp/roboshop.log
go mod init dispatch &>> /tmp/roboshop.log
go get &>> /tmp/roboshop.log
go build &>> /tmp/roboshop.log

func_service_systemd