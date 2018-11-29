#!/usr/bin/env bash

# REPLICATION_HEALTH_GRACE_PERIOD=${REPLICATION_HEALTH_GRACE_PERIOD:-3}
# REPLICATION_HEALTH_TIMEOUT=${REPLICATION_HEALTH_TIMEOUT:-10}

# check_slave_health () {
#   echo Checking replication health:
#   status=$(mysql -uroot -p ${MYSQL_ROOT_PASSWORD} -e "SHOW SLAVE STATUS\G")
#   echo "$status" | egrep 'Slave_(IO|SQL)_Running:|Seconds_Behind_Master:|Last_.*_Error:' | grep -v "Error: $"
#   if ! echo "$status" | grep -qs "Slave_IO_Running: Yes"    ||
#      ! echo "$status" | grep -qs "Slave_SQL_Running: Yes"   ||
#      ! echo "$status" | grep -qs "Seconds_Behind_Master: 0" ; then
# 	echo WARNING: Replication is not healthy.
#     return 1
#   fi
#   return 0
# }

# 此处授权"%"，是为了做主备切换，一般限制为本地ip"192.168.0.%"，在docker overlay网络下如何限制网路
echo Grant replication user for master and slave.
mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "GRANT REPLICATION SLAVE, REPLICATION CLIENT ON \
    *.* TO '$REPLICATION_USER'@'%' IDENTIFIED BY '$REPLICATION_PASSWORD';"

if ${MODE} = 'slave' ; then
    echo Updating master connetion info in slave.

    mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "RESET MASTER; \
        CHANGE MASTER TO \
        MASTER_HOST='$MASTER_HOST', \
        MASTER_PORT=$MASTER_PORT, \
        MASTER_USER='$REPLICATION_USER', \
        MASTER_PASSWORD='$REPLICATION_PASSWORD', \
        MASTER_LOG_FILE='${MASTER_LOG_FILE:-mysql-bin.000001}', \
        MASTER_LOG_POS='${MASTER_LOG_POS:-0}';"
fi

echo Starting slave ...
mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "START SLAVE;"

# echo Initial health check:
# check_slave_health

# echo Waiting for health grace period and slave to be still healthy:
# sleep ${REPLICATION_HEALTH_GRACE_PERIOD}

# counter=0
# while ! check_slave_health; do
#   if (( counter >= $REPLICATION_HEALTH_TIMEOUT )); then
#     echo ERROR: Replication not healthy, health timeout reached, failing.
# 	break
#     exit 1
#   fi
#   let counter=counter+1
#   sleep 1
# done