#!/bin/bash
for user in `cat usersdel.txt`
do
userdel -r $user
echo "删除成功! ! !"
done
