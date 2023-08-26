# inHadoop-Hive-Spark cluster + Jupyter on Docker

## Software

* [Hadoop 3.3.4](https://hadoop.apache.org/)
* [Hive 3.1.3](http://hive.apache.org/)
* [Spark 3.4.1](https://spark.apache.org/)

## Quick Start

To deploy the cluster, run:

```
make
docker-compose up
```

docker exec -u root -it <container_id_or_name> /bin/bash

or in terminal write  sudo su

## Access interfaces with the following URL

### Hadoop

ResourceManager: http://localhost:8088

NameNode: http://localhost:9870

HistoryServer: http://localhost:19888

Datanode1: http://localhost:9864
Datanode2: http://localhost:9865

NodeManager1: http://localhost:8042
NodeManager2: http://localhost:8043

### Spark

master: http://localhost:8080

worker1: http://localhost:8081
worker2: http://localhost:8082

history: http://localhost:18080

### Hive

URI: jdbc:hive2://localhost:10000

### HUE

http://localhost:8989

### Jupyter Notebook

URL: http://localhost:8888

example: [jupyter/notebook/pyspark.ipynb](jupyter/notebook/pyspark.ipynb)

```
docker container run -it hadoop-hive-spark-dev  bash
```

```docker
jupyter:
    image: hadoop-hive-spark-jupyter
    hostname: jupyter
    environment:
      SPARK_MASTER_HOST: 172.28.1.2
      SPARK_LOCAL_IP: 172.28.1.6
      SPARK_LOCAL_HOSTNAME: jupyter
    depends_on:
      - master
      - worker1
      - worker2
    ports:
      - "8888:8888"
    volumes:
      - ./jupyter/notebook:/home/jupyter
      - ../../Data:/landing
    restart: always
    networks:
      sparknet:
        ipv4_address: 172.28.1.6
    extra_hosts:
      - "metastore:172.28.1.1"
      - "master:172.28.1.2"
      - "worker1:172.28.1.3"
      - "worker2:172.28.1.4"
      - "history:172.28.1.5"
```

	docker build -t hadoop-hive-spark-jupyter ./jupyter 


## references:

https://marcel-jan.eu/datablog/2020/10/25/i-built-a-working-hadoop-spark-hive-cluster-on-docker-here-is-how/

hive and delta tables integration

[connectors/hive at master · delta-io/connectors · GitHub](https://github.com/delta-io/connectors/tree/master/hive)




