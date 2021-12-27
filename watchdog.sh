#!/bin/bash

SERVICES="ssh vsftpd mysql"                         #Danh sách các dịch vụ được giám sát
DATE=$(date '+%d-%m-%Y %H:%M:%S')
TOKEN="2063525390:AAGiLWX7CVJdN0DE-f8N_ch7XjqqGKwTleE"          #Token bot Telegram
ID="1376524405"                                      #Chat ID bot Telegram
URL="https://api.telegram.org/bot$TOKEN/sendMessage"

for SERVICE in ${SERVICES}
 do
   /etc/init.d/$SERVICE status 2>&1>/dev/null          #Kiểm tra trạng thái dịch vụ
    if [ $? -ne 0 ];
      then
        /etc/init.d/$SERVICE restart
        echo -e "Khởi động dịch vụ $SERVICE"

        #Gửi mail. Thêm địa chỉ IP
        (echo -e "Subject:Khởi động lại dịch vụ  $SERVICE\nDịch vụ $SERVICE không hoạt động trên host $HOSTNAME! Khởi động lại.";) | /usr/sbin/ssmtp -v  vuduclong10a1cma@gmail.com

        #Thông báo Telegram
        /usr/bin/curl -s -X POST $URL -d chat_id=$ID -d text="$DATE Dịch vụ $SERVICE không hoạt động trên host $HOSTNAME! Khởi động lại."
      else
        echo -e "$SERVICE OK"
    fi
done
