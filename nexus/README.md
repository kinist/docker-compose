# Nexus docker-compose 基本用法

nexus container 建议直接mount到数据目录，不要采用volume方式，便于数据单独存储。

在docker-compose.yml目录下运行

```Linux shell
# mkdir -p ./persistence/nexus-data && chown -R 200 ./persistence/nexus-data
```

参考文档：
[sonatype/nexus3 - dockerhub](https://hub.docker.com/r/sonatype/nexus3)