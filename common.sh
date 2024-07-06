LOG_FILE=/tmp/roboshop.log
rm -rf $LOG_FILE

PRINT(){
  echo
  echo
  echo ================$*==================
}

NODEJS(){
  PRINT Disable NodeJS default version
  dnf module disable nodejs -y &>>$LOG_FILE
  if [ $? -eq 0 ]; then
     echo SUCCESS
  else
     echo FAILED
  fi

  PRINT Enable NodeJS 20 module
  dnf module enable nodejs:20 -y &>>$LOG_FILE
  if [ $? -eq 0 ]; then
     echo SUCCESS
  else
     echo FAILED
  fi

  PRINT Install NodeJS
  dnf install nodejs -y &>>$LOG_FILE
  if [ $? -eq 0 ]; then
       echo SUCCESS
    else
       echo FAILED
    fi

  PRINT Cpoy Service file
  cp ${component}.service /etc/systemd/system/${component}.service  &>>$LOG_FILE
  if [ $? -eq 0 ]; then
       echo SUCCESS
    else
       echo FAILED
    fi

  PRINT Copy MongoDB repo file
  cp mongo.repo /etc/yum.repos.d/mongo.repo  &>>$LOG_FILE
  if [ $? -eq 0 ]; then
       echo SUCCESS
    else
       echo FAILED
    fi

  PRINT Add Application User
  useradd roboshop
  rm -rf /app  &>>$LOG_FILE
  if [ $? -eq 0 ]; then
       echo SUCCESS
    else
       echo FAILED
    fi

  PRINT Make /app directory
  mkdir /app  &>>$LOG_FILE
  if [ $? -eq 0 ]; then
       echo SUCCESS
    else
       echo FAILED
    fi

  PRINT Create App content
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip  &>>$LOG_FILE
  if [ $? -eq 0 ]; then
       echo SUCCESS
    else
       echo FAILED
    fi

  cd /app
  PRINT Extract App content
  unzip /tmp/${component}.zip  &>>$LOG_FILE
  if [ $? -eq 0 ]; then
       echo SUCCESS
    else
       echo FAILED
    fi

  cd /app

  PRINT Install NodeJS npm dependencies
  npm install  &>>$LOG_FILE
  if [ $? -eq 0 ]; then
       echo SUCCESS
    else
       echo FAILED
    fi

  PRINT Start Service
  systemctl daemon-reload  &>>$LOG_FILE
  systemctl enable ${component}  &>>$LOG_FILE
  systemctl start ${component}   &>>$LOG_FILE
  if [ $? -eq 0 ]; then
       echo SUCCESS
    else
       echo FAILED
    fi


}

