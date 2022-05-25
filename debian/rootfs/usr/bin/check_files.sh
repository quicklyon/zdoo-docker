#!/bin/bash

# shellcheck disable=SC1091

. /etc/s6/s6-init/envs

while ((1))
do
    CFG_INITED=$(wc -l /apps/zdoo/config/my.php | awk '{print $1}')
    if [ "$CFG_INITED" != "0" ];then
        table_prefix=$(grep prefix /data/zdoo/config/my.php  | cut -d '=' -f 2 | sed -E "s/( |'|;)//g")
        DB_INITED=$(mysql -h"$MYSQL_HOST" \
                    -u"$MYSQL_USER" \
                    -p"$MYSQL_PASSWORD" \
                    -D"$MYSQL_DB" \
                    -e "select * from \`${table_prefix}_sys_config\` where \`key\`='version';" 2>/dev/null | wc -l)
    fi

    if [ "$DB_INITED" != "0" ] && [ "$CFG_INITED" != "0" ];then
        rm -f /apps/zdoo/www/sys/{install.php,upgrade.php} && break 
    fi
    sleep 3
done