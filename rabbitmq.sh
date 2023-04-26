script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh
RABBIT_MQ_PASSWD=$1

if [ -z "$RABBIT_MQ_PASSWD" ]; then
  echo " Password not input"
  exit
fi

func_title_print " Install Erlang Repo "
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$log_file
func_exit_status $?

func_title_print " Install Erlang "
yum install erlang -y &>>$log_file
func_exit_status $?

func_title_print " Install Rabbit MQ Repo "
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$log_file
func_exit_status $?

func_title_print " Install and Enable RabbitMQ Server"
yum install rabbitmq-server -y &>>$log_file
systemctl enable rabbitmq-server &>>$log_file
func_exit_status $?

func_title_print "Start RabbitMQ "
systemctl start rabbitmq-server &>>$log_file
func_exit_status $?

func_title_print " Rabbit MQ User add"
rabbitmqctl add_user $app_user ${RABBIT_MQ_PASSWD} &>>$log_file
func_exit_status $?

func_title_print " Rabbit MQ User permission Set"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$log_file
func_exit_status $?

