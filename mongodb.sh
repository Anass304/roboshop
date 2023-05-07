source common.sh
print_head "setup mongodb repository "
cp configs/mongodb.repo /etc/yum.repos.d/mongo.repo
print_head "installimg mongodb"
yum install mongodb-org -y
print_head "enabling mongodb"
systemctl enable mongod
print_head "start mongodb service"
systemctl start mongod

# update /etc/mongodb.conf file from 123.0.0.1 with 0.0.0.0
