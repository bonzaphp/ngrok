
# ngrok docker版

使用方法

```
docker run -it  -p 8081:8081 -p 5443:4443  -d bonzaphp/ngrok:v1.0.2 /ngrok/bin/ngrokd -domain="ngrok.bonza.cn" -httpAddr=":8081"
```

其中版本v1,为直接构建，版本v2为多阶构建的，所以镜像小很多。