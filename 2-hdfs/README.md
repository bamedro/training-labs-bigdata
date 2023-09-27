# Work with files and directories on HDFS
**Objective:**
In this exercise, we will learn how to work with files and directories on HDFS.

First, let's check everything is OK
```
hadoop fs -version
hadoop dfsadmin -report
```
This command returns a detailed report on the status of HDFS. This report includes information about the Namenode, Datanodes, and the HDFS filesystem itself.

## Simple file and directory operations
Create directories, upload some files and list all them using the following commands:
```
hadoop fs -mkdir /ex_hdfs
hadoop fs -copyFromLocal ./README.md /ex_hdfs
hadoop fs -copyToLocal /ex_hdfs/README.md ./README_download.md
hadoop fs -ls /ex_hdfs
hadoop fs -ls -R /
```

## Check files status and permissions
Check if a file or directory exists:
```
hadoop fs -test -e /my_file.txt
```
Get and set permissions of a file or a directory:
```
hadoop fs -stat /my_file.txt
hadoop fs -chmod 755 /my_file.txt
hadoop fs -chown user:group /my_file.txt
```

### Get the free space available on HDFS:

Get the total capacity of HDFS:
```
hadoop fs -df /
hadoop fs -df -h /
```

Get the size a a directory:
```
hadoop fs -du /ex_hdfs
hadoop fs -du -h /
```

## Cleanup a directory
```
hadoop fs -rm -r /ex_hdfs
```
You can also delete a single file or a directory with ```-rmdir``` option.

