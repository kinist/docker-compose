#!/bin/bash
#set -e
if [ "$1" = "storage" ] ; then
  FASTDFS_MODE="storage"
  if [ -n "${PORT}" ] ; then
    sed -i "s|^port = .*$|port = ${PORT}|g" /etc/fdfs/storage.conf
    sed -i "s|^storage_server_port=.*$|storage_server_port=${PORT}|g" /etc/fdfs/mod_fastdfs.conf
  fi

  if [ -n "${TRACKER_SERVER}" ] ; then
    sed -i "s|tracker_server = .*$|tracker_server = ${TRACKER_SERVER}|g" /etc/fdfs/storage.conf
    sed -i "s|tracker_server=.*$|tracker_server=${TRACKER_SERVER}|g" /etc/fdfs/mod_fastdfs.conf
  fi

  if [ -n "${GROUP_NAME}" ] ; then  
    sed -i "s|group_name = .*$|group_name = ${GROUP_NAME}|g" /etc/fdfs/storage.conf
    sed -i "s|group_name=.*$|group_name=${GROUP_NAME}|g" /etc/fdfs/mod_fastdfs.conf
  fi

  if [ -f "/etc/fdfs/tracker.conf" ]; then
	  rm -f /etc/fdfs/tracker.conf
  fi
  if [ -f "/etc/fdfs/client.conf" ]; then
	  rm -f /etc/fdfs/client.conf
  fi

else
  FASTDFS_MODE="tracker"
  if [ -n "${PORT}" ] ; then
    sed -i "s|^port = .*$|port = ${PORT}|g" /etc/fdfs/tracker.conf
  fi

  if [ -n "${TRACKER_SERVER}" ] ; then
    sed -i "s|tracker_server = .*$|tracker_server = ${TRACKER_SERVER}|g" /etc/fdfs/client.conf
  fi

  if [ -f "/etc/fdfs/storage.conf" ]; then
	  rm -f /etc/fdfs/storage.conf
  fi
  if [ -f "/etc/fdfs/storage_ids.conf" ]; then
	  rm -f /etc/fdfs/storage_ids.conf
  fi
  if [ -f "/etc/fdfs/mod_fastdfs.conf" ]; then
	  rm -f /etc/fdfs/mod_fastdfs.conf
  fi
  if [ -f "/etc/fdfs/http.conf" ]; then
	  rm -f /etc/fdfs/http.conf
  fi
  if [ -f "/etc/fdfs/mime.types" ]; then
	  rm -f /etc/fdfs/mime.types
  fi
  if [ -f "/etc/fdfs/anti-steal.jpg" ]; then
	  rm -f /etc/fdfs/anti-steal.jpg
  fi

fi

FASTDFS_LOG_FILE="${FASTDFS_BASE_PATH}/logs/${FASTDFS_MODE}d.log"

# start the fastdfs node.
echo "try to start the ${FASTDFS_MODE} node..."
#if [ -f "$FASTDFS_LOG_FILE" ]; then
#	 rm "$FASTDFS_LOG_FILE"
#fi
fdfs_${FASTDFS_MODE}d /etc/fdfs/${FASTDFS_MODE}.conf start

# start nginx in the storage node.
if [ "$1" = "storage" ] ; then
  echo "try to start the nginx ..."
  /usr/local/nginx/sbin/nginx
fi

tail -f "${FASTDFS_LOG_FILE}"
