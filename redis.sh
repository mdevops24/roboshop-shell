dnf module disable redis -y
dnf module enable redis:7 -y
dnf install redis -y

sed -i '/^bind/ s/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf #to replace to 0.0.0.0
sed -i '/protected-mode/ c protected-mode no' /etc/redis/redis.conf

systemctl enable redis
systemctl start redis