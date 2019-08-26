---
title: 伽马函数、伽马分布和斯特林公式
author: 黄湘云
date: '2019-08-20'
slug: gamma-stirling
categories:
  - 统计模型
tags:
  - 伽马函数
  - 伽马分布
  - R 语言
  - 特殊函数
  - 统计分布
  - 斯特林公式
---

## 伽马函数

伽马函数是由一个不定积分定义的

`$$
\Gamma(\alpha) = \int_{0}^{\infty} t^{\alpha-1}e^{-t}dt
$$`

我们通过分部积分的方式计算 `$\Gamma(\alpha + 1)$`

`$$
\begin{align}
\Gamma(\alpha + 1) &= \int_{0}^{\infty} t^{\alpha}e^{-t}dt \\
&= t^{\alpha}(-e^{-t})|_{0}^{\infty} - \int_{0}^{\infty}(-e^{-t})(\alpha t^{\alpha-1}dt) \\
&= (0-0) + \alpha \int_{0}^{\infty}t^{\alpha-1}e^{-t}dt \\
&= \alpha\Gamma(\alpha)
\end{align}
$$`

我们容易验证 `$\Gamma(1) = \int_{0}^{\infty}e^{-t} = 1$`，而且 `$\Gamma(2) = 1 \times \Gamma(1) = 1$`，`$\Gamma(3) = 2\Gamma(2) = 2$`，更一般地，`$\Gamma(k+1) = k!$`，对任意正整数都成立。当 `$\alpha \leq 0$` 时，`$\Gamma(\alpha)$` 趋于 `$\infty$` 要求更多数学工具才能计算。而取有理数时， `$\Gamma(1/2) = \sqrt{\pi}$`

当 `$\alpha$` 趋于无穷时，根据 Stirling 公式

`$$
\lim_{\alpha \rightarrow \infty} \frac{\Gamma(\alpha + 1)}{\alpha^{\alpha+1}e^{-\alpha}} = \sqrt{2\pi}
$$`

## 尺度变换 rescale

令 `$s = at$`，则 `$ds = adt$`，然后有 

`$$
\int_{0}^{\infty} t^{\alpha -1}e^{-at} dt = \int_{0}^{\infty} (s/a)^{\alpha -1}e^{s}(ds/a) = a^{-\alpha}\int_{0}^{\infty} s^{\alpha -1}e^{-s} ds = \Gamma(\alpha)/a^{\alpha} 
$$`

## 计算

在 R 语言中，伽马函数的计算由函数 `gamma(x)` 完成，参数 x 可以是数值型的向量

```r
gamma(x = 0.5)
sqrt(pi)
```
```
[1] 1.772
```

函数 `lgamma(x)` 返回 `$\ln(|\Gamma(x)|)$` 的值，即伽马函数绝对值的自然对数。函数 `digamma(x)` 和`trigamma(x)` 分别计算伽马函数的对数的一阶和二阶导数。

`$$
\mathrm{digamma}(x) = \Psi(x) = \frac{d}{dx}\ln\Gamma(x) = \frac{\Gamma'(x)}{\Gamma(x)}
$$`

函数 `psigamma(x, deriv) (deriv >= 0)` 计算 `$\Psi(x)$` 的 `deriv` 阶导数

```r
digamma(x = 0.5)
```
```
[1] -1.964
```


## 伽马分布

```r
# 概率密度函数值
dgamma(x, shape, rate = 1, scale = 1/rate, log = FALSE)
# 概率分布函数值
pgamma(q, shape, rate = 1, scale = 1/rate, lower.tail = TRUE,
       log.p = FALSE)
# 概率分位函数值
qgamma(p, shape, rate = 1, scale = 1/rate, lower.tail = TRUE,
       log.p = FALSE)
# 产生服从伽马分布的随机数
rgamma(n, shape, rate = 1, scale = 1/rate)
```

`x,q`
: 分位数向量，一组分位数值

`p`
: 概率向量，一组概率值

`n`
: 观测值的个数，样本量

`rate`
: 指定 scale 的替代方式

`shape, scale`
: 形状和尺度参数。必须是正数

`log,log.p`
: 逻辑值。如果是 `TRUE`，概率/密度 `$p$` 取对数后返回，即 `$\log(p)$`

`lower.tail`
: 逻辑值。如果是 `TRUE`（默认），概率是 `$P(X \leq x)$`，否则 `$P(X > x)$`


如果参数 `scale` 省略，默认为 1。参数为 `shape = a` 和 `scale = s` 的伽马分布，其密度函数形式如下

`$$
f(x) = \frac{1}{s^a \Gamma(a)} x^{a-1}e^{-\frac{x}{s}}
$$`

其中 `$x \geq 0, a > 0, s > 0$`，`$\Gamma(a)$` 由 R 函数 `gamma()` 计算。 `$a = 0$` 对应伽马分布为 `$f(x) = \frac{1}{\Gamma(0)}x^{-1}e^{-\frac{x}{s}}$`，其中 `$\Gamma(0) = \int_{0}^{\infty} t^{-1}e^{-t}dt$`

> Note that `$a = 0$` corresponds to the **trivial distribution** with all mass at point 0.

服从伽马分布的随机变量 `$X$` 的均值为 `$\mathsf{E}(X) = a*s$` 方差为 `$\mathsf{Var}(X) = a*s^2$`，累积风险函数 `$H(t) = - \log(1- F(t))$` 是

```r
-pgamma(t, ..., lower = FALSE, log = TRUE)
```

> Note that for smallish values of `shape` (and moderate `scale`) a large parts of the mass of the Gamma distribution is on values of `x` so near zero that they will be represented as zero in computer arithmetic. So `rgamma` may well return values which will be represented as zero. (This will also happen for very large values of `scale` since the actual generation is done for `scale = 1`.)


## 参考文献

1. R 软件内置帮助文档 `?gamma`
1. 靳志辉.神奇的伽玛函数 (上).2014. <https://cosx.org/2014/07/gamma-function-1>
1. 靳志辉.神奇的伽玛函数 (下).2014. <https://cosx.org/2014/07/gamma-function-2>
