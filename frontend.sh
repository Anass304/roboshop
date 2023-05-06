code_dir=$(pwd)
log_file=/tmp/rorboshop.log
rm-f ${log_file}

echo -e "\e[35mInstalling nginx\e[0m"
yum install nginx -y

echo -e "\e[35mRemoving old content\e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[35mDownloading frontend content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>{log_file}

echo -e "\e[35mExtracting Downloaded frontend content\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>{log_file}

echo -e "\e[35mCopying nginx config for Roboshop\e[0m"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>{log_file}

echo -e "\e[35mEnabling nginx\e[0m"
systemctl enable nginx

echo -e "\e[35mRestart nginx\e[0m"
systemctl restart nginx

# Roboshop config is not copied
# if any cmd is erored or failed , we need to stop the script
