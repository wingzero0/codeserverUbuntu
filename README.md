# Code Server in Ubuntu 22.04
Code Server是一個可以在Linux上經網頁介面提供VS Code的[Open Source Project](https://github.com/coder/code-server)。

而這個Repo，主要是把Code Server包裝在Docker Image中，大家安裝了Docker就可以直接使用。

目前Base Image為Ubuntu:22.04，預裝Java 17, Java 11, Maven, Gradle, Node 16.x


## 直接使用Pre-Build Image
checkout repository, then
```
docker compose up -d
```

## Local Build Image
checkout repository, then
```
docker compose -f docker-compose.local.yaml up -d
```