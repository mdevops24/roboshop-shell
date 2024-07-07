LOG_FILE=/tmp/roboshop.log
rm -rf $LOG_FILE

PRINT(){
  echo
  echo
  echo ================$*==================
}

STAT() {
  if [ $1 -eq 0 ]; then   #only one argument in this file so $? referred as $1
       echo -e "\e[32mSUCCESS\e[0m"  #color code
    else
       echo -e "\e[31mFAILED\e[0m"
       exit $1   # $1 it will print actual exit status of the error
    fi
}
NODEJS(){
  PRINT Disable NodeJS default version
  dnf module disable nodejs -y &>>$LOG_FILE
  STAT $?

  PRINT Enable NodeJS 20 module
  dnf module enable nodejs:20 -y &>>$LOG_FILE
  STAT $?

  PRINT Install NodeJS
  dnf install nodejs -y &>>$LOG_FILE
  STAT $?

  PRINT Cpoy Service file
  cp ${component}.service /etc/systemd/system/${component}.service  &>>$LOG_FILE
  STAT $?

  PRINT Copy MongoDB repo file
  cp mongo.repo /etc/yum.repos.d/mongo.repo  &>>$LOG_FILE
  STAT $?

  PRINT Add Application User
  useradd roboshop &>>$LOG_FILE
  rm -rf /app
  STAT $?

  PRINT Make /app directory
  mkdir /app  #&>>$LOG_FILE
  STAT $?

  PRINT Create App content
  #curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip  #&>>$LOG_FILE
  #STAT $?
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip  &>>$LOG_FILE
    STAT $?

  cd /app
  PRINT Extract App content
  unzip /tmp/${component}.zip  &>>$LOG_FILE
  STAT $?

  cd /app

  PRINT Install NodeJS npm dependencies
  npm install  &>>$LOG_FILE
  STAT $?

  PRINT Start Service
  systemctl daemon-reload  &>>$LOG_FILE
  systemctl enable ${component}  &>>$LOG_FILE
  systemctl start ${component}   &>>$LOG_FILE
  STAT $?


}

