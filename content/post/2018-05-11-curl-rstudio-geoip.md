---
title: Curl、RStudio 和 GeoIP 简介
author: 黄湘云
date: '2018-05-11'
slug: curl-rstudio-geoip
categories:
  - 统计软件
tags:
  - curl
thumbnail: https://wp-contents.netlify.com/logos/curl.svg
description: "curl 的功能非常强大，应用非常广泛，大部分的 Linux 几乎自带。RStudio 公司出品了很多开源的R包，打造了 Shiny 生态、Spark 生态、tensorflow 生态、R Markdown 生态和tidyverse 数据分析、数据可视化等生态。GeoIP 解析地址。"
---

# curl 常用参数含义

见在线帮助文档 <https://man.linuxde.net/curl>

## 下载文件至当前目录

文件名为 `quadprog_1.5-5.tar.gz`

```bash
curl -C - -O https://cran.r-project.org/src/contrib/quadprog_1.5-5.tar.gz
```

## 下载文件到指定目录

```bash
curl -fLo ~/R-latest.tar.gz https://cloud.r-project.org/src/base/R-latest.tar.gz
```
```
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
 10 28.7M   10 3232k    0     0   107k      0  0:04:34  0:00:30  0:04:04  118k
```

## 安装 oh-my-zsh

在 Ubuntu/Debian 系统上安装 oh-my-zsh

```bash
sudo apt update && sudo apt install git
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

# RStudio

专为统计软件 R 打造的集成开发环境，开发 R 包，使用 bookdown 写书、blogdown 建网站、开发 Shiny 应用。提供桌面端、服务器端，跨平台支持 Linux/macOS/Windows 系统

![rstudio-ide-win](https://wp-contents.netlify.com/2019/05/rstudio-ide-win.png)

RStudio IDE 是开源的，源代码托管在 Github 上，开放性体现在生态的强大，很多社区成员为其打造插件

![rstudio-ide-win](https://wp-contents.netlify.com/2019/05/rstudio-ide-addins.png)


RStudio IDE 功能非常强大，体现在强大的包容性，支持 C++ 、Python、SQL、Stan、D3 等脚本语言

![rstudio-ide-language](https://wp-contents.netlify.com/2019/05/rstudio-ide-language.png)

RStudio 支持丰富的项目开发模版

![rstudio-ide-project](https://wp-contents.netlify.com/2019/05/rstudio-ide-project.png)

# Shiny

Shiny 模版项目

![shiny-project](https://wp-contents.netlify.com/2019/05/shiny-project.png)

演示文件

![shiny-demo](https://wp-contents.netlify.com/2019/05/shiny-demo.png)

# R Markdown

blogdown 便是 R Markdown 生态中的一员，比较著名的还有 rmarkdown 和 bookdown，目前 pagedown 也在活跃地开发之中

![bookdown-demo](https://wp-contents.netlify.com/2019/05/bookdown-demo.png)

编译 bookdown 项目的演示模版

![bookdown-gitbook](https://wp-contents.netlify.com/2019/05/bookdown-gitbook.png)

## 查询本机 IP 地址

可以使用 Linux 自带的工具 [curl][man-curl]。

```bash
curl ifconfig.me
```

```
223.71.83.98% 
```

```bash
curl ipinfo.io
```
```
{
  "ip": "223.71.83.98",
  "city": "Beijing",
  "region": "Beijing",
  "country": "CN",
  "loc": "39.9288,116.3890",
  "org": "AS56048 China Mobile Communicaitons Corporation"
}%  
```

```bash
curl cip.cc
```
```
IP      : 223.71.83.98
地址    : 中国  北京
运营商  : 移动

数据二  : 北京市 | 中国移动北京分公司

数据三  : 中国北京北京市 | 移动

URL     : http://www.cip.cc/223.71.83.98
```

```bash
curl ip.cip.cc
```
```
223.71.83.98
```

学校的网络 IP 动态分配，有时又出现 111.203.130.69

## 自动更新 GeoLite2 数据库

```bash
sudo yum install GeoIP-update
```

详情请看 https://dev.maxmind.com/zh-hans/geoip/geoipupdate/

## 解析 IP 地址

安装 rgeolocate 包

```bash
install.r rgeolocate
```

离线下载 GeoLite2 数据库，下载地址 https://dev.maxmind.com/geoip/geoip2/geolite2/

```bash
curl -C - -O http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz
curl -C - -O http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz
```

![GeoLite2 数据库下载页面](https://wp-contents.netlify.com/2018/12/GeoIP2.png)

校验 MD5 码

```bash
md5sum GeoLite2-Country.tar.gz
md5sum GeoLite2-City.tar.gz
```

解压

```bash
tar -xzf GeoLite2-City.tar.gz
tar -xzf GeoLite2-Country.tar.gz
```

将 maxmind 格式数据库移动到 [rgeolocate 包][rgeolocate] 的额外数据存放位置

```bash
mv GeoLite2-City_20181127/GeoLite2-City.mmdb /usr/local/lib/R/site-library/rgeolocate/extdata/
mv GeoLite2-Country_20181127/GeoLite2-Country.mmdb /usr/local/lib/R/site-library/rgeolocate/extdata/
```

解析 IP，获取 IP 指向的洲名，国家代码，国家，城市，城市唯一识别码，所在时区和经纬度。

```r
library(rgeolocate)
path_to_file <- system.file("extdata", "GeoLite2-City.mmdb", package = "rgeolocate")
results <- maxmind(
  "111.203.130.69", path_to_file,
  c(
    "continent_name", "country_code", "country_name",
    "region_name", "city_name", "city_geoname_id",
    "timezone", "longitude", "latitude"
  )
)
results
```

```
  continent_name country_code country_name region_name city_name city_geoname_id      timezone longitude latitude
1           Asia           CN        China     Beijing   Beijing         1816670 Asia/Shanghai       116     39.9
```

> 这里使用的 IP 地址 111.203.130.69 在中国矿业大学（北京）校区内

## 空间可视化

> 获得经纬度后，可以将位置标记在地图上

在百度地图上，根据地理名称获得经纬度信息， 以中国矿业大学（北京）为例

```r
# https://github.com/badbye/baidumap
library(devtools)
install_github('badbye/baidumap')
library(baidumap)
options(baidumap.key = 'DaQR8wEazA53eNDMuc1BYCj5ZWXVyzLk')
getCoordinate('中国矿业大学（北京）', formatted = T)
```
```
longtitude   latitude 
 116.35688   40.00314 
```


在 leaflet 地图上实际经纬度为 `c(116.34394, 39.99665)`

```r
library(leaflet)
m1 = leaflet() %>% setView(lng = 116.34394, lat = 39.99665, zoom = 17) %>%
  addTiles() %>% 
  addPopups(116.34394, 39.99665, 'Here is the <b>Department of Statistics</b>, CUMTB')
m1
```

不难看出，百度地图和 leaflet 地图的坐标系不是同一个，获取的经纬度不同，这里将矿大（北京）定位到农大了

```r
m2 = leaflet() %>% setView(lng = 116.35688, lat = 40.00314, zoom = 17) %>%
  addTiles() %>% 
  addPopups(116.35688, 40.00314, 'Here is the <b>Department of Statistics</b>, CUMTB')
m2
```

> 注意：GeoIP 只能给定一个粗略的经纬度信息，根据IP解析出来的经纬度 `c(116,39.9)` ，相比百度地图API根据地理名称获取的经纬度`c(116.35688,40.00314 )`就更加模糊了

[rgeolocate]: https://github.com/ironholds/rgeolocate
[man-curl]: https://curl.haxx.se/docs/manpage.html
