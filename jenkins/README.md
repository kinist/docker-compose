# Jenkins docker-compose 基本用法

Jenkins container 建议直接mount到数据目录，不要采用volume方式，便于数据单独存储或备份。

如果使用bind mount来持久化jenkins_home，确认该目录归属于jenkins用户，即 `jenkins user - uid 1000` 或 使用 `-u some_other_user` 参数来启动docker。

Read [documentation](https://github.com/jenkinsci/docker/blob/master/README.md) for usage
