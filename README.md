# Code Server in Ubuntu 24.04
Code Server是一個可以在Linux上經網頁介面提供VS Code的[Open Source Project](https://github.com/coder/code-server)。

而這個Repo，主要是把Code Server包裝在Docker Image中，大家安裝了Docker就可以直接使用。

目前Base Image為Ubuntu:24.04，預裝Java 17, Java 11, Maven, Gradle, Node 20.x, 18.x


## 直接使用Pre-Build Image
checkout [git repository](https://github.com/wingzero0/codeserverUbuntu)
```bash
# create / run container
sudo docker compose up -d
# stop container
sudo docker compose stop
# stop and delete container
sudo docker compose down
```

## Local Build Image
checkout [git repository](https://github.com/wingzero0/codeserverUbuntu)
```bash
# create / run container
sudo docker compose -f docker-compose.local.yaml up -d
# stop container
sudo docker compose -f docker-compose.local.yaml stop
# stop and delete container
sudo docker compose -f docker-compose.local.yaml down
```

## 使用Code Server
在run container時，打開Browser localhost:9000，就可以開始使用code server

若然code-server有時異模，需要重啟。

```bash
# in host, outside of code-server
sudo docker compose -f docker-compose.local.yaml stop
sudo docker compose -f docker-compose.local.yaml start

# in guest, inside of code-server
killall5 -9
```

## 上/下載
上載檔案：可以經過拖拉的方式，把桌面的檔案拖進 code-server 的 Explorer 區域。
下載檔案：可以點選 code-server Explorer區域內的檔案，按滑鼠右鍵，選 Download 。