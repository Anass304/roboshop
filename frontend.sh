source common.sh

"Installing nginx"
yum install nginx -y
echo $?

print_head "Removing old content"
rm -rf /usr/share/nginx/html/*
echo $?


print_head "Downloading frontend content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>{log_file}
echo $?


print_head "Extracting Downloaded frontend content"
cd /usr/share/nginx/html
echo $?


unzip /tmp/frontend.zip &>>{log_file}
echo $?


print_head "Copying nginx config for Roboshop"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>{log_file}

echo $?

print_head "Enabling nginx"
systemctl enable nginx
echo $?

print_head "Restart nginx"
systemctl restart nginx
echo $?

# Roboshop config is not copied
# if any cmd is erored or failed , we need to stop the script
#status of the command need to be printed