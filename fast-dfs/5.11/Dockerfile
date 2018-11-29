FROM gcc:7

MAINTAINER yangzifeng "zifeng.1024@gmail.com"

ENV FDFSDATA /var/fdfs

WORKDIR /opt/fdfs/libfastcommon

RUN wget "https://github.com/happyfish100/libfastcommon/archive/V1.0.36.tar.gz" \
    && tar -xvf V1.0.36.tar.gz \
    && ./libfastcommon-1.0.36/make.sh \
    && ./libfastcommon-1.0.36/make.sh install

WORKDIR /opt/fdfs/fastdfs

RUN wget "https://github.com/happyfish100/fastdfs/archive/V5.11.tar.gz" \
    && tar -xvf V5.11.tar.gz \
    && ./fastdfs-5.11/make.sh \
    && ./fastdfs-5.11/make.sh install

RUN mkdir -p /etc/fdfs

COPY *.conf /etc/fdfs

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat

VOLUME $FDFSDATA

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 22122 23000 8080 8888
CMD ["tracker"]
