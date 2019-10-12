---
title: "统计之都微信公众号编辑指南（主站端）"
author: "黄湘云"
date: "2019-10-12"
categories:
  - 统计软件
tags:
  - 统计之都
  - Github
  - 微信公众号
slug: cos-weixin-edit
---

## 微信编辑指南

> 以文章[《重要的不是谁获 COPSS 奖，而是它给我们的启发和思考》](https://cosx.org/2019/08/copss-hadley-special-comment/)为例

> 可以先了解一下统计之都的投稿、审稿、编辑的流程 <https://wp-contents.netlify.com/talks/2019-chinar12th-cos-blogdown>

> 主站其实支持丰富的多媒体内容，Markdown 还可以这样玩 <https://www.xiangyunhuang.com.cn/2019/05/another-hello-markdown/>

> 推荐安装好 R/RStudio/Git 注册好 Github 账户 

> 主站端的介绍如下，微信端的操作可以单独问怡萌、任焱等，也可以在微信编辑工作群里问

1. 下载主站仓库到本地，在目录 `content/post/` 下可以看到很多以扩展名为 md 的文件

	```bash
	git clone --recursive git@github.com:cosname/cosx.org.git
	```

	![](https://user-images.githubusercontent.com/12031874/66697090-1685d600-ed05-11e9-8206-297b4efee2f8.png)

1. typora 打开 md 文件可以预览到

	![](https://user-images.githubusercontent.com/12031874/66697091-1685d600-ed05-11e9-926e-9a1a07f95377.png)

1. 会用 RStudio 的话，可以看到这个

	![](https://user-images.githubusercontent.com/12031874/66697093-171e6c80-ed05-11e9-9c44-bc57351c6b70.png)

1. 此时点击 Serve Site 可以看到网站的本地预览

	![](https://user-images.githubusercontent.com/12031874/66697094-17b70300-ed05-11e9-920f-5064c75878ab.png)

	![](https://user-images.githubusercontent.com/12031874/66697095-17b70300-ed05-11e9-86dd-e1742884345c.png)

1. 点击椭圆圈住的按钮，可以在网页中预览主站

	![](https://user-images.githubusercontent.com/12031874/66697096-17b70300-ed05-11e9-86d0-a17b942622ed.png)
	
	网页中的预览效果
	
	![](https://user-images.githubusercontent.com/12031874/66697097-184f9980-ed05-11e9-806f-5eb452fab903.png)

1. 再点击正在编辑的文章，可以看到

	![](https://user-images.githubusercontent.com/12031874/66697098-184f9980-ed05-11e9-8b29-247791d6ab6c.png)

	**这个时候需要看编辑的是否正确？** 这个时候，需要各位编辑检查文中是否有语句不通顺、错别字、统计术语使用不正确等等都可以提出来

1. 在编辑微信的时候，只需要把 md 文件内容复制到 md2all <https://md.aclickall.com/> 的工具里，除了文章开头三个连字符标记的一段内容（也叫 YAML 元数据）， 预览没有问题，就可以点击复制按钮，粘贴到微信公众号的文章编辑区域

	![](https://user-images.githubusercontent.com/12031874/66697099-18e83000-ed05-11e9-8190-d88b0c553948.png)

## 常见编辑问题

1. 主站的图片一般放在 Github Issues 里或者 Github 仓库里

	![](https://user-images.githubusercontent.com/12031874/66697101-18e83000-ed05-11e9-84e7-cbd50a2fce7f.png)

1. 点击编辑按钮，你可以看到图片的网页地址，编辑按钮是右上角三个点的位置，红线圈住的地方

	![](https://user-images.githubusercontent.com/12031874/66697102-1980c680-ed05-11e9-939f-60b5a8025654.png)

1. 图片带标题的可以参考下面这篇文章的 md 文件修改 <https://cosx.org/2017/10/discussion-about-bar-graph/>

1. 文章的栏目分类限制为以下的类别 <https://cosx.org/categories/>

	![](https://user-images.githubusercontent.com/12031874/66697539-0f60c700-ed09-11e9-946d-09b648b0e172.png)

1. Git 的常用操作见 <https://github.com/521xueweihan/git-tips>

1. 推荐在 [Typora](https://www.typora.io/)/Notepad++ 里编辑 Markdown 文本，投稿指南
<https://cosx.org/contribute/> 其实也是 Markdown 编辑指南
