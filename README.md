# Code Server in Ubuntu 22.04
Code Server是一個可以在Linux上經網頁介面提供VS Code的[Open Source Project](https://github.com/coder/code-server)。

而這個Repo，主要是把Code Server包裝在Docker Image中，大家安裝了Docker就可以直接使用。

目前Base Image為Ubuntu:24.04，預裝Java 17, Java 11, Maven, Gradle, Node 20.x, 18.x


## 直接使用Pre-Build Image
checkout [git repository](https://github.com/wingzero0/codeserverUbuntu)
```
# create / run container
docker compose up -d
# stop container
docker compose stop
# stop and delete container
docker compose down
```

## Local Build Image
checkout [git repository](https://github.com/wingzero0/codeserverUbuntu)
```
# create / run container
docker compose -f docker-compose.local.yaml up -d
# stop container
docker compose -f docker-compose.local.yaml stop
# stop and delete container
docker compose -f docker-compose.local.yaml down
```

## 使用Code Server
在run container時，打開Browser localhost:9000，就可以開始使用code server
