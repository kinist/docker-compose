1. 如果在同一主机上部署5.6和5.7版本，务必使用目录docker-mysql-5.6和docker-mysql-5.7区分，不能同时使用docker-mysql启动
2. persistence目录下面三个文件夹需要预先建好
 2.1 如果使用root启动，docker-compose.yml中user行注释掉，且在persistence目录下运行 chown -R 999:999 logs 和 chown -R 999:999 data
 2.2 如果使用普通用户启动，docker-compose.yml中user需要指定为当前用户uid和gid，persistence目录下全部文件全部是该用户所有
3. 在文件/etc/security/limits.conf增加以下内容，然后重新登录
`*               soft    nofile            8192
*               hard    nofile            20480`
