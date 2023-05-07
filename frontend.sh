source common.sh

"Installing nginx"
yum install nginx -y

print_head "Removing old content"
rm -rf /usr/share/nginx/html/*

print_head "Downloading frontend content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>{log_file}

print_head "Extracting Downloaded frontend content"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>{log_file}

print_head "Copying nginx config for Roboshop"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>{log_file}

print_head "Enabling nginx"
systemctl enable nginx

print_head "Restart nginx"
systemctl restart nginx

# Roboshop config is not copied
# if any cmd is erored or failed , we need to stop the script
