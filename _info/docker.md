## Add packages to container

`apk add curl`

## install (ubuntu/wsl) standalone

https://docs.docker.com/engine/install/ubuntu/

## chroot - run container in jail

`docker run -it --rm -p "127.0.0.1:2022:2022" b44983c7efbe chroot /app ./linux-server`

```
$ docker run -it --rm ubuntu:trusty chroot --userspec=nobody / ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
nobody       1  5.0  0.0   7136   756 ?        Rs+  17:04   0:00 ps aux
```

## all containers should have this

```Dockerfile
ENV LANG=C.UTF-8
```

## git shell on running container (root)

```sh

## takes care of issues with locales
docker run -e LANG=C.UTF-8 -e LC_ALL=C.UTF-8 -it --rm <yourimage> <yourcommand>

## run and map a folder
docker run -it --name testservice -v .:/app ubuntu:latest

## run image and create new image tag called testservice from ubuntu:latest
docker run -it --name testservice ubuntu:latest

## list all "running containers"
docker ps

## list all running and shutdown containers
docker ps -a

## get container ID if running container, in this case 5dc47655b035
docker exec -it -u 0 5dc47655b035 /bin/bash

## run other platforms using apple silicon
docker run --rm -it --platform linux/amd64 test.test.com/image-name:dev bash

## -u 0 = root
```

## running jenkins/jenkins

- build with `--cpu-quota xyz`
  `--cpu-quota 10000` 1 cpu 100%
  `--cpu-quota 20000` 2 cpu 100%
  `--cpu-quota 320000` 4 cpu 80%

- pull from public repo
  docker pull jenkins/jenkins

- run it
  docker run -p 8080:8080 --name=jenkins-master -d jenkins/jenkins -v
  /var/socket

- delete all shutdown containers
  docker container prune
