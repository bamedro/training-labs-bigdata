# Deploy a Python job with Hadoop Streaming
**Objective:**
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