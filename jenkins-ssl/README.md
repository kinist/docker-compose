# Jenkins（采用https方式） docker-compose 基本用法

-其他步骤参考http方式
-补充https自签名证书步骤
*创建私钥
openssl genrsa -out key.pem 2048
*构建证书请求(csr)
openssl req -new -key key.pem -out csr.pem
#localhost可换成你需要的域名domain.com
openssl req \
    -subj "/C=CN/ST=Beijing/L=Beijing/O=Test/OU=Development Software/CN=localhost/emailAddress=test@example.com" \
    -new \
    -key key.pem \
    -out csr.pem
*生成自签名证书
openssl x509 -req -days 9999 -in csr.pem -signkey key.pem -out cert.pem
*删除证书请求(csr)
rm csr.pem
