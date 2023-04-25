app_user=roboshop

func_title_print () {
echo -e "\e[36m>>>>>>>>>>>>>> $1 <<<<<<<<<<<<<<<<<\e[0m"
}

func_nodejs() {
func_title_print "Configuring Node JS repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash


func_title_print  "Install Node Js "
yum install nodejs -y

func_title_print  "Adding App User "
useradd ${app_user}

func_title_print  "Creating App User Homedir "
rm -rf /app
mkdir /app

func_title_print  "Download Install ZIP file for App"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip

func_title_print  "Unzip App content "
cd /app
unzip /tmp/${component}.zip

func_title_print  "Install dependent files for App "
npm install

func_title_print  "Copy ${component} service"
rm -rf /etc/systemd/system/${component}.service
cp /root/roboshop-shell/${component}.service /etc/systemd/system/${component}.service


func_title_print  "Start ${component} service "
systemctl daemon-reload
systemctl enable ${component}
systemctl start ${component}

}