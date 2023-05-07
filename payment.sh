source common.sh

if [ -z "${roboshop_app_password}" ]; then
  echo -e "\e[31mMissing RabbitMQ App user  Password argument\e[0m"
  exit 1
  fi
component =payment
python