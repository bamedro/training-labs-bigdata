# Setting up a Single Node Hadoop Cluster
**Objective:**
In this exercise, we will learn how to setup a single-node Hadoop cluster on your local machine.

This procedure is mostly based on official documentation:
https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html

## Pre-requisites
Hadoop is written in Java, so it requires at least a Java Runtime version 8 or 11 to be installed on your machine.
If you want to compile your own Hadoop Java applications, you will need a Java Development Kit (JDK) version 8.

You can check your Java version with the following command:
```
java -version
```

More details on https://cwiki.apache.org/confluence/display/HADOOP/Hadoop+Java+Versions


## Download and configure your Hadoop environment
Download binaries for the latest stable release of Hadoop from https://hadoop.apache.org/releases.html

Extract the archive to a directory of your choice and set the HADOOP_HOME environment variable:
```
tar -xzf hadoop-3.3.6.tar.gz
export HADOOP_HOME=$PWD/hadoop-3.3.6
```

Locate your java directory and set the JAVA_HOME environment variable:
```
which java
realpath $(which java)
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
```

Set thoses two environment variables in `$HADOOP_HOME/etc/hadoop/hadoop-env.sh`:
```
nano $HADOOP_HOME/etc/hadoop/hadoop-env.sh
```

Include Hadoop binaries in your PATH:
```
export PATH=$PATH:$HADOOP_HOME/bin
```

Try a simple command to check it looks good:
```
hadoop version
```


## Run a simple MapReduce job using standalone mode
Standalone mode is the default mode of Hadoop. It runs on a single JVM process and it is mainly used for debugging purpose.
```
mkdir input
cp $HADOOP_HOME/etc/hadoop/*.xml input
hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar grep input output 'dfs[a-z.]+'
cat output/*
```
You should see the result of a distributed grep command on the Hadoop configuration files.


## Add HDFS to your Hadoop environment
HDFS is the distributed filesystem of Hadoop. It is one of the main components of Hadoop and it is used to store data in a distributed manner.
Hadoop jobs will read and write data from/to HDFS.

### Edit Hadoop configuration files
Edit `$HADOOP_HOME/etc/hadoop/core-site.xml`:
```
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://localhost:9000</value>
    </property>
</configuration>
```

Edit `$HADOOP_HOME/etc/hadoop/hdfs-site.xml`:
```
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
</configuration>
```

### Setup passphraseless ssh
Now check that you can ssh to the localhost without a passphrase:
```
ssh localhost
```

If you cannot ssh to localhost without a passphrase, execute the following commands:
```
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys
```

### Initialize the HDFS filesystem
```
hdfs namenode -format
```

Start NameNode daemon and DataNode daemon:
```
$HADOOP_HOME/start-dfs.sh
```

Browse the web interface for the NameNode; by default it is available at:

NameNode - http://localhost:9870/


### Setup YARN in a pseudo-distributed mode
YARN is the resource manager of Hadoop. It is used to distribute the workload across the cluster nodes.

Edit `$HADOOP_HOME/etc/hadoop/mapred-site.xml`:
```
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
    <property>
        <name>mapreduce.application.classpath</name>
        <value>$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/*:$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/lib/*</value>
    </property>
</configuration>
```

Edit `$HADOOP_HOME/etc/hadoop/yarn-site.xml`:
```
<configuration>
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
    <property>
        <name>yarn.nodemanager.env-whitelist</name>
        <value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PREPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_HOME,PATH,LANG,TZ,HADOOP_MAPRED_HOME</value>
    </property>
</configuration>
```

Start ResourceManager daemon and NodeManager daemon:
```
$HADOOP_HOME/sbin/start-yarn.sh
```

Browse the web interface for the ResourceManager; by default it is available at:

ResourceManager - http://localhost:8088/


### Run a simple MapReduce job using YARN
Let's execute a simple PI estimation (based on Monte Carlo method) using YARN:
```
hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar pi 5 100
```


## Conclusion
In this exercise, we have setup a single-node Hadoop cluster on your local machine. We have configured HDFS and YARN and we have run a simple MapReduce job using YARN.