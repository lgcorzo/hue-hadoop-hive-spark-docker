#!/bin/bash

if [ -z "$(ls -A "$NAMEDIR")" ]; then
  echo "Formatting namenode name directory: $NAMEDIR"
  hdfs namenode -format
fi

echo "Starting Hadoop name node..."
hdfs --daemon start namenode

#echo "Starting Hadoop secondary name node..."
#hdfs --daemon start secondarynamenode

echo "Starting Hadoop resource manager..."
yarn --daemon start resourcemanager

if [ ! -f "$NAMEDIR"/initialized ]; then
  echo "Configuring Hive..."
  hdfs dfs -mkdir -p  /user/hive/warehouse
  schematool -dbType postgres -initSchema
  touch "$NAMEDIR"/initialized
fi

echo "Starting Hive Metastore..."
hive --service metastore &

echo "Starting Hive server2..."
hiveserver2 &

if ! hdfs dfs -test -d /tmp
then
  echo "Formatting directory: /tmp"
  hdfs dfs -mkdir -p  /tmp
fi
if ! hdfs dfs -test -d "$SPARK_LOGS_HDFS_PATH"
then
  echo "Formatting directory: $SPARK_LOGS_HDFS_PATH"
  hdfs dfs -mkdir -p  "$SPARK_LOGS_HDFS_PATH"
fi
if ! hdfs dfs -test -d "$SPARK_JARS_HDFS_PATH"
then
  echo "Formatting directory: $SPARK_JARS_HDFS_PATH"
  hdfs dfs -mkdir -p  "$SPARK_JARS_HDFS_PATH"
  hdfs dfs -put "$SPARK_HOME"/jars/* "$SPARK_JARS_HDFS_PATH"/
fi

echo "Starting thrift server..."
start-thriftserver.sh \
  --conf spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension \
  --conf spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog \
  --packages "org.apache.spark:spark-connect_2.12:$SPARK_VERSION" \
  --packages "io.delta:delta-core_2.12:2.4.0" &

# echo "Starting livy server..."
# livy-server start &

# echo "Starting spark sql server..."

#spark-submit --packages "org.apache.spark:spark-connect_2.12:$SPARK_VERSION" \
#  --packages "io.delta:delta-core_2.12:2.4.0" \
 # --conf "spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension" \
 # --conf "spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog" \
 # --class org.apache.spark.sql.hive.thriftserver.HiveThriftServer2 &

echo "Starting Spark master node..."
spark-class org.apache.spark.deploy.master.Master --ip "$SPARK_MASTER_HOST"

spark-shell --packages 'io.delta:delta-core_2.12:2.4.0' \
  --conf "spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension" \
  --conf "spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog"



