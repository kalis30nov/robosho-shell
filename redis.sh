script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

func_title_print " Install Redis Repo "
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$log_file
func_exit_status $?

func_title_print " Enable Redis module "
dnf module enable redis:remi-6.2 -y &>>$log_file
func_exit_status $?

func_title_print " Install Redis "
yum install redis -y &>>$log_file
func_exit_status $?

func_title_print " Update Redis config file "
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf  /etc/redis/redis.conf &>>$log_file
func_exit_status $?

func_title_print " Enable and Start Redis"
systemctl enable redis &>>$log_file
systemctl start redis &>>$log_file
func_exit_status $?
