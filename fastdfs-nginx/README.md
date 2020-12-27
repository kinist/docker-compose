build: 包含镜像制作内容，该镜像使用超小的Linux镜像alpine
参考资料：https://github.com/luhuiguo/fastdfs-docker.git

standalone：仅支持单节点的FastDFS模式
cluster：待补充

之前时间经验：
* 支持单一Tacker，目前不支持多个Tacker，切勿尝试
* storage容器中包含nginx，用于对上传文件的下载或访问
* 支持多个Group，每个Group仅支持一个Storage，当某个Group停掉后，不影响上传
* mod_fastdfs.conf中group_count = 0后面那些都没有设置，待改进
* 前面如果增加Nginx反向代理，可以支持同一入口访问