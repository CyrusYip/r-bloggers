---
title: 安装 Linux 操作系统
author: 黄湘云
date: '2018-02-19'
slug: setup-linux-oss
categories:
  - 统计软件
tags:
  - Fedora
  - CentOS
  - OpenSUSE
  - Ubuntu
toc: true
thumbnail: https://upload.wikimedia.org/wikipedia/commons/3/3f/Fedora_logo.svg
description: "安装 Fedora 29, CentOS 7, OpenSUSE 15, Ubuntu 18.04"
---


# 安装 Fedora 29

开机进入安装界面后，首先选择安装过程中使用的语言，这里选择英语

![choose-english](https://wp-contents.netlify.com/2019/01/Fedora/01.png)

启用网络连接

![](https://wp-contents.netlify.com/2019/01/Fedora/02.png)

最小安装

![](https://wp-contents.netlify.com/2019/01/Fedora/03.png)

完成各项配置

![](https://wp-contents.netlify.com/2019/01/Fedora/04.png)

等待安装直到完成

![](https://wp-contents.netlify.com/2019/01/Fedora/05.png)


当我们往 Linux 系统输入第一个含有管理员权限的命令后，会提示如下一段话

```
[xiangyun@localhost ~]$ sudo dnf update

我们信任您已经从系统管理员那里了解了日常注意事项。
总结起来无外乎这三点：

    #1) 尊重别人的隐私。
    #2) 输入前要先考虑(后果和风险)。
    #3) 权力越大，责任越大。

[sudo] xiangyun 的密码：
```

# 安装 CentOS 7

开机进入安装界面后，首先选择安装过程中使用的语言，这里选择英语

![choose-english](https://wp-contents.netlify.com/2018/12/installation-centos/01-choose-english.png)

可以看到还有警告提示，需要配置网络连接、远程镜像位置、系统安装位置

![](https://wp-contents.netlify.com/2018/12/installation-centos/02-settings.png)

默认情况下 enpOs3 没有启用

![](https://wp-contents.netlify.com/2018/12/installation-centos/02-network-01.png)

我们把它开启

![](https://wp-contents.netlify.com/2018/12/installation-centos/02-network-02.png)

类似地，把 enpOs8 也开启

![](https://wp-contents.netlify.com/2018/12/installation-centos/02-network-03.png)

此时远程镜像位置还没有配置，选择就近的系统安装源，如清华

![](https://wp-contents.netlify.com/2018/12/installation-centos/03-installation-source.png)

选择最小安装

![](https://wp-contents.netlify.com/2018/12/installation-centos/04-minimal-install.png)

选择安装位置

![](https://wp-contents.netlify.com/2018/12/installation-centos/05-installation-destination.png)

完成各项安装配置

![](https://wp-contents.netlify.com/2018/12/installation-centos/06-settings-down.png)

需要创建用户

![](https://wp-contents.netlify.com/2018/12/installation-centos/07-start-installation.png)

设置用户登陆密码

![](https://wp-contents.netlify.com/2018/12/installation-centos/08-root.png)

将该用户设置为管理员权限

![](https://wp-contents.netlify.com/2018/12/installation-centos/09-user-create.png)

完成用户创建

![](https://wp-contents.netlify.com/2018/12/installation-centos/10-accounts-down.png)

等待安装，直到完成

![](https://wp-contents.netlify.com/2018/12/installation-centos/11-installation-finish-reboot.png)

重启，选择第一项进入系统

![](https://wp-contents.netlify.com/2018/12/installation-centos/12-start-os.png)

获取 IP 地址

![](https://wp-contents.netlify.com/2018/12/installation-centos/13-configure-network.png)

`ONBOOT=no` 设置为 `ONBOOT=yes`

![](https://wp-contents.netlify.com/2018/12/installation-centos/14-onboot-yes.png)

将获得的 IP 输入 PUTTY

![](https://wp-contents.netlify.com/2018/12/installation-centos/15-PuTTY.png)

第一次连接虚拟机中的操作系统， PUTTY 会有安全提示，选择是，登陆进去

![](https://wp-contents.netlify.com/2018/12/installation-centos/16-PuTTY-Security.png)

# 安装 OpenSUSE

开机进入安装界面后，选择时区

![openSUSE-timezone](https://wp-contents.netlify.com/2019/03/openSUSE_timezone.png)

选择安装服务器版本

![openSUSE-server](https://wp-contents.netlify.com/2019/03/openSUSE_server.png)

即将安装的软件

![openSUSE-software](https://wp-contents.netlify.com/2019/03/openSUSE_software.png)

创建管理员用户账户

![openSUSE-user](https://wp-contents.netlify.com/2019/03/openSUSE_user.png)

# 安装 Ubuntu

开机进入安装界面后，首先选择安装过程中使用的语言，这里选择英语

![choose-english](https://wp-contents.netlify.com/2019/01/Bionic/01.png)

选择键盘布局

![](https://wp-contents.netlify.com/2019/01/Bionic/02.png)

安装 Ubuntu

![](https://wp-contents.netlify.com/2019/01/Bionic/03.png)

配置网络连接

![](https://wp-contents.netlify.com/2019/01/Bionic/04.png)

是否配置代理，选择否

![](https://wp-contents.netlify.com/2019/01/Bionic/05.png)

配置远程镜像位置

![](https://wp-contents.netlify.com/2019/01/Bionic/06.png)

文件系统设置

![](https://wp-contents.netlify.com/2019/01/Bionic/07.png)

VBox 指定的磁盘

![](https://wp-contents.netlify.com/2019/01/Bionic/08.png)

确认磁盘的设置

![](https://wp-contents.netlify.com/2019/01/Bionic/09.png)

再次确认磁盘的设置，一旦确认就会开始格式化磁盘，不可逆转

![](https://wp-contents.netlify.com/2019/01/Bionic/10.png)

用户管理员账户配置

![](https://wp-contents.netlify.com/2019/01/Bionic/11.png)

导入 SSH key

![](https://wp-contents.netlify.com/2019/01/Bionic/12.png)

服务器配置

![](https://wp-contents.netlify.com/2019/01/Bionic/13.png)

等待安装系统

![](https://wp-contents.netlify.com/2019/01/Bionic/14.png)

系统安装完成

![](https://wp-contents.netlify.com/2019/01/Bionic/15.png)
