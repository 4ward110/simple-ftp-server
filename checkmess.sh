#!/bin/bash
DATE=$(date "+%d %b %Y %H:%M")
TOKEN="2063525390:AAGiLWX7CVJdN0DE-f8N_ch7XjqqGKwTleE"
ID="1376524405"
URL="https://api.telegram.org/bot$TOKEN/sendMessage"
IP=$(hostname -I)

if md5sum -c /opt/vsftpd.md5 ; then
    echo "$DATE : OK" >> /var/log/checkuser.log
else
    MESS=$(echo -e "$DATE \nIP $IP \nFile cau hinh he thong /etc/vsftpd.conf da bi thay doi boi nguoi dung: $HOSTNAME!")
    curl -s -X POST $URL -d chat_id=$ID -d text="$MESS"
    md5sum /etc/vsftpd.conf > /opt/vsftpd.md5
    echo "$DATE : error : File /etc/vsftpd.conf changed" >> /var/log/checkuser.log
fi
