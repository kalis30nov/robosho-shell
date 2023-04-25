script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

func_title_print "Copy repo file "
cp $script_path/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
func_exit_status $?

func_title_print "Install Mongodb Client "
yum install mongodb-org -y &>>$log_file
func_exit_status $?

func_title_print "Update IP in mongodb conf file "
sed -i 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf &>>$log_file
func_exit_status $?

func_title_print "Enable and Start service "
systemctl enable mongod &>>$log_file
systemctl restart mongod &>>$log_file
func_exit_status $?


