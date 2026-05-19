#!/bin/bash

step=20 #间隔的秒数，不能大于60
name="5g_start.sh" #程序文件名
path="/root/5GModem/" #程序路径
pid=`ps -A |grep $name| awk '{print $1}'` #程序的pid

for (( i = 0; i < 60; i=(i+step) )); do
#检测是否在运行
if [ ! $pid ]; then
    #启动程序命令
    $path$name
fi
sleep $step
done
exit 0
