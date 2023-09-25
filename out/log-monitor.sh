#!/bin/bash

set -e
set -o pipefail

# dapie90194398f68234fc39f28bcdcf3c24e-3
# https://adb-8496832819923775.15.azuredatabricks.net/
# These environment variables would normally be set by Spark scripts
# However, for a Databricks init script, they have not been set yet.
# We will keep the names the same here, but not export them.
# These must be changed if the associated Spark environment variables
# are changed.

DB_HOME=/databricks
SPARK_HOME=$DB_HOME/spark
SPARK_CONF_DIR=$SPARK_HOME/conf

echo "copying splunk library lavalogger"
for jarfile in "okhttp-4.9.3.jar" "gson-2.9.0.jar" "splunk-library-javalogging-1.11.7.jar" "okio-3.5.0.jar" "okio-jvm-3.5.0.jar"
do
    cp -f "/dbfs/databricks/splunk/$jarfile" /databricks/jars
done

LOGGER_NAME="quickbricks"
log4jDirectories=( "executor" "driver" "master-worker" )
for log4jDirectory in "${log4jDirectories[@]}"
do

LOG4J_CONFIG_FILE="$SPARK_HOME/dbconf/log4j/$log4jDirectory/log4j2.xml"
echo "BEGIN: Updating $LOG4J_CONFIG_FILE with Log Analytics appender"

CONTENT="\ \ <SplunkHttp  name=\"$LOGGER_NAME\" url=\"https://prd-p-nexmd.splunkcloud.com:8088\"\n\ \ \ \ token=\"51cac61f-4363-4ce5-9274-0293c4160d94\" host=\"clusterid\" index=\"databricks\" source=\"databricks\"\n\ \ \ \ sourcetype=\"dbx\" messageFormat=\"text\" \n\ \ \ \ disableCertificateValidation=\"true\">\n\ \ \ \ <PatternLayout pattern=\"%m\"/>\n\ \ </SplunkHttp>"
C=$(echo $CONTENT | sed 's/\//\\\//g')
sed -i "/<\/Appenders>/ s/.*/${C}\n&/" $LOG4J_CONFIG_FILE

CONTENT="\ \ \ \ \ \ \  <AppenderRef ref=\"$LOGGER_NAME\"/>"
C=$(echo $CONTENT | sed 's/\//\\\//g')
sed -i "/<\/Root>/ s/.*/${C}\n&/" $LOG4J_CONFIG_FILE

CONTENT="\ \ \ <Logger name=\"$LOGGER_NAME\" level=\"ALL\"> \ \ \ \ \<AppenderRef ref=\"$LOGGER_NAME\"/> \ \ \ </Logger>"
C=$(echo $CONTENT | sed 's/\//\\\//g')
sed -i "/<\/Loggers>/ s/.*/${C}\n&/" $LOG4J_CONFIG_FILE

sed -i 's/packages="\([^"]*\)"/packages="\1,com.splunk.logging"/' $LOG4J_CONFIG_FILE

echo "END: Updating $LOG4J_CONFIG_FILE with Log Analytics appender"

done
