#!/bin/sh
# author  <ranmufei@qq.com>
# date 2016 8 26
# 验证文件的完整性 根据文件指纹

path='/home/www/maindata/'

# 比较验证文件md5  参数为md5文件
# $1 被校验的md5
chackmd5() {
        cd ${path}
        md5file=${path}$1
        md5sum -c ${md5file}
        if [ $? -eq 0 ];then
                # 验证通过
                return 0
        else
                #验证不过
                return 1
        fi

}


# 文件回滚函数
# $1 回滚文件路劲  
# $2 回滚的路径 
rebackfile() {
        filePath=$1
        backPath=$2
        if [[ -f $1 && -d $2 ]];then
                cd ${path}
                tar -zxvf ${filePath}
                return $?
        else
                return 1
        fi
}



if [ ! -f "${path}initOauth.tar.gz" ];then
		# 不存在 查看initinfo 是否存在
		if [ -f "${path}initOauth/initinfo.txt" ];then
			cd ${path}
			find ./initOauth -type f | xargs -I{} md5sum {} > initOauth.md5
			tar -zcvf initOauth.tar.gz initOauth
		else
			echo "initinfo.txt  不存在 系统可能还未激活"
		fi
	else
		# 存在 检查md5 是否存在
		if [ -f "${path}initOauth.md5" ];then
			chackmd5 "initOauth.md5"
			if test $? = 0 ;then
				# 验证通过 ok
				echo 'system success! '
				#return 0
			else
				# 验证不过 回滚
				rebackfile "${path}initOauth.tar.gz" "${path}"
				if [ $? = 0 ];then
					echo "rebackfile success";
				else
					echo "rebackfile error" 


				fi
			fi
		else
			echo "initOauth.md5 还未生成"
		fi

fi


