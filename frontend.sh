script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

func_title_print "Install Ngninx "
yum install nginx -y &>>$log_file
func_exit_status $?

func_title_print "Start Nginx "
systemctl enable nginx &>>$log_file
systemctl start nginx &>>$log_file
func_exit_status $?

func_title_print "Remove old config file "
rm -rf /usr/share/nginx/html/* &>>$log_file
func_exit_status $?

func_title_print "Copy Roboshop config "
cp $script_path/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$log_file
func_exit_status $?

func_title_print "Download app content "
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
func_exit_status $?

func_title_print " Extracting app content "
cd /usr/share/nginx/html &>>$log_file
unzip /tmp/frontend.zip &>>$log_file
func_exit_status $?

func_title_print "Restart Nginx "
systemctl restart nginx &>>$log_file
func_exit_status $?
