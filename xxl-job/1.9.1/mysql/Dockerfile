FROM mysql:5.7

MAINTAINER yangzifeng "zifeng.1024@gmail.com"

ENV INITDIR /docker-entrypoint-initdb.d

ENV SOURCE0 tables_xxl_job.sql

COPY ./$SOURCE0 $INITDIR/

CMD ["mysqld", "--character-set-server=utf8"]