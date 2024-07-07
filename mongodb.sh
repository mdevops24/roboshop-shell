source common.sh
component=mongo

PRINT Copy MongoDB repo
cp mongo.repo /etc/yum.repos.d/mongo.repo  &>>$LOG_FILE
STAT $?

PRINT Install mongoDB
dnf install mongodb-org -y  &>>$LOG_FILE
STAT $?

PRINT Update MongoDB Conf file
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf  &>>$LOG_FILE
STAT $?

PRINT Enable and Start Mongo DB Servie
systemctl enable mongod  &>>$LOG_FILE
systemctl restart mongod  &>>$LOG_FILE
STAT $?