echo -e "\e[36m>>>>>>>>>>>>>> Configuring Node JS repo <<<<<<<<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[36m>>>>>>>>>>>>>> Copy Catelogue service <<<<<<<<<<<<<<<<<\e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[36m>>>>>>>>>>>>>> Install Node Js <<<<<<<<<<<<<<<<<\e[0m"
yum install nodejs -y

echo -e "\e[36m>>>>>>>>>>>>>> Adding App User <<<<<<<<<<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>>>>>>>>>> Creating App User Homedir <<<<<<<<<<<<<<<<<\e[0m"

mkdir /app

echo -e "\e[36m>>>>>>>>>>>>>> Download Install ZIP file for App <<<<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

echo -e "\e[36m>>>>>>>>>>>>>> Unzip App content <<<<<<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/catalogue.zip

echo -e "\e[36m>>>>>>>>>>>>>> Install dependent files for App <<<<<<<<<<<<<<<<<\e[0m"
npm install


echo -e "\e[36m>>>>>>>>>>>>>> Start Catalogue service <<<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue

echo -e "\e[36m>>>>>>>>>>>>>> Copy Mongo Repo<<<<<<<<<<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>>>>>>>> Install Mongo Client <<<<<<<<<<<<<<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[36m>>>>>>>>>>>>>> Configure Mongo Schema <<<<<<<<<<<<<<<<<\e[0m"
mongo --host mogodb-dev.kalis30nov.online </app/schema/catalogue.js