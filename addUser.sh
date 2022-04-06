#!/bin/bash
argNums=$#
if [ $argNums -eq 0 ]
then
    echo "没有找到用户名"
    echo "使用示例:sh ./adduser.sh newUserName"
else
    # 创建用户
    echo "create new user $1"
    echo "请确认：1.用户名正确吗 2.目标公钥在ssh_keys中 3.用户名和公钥同名 [Y/n] "
    newUserName=$1
    read flag
    if [ $flag = Y -o $flag = y -o $flag = yes -o $flag = YES ]
    then
        sudo adduser $newUserName
        echo "User creates entirely."
        # 在新的用户下创建.ssh文件
        sudo mkdir /home/${newUserName}/.ssh
        # 从adept用户下复制公钥至相应用户authorized_keys文件中
        # cat <your_key> >> ~/.ssh/authorized_keys
        sudo cp /home/${USER}/ssh_keys/$newUserName.pub /home/$newUserName/.ssh/authorized_keys
        echo "公钥移动完成"
        # 给用户访问权限 但是不给 authorized_keys的访问权限
        sudo chown $newUserName /home/$newUserName/.ssh/authorized_keys
        sudo chgrp $newUserName /home/$newUserName/.ssh/authorized_keys
        # authorized_keys 仅root可写可读 
        sudo chmod 644 /home/$newUserName/.ssh/authorized_keys
        echo "公钥权限更改完成"
    
    # 写入cuda路径
    echo "Do you want to give ${newUserName} sudo privilege? default is no [y/n]"
    read isCuda
    if [ $isCuda = Y -o $isCuda = y -o $isCuda = yes -o $isCuda = YES ]
    then
        echo 'export LDD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"' |sudo tee -a /home/$newUserName/.bashrc
        echo 'export PATH="/usr/local/cuda/bin:$PATH"' |sudo tee -a /home/$newUserName/.bashrc
        echo 'export CUDA_HOME=/usr/local/cuda' |sudo tee -a /home/$newUserName/.bashrc
    
    fi

    echo "Do you want to give ${newUserName} sudo privilege? default is no [y/n]"
    read isSudo
    if [ $isSudo = Y -o $isSudo = y -o $isSudo = yes -o $isSudo = YES ]
    then
        sudo adduser $newUserName sudo
        echo "${newUserName} have sudo privileges."
    fi

    else
        echo "${newUserName} doesn't have sudo privileges.
    fi

fi
