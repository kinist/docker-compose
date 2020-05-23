# Redis docker-compose 用法

1. docker-compose.yml

   + 使用Redis默认配置，且数据目录直接使用volume模式

2. docker-compose-config.yml

   + 数据目录使用bind到本地persistence目录
   + 在 ./persitence/conf 下可自定义redis.conf
   + redis默认密码: redispasswd
