#!/bin/bash
DATE=$(date "+%d %b %Y %H:%M")
MAIL="vuduclong10a1cma@gmail.com"

if md5sum -c /opt/vsftpd.md5; then
        echo "$DATE : OK"  >> /var/log/checkuser.log
else
        (echo "Subject:Thay doi noi dung file"; echo "File /etc/vsftpd.conf da bi thay doi boi nguoi dung: $HOSTNAME!";) | /usr/sbin/sendmail $MAIL
        md5sum /etc/vsftpd.conf > /opt/vsftpd.md5
        echo "$DATE : error : File /etc/vsftpd.conf changed" >> /var/log/checkuser.log
fi

