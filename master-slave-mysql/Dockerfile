FROM mysql:5.7

MAINTAINER yangzifeng "zifeng.1024@gmail.com"

ENV INITDIR /docker-entrypoint-initdb.d
ENV SOURCE ./init

COPY $SOURCE/* $INITDIR/

CMD ["mysqld"]