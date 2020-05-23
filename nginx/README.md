# Nginx docker-compose 用法

## docker-bind-default

采用 bind 方式 mount /etc/nginx/conf.d，适合做方向代理的案例

## docker-bind-integration

采用 bind 方式 mount /etc/nginx/conf/nginx.conf，适合需要全面修改nginx config文件的案例

## docker-volume

采用 volume 方式，可以将nginx的html和conf目录都mount到docker默认的volume下面