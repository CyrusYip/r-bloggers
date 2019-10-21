---
title: 自定义样条插值
author: 黄湘云
date: '2019-08-10'
slug: spline-in-ggplot2
categories:
  - 统计模型
tags:
  - gglot2
  - 样条
description: "自定义样条插值"
---

# 源起

源起于统计之都论坛 [帖子](https://d.cosx.org/d/420602)，轩哥给出了一个完美方案，我潜水学习了一下，下面把学习的成果分享出来。

`geom_smooth` 支持哪些平滑手段，样条回归，常见样条有哪些，举一个常用的样条例子详加介绍

可以用 `spline()` 造一个插值的方法给 ggplot。

```r
myspline <- function(formula, data, ...)
{
  dat = model.frame(formula, data)
  res = splinefun(dat[[2]], dat[[1]])
  class(res) = "myspline"
  res
}

predict.myspline <- function(object, newdata, ...)
{
  object(newdata[[1]])
}

library(ggplot2)
set.seed(123)
dat = data.frame(xx = runif(100, -5, 5))
dat$yy = sin(dat$xx)

ggplot(dat, aes(x = xx, y = yy)) +
  geom_point() +
  geom_smooth(method = myspline, se = FALSE)
```   
    
![spline-in-ggplot](https://user-images.githubusercontent.com/12031874/67205003-5b1a1b80-f441-11e9-8668-16f96a24f993.png)
