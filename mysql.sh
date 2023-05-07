source common.sh

mysql_root_password=$1
if [ -z "${mysql_root_password}"]; then
  echo -e "\e[31mMissing MYSQL Root Password argument\e[0m"
  exit 1
  fi


print_head "Diabling MySQL 8 version "
dnf module disable mysql -y &>>{log_file}
status_check $?

print_head "copy MYSQL repo file"
cp ${code_dir}/configs/mysql.repo /etc/yum.repos.d/mysql.repo &>>{log_file}
status_check $?

print_head "Installing MySQL community server "
yum install mysql-community-server -y &>>{log_file}
status_check $?

print_head " Enabling MySQL"
systemctl enable mysqld &>>{log_file}
status_check $?

print_head "Starting MySQL"
systemctl start mysqld &>>{log_file}
status_check $?


print_head "Set Root password  "
echo show database | mysql -root -p{mysql_root_password} &>>{log_file}
if [ $?-ne 0 ]; then
mysql_secure_installation --set-root-pass RoboShop@1 ${mysql_root_password} &>>{log_file}
fi
mysql -uroot -pRoboShop@1
