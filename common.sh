code_dir=$(pwd)
log_file=/tmp/rorboshop.log
rm-f ${log_file}

print_head(){
  echo -e "\e[34m$1"
}

status_check(){
if [ $1? -eq 0 ]; then
  echo SUCCESS
  else
    echo FAILURE
    exit 1
    fi
    }


    schema_setup(){
      if [ "${schema_type}"=="mongo"]; then

        print_head "Copy MongoDB Repo File"
            cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>{log_file}
            status_check $?
            print_head "Install Mongo Client "
            yum install mongodb-org-shell -y &>>{log_file}
            status_check $?
            print_head "Load Schema "
            mongo --host mongodb.anassdevops.online </app/schema/${component}.js &>>{log_file}
            status_check $?
 fi
    }
    nodejs(){

      print_head "configure NodeJS Repo"
      curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}

      #status_check $?
      print_head "Install NodeJs "
      yum install nodejs -y &>>{log_file}
      status_check $?

      print_head "Create Roboshop ${component}"
      if roboshop &>>{log_ile}
      if [ $? -ne 0 ]; then
        ${component}add roboshop &>>{log_file}
        fi
      status_check $?

      print_head "Create Application Directory"
      if [ ! -d /app ]; then
      mkdir /app &>>{log_file}
      fi
      status_check $?

      print_head "Create old content "
      rm-rf /app/* &>>{log_file}
      status_check $?

      print_head "Downloading App content"
      curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>{log_file}
      status_check $?
      cd /app

      print_head "Extracting App Content "
      unzip /tmp/${component}.zip &>>{log_file}

      status_check $?
      cd /app

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
      systemctl enable usser

      status_check $?
      print_head "Start ${component}Services"
      systemctl restart ${component}
      status_check $?

    schema_setup

}