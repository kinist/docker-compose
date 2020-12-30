OPENVPN
====

[本文参考链接](https://hub.docker.com/r/kylemanna/openvpn)

- 设置环境变量
后面该容器采用docker-compose启动，而docker-compose建立volume时会把当前目录放到卷名称中，故"aspvpn"为当前目录。

```text
export OVPN_DATA="aspvpn_ovpn-data"
```

- 持久化卷

```text
docker volume create --name $OVPN_DATA
```

- 启动容器并初始化，将10.1.23.29换成对应的服务器IP地址或域名

```text
docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u udp://10.1.23.29
```

- 生成秘钥文件

```text
docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki

输入私钥密码（输入时是看不见的）：
Enter PEM pass phrase: 12345678
再输入一遍
Verifying - Enter PEM pass phrase: 12345678
输入一个CA名称（可以直接回车）
Common Name (eg: your user, host, or server name) [Easy-RSA CA]:
输入刚才设置的私钥密码（输入完成后会再让输入一次）
Enter pass phrase for /etc/openvpn/pki/private/ca.key: 12345678
```

- 生成客户端无密码证书

```text
docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full CLIENTNAME nopass

- 输入刚才设置的密码
Enter pass phrase for /etc/openvpn/pki/private/ca.key: 12345678
```

- 导出客户端证书

```text
docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_getclient CLIENTNAME > aspvpn.ovpn
```

- 开启OpenVPN服务

```text
docker run -v $OVPN_DATA:/etc/openvpn -p 1194:1194/udp --cap-add=NET_ADMIN --restart="unless-stopped" --name=openvpn -d kylemanna/openvpn

或者使用对应的docker-compose.yml，其中volume名称需要去掉对应的目录名"aspvpn"
version: '3'
services:
  openvpn:
    image: kylemanna/openvpn
    container_name: openvpn
    restart: unless-stopped
    cap_add:
      - NET_ADMIN
    ports:
      - "1194:1194/udp"
    volumes:
      - ovpn-data:/etc/openvpn

volumes:
  ovpn-data:
```
