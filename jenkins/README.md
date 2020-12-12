# Jenkins docker-compose 基本用法

- Jenkins container 建议直接mount到数据目录，不要采用volume方式，便于数据单独存储或备份；
- 如果使用bind mount来持久化jenkins_home，确认该目录归属于jenkins用户，即 `jenkins user - uid 1000` 或 使用 `-u some_other_user` 参数来启动docker；
- Jenkins节点管理，master节点执行器数量设置为0，全部采用Slave节点挂接上来，其中Slave节点采用“通过Java Web启动代理”方式；
- “slave/agent”目录下为Slave节点启动脚本，注意下载agent.jar文件及修改slave.sh的部分变量，如：SECRET_KEY、WORK_DIR、JNLP_URL


Read [documentation](https://github.com/jenkinsci/docker/blob/master/README.md) for usage
