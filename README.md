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

# podman-compose in Steam OS 3.5 (3.6)
For podman 4.9.3 in Steam OS, podman compose dns not workings. it will show below warning.
```
WARN[0002] aardvark-dns binary not found, container dns will not be enabled
```
even you add dns:8.8.8.8, it won't help.

you might go back to `podman container run`.
```bash
podman volume create codeserverubuntu_sourcecode
podman volume create codeserverubuntu_m2cache
podman volume create codeserverubuntu_extensions

podman container run \
    -v codeserverubuntu_sourcecode:/root/sourcecode \
    -v codeserverubuntu_m2cache:/root/.m2 \
    -v codeserverubuntu_extensions:/root/.local/share/code-server/extensions/ \
    -v ./config-latest/.config/code-server/config.yaml:/root/.config/code-server/config.yaml \
    -v ./config-latest/.local/share/code-server/User/settings.json:/root/.local/share/code-server/User/settings.json \
    -p 9000:9000 \
    --entrypoint /root/entrypoint.sh \
    --rm docker.io/wingzzz2003/codeserver_ubuntu
```

or using `network_mode: 'host'` in `podman-compose.yaml`.
```
podman compose -f podman-compose.yaml up -d
```
