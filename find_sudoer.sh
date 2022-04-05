#!/bin/bash
# findSudoers.sh
for i in `ls /home`
do
variable=`id $i|grep sudo`
# echo $variable
if [ -z $variable ]
then
echo  
else
echo 用户 $i 有 sudo 权限
echo ---------
fi
done