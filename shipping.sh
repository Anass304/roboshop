source common.sh

myswl_root_password=$1
if [ ${mysql_root_password} == "mysql"]; then
  echo -e "\e[MYSQL  ROOT assword argument\e[m"
component=shipping
schema_type="mysql"
java

