FROM hadoop-hive-spark-base AS base
FROM continuumio/miniconda3:latest

RUN apt-get -qq update  \
     && DEBIAN_FRONTEND=noninteractive apt-get -qq install --no-install-recommends \
     sudo \
     openjdk-11-jdk \
     curl \
     coreutils \
     libc6-dev \
     && rm -rf /var/lib/apt/lists/*

ARG USERNAME=jupyter
ARG GROUPNAME=jupyter
ARG UID=1001
ARG GID=1001

RUN echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
     && chmod 0440 /etc/sudoers.d/$USERNAME \
     && groupadd -g $GID $GROUPNAME \
     && useradd -m -s /bin/bash -u $UID -g $GID $USERNAME \
     && usermod -aG root $USERNAME

USER $USERNAME


ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/

# Hadoop
COPY --from=base --chown=$USERNAME:$GROUPNAME /opt/hadoop /opt/hadoop
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH=$HADOOP_HOME/sbin:$HADOOP_HOME/bin:$PATH
ENV LD_LIBRARY_PATH=$HADOOP_HOME/lib/native:$LD_LIBRARY_PATH

# Spark
COPY --from=base --chown=$USERNAME:$GROUPNAME /opt/spark /opt/spark
ENV SPARK_HOME=/opt/spark
ENV PYTHONHASHSEED=1
ENV PYSPARK_PYTHON=python3
ENV SPARK_CONF_DIR=$SPARK_HOME/conf
ENV PATH=$SPARK_HOME/sbin:$SPARK_HOME/bin:$PATH

# Hive
COPY --from=base --chown=$USERNAME:$GROUPNAME /opt/hive /opt/hive
ENV HIVE_HOME=/opt/hive
ENV HIVE_CONF_DIR=$HIVE_HOME/conf
ENV PATH=$HIVE_HOME/sbin:$HIVE_HOME/bin:$PATH

WORKDIR /home/$USERNAME
COPY ./pyspark_code_env.yml ./
# The code to run when container is started:
COPY ./entrypoint.sh ./entrypoint.sh
RUN sudo chmod +x ./entrypoint.sh

# See this tutorial for details https://pythonspeed.com/articles/activate-conda-dockerfile/
# RUN conda env create -f pyspark_code_env.yml
ENTRYPOINT ["./entrypoint.sh"]

