---
title: 逻辑斯谛分布和回归
author: 黄湘云
date: '2019-06-19'
slug: logistic-distribution
categories:
  - 统计模型
tags:
  - 逻辑回归
---


目前 R 内置的帮助文档 `?rlogis` 有一个错误，见论坛讨论帖 <https://d.cosx.org/d/420735>，考虑到提交错误的代价，我不妨暂记于此，以作提醒

```r
dlogis(x, location = 0, scale = 1, log = FALSE)
plogis(q, location = 0, scale = 1, lower.tail = TRUE, log.p = FALSE)
qlogis(p, location = 0, scale = 1, lower.tail = TRUE, log.p = FALSE)
rlogis(n, location = 0, scale = 1)
```

分别表示逻辑分布的密度函数、分布函数、分位函数和随机数生成函数。如果函数参数 `location` 或 `scale` 没有指定，则分别取默认值 0 和 1，就是标准的逻辑斯谛分布。为方便起见，我们将逻辑斯谛分布简记为 `$logis(m,s)$`。

其中位置参数为 `location = m` 和尺度参数为 `scale = s`， 分布函数的形式为

`$$
F(x) = \frac{1}{1 + \exp(-\frac{x - m}{s})}
$$`

密度函数的形式为

`$$
f(x) = \frac{\exp(-\frac{x - m}{s})}{s(1 + \exp(-\frac{x-m}{s}))^2}
$$`

logis 分布是一个长尾分布，均值为 `$m$`，方差为 `$\frac{\pi^2}{3}s^2$`

生成 4000 个服从逻辑斯谛分布 `$\mathrm{logis}(0,5)$` 的伪随机数，计算其方差

```r
set.seed(1234)
var(rlogis(4000, 0, scale = 5))
```
```
81.60703
```
```r
pi^2/3 * 5^2
```
```
82.2467
```

样本的密度函数和分布函数分别为

<center class="half">
  <img src="https://wp-contents.netlify.com/2017/06/dlogis.png" width="400"/>
  <img src="https://wp-contents.netlify.com/2017/06/plogis.png" width="400"/>
</center>


```r
# 密度函数
png(filename = "dlogis.png", width = 1200, height = 1000, res = 300, type = "cairo")
set.seed(1234)
par(mar = c(2, 4, 3, 0.1))
x <- rlogis(4000, 0, scale = 5)
hist(x, main = "", xlab = "", probability = T)
lines(density(x), col = "red")
mtext(
  side = 3, line = -3, outer = TRUE,
  text = expression(bolditalic(f)(x) == frac(italic(e)^-frac(x, 5), 5(1 + italic(e)^-frac(x, 5))^2))
)
dev.off()
# 分布函数
png(filename = "plogis.png", width = 1200, height = 1000, res = 300, type = "cairo")
set.seed(1234)
par(mar = c(2, 4, 3, 0.5))
plot(ecdf(rlogis(4000, 0, scale = 5)), main = "", xlab = "")
mtext(
  side = 3, line = -3, outer = TRUE,
  text = expression(bolditalic(F)(x) == frac(1, 1 + italic(e)^-frac(x, 5)))
)
dev.off()
```

伯努利分布，也称0-1分布，如表所示

|  0  |   1   |
| :-: | :---: |
| `$p$` | `$1-p$` |

二项分布即 `$n$` 重伯努利分布

`$$Y \sim \mathrm{Binomial}(p)$$`
`$$\log\{\frac{p}{1-p}\} = \beta_0 + \beta_1 * X$$`

模拟观察值

```r
set.seed(2018)
n <- 1000 # 样本量
x <- rnorm(n)  
beta_0 <- 0.5
beta_1 <- 0.3
log.p <- beta_0 + beta_1 * x 
y <- rbinom(n, 1 , prob = exp(beta_0 + beta_1 * x)/(1 + exp(beta_0 + beta_1 * x))) 
```

将模拟数据绘图

```r
plot(y ~ x)
```

估计参数

```r
glm.binomial <- glm(y ~ x, family = binomial(link = "logit"))
summary(glm.binomial)
```
```
Call:
glm(formula = y ~ x, family = binomial(link = "logit"))

Deviance Residuals: 
    Min       1Q   Median       3Q      Max  
-1.7531  -1.3164   0.8515   0.9792   1.3314  

Coefficients:
            Estimate Std. Error z value Pr(>|z|)    
(Intercept)  0.51302    0.06617   7.753 8.94e-15 ***
x            0.31110    0.06658   4.673 2.97e-06 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 1325.2  on 999  degrees of freedom
Residual deviance: 1302.6  on 998  degrees of freedom
AIC: 1306.6

Number of Fisher Scoring iterations: 4
```

预测

```r
y_pred <- predict.glm(glm.binomial,type = "response")
head(y_pred)
plot(y ~ x)
points(y_pred ~ x, col = 'red')
```
