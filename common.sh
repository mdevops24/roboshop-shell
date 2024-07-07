LOG_FILE=/tmp/roboshop.log
rm -rf $LOG_FILE
code_dir=$(pwd)

PRINT(){
  echo
  echo
  echo ================$*==================
}

STAT() {
  if [ $1 -eq 0 ]; then   #only one argument in this file so $? referred as $1
       echo -e "\e[32mSUCCESS\e[0m"  #color code
    else
       echo -e "\e[31mFAILED\e[0m -->Ref. log file for info path : ${LOG_FILE}"
       echo
       #echo "Ref. log file for info path : ${LOG_FILE}"
       exit $1   # $1 it will print actual exit status of the error
    fi
}

APP_PREREQ(){
    PRINT Add Application User
    id roboshop  &>>$LOG_FILE
      if [ $? -ne 0 ]; then
         useradd roboshop &>>$LOG_FILE
      fi
    STAT $?

    PRINT Remove old content
    rm -rf ${app_path}
    STAT $?

    PRINT Make /app directory
    mkdir ${app_path}  &>>$LOG_FILE
    STAT $?

    PRINT Create App content
    curl -o  /tmp/${component}.zip  https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip  &>>$LOG_FILE
    STAT $?

    PRINT Extract App content
    cd ${app_path}
    unzip /tmp/${component}.zip  &>>$LOG_FILE
    STAT $?
}

SYSTEMD_SETUP(){
  PRINT Copy Service file
    cp ${code_dir}/${component}.service /etc/systemd/system/${component}.service  &>>$LOG_FILE
    STAT $?

    PRINT Start Service
    systemctl daemon-reload  &>>$LOG_FILE
    systemctl enable ${component}  &>>$LOG_FILE
    systemctl start ${component}   &>>$LOG_FILE
    STAT $?
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

  PRINT Copy MongoDB repo file
  cp mongo.repo /etc/yum.repos.d/mongo.repo  &>>$LOG_FILE
  STAT $?

  APP_PREREQ

  PRINT Download/Install NodeJS npm dependencies
  npm install  &>>$LOG_FILE
  STAT $?

  SYSTEMD_SETUP

}

JAVA(){
  PRINT Install Java/maven
  dnf install maven -y  &>>$LOG_FILE
  STAT $?

  PRINT Download dependencies
  mvn clean package   &>>$LOG_FILE
  mv target/shipping-1.0.jar shipping.jar  &>>$LOG_FILE
  STAT $?

  dnf install mysql -y

  mysql -h mysql.dev.mdevops24.online -uroot -pRoboShop@1 < /app/db/schema.sql
  mysql -h mysql.dev.mdevops24.online -uroot -pRoboShop@1 < /app/db/master-data.sql
  mysql -h mysql.dev.mdevops24.online -uroot -pRoboShop@1 < /app/db/app-user.sql

  systemctl daemon-reload
  systemctl enable shipping
  systemctl start shipping
}
