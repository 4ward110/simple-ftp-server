#!/bin/bash
DATE=$(date)
rclone copy /var/ftp/user12 ggdrive:
rclone ls ggdrive:/
echo "$DATE Da backup du lieu file user12 len google cloud" >> /var/log/backup_data.log

