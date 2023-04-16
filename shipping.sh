yum install maven -y
cp shipping.service /etc/systemd/system/shipping.service
useradd roboshop
mkdir /app
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app
unzip /tmp/shipping.zip
mvn clean package
mv target/shipping-1.0.jar shipping.jar
systemctl daemon-reload
systemctl enable shipping
systemctl start shipping
yum install mysql -y
mysql -h mysql-dev.kalis30nov.online -uroot -pRoboShop@1 < /app/schema/shipping.sql
systemctl restart shipping