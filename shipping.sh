script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh
MYSQL_ROOT_PASSWD=$1

if [ -z "$MYSQL_ROOT_PASSWD" ]; then
  echo " Password not input"
  exit
fi

component=shipping
schema_setup=mysql
func_java_install