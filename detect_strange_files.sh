#!/bin/bash

#~~~ SCRIPT DETECT STRANGE FILES WITH MAIL~~~#

DATE=$(date)
IP=$(hostname -I)
HOSTNAME=$(hostname -f)
MAIL='vuduclong10a1cma@gmail.com'

TOKEN="2063525390:AAGiLWX7CVJdN0DE-f8N_ch7XjqqGKwTleE"
ID="1376524405"
URL="https://api.telegram.org/bot$TOKEN/sendMessage"


DIR='/etc'
FILE_LIST='/opt/listVsftpd'
TEMP_FILE='/opt/listVsftpd.temp'
FILE_CHANGE=''

#-----------------------------------#

# Hàm kiểm tra thay đổi danh sách file
f_check_change(){
    ls $DIR > $TEMP_FILE

    if diff $FILE_LIST $TEMP_FILE ; then
        return 1
    else
        return 0
    fi
}

# Lấy danh sách file thay đổi
f_get_file_change(){
    cat $FILE_LIST >> $TEMP_FILE
    FILE_CHANGE=$(sort $TEMP_FILE | uniq -u)
}

# Gửi cảnh báo
f_send_alert(){
    # Nội dung cảnh báo
    MESS=$(echo -e "Subject: Detect_Strange_File\n\nThời gian: $DATE\nHostname: $HOSTNAME  IP:  $IP\nDanh sách các file bị mất hoặc mới được thêm vào:\n-------\n$FILE_CHANGE")

    echo "$MESS" | /usr/sbin/sendmail $MAIL
    curl -s -X POST $URL -d chat_id=$ID -d text="$MESS"
}

# Xóa bỏ file temp
f_remove_temp(){
    rm -f $TEMP_FILE
}

#-----------------MAIN-----------------#
main(){
    if f_check_change; then
        echo "$DATE error : Have strange file !!!!" >> /var/log/listVsftpd.log
        f_get_file_change
        f_send_alert
        ls $DIR > $FILE_LIST
    else
        echo "$DATE OK" >> /var/log/listVsftpd.log
    fi

    f_remove_temp
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

main
exit
