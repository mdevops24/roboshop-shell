source common.sh
component=redis

PRINT Disable old redis
dnf module disable redis -y
STAT $?

PRINT Enable redis 7
dnf module enable redis:7 -y
STAT $?

PRINT Install redis
dnf install redis -y
STAT $?

PRINT Edit redis.conf to 0000 and preotected-mode
sed -i -e '/^bind/ s/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf -e '/protected-mode/ c protected-mode no' #to replace to 0.0.0.0
STAT $?

PRINT Enable and start redis
systemctl enable redis
systemctl restart redis
STAT $?