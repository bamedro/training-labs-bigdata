# Work with files and directories on HDFS
Here are a set of commands which you can try out to work with files and directories on HDFS.

## File and directory operations
List all the directories and files in the current directory:

```
hadoop fs -ls /
```

### Create a new directory:
```
hadoop fs -mkdir /ex_hdfs
```

### Delete a directory:
```
hadoop fs -rmdir /ex_hdfs
```

### Copy a file from local to HDFS:
```
hadoop fs -copyFromLocal ./README.md /
```
```
hadoop fs -ls /
```

### Delete a file:
```hadoop fs -rm /my_file.txt```


### Copy a file from HDFS to local:
```hadoop fs -copyToLocal /hdfs_file.txt /local_file.txt```

### List all the files and directories in a specific directory:
```hadoop fs -ls /my_directory```

### List all the files and directories in a specific directory, recursively:
```hadoop fs -ls -r /my_directory```

## File status and permissions
### Check if a file or directory exists:
```hadoop fs -test -e /my_file.txt```

### Get the permissions of a file or directory:
```hadoop fs -stat /my_file.txt```

### Change the permissions of a file or directory:
```hadoop fs -chmod 755 /my_file.txt```

### Change the owner of a file or directory:
```hadoop fs -chown user:group /my_file.txt```

### Get the free space available on HDFS:
```hadoop fs -df /```
```hadoop fs -df -h/```

### Get the total capacity of HDFS:
```hadoop fs -du /```
```hadoop fs -du -h /```

### Get the version of the HDFS client:
```hadoop fs -version```

### Delete all the files and directories in a specific directory, recurisvely:
```hadoop fs -rm -r /my_directory```

## HDFS Administration
```hadoop dfsadmin -report```

This command returns a detailed report on the status of HDFS. This report includes information about the Namenode, Datanodes, and the HDFS filesystem itself.

# Deploy a simple Python job with Hadoop Streaming
**Objective**:
Count the number of times each word appears in a text file using a simple Python script and Hadoop Streaming.

Hadoop Streaming is a utility that comes with the Hadoop distribution. The utility allows you to create and run Map/Reduce jobs with any executable or script as the mapper and/or the reducer.

Thus, review the two files in this directory: mapper.py and reducer.py. These are the two files that we will use to deploy a simple Python job with Hadoop Streaming.

## First, let's run the Python scripts locally to make sure they work
Here, Hadoop is not involved.

We will use the LICENSE file from the parent directory as the input file for the job.

Run this series of commands to understand how the mapper and reducer work together:
```
head ../LICENSE
head ../LICENSE | python mapper.py
head ../LICENSE | python mapper.py | sort -k1,1
head ../LICENSE | python mapper.py | sort -k1,1 | python reducer.py
```
There is a sort operation after the mapper because it is the default operation in MapReduce architecture.

## Now let's submit the job to Hadoop Streaming !
First, we have to prepare the input directory on HDFS so the job can read the LICENSE file:
```
hadoop fs -mkdir -p /wordcount/input
hadoop fs -copyFromLocal ../LICENSE /wordcount/input
```

Then, we can submit the job to Hadoop Streaming using hadoop-streaming jar file:
```
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \
    -input /wordcount/input/LICENSE \
    -output /wordcount/output \
    -mapper "python $PWD/mapper.py" \
    -reducer "python $PWD/reducer.py"
```

Finally, we can check the output of the job:
```
hadoop fs -ls /wordcount/output/
hadoop fs -cat /wordcount/output/part-00000
```

## Conclusion
In this exercise, we have deployed a simple Python job with Hadoop Streaming.
Even if Hadoop is written in Java, it is possible to use other languages to write MapReduce jobs, thanks to Hadoop Streaming.
We have also learned how to prepare the input directory on HDFS and how to check the output of the job.