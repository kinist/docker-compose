#!/bin/sh

CUR_DIR=$(pwd)
#JVM_OPTIONS="-Xms2G -Xmx4G"
APP_NAME=agent.jar
SECRET_KEY=50a5d0445eee59aaf9f99908da1e66d92a11cba4d8e340513fed8e170b8e9467
WORK_DIR=/opt/jenkins/slave/nodes
JNLP_URL=http://127.0.0.1:8080/computer/slave_agent/slave-agent.jnlp

start()
{
    PID=$(ps -ef | grep -w "$APP_NAME" | grep -v "grep" | awk '{print $2}')
    if [ -z $PID ]; then
        if [ -f $CUR_DIR/$APP_NAME ]; then
            nohup java -jar $JVM_OPTIONS $CUR_DIR/$APP_NAME -jnlpUrl $JNLP_URL -secret $SECRET_KEY -workDir $WORK_DIR &
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

