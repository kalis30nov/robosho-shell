script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh
RABBIT_MQ_PASSWD=$1

if [ -z "$RABBIT_MQ_PASSWD"]; then
  echo " Password not input"
  exit
fi

yum install python36 gcc python3-devel -y
sed -i -e "s/RABBIT_MQ_PASSWD/${RABBIT_MQ_PASSWD}/" ${script_path}/payment.service
cp ${script_path}/payment.service /etc/systemd/system/payment.service
useradd $app_user
mkdir /app
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
cd /app
unzip /tmp/payment.zip
pip3.6 install -r requirements.txt
systemctl daemon-reload
systemctl enable payment
systemctl start payment