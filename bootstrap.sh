#!/usr/bin/env bash

: ${HADOOP_PREFIX:=/usr/local/hadoop}

rm /tmp/*.pid

cd $HADOOP_PREFIX/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

sed s/HOSTNAME/$HOSTNAME/ /usr/local/hadoop/etc/hadoop/core-site.xml.template > /usr/local/hadoop/etc/hadoop/core-site.xml
sed -i s/HOSTNAME/$HOSTNAME/ $SPARK_HOME/yarn-remote-client/core-site.xml
sed -i s/HOSTNAME/$HOSTNAME/ $SPARK_HOME/yarn-remote-client/yarn-site.xml

echo "spark.yarn.jars hdfs:///spark/*" > $SPARK_HOME/conf/spark-defaults.conf
cp $SPARK_HOME/conf/metrics.properties.template $SPARK_HOME/conf/metrics.properties

/usr/sbin/sshd
$HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
$HADOOP_PREFIX/sbin/start-dfs.sh
$HADOOP_PREFIX/sbin/start-yarn.sh

pyspark --master yarn --deploy-mode client
