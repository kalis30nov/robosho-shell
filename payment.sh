script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh
RABBIT_MQ_PASSWD=$1

if [ -z "$RABBIT_MQ_PASSWD"]; then
  echo " Password not input"
  exit
fi

component=payment

func_python