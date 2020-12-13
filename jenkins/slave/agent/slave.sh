#!/bin/sh

# Shell scripts for Jenkins slave start stop status.
# Author: Gavin Zhang

# Slave APP Jar executable file
APP_NAME=agent.jar

# Conection secret
SECRET_KEY=5eabed57fef34abc6856d96c2a3bea841bea10bef62e202ef64e156a76783113

# Remote root directory
WORK_DIR=/opt/jenkins/slave/nodes

# Jenkins master
JNLP_URL=http://192.168.128.128:8080/computer/slave_node/slave-agent.jnlp

# Jenkins use https:0 ; Jenkins use http:1
HTTPS_TYPE=1

# JVM Options
#JVM_OPTIONS="-Xms2G -Xmx4G"

start()
{
    CUR_DIR=$(pwd)
    PID=$(ps -ef | grep -w "$APP_NAME" | grep -v "grep" | awk '{print $2}')
    if [ -z $PID ]; then
        if [ -f $CUR_DIR/$APP_NAME ]; then
            if [ $HTTPS_TYPE -eq 0 ]; then
                nohup java -jar $JVM_OPTIONS $CUR_DIR/$APP_NAME -jnlpUrl $JNLP_URL -noCertificateCheck -secret $SECRET_KEY -workDir $WORK_DIR &
            else
                nohup java -jar $JVM_OPTIONS $CUR_DIR/$APP_NAME -jnlpUrl $JNLP_URL -secret $SECRET_KEY -workDir $WORK_DIR &
            fi
            sleep 1
            echo "Starting Jenkins salve......      [  OK  ]"
        else
            echo "Not found $APP_NAME file in the current directory. [FAILED]"
        fi
    else
        echo "Jenkins slave process already exists, PID="$PID". [FAILED]"
    fi
}

stop()
{
    PID=$(ps -ef | grep -w "$APP_NAME" | grep -v "grep" | awk '{print $2}')
    if [ -z $PID ]; then
        echo "Jenkins slave is stopped.         [FAILED]"
    else
        kill -9 $PID
        sleep 1
        echo "Stopping Jenkins slave......      [  OK  ]"
    fi
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        start
        ;;
    status)
        PID=$(ps -ef | grep -w "$APP_NAME" | grep -v "grep" | awk '{print $2}')
        if [ "$PID" == "" ]; then
            echo "Jenkins slave is stopped."
        else
            echo "Jenkins slave is running, PID="$PID"."
        fi
        ;;
    *)
	echo $"Usage: $0 {start|stop|restart|status}"
        RETVAL=1
esac
exit $RETVAL

