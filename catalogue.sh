source common.sh
print_head "configure NodeJS Repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}

print_head "Install NodeJs "
yum install nodejs -y &>>{log_file}

print_head "Create Roboshop user "
useradd roboshop &>>{log_file}

print_head "Create Application Directory"
mkdir /app &>>{log_file}

print_head "Create old content "
rm-rf /app/* &>>{log_file}

print_head "Downloading App content"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>{log_file}
cd /app

print_head "Extracting App Content "
unzip /tmp/catalogue.zip &>>{log_file}
cd /app

print_head "Installing NodeJs dependencyes"
npm install &>>{log_file}

print_head "Copy SystemD service File "
cp ${code_dir}/configs/catalogue.service etc/systemd/system/catalogue.service &>>{log_file}
print_head "Reload systemd"
systemctl daemon-reload
print_head "Enabling catalouge service"
systemctl enable catalogue
print_head "Start Catalouge Services"
systemctl restart catalogue

print_head "Copy MongoDB Repo File"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>{log_file}

print_head "Install Mongo Client "
yum install mongodb-org-shell -y &>>{log_file}

print_head "Load Schema "
mongo --host mongodb.anassdevops.online </app/schema/catalogue.js &>>{log_file}
