---
title: 网络数据可视化
author: 黄湘云
date: '2019-08-08'
slug: network-data-visualization
categories:
  - 统计图形
tags:
  - 网络数据可视化
  - ggplot2
  - Rgraphviz
  - igraph 
  - DiagrammeR
description: "网络数据可视化，介绍 Rgraphviz, igraph 和 DiagrammeR 的简答使用"
---


## 安装


```r
BiocManager::install(pkgs = "graph")
```

4个节点，给定邻接矩阵，即可画出关系图

```r
library(graph)
mat <- matrix(c(
  0, 0, 1, 1,
  0, 0, 1, 1,
  1, 1, 0, 1,
  1, 1, 1, 0
), byrow = TRUE, ncol = 4)
rownames(mat) <- letters[1:4]
colnames(mat) <- letters[1:4]
g1 <- graphAM(adjMat = mat)
plot(g1)
```

![graph-01](https://user-images.githubusercontent.com/12031874/67205314-193da500-f442-11e9-834f-2617220aa084.png)

randomGraph 生成一个随机图

```r
set.seed(123)
V <- letters[1:10] # 图的定点
M <- 1:4 # 
g2 <- randomGraph(V, M, p = 0.2)
numEdges(g2) # 边的个数
```
```
[1] 16
```
```r
edgeNames(g2) # 边的名字，无向图顶点之间用 ~ 连接
```

```
 [1] "a~b" "a~d" "a~e" "a~f" "a~h" "b~f" "b~d" "b~e" "b~h" "c~h" "d~e" "d~f"
[13] "d~h" "e~f" "e~h" "f~h"
```
```r
plot(g2)
```

![graph-02](https://user-images.githubusercontent.com/12031874/67205315-193da500-f442-11e9-88c8-e053a35a2168.png)

换个布局

```r
plot(g2, "neato")
```

![graph-03](https://user-images.githubusercontent.com/12031874/67205319-19d63b80-f442-11e9-83c8-6c68b1793526.png)

```r
plot(g2, "twopi")
```

![graph-04](https://user-images.githubusercontent.com/12031874/67205321-19d63b80-f442-11e9-88e0-b783d3daa5f7.png)
