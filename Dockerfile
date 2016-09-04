#FROM alpine:3.3
FROM centos:7
MAINTAINER <ranmufei@qq.com>, Linksame Team

ENV TZ=Asia/Shanghai


#RUN echo "http://mirrors.ustc.edu.cn/alpine/v3.3/main/" > /etc/apk/repositories
RUN echo "Asia/shanghai" > /etc/timezone
#RUN yum -y update; yum clean all

RUN yum -y cronie crontabs ntpdate curl  php php-curl  php-json; yum clean all



ADD ./file/start.sh /start.sh
ADD ./file/script.sh /script.sh
ADD ./file/backupscript.sh /backupscript.sh
ADD ./file/root /etc/crontabs/
RUN chmod u+x /script.sh
RUN chmod u+x /start.sh
RUN chmod u+x /backupscript.sh


#EXPOSE 80
VOLUME ["/home"]


CMD ["/bin/sh","/start.sh","crond"]
