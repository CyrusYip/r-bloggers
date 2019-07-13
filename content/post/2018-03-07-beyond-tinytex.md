---
title: 穷折腾
author: 黄湘云
date: '2018-03-07'
slug: beyond-tinytex
categories:
  - 统计软件
tags: 
  - tinytex
  - TinyTeX
---

# 源起

从JD总部送完三方返回学校的过程中，我大约有两个小时的时间在地铁上，这种时间我一般会开始百度雍和宫、张自忠路等地铁站名，看看为什么会叫这个名字，当是了解北京的历史了。对北京历史的认识我还停留在清朝，初高中课本里对清朝及以后的介绍不叫历史，那叫政治宣传。我对清朝历史的认识来源于电视剧，我目前看了《康熙王朝》（陈道明饰）、《雍正王朝》（唐国强饰）、《乾隆王朝》（焦晃饰）以及徐峥主演的《李卫当官》和《大内低手》，后来又看了《李卫辞官》、《步步惊心》。别的暂时想不起来了，《铁齿铜牙纪晓岚》和《康熙微服私访记》就不说了，完全逗大家玩。有时间了准备再看下《大明王朝1566》

# 言归正传

今天在看完张自忠路的介绍后，我又开始翻 COSer 的博客，希望某一天相见的时候，有些话题可以聊。 [益辉的博客](https://yihui.name/cn/) 每隔一段时间都会去翻的，今天也不例外，首先看到的是一堆博客更新了，不知道从哪一篇下手，就先随手翻目录，再一次地看到**穷折腾**。自从被刘海洋等人用这个词怼过之后，**穷折腾** 三个字已经在我心里留下了阴影。再一看益辉写作的时间，我在心里打鼓了，我知道很有可能在说我，点开之后，却发现真的在说我。汗汗汗

>部分 Linux 用户乐于在仔细查看官方文档之前轻信网上过时的资料，并在读源代码的时候一知半解，对此我深表遗憾。在这个基础上写出来的冗余代码，我称之为穷折腾。

首先，我没有去网上看什么过时的资料，我手边一直有一本胡伟著的《LaTeX2e 完全学习手册》（第二版），在此之前是 [一份不太简短的 LaTeX2e 介绍](https://github.com/CTeX-org/lshort-zh-cn)，当然啦！现在说这些没有多大意义，也不能证明什么！刘海洋一上来很武断地判断我就是他自认为的那种用户，此处细节请看我在 Github 提的 [issues](https://github.com/CTeX-org/ctex-kit/issues/331)，一方面我承认在 Pandoc 、R Markdown、LaTeX 之间的关系理解的不深，另外对于 CTeX 和字体也不是很清楚，提的这个问题在开发者看来就比较弱智了，因为他们认为字体什么的可以自己写代码重定义，如果动不动就要用户自定义，这好像就是在要求用户具有开发者的潜质啊！更气人的是，还要把我使用 Linux 的事情怼一遍，以便他好有道理似的，好像用户就不能使用 Linux，不然就是穷折腾。

# 回答益辉的关切

>我早该料到这个结果的，因为早在他折腾 CentOS 时，[我就感觉不太对劲](https://d.cosx.org/d/419672/86)（他不回答我为什么作为一个刚接触 CentOS 系统时间不长、却非得对这个系统这么执着，还要卯足了劲要生死往前冲，感觉这就是纯粹为了折腾而折腾）。

我在 COS 论坛上是看到的，我忘了当时为什么没有正面回答这个问题了，2017年9月至11月期间，我在新浪公司运维部做数据分析实习生，这个部门有的是数据和服务器，装的都是 CentOS ，据说 Ubuntu 也有服务器版本，也有人和公司用它做服务器上的操作系统，但为啥我就是没有听说过身边的人用呢？隔壁网易也是用的 CentOS。在这样统一的环境下，我自然也接触上了 CentOS，期间也接触了 Dirk Eddelbuettel 大人的 [rocker 项目](https://github.com/rocker-org/rocker)，当时的 rocker 带的是2013版的 TeXLive，不继续装 texlive-full 还真是挺麻烦的^[不想一个一个地去找依赖和中文支持]，再加上又装了一些分析用的 R 包，等到要 commit 的时候，发现 docker 太大了，没法部署。还是要直面困难，临时解决中文的方案很不可取，至少这个不可取。 [高老板](http://jackpgao.github.io/) 建议我基于 CentOS minimal 开始搭建一个新的 rocker （暂且让我这样盗用这个名词吧），这就是我的全部原因。  


# 后来

后来就有我积极参与 tinytex 测试的事了，我曾问益辉 tinytex 会不会直接支持 CentOS，答案是他本人对 CentOS 不熟悉，还有他认为问题在于找到 CentOS 下一个合适的工具解锁那 [一坨依赖](https://d.cosx.org/d/419672/84)。其实我发现没那么麻烦，也不用借助 tinytex 包装 TinyTeX 发行版，把安装过程给人为的弄复杂了^[这已经是后话了]。不可否认的是 tinytex 和 rmarkdown 的组合拳自动找依赖去编译文档还是可圈可点的。为什么 tlmgr 在安装某个 tex 包的时候，不能像安装 R 包那样顺便把它的依赖给装了呢！非要等到 tinytex 包出来，在编译发生错误的日志中提取缺失的 tex 包，再逐个安装。

几行命令轻松安装 TinyTeX 

```bash
wget http://mirrors.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
tar -xzf install-tl-unx.tar.gz
cd install-tl\*
sudo ./install-tl
```

然后设置基本安装，即只安装 tlmgr 管理器和 scheme-basic，问要不要加路径的时候选择加上。剩下的那些未安装的 tex 依赖包，照抄益辉的，只是另外加上中文支持和常用的几个包（这些包看个人喜好了）

```bash
tlmgr install fontspec ctex tex inconsolata cjk zhnumber \
  fandol xecjk environ ulem trimspaces sourcesanspro sourcecodepro \
  appendix metalogo realscripts xltxtra ms beamer etoolbox translator ec
```

至此， CentOS 下安装极小版的 TeX 套装完成。
