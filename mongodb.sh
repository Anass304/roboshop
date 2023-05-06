cp configs/mongodb.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org -y
systemctl enable mongod
systemctl start mongod

# update /etc/mongodb.conf file from 123.0.0.1 with 0.0.0.0
