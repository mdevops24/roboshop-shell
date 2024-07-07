source common.sh
component=mysql

PRINT Install mysql server
dnf install mysql-server -y
STAT $?

PRINT Enable mysqld and start
systemctl enable mysqld
systemctl restart mysqld
STAT $?

PRINT Setup MySQL root pwd
mysql_secure_installation --set-root-pass RoboShop@1
STAT $?
