if [ $argNums -eq 0 ]
then
    echo "没有找到用户名"
    echo "使用示例:sh ./adduser.sh newUserName"
else
    echo "make sure you want delete user $1"
    sudo deluser $1 --remove-home
    echo "already delete"
fi