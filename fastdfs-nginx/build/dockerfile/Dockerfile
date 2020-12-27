FROM alpine:3.12

LABEL vendor=Gavin\ Zhang \
      maintainer="kinist@gmail.com" \
      version="6.06" \
      buildtime="20201225" \
      description="FastDFS + Nginx"

ARG FASTDFS_BASE_PATH=/opt/fastdfs
ARG NGINX_VERSION=nginx-1.17.1
ARG LIBFASTCOMMON_VERSION=1.0.43
ARG FASTDFS_VERSION=6.06
ARG FASTDFS_NGINX_MODULE_VERSION=1.22

ARG FASTDFS_TEMP_PATH=/tmp/fdfs

ENV FASTDFS_BASE_PATH=${FASTDFS_BASE_PATH} \
    NGINX_VERSION=${NGINX_VERSION} \
    LIBFASTCOMMON_VERSION=${LIBFASTCOMMON_VERSION} \
    FASTDFS_VERSION=${FASTDFS_VERSION} \
    FASTDFS_NGINX_MODULE_VERSION=${FASTDFS_NGINX_MODULE_VERSION}

#get all the dependences
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
RUN apk add --no-cache --virtual .build-deps gcc libc-dev make automake autoconf libtool pcre pcre-dev zlib zlib-dev openssl-dev curl

#compile the libfastcommon
WORKDIR ${FASTDFS_TEMP_PATH}/libfastcommon

#COPY source/libfastcommon-master.tar.gz libfastcommon-master.tar.gz
RUN curl -fSL https://github.com/happyfish100/libfastcommon/archive/V${LIBFASTCOMMON_VERSION}.tar.gz -o libfastcommon-${LIBFASTCOMMON_VERSION}.tar.gz && \
    tar xvf libfastcommon-${LIBFASTCOMMON_VERSION}.tar.gz && \
    cd libfastcommon-${LIBFASTCOMMON_VERSION} && \
    ./make.sh && \
    ./make.sh install

#compile the fastdfs
WORKDIR ${FASTDFS_TEMP_PATH}/fastdfs

#COPY source/fastdfs-master.tar.gz fastdfs-master.tar.gz
RUN curl -fSL https://github.com/happyfish100/fastdfs/archive/V${FASTDFS_VERSION}.tar.gz -o fastdfs-${FASTDFS_VERSION}.tar.gz \
 && tar xvf fastdfs-${FASTDFS_VERSION}.tar.gz \
 && cd fastdfs-${FASTDFS_VERSION} \
 && ./make.sh && ./make.sh install

#compile the nginx
WORKDIR ${FASTDFS_TEMP_PATH}/nginx

#COPY source/fastdfs-nginx-module-master.tar.gz fastdfs-nginx-module-master.tar.gz
#COPY source/nginx-1.16.1.tar.gz nginx-1.16.1.tar.gz
RUN curl -fSL https://github.com/happyfish100/fastdfs-nginx-module/archive/V${FASTDFS_NGINX_MODULE_VERSION}.tar.gz -o fastdfs-nginx-module-${FASTDFS_NGINX_MODULE_VERSION}.tar.gz \
 && curl -fSL https://nginx.org/download/${NGINX_VERSION}.tar.gz -o ${NGINX_VERSION}.tar.gz \
 && tar xvf fastdfs-nginx-module-${FASTDFS_NGINX_MODULE_VERSION}.tar.gz \
 && tar xvf ${NGINX_VERSION}.tar.gz \
 && cd ${NGINX_VERSION} \
 && sed -i 's/^    ngx_module_incs=.*/    ngx_module_incs="\/usr\/include"/g' ${FASTDFS_TEMP_PATH}/nginx/fastdfs-nginx-module-${FASTDFS_NGINX_MODULE_VERSION}/src/config \
# && sed -i 's/^    ngx_module_incs=.*/    ngx_module_incs="\/usr\/include\/fastdfs \/usr\/include\/fastcommon\/"/g' ${FASTDFS_TEMP_PATH}/nginx/fastdfs-nginx-module-master/src/config \
# && sed -i 's/^    CORE_INCS=.*/    CORE_INCS="\/usr\/include\/fastdfs \/usr\/include\/fastcommon\/"/g' ${FASTDFS_TEMP_PATH}/nginx/fastdfs-nginx-module-master/src/config \
 && ./configure --add-module=${FASTDFS_TEMP_PATH}/nginx/fastdfs-nginx-module-${FASTDFS_NGINX_MODULE_VERSION}/src \
 && make && make install

# 清理文件
RUN rm -rf ${FASTDFS_TEMP_PATH} && \
    apk del .build-deps gcc libc-dev make automake autoconf libtool pcre pcre-dev zlib zlib-dev openssl-dev curl && \
    apk add bash pcre-dev zlib-dev tzdata && \
# 清理原有配置文件
    rm -f /etc/fdfs/*

# 原本配置文件全部拷贝到/etc/fdfs，但是使用非root用户启动时没法修改，故只能将其持久化
#COPY conf/* /etc/fdfs/
COPY conf/*.* /etc/fdfs/
#COPY source/favicon.ico /usr/local/nginx/html
COPY start.sh /

#make the start.sh executable 
#RUN ln -sf /dev/stdout /usr/local/nginx/logs/access.log && \
#    ln -sf /dev/stderr /usr/local/nginx/logs/error.log
RUN mv /etc/fdfs/nginx.conf /usr/local/nginx/conf && \
    chmod 755 /start.sh

WORKDIR ${FASTDFS_BASE_PATH}

EXPOSE 22122 23000 8011
VOLUME ["$FASTDFS_BASE_PATH", "/etc/fdfs"]

ENTRYPOINT ["/start.sh"]
CMD ["tracker"]
