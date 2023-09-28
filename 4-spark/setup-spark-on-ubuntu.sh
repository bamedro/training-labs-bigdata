#!/bin/sh

# This script intends to install Spark on Ubuntu.
# It works well on :
# - Ubuntu 22.04 LTS
# - Google Colab (based on Ubuntu 22.04 LTS)

# Spark requires Java 8 or later, but soon, Java version prior to 17 will be deprecated.
sudo apt-get update -y -q
sudo apt-get install openjdk-17-jdk-headless -y -q

# Download Spark. You can check the latest version of Spark at https://spark.apache.org/downloads.html.
SPARK_VERSION=3.5.0
wget -nc -q https://dlcdn.apache.org/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop3.tgz
tar xf spark-$SPARK_VERSION-bin-hadoop3.tgz

# Install findspark and pyspark to use Spark with Python.
pip install -q findspark
pip install pyspark==$SPARK_VERSION