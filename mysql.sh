script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh
MYSQL_ROOT_PASSWD=$1

if [ -z "$MYSQL_ROOT_PASSWD"]; then
  echo " Password not input"
  exit
fi

dnf module disable mysql -y
cp mysql.repo /etc/yum.repos.d/mysql.repo
yum install mysql-community-server -y
systemctl enable mysqld
systemctl start mysqld
mysql_secure_installation --set-root-pass $(MYSQL_ROOT_PASSWD)
mysql -uroot -pRoboShop@1