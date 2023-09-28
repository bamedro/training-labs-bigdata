#/bin/sh

SPARK_VERSION=3.5.0

sudo apt update -y -qq > /dev/null
sudo apt install openjdk-17-jdk-headless -y -qq > /dev/null
wget -q https://dlcdn.apache.org/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop3.tgz
tar xf spark-$SPARK_VERSION-bin-hadoop3.tgz

pip install -q findspark
pip install pyspark==$SPARK_VERSION