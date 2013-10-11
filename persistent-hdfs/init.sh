#!/bin/bash

pushd /root

if [ -d "persistent-hdfs" ]; then
  echo "Persistent HDFS seems to be installed. Exiting."
  return 0
fi

case "$HADOOP_MAJOR_VERSION" in
  1)
    wget http://mirror.reverse.net/pub/apache/hadoop/common/hadoop-1.2.1/hadoop-1.2.1.tar.gz
    echo "Unpacking Hadoop"
    tar xvzf hadoop-1.2.1.tar.gz > /tmp/spark-ec2_hadoop.log
    rm hadoop-*.tar.gz
    mv hadoop-1.2.1/ persistent-hdfs/
    ;;
  2)
    wget http://d3kbcqa49mib13.cloudfront.net/hadoop-2.0.0-cdh4.2.0.tar.gz
    echo "Unpacking Hadoop"
    tar xvzf hadoop-*.tar.gz > /tmp/spark-ec2_hadoop.log
    rm hadoop-*.tar.gz
    mv hadoop-2.0.0-cdh4.2.0/ persistent-hdfs/

    # Have single conf dir
    rm -rf /root/persistent-hdfs/etc/hadoop/
    ln -s /root/persistent-hdfs/conf /root/persistent-hdfs/etc/hadoop
    ;;

  *)
     echo "ERROR: Unknown Hadoop version"
     return -1
esac
cp /root/hadoop-native/* /root/persistent-hdfs/lib/native/
/root/spark-ec2/copy-dir /root/persistent-hdfs
popd
