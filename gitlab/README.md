# GitLab docker-compose 最佳实践

## 官方建议初始配置

```docker-compose
version: '3'
services:
  web:
    image: 'gitlab/gitlab-ce:latest'
    restart: always
    hostname: 'gitlab.example.com'
    environment:
      GITLAB_OMNIBUS_CONFIG: |
        external_url 'https://gitlab.example.com'
    ports:
      - '80:80'
      - '443:443'
      - '22:22'
    volumes:
      - '/srv/gitlab/config:/etc/gitlab'
      - '/srv/gitlab/logs:/var/log/gitlab'
      - '/srv/gitlab/data:/var/opt/gitlab'
```

## 官方建议生产配置

GitLab running on a custom HTTP and SSH port.

This is the same as using --publish 8929:8929 --publish 2224:22.

```docker-compose
version: '3'
services:
  web:
    image: 'gitlab/gitlab-ce:latest'
    restart: always
    hostname: 'gitlab.example.com'
    environment:
      GITLAB_OMNIBUS_CONFIG: |
        external_url 'http://gitlab.example.com:8929'
        gitlab_rails['gitlab_shell_ssh_port'] = 2224
    ports:
      - '8929:8929'
      - '2224:22'
    volumes:
      - '$GITLAB_HOME/gitlab/config:/etc/gitlab'
      - '$GITLAB_HOME/gitlab/logs:/var/log/gitlab'
      - '$GITLAB_HOME/gitlab/data:/var/opt/gitlab'
```

## 个人最佳实践

+ 参考已上传的 `docker-compose.yml`
+ 生产环境不建议使用docker volume方式挂载持久化文件，而是bind到本地磁盘或存储上。
+ 生产环境不建议将某些配置放在docker-compose的环境变量中，而是编辑 `/etc/gitlab/gitlab.rb`

GitLab配置的修改参考：

```Linux shell
# cd ./persistence/gitlab/config
# vi gitlab.rb

external_url 'http://192.168.1.1:8929'
gitlab_rails['time_zone'] = 'Asia/Shanghai'
gitlab_rails['gitlab_shell_ssh_port'] = 2224
```

以上修改会将http端口修改为8929，ssh端口修改为2224

+ 常用的命令行：（需进入docker容器内使用）

```Linux shell
# gitlab-ctl status               //查看gitlab组件状态
# gitlab-ctl start                //启动全部服务
# gitlab-ctl restart              //重启全部服务
# gitlab-ctl stop                 //停止全部服务
# gitlab-ctl reconfigure          //修改完主配置文件后执行使其生效
# gitlab-ctl show-config          //验证配置文件
# gitlab-ctl uninstall            //删除gitlab（保留数据）
# gitlab-ctl cleanse              //删除所有数据，从新开始
# gitlab-ctl tail <service name>  //查看服务的日志

// nginx：静态Web服务器
// gitlab-shell：用于处理Git命令和修改authorized keys列表，GitLab是以Git做为最层的，操作实际就是调用gitlab-shell命令进行处理。
// gitlab-workhorse:轻量级的反向代理服务器
// logrotate：日志文件管理工具
// postgresql：数据库
// redis：缓存数据库
// sidekiq：用于在后台执行队列任务（异步执行）
// unicorn：GitLab Rails应用是托管在这个服务器上面的
```

+ Rake tasks： [参考链接](https://s0docs0gitlab0com.icopy.site/ee/raketasks/README.html)

+ GitLab备份恢复(属于Rake task内命令)： [参考链接](https://docs.gitlab.com/ce/raketasks/backup_restore.html)

+ 邮件设置参考： 待补充