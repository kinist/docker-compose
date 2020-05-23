# MySQL docker-compose 用法

1. 目录default: 以MySQL 5.7举例的默认版本，数据目录直接使用volume模式。内带PHP版本的adminer，已使用links特性，所以在adminer中服务器可直接使用db访问。
2. 目录5.6: MySQL5.6版本的docker-compose文件
3. 目录5.7: MySQL5.7版本的docker-compose文件
4. 在同一主机上同时部署 MySQL 5.6 和 MySQL 5.7 版本，两个app不能使用相同目录部署，如：mysql-5.6 和 mysql-5.7 分开部署。另外可使用不同的networks，如：

```docker-compose
networks:
  - mysql_56

networks:
  mysql_56:
```

```docker-compose
networks:
  - mysql_57

networks:
  mysql_57:
```

5. 非default模式下，persistence目录下面三个文件夹需要预先建好

6. 非default模式下，如果使用root启动，docker-compose.yml中 `user` 那行需要注释掉，且需要将persistence目录下的所有文件宿主改为 `999:999`

```Linux
# chown -R 999:999 conf
# chown -R 999:999 data
# chown -R 999:999 logs
```

7. 非default模式下，如果使用普通用户启动，docker-compose.yml中 `user` 需要指定为当前用户 `uid` 和 `gid` ，且需要将persistence目录下的所有文件改为用户所有

8. 建议在宿主机的 `/etc/security/limits.conf` 增加以下内容，然后重新登录

```Shell
*               soft    nofile            8192
*               hard    nofile            20480
```
