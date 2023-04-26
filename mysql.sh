script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh
MYSQL_ROOT_PASSWD=$1
echo $1

if [ -z "$MYSQL_ROOT_PASSWD" ]; then
  echo " Password not input"
  exit
fi

func_title_print "Disable MySQL module "
dnf module disable mysql -y &>>$log_file
func_exit_status $?

func_title_print "Copy Repo file for MYSQL "
cp $script_path/mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
func_exit_status $?

func_title_print "Install MYSQL "
yum install mysql-community-server -y &>>$log_file
func_exit_status $?

func_title_print "Enable and start MYSQL "
systemctl enable mysqld &>>$log_file
systemctl start mysqld &>>$log_file
func_exit_status $?

func_title_print "Change Def password "
mysql_secure_installation --set-root-pass $(MYSQL_ROOT_PASSWD) &>>$log_file
func_exit_status $?

func_title_print "Validate the new password "
mysql -uroot -p$(MYSQL_ROOT_PASSWD) &>>$log_file
func_exit_status $?


