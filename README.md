# Code Server in Ubuntu 24.04
Code Server是一個可以在Linux上經網頁介面提供VS Code的[Open Source Project](https://github.com/coder/code-server)。

而這個Repo，主要是把Code Server包裝在Docker Image中，大家安裝了Docker就可以直接使用。

目前Base Image為Ubuntu:24.04，預裝Java 21, 17, 8, Maven, Gradle, Node 22.x, 20.x


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

若然code-server異常，需要重啟。請見 FAQ

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
    -v codeserverubuntu_sourcecode:/home/ubuntu/sourcecode \
    -v codeserverubuntu_m2cache:/home/ubuntu/.m2 \
    -v codeserverubuntu_extensions:/home/ubuntu/.local/share/code-server/extensions/ \
    -v ./config-latest/.config/code-server/config.yaml:/home/ubuntu/.config/code-server/config.yaml \
    -v ./config-latest/.local/share/code-server/User/settings.json:/home/ubuntu/.local/share/code-server/User/settings.json \
    -p 9000:9000 \
    --entrypoint /home/ubuntu/entrypoint.sh \
    --rm docker.io/wingzzz2003/codeserver_ubuntu
```

or using `network_mode: 'host'` in `podman-compose.yaml`.
```
podman compose -f podman-compose.yaml up -d
```

# 常見問題 FAQ
1. 運行 node 應用時很慢

    在 windows / mac 下，它們的 docker 是經過 VM 建出來的。若使用 bind mount ，其實是經過 VM 層面抄資料夾。普通 java 開發沒有大問題，但如果遇上 node_module ，就會出現極大效能問題。 node_module 最好還是放在 container 內的 mounted volume 中。本 project 預設的 `docker-compose.yaml` 就已經有 `/home/ubuntu/sourcecode` mounted volume ，有需要可以放在其內直接使用。

    linux 則沒有這個問題，因為 docker 只是 linux 的一個 process ，可以直接連到資料夾。

2. mounted volume 權限問題

    如果大家自定義 mounted volume ，注意 docker 預設會是 root 權限，本系統使用 local user `ubuntu`，有需要改為它。 `chown -R 'ubuntu:ubuntu' YOUR_TARGE_FOLDER`

3. 若然code-server異常，需要重啟。在 host 可以使用 docker command，在 container 中，可能殺掉所有 process

```bash
# at host, outside of code-server
sudo docker compose -f docker-compose.local.yaml stop
sudo docker compose -f docker-compose.local.yaml start

# at container, inside of code-server
killall5 -9
```