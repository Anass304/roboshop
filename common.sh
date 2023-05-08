code_dir=$(pwd)
log_file=/tmp/rorboshop.log
rm -f ${log_file}
print_head(){
  echo -e "\e[34m$1"
}

status_check(){
  if [ $1 -eq 0 ]; then
  echo SUCCESS
  else
    echo FAILURE
    exit 1
    fi
    }

systemd_setup() {
    print_head "Copy SystemD Service File"
    cp ${code_dir}/configs/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
    status_check $?

    sed -i -e "s/ROBOSHOP_USER_PASSWORD/${roboshop_app_password}/" /etc/systemd/system/${component}.service &>>${log_file}

    print_head "Reload SystemD"
    systemctl daemon-reload &>>${log_file}
    status_check $?

    print_head "Enable ${component} Service "
    systemctl enable ${component} &>>${log_file}
    status_check $?

    print_head "Start ${component} Service"
    systemctl restart ${component} &>>${log_file}
    status_check $?
  }



schema_setup() {
  if [ "${schema_type}" == "mongo" ]; then
    print_head "Copy MongoDB Repo File"
    cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
    status_check $?

    print_head "Install Mongo Client"
    yum install mongodb-org-shell -y &>>${log_file}
    status_check $?

    print_head "Load Schema"
    mongo --host mongodb-dev.devopsb71.online </app/schema/${component}.js &>>${log_file}
    status_check $?
  elif [ "${schema_type}" == "mysql" ]; then
    print_head "Install MySQL Client"
    yum install mysql -y &>>${log_file}
    status_check $?

    print_head "Load Schema"
    mysql -h mysql-dev.devopsb71.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql &>>${log_file}
    status_check $?
  fi
}
    app_prereq_setup(){
        print_head "Create Roboshop user"
            id roboshop &>>{log_file}
            if [ $? -ne 0 ]; then
              useradd roboshop &>>{log_file}
              fi
            status_check $?

            print_head "Create Application Directory"
            if [ ! -d /app ]; then
            mkdir /app &>>{log_file}
            fi
            status_check $?

            print_head "Create old content "
            rm -rf /app/* &>>{log_file}
            status_check $?

            print_head "Downloading App content"
            curl -l -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>{log_file}
            status_check $?
            cd /app

            print_head "Extracting App Content "
            unzip /tmp/${component}.zip &>>{log_file}
             status_check $?
                  cd /app
}


    nodejs(){

      print_head "configure NodeJS Repo"
      curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}

      #status_check $?
      print_head "Install NodeJs "
      yum install nodejs -y &>>{log_file}
      status_check $?

    app_prereq_setup


      print_head "Installing NodeJs dependencyes"
      npm install &>>{log_file}
      status_check $?
      print_head "Copy SystemD service File "
      cp ${code_dir}/configs/${component}.service etc/systemd/system/${component}.service &>>{log_file}

      status_check $?
      print_head "Reload systemd"
      systemctl daemon-reload

      status_check $?
      print_head "Enabling ${component}service"
      systemctl enable user

      status_check $?
      print_head "Start ${component}Services"
      systemctl restart ${component}
      status_check $?
#schema setup function
    schema_setup

#systemD Function
systemd_setup
}


java(){
  print_head " Install Maven "
  yum install maven -y &>>${log_file}
  status_check $?

  app_prereq_setup
    print_head " Download dependencies & package "
    mvn clean package &>>${log_file}
    mv target/${component}-1.0.jar ${component}.jar &>>${log_file}
      status_check $?

#schema setup function
schema_setup
#systemd function
systemd_setup


}
python(){

    print_head "Install python "
    yum install python36 gcc python3-devel -y &>>{log_file}
  status_check $?

  app_prereq_setup

  print_head "install python Dependencies & package"

  pip3.6 install -r requirements.txt&>>{log_file}
  status_check $?


  systemctl daemon-reload
  systemctl enable shipping
  systemctl start shipping

#systemD function
systemd_setup
}