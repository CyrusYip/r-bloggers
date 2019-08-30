---
title: 喀麦隆及周边地区盘尾丝虫病的空间分布
author: 黄湘云
date: '2019-07-25'
slug: modeling-cameroon-loaloa
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

盘尾丝虫病是由一种可致盲的热带疾病，非洲盘尾丝虫病控制项目 APOC (African Programme for Onchocerciasis Control) 搜集了 `$N=168$` 个村庄的 `$M = 21938$` 个血液样本，每个村庄抽取的样本量为`$m_i=\mathrm{NO\_EXAM}$`，其中感染了的 NO_INF 人， 在该村庄（坐标 `$x_i$`）观察到的感染比例 `$p(x_i) = \mathrm{NO\_INF/NO\_EXAM}$` ， 在村庄 1 公里的范围内添加了周围环境的指标，有从美国地质调查局获得的海拔信息 ELEVATION (<https://www.usgs.gov/>) 和卫星在 1999 年至 2001 年间测得的植被绿色度数据 NDVI (<http://free.vgt.vito.be>)，NDVI 分四个指标， 分别是所有 NDVI 的平均值 MEAN9901，最大值 MAX9901，最小值 MIN9901，标准差 STDEV9901。 样本采集的区域如图所示

```{r loaloa-map,fig.asp=1,fig.cap="红色加号标注样本所在的村庄"}
library(sp)
library(raster)
# CMR  喀麦隆及其周边地区地图
cmr_map <- getData('GADM', country='CMR', level = 1) # 省界
# getData('ISO3') # 国家代码
cmr_alt <- getData('alt', country='CMR', mask=TRUE) 
# alt 是 altitude （海拔）的缩写 函数返回 raster 类型数据对象
png(filename = "cameroon-elevation.png", width = 1200, height = 1000, res = 200, type = "cairo")
par(mar = c(4, 4, 0.5, 2))
plot(cmr_alt, xlab = "LONGITUDE", ylab = "LATITUDE")
plot(cmr_map, add = TRUE, border = "gray")
dev.off()
```

![喀麦隆地形图](https://wp-contents.netlify.com/2019/08/cameroon-elevation.png)

```r
loaloa <- read.table(
  file =
    paste("http://www.leg.ufpr.br/lib/exe/fetch.php",
      "pessoais:paulojus:mbgbook:datasets:loaloa.txt",
      sep = "/"
    )
)
colnames(loaloa) <- c("long", "lat", "NO_EXAM", "NO_INF", "ELEVATION", "MAX9901", "STDEV9901")

par(mar = c(4, 4, 0.5, 2))
plot(cmr_alt, xlab = "LONGITUDE", ylab = "LATITUDE")
plot(cmr_map, add = TRUE, border = "gray")
```

村庄没有人感染应该是常见的，而全部感染确实罕见的，如果后者发生了，那太可怕了！此外，村庄里感染的比例高达 20% 以上的视为严重级别，一定要采取医疗措施的，即相当于临界水平，跨过去就相当危险！据此，将观测的感染比例，划分为以下几个等级。

```r
range(loaloa$NO_INF/loaloa$NO_EXAM)
[1] 0.00000 0.53125
```
```r
loaloa$class <- cut(loaloa$NO_INF / loaloa$NO_EXAM,
  breaks = c(0, 0.05, 0.15, 0.25, 0.35, 0.45, 0.55, 1),
  right = FALSE, ordered = TRUE
)
```

将抽样调查获得的数据，即将观测到的村庄感染人数的比例添加到地图上

```r
with(loaloa, {
  points(x = long, y = lat, pch = 16,
  col = hcl.colors(7, rev = TRUE)[class])
})
legend("topleft", col = hcl.colors(7, rev = TRUE), pch = 16, 
       legend = levels(loaloa$class), title = "Infection rate")
# 或者
library(ggplot2)
ggplot(fortify(cmr_map), aes(x = long, y = lat)) + 
 geom_polygon(aes(group = group, fill = group), show.legend = FALSE)
```

![喀麦隆及其周边地区村庄感染的比例](https://wp-contents.netlify.com/2019/08/cameroon-infection-rate.png)

为了分析 loaloa 数据集，我们建立响应变量 `$Y$` 服从二项分布的空间广义线性混合效应模型

`$$
\begin{equation*}
\begin{split}
\log\big\{ \frac{ p(x_i)}{ 1-p(x_i)} \big\} = 
               & \beta_{0} + \beta_{1} \times \mathrm{ELEVATION}_{i} + \beta_{2} \times \mathrm{MEAN9901}_{i} + \beta_{3} \times \mathrm{MAX9901}_{i} + \\
               & \beta_{4} \times \mathrm{MIN9901}_{i} +  \beta_{5} \times \mathrm{STDEV9901}_{i} + S(x_{i})
\end{split}
\end{equation*}
$$`

其中，`$\beta_0$` 是截距，`$\beta_{1},\beta_{2}, \beta_{3},\beta_{4}, \beta_{5}$` 是各指标的系数，`$Y_{i} \sim \mathrm{Binomial}(m_{i},p(x_i))$`，平稳空间高斯过程 `$\mathcal{S} = S(x), x = ( \mathrm{LONGITUDE}, \mathrm{LATITUDE}) \in \mathbb{R}^2$` 的均值为 0，自协方差函数为

`$$
\mathrm{Cov}(S(x_i),S(x_j)) = \sigma^2 \big\{2^{\kappa-1}\Gamma(\kappa)\big\}^{-1}(u_{ij}/\phi)^{\kappa}K_{\kappa}(u_{ij}/\phi), \kappa = 2
$$`

在实际数据分析中，选择一组合适的初始值可以缩短各算法迭代的过程。我们分两步获取 `$\beta = (\beta_{0},\beta_{1},\beta_{2}, \beta_{3},\beta_{4}, \beta_{5})$` 和 `$\boldsymbol{\theta} = (\sigma^2,\phi)$` 的初始值。第一步，离散自协方差函数中的 `$\kappa$`，再调用 **PrevMap** 包中的 `shape.matern` 函数选择一个 `$\kappa$`；第二步，在去掉空间效应 `$S(x)$` 的情况下，以广义线性模型拟合数据得到 `$\beta$`的初始估计值。





然后分别使用贝叶斯 MCMC 算法和贝叶斯 STAN-MCMC 算法估计参数 `$\beta = (\beta_{0},\beta_{1},\beta_{2}, \beta_{3},\beta_{4}, \beta_{5})$` 和 `$\boldsymbol{\theta} = (\sigma^2,\phi)$`，结果如表所示。

MCML 算法估计模型的参数

| 参数        | 估计        | 标准差      |   标准误    |
| :---------: | :--------:  | :---------: | :------:    |
| `$\beta_{0}$` | -11.120     | 1.447       | 8.268e-03   |
| `$\beta_{1}$` | -0.001      | 3.155e-04   | 1.023e-05   |
| `$\beta_{2}$` | 13.513      | 2.223       | 4.877e-02   |
| `$\beta_{3}$` | 1.454       | 2.013       | 3.094e-02   |
| `$\beta_{4}$` | -0.576      | 1.315       | 1.016e-02   |
| `$\beta_{5}$` | 11.216      | 5.181       | 5.321e-02   |
| `$\sigma^2$`  | 1.171       | 0.272       | 1.300e-03   |
| `$\phi$`      | 0.486       | 0.353       | 2.344e-03   |

通过表的 P 值，可以看出 `$\beta_{0},\beta_{1},\beta_{2}$` 是显著的，分别对应模型的截距项，海拔 (ELEVATION)和 NDVI 的平均值 (MEAN9901)，在这组数据中，刻画 NDVI 指标使用平均值比较能体现村庄周围植被的整体绿色度，而最大值 MAX9901，最小值 MIN9901，标准差 STDEV9901 与影响不显著。

贝叶斯 MCMC 算法估计模型的参数

| 参数        | 估计        | 标准差      |   均方误差  |
| :---------: | :--------:  | :---------: | :------:    |
| `$\beta_{0}$` | -11.562     | 0.681       | 5.563e-03   |
| `$\beta_{1}$` | -8.721e-04  | 1.415e-04   | 1.155e-06   |
| `$\beta_{2}$` | 8.426       | 2.064       | 1.686e-02   |
| `$\beta_{3}$` | 4.857       | 1.334       | 1.090e-02   |
| `$\beta_{4}$` | 0.233       | 1.367       | 1.116e-02   |
| `$\beta_{5}$` | 11.087      | 3.565       | 2.911e-02   |
| `$\sigma^2$`  | 1.096       | 0.170       | 1.390e-03   |
| `$\phi$`      | 3.675       | 0.582       | 4.754e-03   |

贝叶斯 STAN-MCMC 算法估计模型的参数

| 参数        | 估计        | 标准差      |   均方误差  |
| :---------: | :--------:  | :---------: | :------:    |
| `$\beta_{0}$` | -12.878     | 1.460       | 3.515e-03   |
| `$\beta_{1}$` | -6.596e-04  | 3.188e-04   | 7.733e-07   |
| `$\beta_{2}$` | 9.647       | 2.136       | 5.222e-03   |
| `$\beta_{3}$` | 4.380       | 1.993       | 5.026e-03   |
| `$\beta_{4}$` | -0.102      | 1.159       | 2.822e-03   |
| `$\beta_{5}$` | 11.216      | 5.539       | 1.343e-02   |
| `$\sigma^2$`  | 1.027       | 0.09        | 2.171e-04   |
| `$\phi$`      | 1.157e-02   | 1.292e-03   | 3.244e-06   |

发现贝叶斯 STAN-MCMC 算法比贝叶斯 MCMC 算法稍好一点， 多半的参数估计的标准差要小一些， 均方误差普遍要小一点。

# 参考文献

1. P. J. Diggle and M. C. Thomson and O. F. Christensen and B. Rowlingson and V. Obsomer and J. Gardon and S. Wanji and I. Takougang and P. Enyong and J. Kamgno and J. H. Remme and M. Boussinesq and D. H. Molyneux. 2007. Spatial modelling and the prediction of Loa loa risk: decision making under uncertainty. Annals of Tropical Medicine and Parasitology, 101(6):499--509. <https://www.tandfonline.com/doi/abs/10.1179/136485913X13789813917463>

1. Ciprian M Crainiceanu and Peter J Diggle and Barry Rowlingson. 2008. Bivariate Binomial Spatial Modeling of Loa loa Prevalence in Tropical Africa. Journal of the American Statistical Association, 103(481):21--37. <https://doi.org/10.1198/016214507000001409>

1. Schlüter, Daniela K and Ndeffo-Mbah, Martial L and Takougang, Innocent and Ukety, Tony and Wanji, Samuel and Galvani, Alison P and Diggle, Peter J. 2016. Using Community-Level Prevalence of Loa loa Infection to Predict the Proportion of Highly-Infected Individuals: Statistical Modelling to Support Lymphatic Filariasis and Onchocerciasis Elimination Programs. Plos Neglected Tropical Diseases. 10(12):e0005157. <https://doi.org/10.1371/journal.pntd.0005157>
