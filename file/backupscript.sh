#!/bin/sh
# author  <ranmufei@qq.com>
# date 2016 8 26
# 数据库备份

path='/home/www/maindata/'
host='http://172.17.0.1:8080/'
data=$(date "+%Y_%m_%d_%H_%M")

#curl http rancher method
# $1 api     v1/projects/1a5/services/1s37/?action=deactivate 停止数据库
# 			/v1/projects/1a5/services/1s37/?action=activate 启动
# 			"${CATTLE_ACCESS_KEY}:${CATTLE_SECRET_KEY}"
http_rancher() {
	curl -u "CA536FF6119B49B21403:z5KLJ5RVH9gqzL5rrZw45G5LdKP9r5GeFpNAV6ZT" \
	-X POST \
	-H 'Accept: application/json' \
	-H 'Content-Type: application/json' \
	-d '{}' \
	'http://172.17.0.1:8080/'$1	
}
# backup database
backdatabase() {
	http_rancher 'v1/projects/1a5/services/1s37/?action=deactivate'

	sleep 5
	cd /home/database/ 
	tar -zcvf db-${data}.tar.gz 'www-apps-com' 
	mv db-${data}.tar.gz ${path}backup/database/
	if [ $? = 0 ];then
		http_rancher 'v1/projects/1a5/services/1s37/?action=activate'
	fi
}

# reback database
# $1 还原数据
# rebackdatase [$1 还原日期]
rebackdatabase() {
	http_rancher 'v1/projects/1a5/services/1s37/?action=deactivate'
	sleep 5
	cd /home/database
	tar -zxvf "${path}backup/database/$1" -C /home/database/
	if [ $? = 0 ];then
		http_rancher 'v1/projects/1a5/services/1s37/?action=activate'
	fi
}

# 备份 1  还原 2 
# sh script.sh [$1操作] [$2选择的还原版本]
if [ $1 -eq 1 ];then
	backdatabase
elif [ $1 -eq 2 ];then
	rebackdatabase $2
else
	echo "请输入你的操作参数";
fi