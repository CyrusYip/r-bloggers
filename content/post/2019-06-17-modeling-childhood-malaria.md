---
title: 冈比亚儿童疟疾流行度的空间分布
author: 黄湘云
date: '2019-06-17'
slug: modeling-childhood-malaria
categories:
  - 统计模型
tags:
  - 混合效应模型
  - 空间随机过程
  - 广义线性模型
  - 二项分布
  - 高斯过程
draft: true
---

分析 5 岁以下儿童在非洲冈比亚 65 个村庄的疟疾感染情况， 依冈比亚狭长的地形和横穿东西全境的冈比亚河， 将其看作东、中和西三个部分， 东部是河流上游，西部是河流下游，村庄分为 5 个区域，西部两个， 南岸和北岸各一个，中游一个在南岸，东部两个，也是南岸和北岸各有一个， 村庄的位置在图中以黑圈标记。

[Paulo J. Ribeiro Jr](http://www.leg.ufpr.br/~paulojus/) 和 [Peter J. Diggle](https://www.lancaster.ac.uk/staff/diggle/) 将 Gambia 数据集内置在 geoR 包内，[Barry Rowlingson](https://barry.rowlingson.com/research.html) 分析过 Gambia 数据集。[Ole F. Christensen](http://gbi.agrsci.dk/~ofch/) 和 Paulo J. Ribeiro Jr 将 rongelap 数据集存放在 geoRglm 包内。

```r
library(sp)
library(raster)
## level = 0 对应国界, level = 1 对应省界，以此类推
## 返回 sp 对象
gambia_map <- getData('GADM', country = 'GMB', level = 2) # 市级行政边界数据
gambia_alt <- getData('alt', country = 'GMB', mask = TRUE) # 海拔数据
## GMB 冈比亚地图
png(filename = "Gambia-map.png", width = 1200, height = 1000, res = 200, type = "cairo")
par(mar = c(4.5, 4.5, 0.5, 0.5))
plot(gambia_alt, xlab = "LONGITUDE", ylab = "LATITUDE")
plot(gambia_map, add = TRUE, border = "gray")
dev.off()
```

![Gambia 地形图](https://wp-contents.netlify.com/2019/08/Gambia-map.png)

添加 Gambia 疟疾数据，图中黑色的点为村庄位置

```r
# 或者安装 R 包 geoR 
#library(geoR)
#data(gambia)
#str(gambia)
#head(gambia)
# 加载数据
gambia <- read.table(
  file =
    paste("http://www.leg.ufpr.br/lib/exe/fetch.php",
      "pessoais:paulojus:mbgbook:datasets:gambia.txt",
      sep = "/"
    ), header = TRUE
)
# 冈比亚边界线
gambia_borders <- read.table(
  file =
    paste("http://www.leg.ufpr.br/lib/exe/fetch.php",
      "pessoais:paulojus:mbgbook:datasets:gambia-borders.txt",
      sep = "/"
    ), header = TRUE
)
# 查看下载的数据集
head(gambia)
```
```
         x       y pos  age netuse treated green phc
1 349631.3 1458055   1 1783      0       0 40.85   1
2 349631.3 1458055   0  404      1       0 40.85   1
3 349631.3 1458055   0  452      1       0 40.85   1
4 349631.3 1458055   1  566      1       0 40.85   1
5 349631.3 1458055   0  598      1       0 40.85   1
6 349631.3 1458055   1  590      1       0 40.85   1
```

其中 x 和 y 分别为调查的村庄的横纵坐标，参考系是 UTM，为了保持坐标参考系的一致，方便后续画图呈现，先将坐标转化一下，将 UTM 坐标系转化为 WGS84 坐标系，两个坐标系原理以后介绍，坐标转化代码来自书籍 [Geospatial Health Data: Modeling and Visualization with R-INLA and Shiny](https://paula-moraga.github.io/book-geospatial) 第八章

```r
library(rgdal)
sps <- SpatialPoints(gambia[, c("x", "y")],
  proj4string = CRS("+proj=utm +zone=28")
)
spst <- spTransform(sps, CRS("+proj=longlat +datum=WGS84"))
gambia[, c("long", "lat")] <- coordinates(spst)
# 查看转化坐标后的数据集
head(gambia)
```
```
         x       y pos  age netuse treated green phc      long      lat
1 349631.3 1458055   1 1783      0       0 40.85   1 -16.38755 13.18541
2 349631.3 1458055   0  404      1       0 40.85   1 -16.38755 13.18541
3 349631.3 1458055   0  452      1       0 40.85   1 -16.38755 13.18541
4 349631.3 1458055   1  566      1       0 40.85   1 -16.38755 13.18541
5 349631.3 1458055   0  598      1       0 40.85   1 -16.38755 13.18541
6 349631.3 1458055   1  590      1       0 40.85   1 -16.38755 13.18541
```

最后将村庄的位置呈现在地图上，图中黑色的圆圈就是

```r
library(ggplot2)
png(filename = "Gambia-villages-ggplot2.png", width = 1200, height = 400, res = 200, type = "cairo")
ggplot(fortify(gambia_map), aes(x = long, y = lat)) + 
 geom_polygon(aes(group = group, fill = group), show.legend = FALSE) +
 geom_point(data = gambia, aes(x = long,y = lat)) +
 coord_map()
dev.off()
# 或者
png(filename = "Gambia-villages.png", width = 1200, height = 400, res = 200, type = "cairo")
windows(width = 12, height = 4)
par(mar = c(4.5, 4.5, 0.5, 0.5))
plot(gambia_alt, xlab = "LONGITUDE", ylab = "LATITUDE")
plot(gambia_map, add = TRUE, border = "gray")
points(x = gambia$long, y = gambia$lat)
dev.off()
```

![非洲 Gambia 村庄位置](https://wp-contents.netlify.com/2019/08/Gambia-villages.png)

基于 Peter J. Diggle 等 (2002)  建立如下空间广义线性混合效应模型，记为模型一

`$$
\begin{equation}
\log\{p_{ij}/(1-p_{ij})\} = \alpha + \boldsymbol{\beta}^{\top}z_{ij} + S(x_i)
\end{equation}
$$`

`$\alpha$` 是截距，回归系数向量 `$\boldsymbol{\beta}^{\top} = (\beta_1,\beta_2,\beta_3,\beta_4,\beta_5,\beta_6,\beta_7,\beta_8,\beta_9)$` 各个参数的含义如下表

参数           | 实际意义
:------------- | :-------------
`$\alpha$`     | 截距项
`$\beta_1$`    | 儿童年龄(age)，以天计
`$\beta_2$`    | 蚊帐没有消毒(untreated)
`$\beta_3$`    | 蚊帐消毒(treated)
`$\beta_4$`    | 村庄周围绿植覆盖度(greenness)
`$\beta_5$`    | 村庄是否有医疗中心(PHC)
`$\beta_6$`    | 村庄在2号区域(1号区域作为参考)
`$\beta_7$`    | 村庄在3号区域
`$\beta_8$`    | 村庄在4号区域
`$\beta_9$`    | 村庄在5号区域
 
`$S(x)$` 是平稳空间高斯过程，自协方差函数 `$\mathsf{Cov}(S(x_i),S(x_j)) = \sigma^2\rho(u), u = \|x_i -x_j \|_2$`，自相关函数 `$\rho(u) = \{2^{\kappa -1}\Gamma(\kappa)\}^{-1}(u/\phi)^{\kappa}\mathcal{K}_{\kappa}(u/\phi),u > 0$` 为 Matérn 型，`$Y_{ij} \sim \mathrm{Bernoulli}(p_{ij})$`，其中 `$Y_{ij}$` 表示在第 `$i$` 个村庄的第 `$j$` 个儿童血液中是否含有疟原虫，有就取1，没有就取0，`$p_{ij}$` 是伯努利分布的成功概率，实际含义是儿童携带疟原虫的可能性。

Peter J. Diggle 等 (2002) 使用贝叶斯 MCMC 算法计算模型参数后验估计值，并主要依赖 geoRglm 包实现，计算结果见下表。
 
模型一参数的贝叶斯估计， 估计的 95% 的置信区间端点分别来自后验 2.5% 和97.5% 分位点，第3列和第4列分别是后验均值和中位数

| 参数                  |   2.5%分位点   |   97.5%分位点  |   均值 (mean)  |  中位数 (median)  |
| :-------------------- | :-------------: | :-------------: | :------------: | :---------------: |
| `$\alpha$`              |    -2.966473    |     2.624348    |   -0.131214    |   -0.077961       |
| `$\beta_1$`(age)        |     0.000455    |     0.000933    |    0.000689    |    0.000685       |
| `$\beta_2$`(untreated)  |    -0.673143    |    -0.042011    |   -0.357825    |   -0.359426       |
| `$\beta_3$`(treated)    |    -0.753803    |     0.088418    |   -0.32954     |   -0.325853       |
| `$\beta_4$`(greenness)  |    -0.085675    |     0.047924    |   -0.020068    |   -0.020834       |
| `$\beta_5$`(PHC)        |    -0.787913    |     0.129883    |   -0.344846    |   -0.349915       |
| `$\beta_6$`(area 2)     |    -1.14419     |     0.51023     |   -0.324665    |   -0.331634       |
| `$\beta_7$`(area 3)     |    -1.40862     |     0.558616    |   -0.5321      |   -0.559229       |
| `$\beta_8$`(area 4)     |    -0.109472    |     2.425342    |    1.049441    |    1.016969       |
| `$\beta_9$`(area 5)     |     0.164828    |     2.606357    |    1.309553    |    1.325129       |
| `$\sigma^2$`            |     0.311756    |     1.050227    |    0.585592    |    0.553477       |
| `$\phi$`                |     0.915789    |     10.20069    |    2.522294    |    1.422975       |
| `$\kappa$`              |     0.079522    |     2.784646    |    1.084108    |    0.937436       |

作为对比，在上述模型的基础上添加块金效应 `$U_{i}$`，建立新模型，记为模型二，其中 `$U_{i} \sim \mathcal{N}(0,\nu^2)$`，其它符号含义不变。

`$$
\begin{equation}
\log\{p_{ij}/(1-p_{ij})\} = \alpha + \boldsymbol{\beta}^{\top}z_{ij} + S(x_i) + U_{i}
\end{equation}
$$`

再用 Stan 实现贝叶斯 MCMC 算法估计模型二中的各个参数值，计算结果见下表 。观察到块金效应占比 `$\nu^2 = \tau^2/\sigma^2 = 0.000002$`，是一个很小的值，在实际应用中应该可以忽略。 与模型一不同的是模型二的回归系数向量 `$\boldsymbol{\beta}$` 不包含 `$\beta_6,\ldots,\beta_9$` 四个回归系数，这是因为 geoR 包内的 gambia 数据集缺失与区域有关的标记信息，因此不能复现 Peter J. Diggle 等 (2002) 的结果，但是这里考虑了块金效应。

模型二参数的贝叶斯估计值和 95% 的置信区间，第1至4列依次是后验2.5%、97.5%分位点、后验均值以及后验中位数

| 参数                  |   2.5%分位点   |   97.5%分位点  |   均值 (mean)  |  中位数 (median)  |
| :-------------------- | :-------------: | :-------------: | :------------: | :---------------: |
| `$\alpha$`              |    -4.232073    |     1.114734    |   -1.664353    |   -1.696228       |
| `$\beta_1$`(age)        |     0.000442    |     0.000918    |    0.000677    |    0.000676       |
| `$\beta_2$`(untreated)  |    -0.684407    |    -0.083811    |   -0.383750    |   -0.385772       |
| `$\beta_3$`(treated)    |    -0.778149    |     0.054543    |   -0.355655    |   -0.355632       |
| `$\beta_4$`(greenness)  |    -0.039706    |     0.071505    |   -0.018833    |    0.020079       |
| `$\beta_5$`(PHC)        |    -0.791741    |     0.180737    |   -0.324738    |   -0.322760       |
| `$\nu^2$`               |     0.000002    |     0.515847    |    0.117876    |    0.018630       |
| `$\sigma^2$`            |     0.240826    |     1.662284    |    0.793031    |    0.740790       |
| `$\phi$`                |     1.242164    |     53.351207   |   11.653717    |    7.032258       |
| `$\kappa$`              |     0.150735    |     1.955524    |    0.935064    |    0.830548       |

由于年龄在模型中以天计，所以会发现回归系数 `$\beta_1$` 在两个模型中都很小，

# 参考文献

1. Diggle, Peter and Moyeed, Rana and Rowlingson, Barry and Thomson, Madeleine. 2002. Childhood malaria in the Gambia: a case-study in model-based geostatistics. Journal of the Royal Statistical Society: Series C (Applied Statistics). 51(4):493--506. <http://dx.doi.org/10.1111/1467-9876.00283>

1. Thomson, Madeleine and Connor, Stephen and D'Alessandro, Umberto and Rowlingson, B and Diggle, Peter and Cresswell, Mark and BM, Greenwood. 1999. Predicting malaria infection in Gambian children from satellite data and bednet use surveys: the importance of spatial correlation in the interpretation of results. American Journal of Tropical Medicine and Hygiene, 61(1), 2--8. <https://dx.doi.org/10.4269/ajtmh.1999.61.2>
