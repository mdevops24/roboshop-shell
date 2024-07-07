source common.sh
component=payment
app_path=/app


PRINT Install python3
dnf install python3 gcc python3-devel -y &>>$LOG_FILE
STAT $?

APP_PREREQ
#cp payment.service /etc/systemd/system/payment.service
#useradd roboshop
#rm -rf /app
#mkdir /app
#curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment-v3.zip
#cd /app
#unzip /tmp/payment.zip

cd /app
PRINT Install/download the dependencies
pip3 install -r requirements.txt &>>$LOG_FILE
STAT $?

SYSTEMD_SETUP
#systemctl daemon-reload
#systemctl enable payment
#systemctl restart payment
