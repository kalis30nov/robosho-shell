app_user=roboshop

func_title_print () {
echo -e "\e[36m>>>>>>>>>>>>>> $1 <<<<<<<<<<<<<<<<<\e[0m"
}

func_exit_status () {
if [ $1 -eq 0 ]; then
    echo "\e[32mSUCCESS\e0m"
else
  echo "\e[31mFAILURE\e0m"
  exit 1
fi
}

func_schema(){
    if [ "$schema_setup" =="mongo" ]; then
        func_title_print " Copy Mongo Repo "
        rm -rf /etc/yum.repos.d/mongo.repo
        cp /root/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo
        func_exit_status $?

        func_title_print " Install Mongo Client "
        yum install mongodb-org-shell -y
        func_exit_status $?

        func_title_print " Configure Mongo Schema "
        mongo --host mongodb-dev.kalis30nov.online </app/schema/${component}.js
        func_exit_status $?
    fi
    if [ "$schema_setup" =="mysql" ]; then
        func_title_print  "Install MySQL clent"
        yum install mysql -y
        func_exit_status $?
        func_title_print  "Load Schema"
        mysql -h mysql-dev.kalis30nov.online -uroot -p${MYSQL_ROOT_PASSWD} < /app/schema/shipping.sql
        func_exit_status $?
    fi
}

fun_user_prereq(){

        func_title_print  "Adding App User "
        useradd ${app_user}
        func_exit_status $?

        func_title_print  "Creating App User Homedir "
        rm -rf /app
        mkdir /app

        func_title_print  "Download Install ZIP file for App"
        curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
        ls -l /tmp/${component}.zip
        func_exit_status $?

        func_title_print  "Unzip App content "
        cd /app
        unzip /tmp/${component}.zip
        func_exit_status $?
}

func_service_systemd() {

        func_title_print  "Copy Service"
        rm -rf /etc/systemd/system/${component}.service
        cp ${script_path}/${component}.service /etc/systemd/system/${component}.service
        func_exit_status $?

        func_title_print  "Restart service"
        systemctl daemon-reload
        systemctl enable ${component}
        systemctl start ${component}
        func_exit_status $?

}

func_nodejs() {
        func_title_print "Configuring Node JS repo"
        curl -sL https://rpm.nodesource.com/setup_lts.x | bash
        func_exit_status $?


        func_title_print  "Install Node Js "
        yum install nodejs -y
        func_exit_status $?

        fun_user_prereq

        func_title_print  "Install dependent files for App "
        npm install
        func_exit_status $?

        func_schema

        func_service_systemd
}


func_java_install() {

        func_title_print  "Installing Maven"
        yum install maven -y
        func_exit_status $?

        fun_user_prereq

        func_title_print  "Clean Package"
        mvn clean package
        mv target/${component}-1.0.jar ${component}.jar
        func_exit_status $?

        func_schema

        func_service_systemd

}

