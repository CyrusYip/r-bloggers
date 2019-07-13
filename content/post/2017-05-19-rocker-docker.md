---
title: Docker 环境
author: 黄湘云
date: '2017-05-19'
slug: rocker-docker
categories:
  - 统计软件
tags:
  - Docker
thumbnail: https://cdn.worldvectorlogo.com/logos/docker.svg
description: "Docker 数据分析环境的构建及其在书籍项目中结合Trvais的使用"
---



## 1. 常用操作

作为演示，我们选择来自 [rocker 项目](https://github.com/rocker-org/rocker-versioned)的 Docker 镜像 `rocker/verse`

### 1.1 拉取镜像 `docker pull`

```bash
docker pull rocker/verse
```

### 1.2 运行容器 `docker run` 

```bash
docker run --name rstudio -d -p 8585:8787 -e ROOT=TRUE \
   -e USER=cloud -e PASSWORD=cloud \
   -v /c/Users/xy-huang/Documents:/home/rstudio/dockspace rocker/verse
```

- `--name` 表示给容器取名字 rstudio
- `-d` 即表示 `--detach=false` 默认在后台运行容器
- `-p` 指定容器暴露的端口，`8585:8787` 表示主机端口 8585 映射容器端口 8787，这是主机和容器之间通信的一种方式
- `-e` 指定环境变量，供容器使用
- `-v` 挂载主机目录到容器中的目录，主机和容器共享目录

### 1.3 构建镜像 `docker build`

```bash
docker build -f ./3.6/Dockerfile --build-arg "PANDOC_VERSION=2.7.3" -t rocker/verse .
```

- `-f` 指定 Dockerfile 的路径
- `-t` 指定镜像的名称
- `--build-arg` 传递构建参数给 Dockerfile 的 ARG 变量

### 1.4 提交容器 `docker commit` 

有时候，我们在本地先从Base镜像构建一个容器，这时从容器提交一个镜像

```bash
docker commit -a "Xiangyun Huang <xiangyunfaith@outlook.com>" \
 -m "Docker Image for CmdStan" f8bb7e701514 rocker/verse:local
```

- `-a` 表示 `author` 指定提交该镜像的作者
- `-m` 提交镜像的说明文字
- `f8bb7e701514` 容器的 ID
- `rocker/verse` 镜像的名字
- `local` 指定镜像 TAG ，如果不指定，默认就是 latest

### 1.5 登陆 Dockerhub

```bash
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
```

### 1.6 推送镜像 `docker push`

```bash
docker push rocker/verse
```

### 1.7 删除镜像 `docker rmi`

```bash
docker rmi -f 镜像ID
```
其中 `-f` 表示强制删除

### 1.8 删除容器 `docker rm`

```bash
docker rm 容器ID/名称
```

## 2. Git Bash 中使用 Docker

> **注意**
>
> 这是 Windows 环境下的操作

### 2.1 启动虚拟机 `docker-machine start default` 

默认情形下，虚拟机叫 default 如果你有自定义的就启用自定义的名称

### 2.2 启动容器

```bash
docker start rstudio
```

### 2.3 进入容器

`winpty` 和 `-it` 是一起使用的，实现在命令行中交互执行命令

```bash
winpty docker exec -it rstudio bash
```

### 2.4 登陆虚拟机 default 

```bash
docker-machine.exe ssh default
```

或者

```bash
ssh -X docker@$(docker-machine.exe ip default)
```

默认密码是 `tcuser`，通常会伴随警告，就是没有配置 X11 显示器

```bash
Warning: untrusted X11 forwarding setup failed: xauth key data not generated
```

### 2.5 在容器里执行本地命令，挂载路径要使用绝对路径

```bash
docker run --rm --name=masr -u docker -v "/${PWD}://home/docker/" rstudio /bin/bash ./_build.sh
```

- `--rm` 执行完命令删除容器
- `-u` 指定执行用户
- `-v` 挂载主机当前目录到容器中的目录下 `/home/docker/`
- `rstudio` 是容器名称
- `./_build.sh` 是本地可执行的脚本


## 分配容器资源 

1. 选择容器虚拟机，`点击设置->系统->主板内存大小/处理器数量`
1. 设置可分配的 CPU 核心数，内部程序就可以使用更大的内存和更多的 CPU

```bash
docker run --rm --cpus 4 xiangyunhuang/masr Rscript -e "parallel::detectCores()"
```

> 不要在 Dockerfile 中轻易使用 `--dep=TRUE` 来安装 R 包，它会把 suggestion 级别的依赖也安装上


## 在容器中执行多个命令

在 Git Bash 中创建启动并进入容器执行两条命令 `cat /etc/hosts` 和 `uname -a` 执行完删除容器，命令执行结果返回终端显示器

```bash
winpty docker run --rm -it xiangyunhuang/r-mxnet sh -c 'cat /etc/hosts; uname -a'
```

```
127.0.0.1       localhost
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
172.17.0.2      949a1702bd54
Linux 0a428e1e8e42 4.14.134-boot2docker #1 SMP Mon Jul 22 20:22:16 UTC 2019 x86_
64 x86_64 x86_64 GNU/Linux
```

## 本地编译书籍

> 编译书籍的依赖全部打包到镜像中，然后从容器编译本地书籍项目

切到书籍项目下，编译书籍

```bash
docker run --rm --name=book -u docker -v "/${PWD}://home/docker/" ${DOCKER_REPO_Fedora30} sh ./_build.sh
```

1. 取代 Travis 做测试，有人觉得它是一个黑箱，那么自制一个容器环境肯定不是黑箱了
1. 企业提供的测试环境不足，不可能 Ubuntu/CentOS/Debian/Fedora 所有系统和软件版本全覆盖 ，所以自己制作测试环境，供特定的场景使用，见论坛 <https://d.cosx.org/d/420781>，比如基于 Fedora 30 的镜像，在测试本书籍运行环境，预览见 <https://5d12f0f11c924f927cab200f--rbook.netlify.com>


## 配置显示器

解决 Docker 内的警告 `couldn't connect to display ":0"`

```bash
sudo apt-get install -y \
  # tcltk
  tcl-dev tk-dev
  # rgl
  libcgal-dev libglu1-mesa-dev
  # x11
  xvfb xauth xfonts-base
```

在命令行运行 `xvfb-run R --no-save` 启动 R，此时在 R 控制台输入命令 `capabilities()` 应该可以看到 X11 显示为 TRUE

rgl 的问题还存在，请看 <https://github.com/XiangyunHuang/RGraphics/issues/2>

在本地拉取了一个名叫 rstudio 的镜像，从虚拟机到宿主机的端口映射是8787:8585，8787 端口是虚拟机中 RStudio IDE 默认占用的，这样就可以在宿主机的浏览器里打开链接 <http://localhost:8585>

- `DISPLAY=192.168.99.100:0` 主机 host IP 地址显示器

docker 内 tcltk 可能不可用

```bash
winpty docker run -ti --rm --name book -e DISPLAY='192.168.99.100:0' xiangyunhuang/masr Rscript -e "xfun::session_info(.packages(T))"
```

需要配置主机 X11 显示器

```
Warning message:
In fun(libname, pkgname) : couldn't connect to display "192.168.99.100:0"
```

没有 X11 服务运行相关依赖 <https://stackoverflow.com/questions/1710853/> 和 <https://superuser.com/questions/310197/>





## Python 环境配置

配置 Python 环境

```{bash,eval=FALSE}
sudo apt-get install -y virtualenv python3-pip python3-virtualenv \
  libpython3-dev python3-tk # reticulate::py_config()
# 创建 tensorflow 虚拟环境
sudo virtualenv -p /usr/bin/python3 /opt/pyenv/shims/r-tensorflow
# 给用户写入权限用于安装其它 Python 模块
sudo chown -R root:$(whoami) /opt/pyenv
sudo chmod -R g+w /opt/pyenv
source /opt/pyenv/shims/r-tensorflow/bin/activate
pip install numpy matplotlib tensorflow

echo "source /opt/pyenv/shims/r-tensorflow/bin/activate" | tee -a ~/.bashrc
source ~/.bashrc

# 清理内核和软件备份
dpkg --list | grep linux-image
sudo apt-get autoremove --purge linux-image-4.15.0-{48,50,51}
sudo update-grub2
sudo apt-get clean
```

> 配置 Jupyter 环境

类似 RStudio Server，我们也是从主机浏览器中登陆，Jupyter 默认占用 8888 端口号 

```bash
sudo firewall-cmd --zone=public --add-port=8888/tcp --permanent
sudo firewall-cmd --reload
```

终端中启动  Jupyter 

```bash
jupyter notebook --ip=192.168.176.3 --no-browser
```

然后使用分配给虚拟机的 IP 在浏览器中登陆，如 <http://192.168.176.3:8888>

## 贝叶斯统计计算镜像

> 或者直接使用别人打包的 Dockerfile，拉起本地环境

推荐的运行环境来自 Damir Perisa 打包的 Docker 镜像，下载镜像到本地

```{bash,eval=FALSE}
docker pull mavelli/rocker-bayesian
```

加载镜像文件，启动容器

```{bash,eval=FALSE}
docker run -d -p 8787:8787 mavelli/rocker-bayesian
```

然后，打开网址 <http://localhost:8787> 你就可以在浏览器中进入打包的容器

## 给容器设置静态 IP 

<https://www.cnblogs.com/brock0624/p/9795208.html>

```
docker network create --driver bridge --subnet=172.18.12.0/16 --gateway=172.18.1.1 booknet
```

```
docker network ls
```

```
docker network inspect booknet
```
```
[
    {
        "Name": "booknet",
        "Id": "e6e12757f855ab6c5e886cbe7ac34ab53b93cb6c088e6eacf884ba6e5a4e08e9",
        "Created": "2019-06-29T08:47:49.496869652Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "172.18.12.0/16",
                    "Gateway": "172.18.1.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {},
        "Options": {},
        "Labels": {}
    }
]
```
