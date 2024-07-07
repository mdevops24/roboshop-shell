source common.sh
component=mongo

PRINT Copy MongoDB repo
cp mongo.repo /etc/yum.repos.d/mongo.repo
STAT $?

PRINT Install mongoDB
dnf install mongodb-org -y
STAT $?

PRINT Update MongoDB Conf file
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
STAT $?

PRINT Enable and Start Mongo DB Servie
systemctl enable mongod
systemctl restart mongod
STAT $?