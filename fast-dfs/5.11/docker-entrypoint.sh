#!/bin/bash
#set -e
if [ "$1" = "monitor" ] ; then
  if [ -n "$TRACKER_SERVER" ] ; then
    sed -i "s|tracker_server=.*$|tracker_server=${TRACKER_SERVER}|g" /etc/fdfs/client.conf
  fi
  fdfs_monitor /etc/fdfs/client.conf
  exit 0
elif [ "$1" = "storage" ] ; then
  FASTDFS_MODE="storage"
  # 安装fastdfs-nginx-module  TODO
else
  # 安装nginx模块 TODO
  FASTDFS_MODE="tracker"
fi

# 覆写tracker或者storage的端口
if [ -n "$PORT" ] ; then
sed -i "s|^port=.*$|port=${PORT}|g" /etc/fdfs/"$FASTDFS_MODE".conf
fi

# 覆写storage的tracker地址,如果多个，分割逗号，写多个 TODO
if [ -n "$TRACKER_SERVER" ] ; then

sed -i "s|tracker_server=.*$|tracker_server=${TRACKER_SERVER}|g" /etc/fdfs/storage.conf
sed -i "s|tracker_server=.*$|tracker_server=${TRACKER_SERVER}|g" /etc/fdfs/client.conf

fi

# 覆写storage的group_name
if [ -n "$GROUP_NAME" ] ; then

sed -i "s|group_name=.*$|group_name=${GROUP_NAME}|g" /etc/fdfs/storage.conf

fi

# 覆写storage的http_domain TODO


# 日志和数据存储位置
FASTDFS_LOG_FILE="${FDFSDATA}/logs/${FASTDFS_MODE}d.log"
PID_NUMBER="${FDFSDATA}/data/fdfs_${FASTDFS_MODE}d.pid"

echo "try to start the $FASTDFS_MODE node..."
if [ -f "$FASTDFS_LOG_FILE" ]; then
	rm "$FASTDFS_LOG_FILE"
fi
# start the fastdfs node.
fdfs_${FASTDFS_MODE}d /etc/fdfs/${FASTDFS_MODE}.conf start

# wait for pid file(important!),the max start time is 5 seconds,if the pid number does not appear in 5 seconds,start failed.
TIMES=5
while [ ! -f "$PID_NUMBER" -a ${TIMES} -gt 0 ]
do
    sleep 1s
	TIMES=`expr ${TIMES} - 1`
done

tail -f "$FASTDFS_LOG_FILE"