script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

component=dispatch

func_title_print " Install GoLang "
yum install golang -y &>>$log_file

fun_user_prereq

func_title_print "  Download dependencies "
cd /app &>>$log_file
func_exit_status $?

func_title_print "  Init Desptach "
go mod init dispatch &>>$log_file
func_exit_status $?

func_title_print "  Golang get "
go get &>>$log_file
func_exit_status $?

func_title_print "  Golang Build "
go build &>>$log_file
func_exit_status $?

func_service_systemd


