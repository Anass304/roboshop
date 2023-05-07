source common.sh

roboshop_app_password=$1
if [ -z "${roboshop_app_password}" ]; then
  echo -e "\e[31mMissing MYSQL Root Password argument\e[0m"
  exit 1
  fi

status_check $?

print_head "Setup Erlang repo"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>{log_file}

status_check $?

print_head "Install Erlang"
yum install erlang -y &>>{log_file}
status_check $?


print_head "setup Rabbitmq repo "
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>{log_file}
print_head "Install Erlang & RabbitMq"
yum install rabbitmq-server -y &>>{log_file}
status_check $?


print_head " enabling RabbitMqservice "
systemctl enable rabbitmq-server &>>{log_file}

status_check $?

print_head " starting RabbitMqservice"
systemctl start rabbitmq-server &>>{log_file}

status_check $?

print_head "Add application user "
rabbitmqctl add_user roboshop ${roboshop_app_password} &>>{log_file}

status_check $?

print_head " configure permission for app user "
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>{log_file}
status_check $?
