# Jenkins docker-compose 基本用法

- **持久化方式：** Jenkins container 建议直接mount到数据目录，不要采用volume方式，便于数据单独存储或备份；

- **用户归属：** 如果使用bind mount来持久化jenkins_home，确认该目录归属于jenkins用户，即 `jenkins user - uid 1000` 或 使用 `-u some_other_user` 参数来启动docker；

- **节点建议：** Jenkins节点管理，master节点执行器数量设置为0，全部采用Slave节点挂接上来，其中Slave节点采用 "通过Java Web启动代理" 方式；

- **节点启动：** "slave/agent" 目录下为Slave节点启动脚本，需要下载agent.jar文件及修改slave.sh的部分变量，如：SECRET_KEY、WORK_DIR、JNLP_URL

- **脚本说明：** Port=8080默认http模式；8443默认https模式；环境变量"JENKINS_OPTS"为https模式下专用；"jenkins/openssl"持久化目录存放证书专用

- **https自签名：** 补充自签名证书生成步骤

```shell
# 创建私钥
openssl genrsa -out key.pem 2048
# 构建证书请求(csr)
openssl req -new -key key.pem -out csr.pem
# 免交互的构建证书请求(csr) localhost可换成你需要的域名domain.com
openssl req \
    -subj "/C=CN/ST=Beijing/L=Beijing/O=Test/OU=Development Software/CN=localhost/emailAddress=test@example.com" \
    -new \
    -key key.pem \
    -out csr.pem
# 生成自签名证书
openssl x509 -req -days 9999 -in csr.pem -signkey key.pem -out cert.pem
# 删除证书请求(csr)
rm csr.pem
```

Read [documentation](https://github.com/jenkinsci/docker/blob/master/README.md) for Jenkins usage
