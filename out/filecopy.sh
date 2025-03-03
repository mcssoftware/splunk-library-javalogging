dbfs rm dbfs:/databricks/*.jar --profile mcs 
dbfs cp lib/okhttp-4.9.3.jar dbfs:/databricks/splunk/okhttp-4.9.3.jar --overwrite --profile mcs 
dbfs cp lib/gson-2.9.0.jar dbfs:/databricks/splunk/gson-2.9.0.jar --overwrite --profile mcs 
dbfs cp lib/okio-3.5.0.jar dbfs:/databricks/splunk/okio-3.5.0.jar --overwrite --profile mcs 
dbfs cp lib/okio-jvm-3.5.0.jar dbfs:/databricks/splunk/okio-jvm-3.5.0.jar --overwrite --profile mcs 
dbfs cp lib/splunk-library-javalogging-1.11.7.jar dbfs:/databricks/splunk/splunk-library-javalogging-1.11.7.jar --overwrite --profile mcs 
dbfs cp scripts/log-monitor.sh dbfs:/databricks/splunk/log-monitor.sh --overwrite --profile mcs 
dbfs ls dbfs:/databricks/splunk --profile mcs 
