app_user=roboshop
log_file=/tmp/roboshop.log

func_title_print () {
echo -e "\e[36m>>>>>>>>>>>>>> $1 <<<<<<<<<<<<<<<<<\e[0m"
echo -e "\e[36m>>>>>>>>>>>>>> $1 <<<<<<<<<<<<<<<<<\e[0m" &>> $log_file
}

func_exit_status () {
if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
else
  echo -e "\e[31mFAILURE\e0m"
  echo -e " Check log file $log_file"
  exit 1
fi
}

func_schema(){
    if [ "$schema_setup" == "mongo" ]; then
        func_title_print " Copy Mongo Repo "
        rm -rf /etc/yum.repos.d/mongo.repo &>>$log_file
        cp /root/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
        func_exit_status $?

        func_title_print " Install Mongo Client "
        yum install mongodb-org-shell -y &>>$log_file
        func_exit_status $?

        func_title_print " Configure Mongo Schema "
        mongo --host mongodb-dev.kalis30nov.online </app/schema/${component}.js &>>$log_file
        func_exit_status $?
    fi
    if [ "$schema_setup" == "mysql" ]; then
        func_title_print  "Install MySQL clent"
        yum install mysql -y &>>$log_file
        func_exit_status $?
        func_title_print  "Load Schema"
        mysql -h mysql-dev.kalis30nov.online -uroot -p${MYSQL_ROOT_PASSWD} < /app/schema/shipping.sql &>>$log_file
        func_exit_status $?
    fi
}

fun_user_prereq(){

        func_title_print  "Adding App User "
        id ${app_user} &>>$log_file
        if [ $? -ne 0 ]; then
            useradd ${app_user} &>>$log_file
        fi

        func_exit_status $?

        func_title_print  "Creating App User Homedir "
        rm -rf /app &>>$log_file
        mkdir /app
        func_exit_status $?

        func_title_print  "Download Install ZIP file for App"
        curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
        ls -l /tmp/${component}.zip &>>$log_file
        func_exit_status $?

        func_title_print  "Unzip App content "
        cd /app
        unzip /tmp/${component}.zip &>>$log_file
        func_exit_status $?
}

func_service_systemd() {

        func_title_print  "Copy Service"
        rm -rf /etc/systemd/system/${component}.service
        cp ${script_path}/${component}.service /etc/systemd/system/${component}.service &>>$log_file
        func_exit_status $?

        func_title_print  "Restart service"
        systemctl daemon-reload &>>$log_file
        systemctl enable ${component} &>>$log_file
        systemctl start ${component} &>>$log_file
        func_exit_status $?

}

func_nodejs() {
        func_title_print "Configuring Node JS repo"
        curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file
        func_exit_status $?


        func_title_print  "Install Node Js "
        yum install nodejs -y &>>$log_file
        func_exit_status $?

        fun_user_prereq

        func_title_print  "Install dependent files for App "
        cd /app
        npm install &>>$log_file
        func_exit_status $?

        func_schema

        func_service_systemd
}


func_java_install() {

        func_title_print  "Installing Maven"
        yum install maven -y &>>$log_file
        func_exit_status $?

        fun_user_prereq

        func_title_print  "Clean Package"
        mvn clean package &>>$log_file
        mv target/${component}-1.0.jar ${component}.jar
        func_exit_status $?

        func_schema

        func_service_systemd

}


function_python() {
        func_title_print "Install Python"
        yum install python36 gcc python3-devel -y >>$log_file
        func_exit_status $?

        func_title_print "Updated Password for service"
        sed -i -e "s/RABBIT_MQ_PASSWD/${RABBIT_MQ_PASSWD}/" ${script_path}/payment.service >>$log_file
        func_exit_status $?

        fun_user_prereq

        func_title_print "Install PIP"
        pip3.6 install -r requirements.txt >>$log_file
        func_exit_status $?
        
        func_service_systemd
}

