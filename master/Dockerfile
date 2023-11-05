FROM lanteklcorzo001/hue-hadoop-hive-spark-docker-base:latest

ENV NAMEDIR=/opt/hadoop/dfs/name
RUN mkdir -p /opt/hadoop/dfs/name
VOLUME /opt/hadoop/dfs/name

#ENV NAMESECONDDIR=/opt/hadoop/dfs/namesecondary
#RUN mkdir -p /opt/hadoop/dfs/namesecondary
#VOLUME /opt/hadoop/dfs/namesecondary

ENV SPARK_PUBLIC_DNS=localhost
ENV SPARK_LOGS_HDFS_PATH=/var/log/spark
ENV SPARK_JARS_HDFS_PATH=/spark/jars

RUN sudo pip install -U pip &&\
    sudo pip install --no-cache-dir \
    openpyxl \
    findspark \
    pyspark==3.4.1 \
    delta-spark==2.4.* \
    pandas \
    pyarrow

COPY run.sh /usr/local/sbin/run.sh
RUN sudo chmod a+x /usr/local/sbin/run.sh
CMD ["run.sh"]