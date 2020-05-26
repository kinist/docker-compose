# 个人常用的第三方软件的Docker-compose文件

## 前言

把个人在学习过程中的点滴收货记录下来，希望能帮到其他人。

## Project-name

多容器冲突，多个容器配置的目录名一样，导致默认名一致出现的问题。在docker-compose启动的时候会提示警告。解决办法：每个配置都有一个项目名称。如果提供 -p 或 --project-name 或 COMPSE_PROJECT_NAME 标志，则可以指定项目名称。如果未指定标志，Compose 将使用当前目录名称（所以也可以使用不同的目录名以区分）。

>WARNING: Found orphan containers (mysql-5.6) for this project. If you removed or renamed this service in your compose file, you can run this command with the --remove-orphans flag to clean it up.

```linux shell
# docker-compose -p xxx up -d
```

**就目前看来还是建议不要用相同的目录名。**

## networks(网络)

Compose 默认给你的 app 设置一个网络。 service 中的每个容器默认都加入这个网络，容器之间彼此是互通的。并且，可以利用**容器名字**识别到。

> Note: 你 app 的网络默认情况下是和你的 project name 有关的。这个 project name 其实就是你 docker-compose.yml 文件存放的那个目录的名字。比如，目录名叫 db，那么默认情况下会创建一个叫 db_default 的网络。你可以使用 --project-name 或 COMPSE_PROJECT_NAME 环境变量。

注：services 下级的服务中 networks 指定的网络不是指要创建的网络，而是这个服务要加入的网络。所以说，这时候如果你指定了一个没有的网络，就会报错啦，类似这种：

```text
ERROR: Service "mongodb" uses an undefined network "mogo_net"
```

假设该docker-compose文件所在目录为db，容器启动后，自动创建的 "db_mongo_net" 的网络。

```docker-compose
version: "3"
services:
  mongodb:
    ...
    ......
    networks:
      - mongo_net

networks:
  mongo_net:
```

按照下面修改后，容器启动后创建 "mynetwork" 的网络

```docker-compose
version: "3"
services:
  mongodb:
    ...
    ......
    networks:
      - mongo_net

networks:
  mongo_net:
    name: mynetwork
```

>注意点：name 这个标签，这样的用法需要在 Compose 2.1 版本及以上才能使用

## Stroage(持久化数据)

![](https://docs.docker.com/storage/images/types-of-mounts-volume.png)

Volumes：**卷**存储在主机文件系统中，作为其一部分，由Docker管理（在Linux上，位于/var/lib/docker/volumes/）。 非Docker进程不应修改文件系统的这一部分。卷是在Docker中持久保存数据的最佳方法。

Bind mounts：**绑定挂载**可以存储在主机系统上的任何位置。 它们甚至可能是重要的系统文件或目录。 Docker主机或Docker容器上的非Docker进程可以随时对其进行修改。

tmpfs：挂载仅存储在主机系统的内存中，并且永远不会写入主机系统的文件系统中。

**如果使用绑定安装或卷，请牢记以下几点：**

+ 如果将空卷装入存在文件或目录的容器中的目录中，则这些文件或目录将传播（复制）到该卷中。 同样，如果启动一个容器并指定一个尚不存在的卷，则会为您创建一个空卷。 这是预填充另一个容器所需数据的好方法。
+ 如果将绑定安装或非空卷安装到存在某些文件或目录的容器中的目录中，则这些文件或目录会被安装遮盖，就像您将文件保存到Linux主机上的/ mnt中一样，然后 将USB驱动器安装到/ mnt中。 在卸载USB驱动器之前，/ mnt的内容将被USB驱动器的内容遮盖。 不会删除或更改被遮盖的文件，但是在装入绑定安装或卷时将无法访问这些文件。
