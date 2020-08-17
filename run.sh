#!/bin/bash
# Author : James Law
# Date : 2020-02-26
# Description : backup DB and remove old backup

# DB access
DB_HOST=""
DB_USER=""
DB_PASS=""
DB_NAME=""

# Settings
MINUSMONTH=2
SCRIPT_FILENAME=`basename "$0"`
DATE=`date +%Y%m%d`
DATE_TO_REMOVE="$(date "+%Y%m%d" -d "${MINUSMONTH} months ago")"
LOG_PATH="/opt/logs/"
FILE_PATH="/opt/backup/database/${DB_NAME}/${DATE}/"
BACKUP_PATH="/opt/backup/database/${DB_NAME}"

echo "$(date "+%Y-%m-%d %H:%M:%S")|Backup start" >> ${LOG_PATH}${SCRIPT_FILENAME}.log

mkdir -p ${FILE_PATH}
cd ${FILE_PATH}

for tbl_name in `echo "show tables" | mysql -u ${DB_USER} -h ${DB_HOST} -p"${DB_PASS}" ${DB_NAME} | grep -v Tables_in_`
do
    #echo "$(date "+%Y-%m-%d %H:%M:%S")|${tbl_name}"
    mysqldump -u ${DB_USER} -h ${DB_HOST} -p"${DB_PASS}" ${DB_NAME} ${tbl_name} | gzip > ${tbl_name}.sql.gz
done

cd ${BACKUP_PATH}
rm -rf ${DATE_TO_REMOVE}*
echo "$(date "+%Y-%m-%d %H:%M:%S")|Backup done" >> ${LOG_PATH}${SCRIPT_FILENAME}.log

exit;
