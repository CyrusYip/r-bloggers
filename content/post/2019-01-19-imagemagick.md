---
title: 一些 ImageMagick 命令
author: 黄湘云
date: '2019-01-19'
slug: imagemagick
categories:
  - 统计软件
tags:
  - ImageMagick
thumbnail: https://upload.wikimedia.org/wikipedia/commons/9/9a/ImageMagick_logo.svg
description: "ImageMagick 具有强大的图像处理功能"
---


# 1. 安装配置

接受协议

![](https://wp-contents.netlify.com/2018/12/install-imagemagick/01.png)

点击下一步

![](https://wp-contents.netlify.com/2018/12/install-imagemagick/02.png)

选择安装目录

![](https://wp-contents.netlify.com/2018/12/install-imagemagick/03.png)

在开始菜单栏中创建快捷方式

![](https://wp-contents.netlify.com/2018/12/install-imagemagick/04.png)

选中创建桌面快捷方式、将软件安装目录添加到系统路径、安装 FFmpeg、不关联文件扩展、安装 convert 工具、安装开发的头文件和和库

![](https://wp-contents.netlify.com/2018/12/install-imagemagick/05.png)

确认即将安装的内容

![](https://wp-contents.netlify.com/2018/12/install-imagemagick/06.png)

等待程序安装

![](https://wp-contents.netlify.com/2018/12/install-imagemagick/07.png)

是否测试一下你安装的 ImageMagick

![](https://wp-contents.netlify.com/2018/12/install-imagemagick/08.png)

是否现在看看软件使用手册

![](https://wp-contents.netlify.com/2018/12/install-imagemagick/09.png)

确保 convert 和 FFmpeg 安装好

![](https://wp-contents.netlify.com/2018/12/install-imagemagick/convert.png)

# 2. 功能介绍

见益辉博客[一些 ImageMagick 命令](https://yihui.name/cn/2018/04/imagemagick/)

## 2.1 PDF 格式转 PNG 格式

```bash
convert -quality 100 -antialias -density 96 -transparent white -trim INPUT.pdf OUTPUT.png 
```
 
|选项                          |作用                                                  |
|:-----------------------------|:-----------------------------------------------------|
|trim                          |  裁剪图像四周空白区域 
|transparent color             |  去除图像中指定的颜色 
|density geometry              |  设定图像的 DPI 值
|antialias                     |  让图像具有抗锯齿的效果 
|quality                       |  图像压缩等级

---
像素、点等常见术语

|符号                          |含义                                                  |
|:-----------------------------|:-----------------------------------------------------|
| px                           | pixel 像素，电子屏幕上组成一幅图画或照片的最基本单元 
| pt                           | point，点，印刷行业常用单位，等于1/72英寸
| ppi                          | pixel per inch，每英寸像素数，该值越高，则屏幕越细腻
| dpi                          | dot per inch，每英寸多少点，该值越高，则图片越细腻
