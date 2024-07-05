LOG_FILE=/tmp/roboshop.log

NODEJS(){
  echo Disable NodeJS default version
  dnf module disable nodejs -y &>>$LOG_FILE

  echo Enable NodeJS 20 module
  dnf module enable nodejs:20 -y &>>$LOG_FILE

  echo Install NodeJS
  dnf install nodejs -y &>>$LOG_FILE

  echo Cpoy Service file
  cp ${component}.service /etc/systemd/system/${component}.service  &>>$LOG_FILE

  echo Copy MongoDB repo file
  cp mongo.repo /etc/yum.repos.d/mongo.repo  &>>$LOG_FILE

  echo Add Application User
  useradd roboshop
  rm -rf /app  &>>$LOG_FILE

  echo Make /app directory
  mkdir /app  &>>$LOG_FILE

  echo Create App content
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip  &>>$LOG_FILE

  cd /app
  echo Extract App content
  unzip /tmp/${component}.zip  &>>$LOG_FILE
  cd /app

  echo Install NodeJS npm dependencies
  npm install  &>>$LOG_FILE

  echo Start Service
  systemctl daemon-reload  &>>$LOG_FILE
  systemctl enable ${component}  &>>$LOG_FILE
  systemctl start ${component}   &>>$LOG_FILE


}

