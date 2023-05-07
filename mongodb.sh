source common.sh
print_head "setup mongodb repository "
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo
print_head "installimg mongodb"
yum install mongodb-org -y

print_head "Update MongoDB Listen address"

sed -i -e 's/127.0.0.1/0.0.0/' /etc/mongodb.conf
print_head "enabling mongodb"
systemctl enable mongod
print_head "start mongodb service"
systemctl restart mongod

# update /etc/mongodb.conf file from 127.0.0.1 with 0.0.0.0
