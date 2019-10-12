---
title: "CPU Performance Analysis 翻译：CPU 性能分析"
author: "黄湘云"
date: "2019-10-12"
categories:
  - 统计模型
tags:
  - 统计学习
  - 回归问题
slug: cpu-performance-analysis
toc: yes
---

> 本文翻译自 Suraj Vidyadaran 的 <https://github.com/surajvv12/cpu_performance>

# 数据集描述

摘要: Relative CPU Performance Data, described in terms of its cycle time, memory size, etc

数据集信息:

The estimated relative performance values were estimated by the authors using a linear regression method. See their article (pp 308-313) for more details on how the relative performance values were set.

属性信息:

1. vendor name: 30 
(adviser, amdahl,apollo, basf, bti, burroughs, c.r.d, cambex, cdc, dec, 
dg, formation, four-phase, gould, honeywell, hp, ibm, ipl, magnuson, 
microdata, nas, ncr, nixdorf, perkin-elmer, prime, siemens, sperry, 
sratus, wang) 
2. Model Name: many unique symbols 
3. MYCT: machine cycle time in nanoseconds (integer) 
4. MMIN: minimum main memory in kilobytes (integer) 
5. MMAX: maximum main memory in kilobytes (integer) 
6. CACH: cache memory in kilobytes (integer) 
7. CHMIN: minimum channels in units (integer) 
8. CHMAX: maximum channels in units (integer) 
9. PRP: published relative performance (integer) 
10. ERP: estimated relative performance from the original article (integer)

# 加载数据


```r
machine <- read.csv("./machine.data.txt", header = FALSE)
colnames(machine) <- c(
  "vendor_name", "model_name", "myct", "mmin",
  "mmax", "cach", "chmin", "chmax", "prp", "erp"
)
head(machine)
```

```
##   vendor_name model_name myct mmin  mmax cach chmin chmax prp erp
## 1     adviser      32/60  125  256  6000  256    16   128 198 199
## 2      amdahl     470v/7   29 8000 32000   32     8    32 269 253
## 3      amdahl    470v/7a   29 8000 32000   32     8    32 220 253
## 4      amdahl    470v/7b   29 8000 32000   32     8    32 172 253
## 5      amdahl    470v/7c   29 8000 16000   32     8    16 132 132
## 6      amdahl     470v/b   26 8000 32000   64     8    32 318 290
```

# 探索性分析


```r
str(machine)
```

```
## 'data.frame':	209 obs. of  10 variables:
##  $ vendor_name: chr  "adviser" "amdahl" "amdahl" "amdahl" ...
##  $ model_name : chr  "32/60" "470v/7" "470v/7a" "470v/7b" ...
##  $ myct       : int  125 29 29 29 29 26 23 23 23 23 ...
##  $ mmin       : int  256 8000 8000 8000 8000 8000 16000 16000 16000 32000..
##  $ mmax       : int  6000 32000 32000 32000 16000 32000 32000 32000 64000..
##  $ cach       : int  256 32 32 32 32 64 64 64 64 128 ...
##  $ chmin      : int  16 8 8 8 8 8 16 16 16 32 ...
##  $ chmax      : int  128 32 32 32 16 32 32 32 32 64 ...
##  $ prp        : int  198 269 220 172 132 318 367 489 636 1144 ...
##  $ erp        : int  199 253 253 253 132 290 381 381 749 1238 ...
```

```r
summary(machine)
```

```
##  vendor_name         model_name             myct           mmin      
##  Length:209         Length:209         Min.   :  17   Min.   :   64  
##  Class :character   Class :character   1st Qu.:  50   1st Qu.:  768  
##  Mode  :character   Mode  :character   Median : 110   Median : 2000  
##                                        Mean   : 204   Mean   : 2868  
##                                        3rd Qu.: 225   3rd Qu.: 4000  
##                                        Max.   :1500   Max.   :32000  
##       mmax            cach           chmin          chmax      
##  Min.   :   64   Min.   :  0.0   Min.   : 0.0   Min.   :  0.0  
##  1st Qu.: 4000   1st Qu.:  0.0   1st Qu.: 1.0   1st Qu.:  5.0  
##  Median : 8000   Median :  8.0   Median : 2.0   Median :  8.0  
##  Mean   :11796   Mean   : 25.2   Mean   : 4.7   Mean   : 18.3  
##  3rd Qu.:16000   3rd Qu.: 32.0   3rd Qu.: 6.0   3rd Qu.: 24.0  
##  Max.   :64000   Max.   :256.0   Max.   :52.0   Max.   :176.0  
##       prp            erp        
##  Min.   :   6   Min.   :  15.0  
##  1st Qu.:  27   1st Qu.:  28.0  
##  Median :  50   Median :  45.0  
##  Mean   : 106   Mean   :  99.3  
##  3rd Qu.: 113   3rd Qu.: 101.0  
##  Max.   :1150   Max.   :1238.0
```

```r
which(is.na(machine))
```

```
## integer(0)
```


```r
# Top 10 High performance machine
top_10 <- machine[, c(1, 2, 9)]
top_10$Computer <- paste(top_10$vendor_name, top_10$model_name, sep = ":")
top_10 <- top_10[order(-top_10$prp), ]
top_10_performance <- top_10[1:10, ]
```



```r
library(ggplot2)
ggplot(top_10_performance, aes(x = reorder(Computer, prp), y = prp)) +
  geom_bar(stat = "identity", fill = "#56B4E9") +
  coord_flip() +
  geom_text(aes(label = prp), size = 5) +
  ylab("Published relative performance of machine") +
  xlab("Machine Name") +
  ggtitle("Top 10 High performance machines")
```

![unnamed-chunk-4-1](https://user-images.githubusercontent.com/12031874/66704056-71422080-ed4b-11e9-87d5-89e970115c99.png)


```r
# Top 20 High performance Machine
top_20_performance <- top_10_performance <- top_10[1:20, ]
ggplot(top_20_performance, aes(x = reorder(Computer, prp), y = prp)) +
  geom_bar(stat = "identity", fill = "#56B4E9") +
  coord_flip() +
  geom_text(aes(label = prp), size = 5) +
  ylab("Published relative performance of machine") +
  xlab("Machine Name") +
  ggtitle("Top 20 High performance machines")
```


![unnamed-chunk-5-1](https://user-images.githubusercontent.com/12031874/66704058-71dab700-ed4b-11e9-9945-916412aafb2e.png)

# 相关性分析


```r
library(PerformanceAnalytics)
```

```
## Loading required package: xts
```

```
## Loading required package: zoo
```

```
## 
## Attaching package: 'zoo'
```

```
## The following objects are masked from 'package:base':
## 
##     as.Date, as.Date.numeric
```

```
## Registered S3 method overwritten by 'xts':
##   method     from
##   as.zoo.xts zoo
```

```
## 
## Attaching package: 'PerformanceAnalytics'
```

```
## The following objects are masked from 'package:e1071':
## 
##     kurtosis, skewness
```

```
## The following object is masked from 'package:graphics':
## 
##     legend
```

```r
corr <- machine[, 3:9]
chart.Correlation(corr, histogram = TRUE, pch = 19)
```

![unnamed-chunk-6-1](https://user-images.githubusercontent.com/12031874/66704059-71dab700-ed4b-11e9-8eb4-f18a85c04111.png)

# 回归分析

# A)Linear Regression 线性回归

## 1)Ordinary Least Squares Regression 普通最小二乘


```r
# Create Model
model1 <- lm(prp ~ myct + mmin + mmax + cach + chmin + chmax, data = machine)

# Summary of the model
summary(model1)
```

```
## 
## Call:
## lm(formula = prp ~ myct + mmin + mmax + cach + chmin + chmax, 
##     data = machine)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -195.8  -25.2    5.4   26.5  385.7 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -5.59e+01   8.05e+00   -6.95  5.0e-11 ***
## myct         4.89e-02   1.75e-02    2.79   0.0058 ** 
## mmin         1.53e-02   1.83e-03    8.37  9.4e-15 ***
## mmax         5.57e-03   6.42e-04    8.68  1.3e-15 ***
## cach         6.41e-01   1.40e-01    4.60  7.6e-06 ***
## chmin       -2.70e-01   8.56e-01   -0.32   0.7524    
## chmax        1.48e+00   2.20e-01    6.74  1.6e-10 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 60 on 202 degrees of freedom
## Multiple R-squared:  0.865,	Adjusted R-squared:  0.861 
## F-statistic:  216 on 6 and 202 DF,  p-value: <2e-16
```

```r
# Make Predictions
machine$pred_prp_lm <- predict(model1, newdata = machine)

# Root Mean Squared Error
rmse <- function(y, f) {
  sqrt(mean((y - f)^2))
}
rmse(machine$prp, machine$pred_prp_lm)
```

```
## [1] 58.98
```

```r
# Plot the prediction

ggplot(machine, aes(x = pred_prp_lm, y = prp)) +
  geom_point(alpha = 0.5, color = "black", aes(x = pred_prp_lm)) +
  geom_smooth(aes(x = pred_prp_lm, y = prp), color = "#56B4E9") +
  geom_line(aes(x = prp, y = prp), color = "blue", linetype = 2) +
  xlab("Predicted Performance") +
  ylab("Published performance") +
  ggtitle("Linear regression Analysis of Computer Performance")
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```

![unnamed-chunk-7-1](https://user-images.githubusercontent.com/12031874/66704060-72734d80-ed4b-11e9-96e4-af603ee00718.png)

## 2)Stepwise Linear Regression 逐步回归


```r
# Create Model
model2 <- lm(prp ~ myct + mmin + mmax + cach + chmin + chmax, data = machine)
# Summary of the model
summary(model2)
```

```
## 
## Call:
## lm(formula = prp ~ myct + mmin + mmax + cach + chmin + chmax, 
##     data = machine)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -195.8  -25.2    5.4   26.5  385.7 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -5.59e+01   8.05e+00   -6.95  5.0e-11 ***
## myct         4.89e-02   1.75e-02    2.79   0.0058 ** 
## mmin         1.53e-02   1.83e-03    8.37  9.4e-15 ***
## mmax         5.57e-03   6.42e-04    8.68  1.3e-15 ***
## cach         6.41e-01   1.40e-01    4.60  7.6e-06 ***
## chmin       -2.70e-01   8.56e-01   -0.32   0.7524    
## chmax        1.48e+00   2.20e-01    6.74  1.6e-10 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 60 on 202 degrees of freedom
## Multiple R-squared:  0.865,	Adjusted R-squared:  0.861 
## F-statistic:  216 on 6 and 202 DF,  p-value: <2e-16
```

```r
# Perform step wise feature selection
fit <- step(model2)
```

```
## Start:  AIC=1718
## prp ~ myct + mmin + mmax + cach + chmin + chmax
## 
##         Df Sum of Sq    RSS  AIC
## - chmin  1       359 727279 1716
## <none>               726920 1718
## - myct   1     27985 754905 1724
## - cach   1     76009 802929 1737
## - chmax  1    163347 890267 1759
## - mmin   1    252179 979099 1778
## - mmax   1    271177 998097 1782
## 
## Step:  AIC=1716
## prp ~ myct + mmin + mmax + cach + chmax
## 
##         Df Sum of Sq    RSS  AIC
## <none>               727279 1716
## - myct   1     28343 755623 1722
## - cach   1     78715 805995 1736
## - chmax  1    177114 904393 1760
## - mmin   1    258252 985531 1778
## - mmax   1    270856 998135 1781
```

```r
# Summarize the selected model
summary(fit)
```

```
## 
## Call:
## lm(formula = prp ~ myct + mmin + mmax + cach + chmax, data = machine)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -193.4  -24.9    5.8   26.6  389.7 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -56.07502    8.00675   -7.00  3.6e-11 ***
## myct          0.04911    0.01746    2.81   0.0054 ** 
## mmin          0.01518    0.00179    8.49  4.3e-15 ***
## mmax          0.00556    0.00064    8.69  1.2e-15 ***
## cach          0.62982    0.13437    4.69  5.1e-06 ***
## chmax         1.45988    0.20763    7.03  3.1e-11 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 59.9 on 203 degrees of freedom
## Multiple R-squared:  0.865,	Adjusted R-squared:  0.861 
## F-statistic:  260 on 5 and 203 DF,  p-value: <2e-16
```

```r
# Make Predictions
machine$pred_prp_step_lm <- predict(fit, newdata = machine)

# Root Mean Squared Error
rmse(machine$prp, machine$pred_prp_step_lm)
```

```
## [1] 58.99
```

## 3)Principal Component Regression 主成分回归


```r
library(pls)
```

```
## 
## Attaching package: 'pls'
```

```
## The following object is masked from 'package:caret':
## 
##     R2
```

```
## The following object is masked from 'package:stats':
## 
##     loadings
```

```r
# Create Model
model3 <- pcr(prp ~ myct + mmin + mmax + cach + chmin + chmax, data = machine, validation = "CV")

# Summary of the model
summary(model3)
```

```
## Data: 	X dimension: 209 6 
## 	Y dimension: 209 1
## Fit method: svdpc
## Number of components considered: 6
## 
## VALIDATION: RMSEP
## Cross-validated using 10 random segments.
##        (Intercept)  1 comps  2 comps  3 comps  4 comps  5 comps  6 comps
## CV           161.2    82.56    80.47    80.33    71.71    66.64    68.27
## adjCV        161.2    82.34    80.09    79.94    71.23    66.24    67.77
## 
## TRAINING: % variance explained
##      1 comps  2 comps  3 comps  4 comps  5 comps  6 comps
## X      96.03    99.96   100.00   100.00   100.00   100.00
## prp    76.25    79.13    79.27    84.53    86.47    86.49
```

```r
# Make Predictions
machine$pred_prp_pcr <- predict(model3, newdata = machine, ncomp = 6)
# Root Mean Squared Error
rmse(machine$prp, machine$pred_prp_pcr)
```

```
## [1] 58.98
```

## 4)Partial Least Squares Regression 偏最小二乘回归


```r
# Create Model
model4 <- plsr(prp ~ myct + mmin + mmax + cach + chmin + chmax, data = machine, validation = "CV")

# Summary of the model
summary(model4)
```

```
## Data: 	X dimension: 209 6 
## 	Y dimension: 209 1
## Fit method: kernelpls
## Number of components considered: 6
## 
## VALIDATION: RMSEP
## Cross-validated using 10 random segments.
##        (Intercept)  1 comps  2 comps  3 comps  4 comps  5 comps  6 comps
## CV           161.2    79.71    77.76    76.75    68.36    66.35    68.03
## adjCV        161.2    79.62    77.51    76.60    67.98    65.95    67.53
## 
## TRAINING: % variance explained
##      1 comps  2 comps  3 comps  4 comps  5 comps  6 comps
## X      96.02    99.96   100.00   100.00   100.00   100.00
## prp    76.48    79.13    79.61    85.61    86.48    86.49
```

```r
# Make Predictions
machine$pred_prp_plsr <- predict(model4, newdata = machine, ncomp = 6)

# Root Mean Squared Error
rmse(machine$prp, machine$pred_prp_plsr)
```

```
## [1] 58.98
```

# B)Penalized Linear regression 惩罚线性回归

## 1)Ridge Regression 岭回归


```r
library(glmnet)
```

```
## Loading required package: Matrix
```

```
## Loading required package: foreach
```

```
## Loaded glmnet 2.0-18
```

```r
x <- as.matrix(machine[, 3:8])
y <- as.matrix(machine[, 9])

# Create Model
model5 <- glmnet(x, y, family = "gaussian", alpha = 0, lambda = 0.001)

# Summary of the model
summary(model5)
```

```
##           Length Class     Mode   
## a0        1      -none-    numeric
## beta      6      dgCMatrix S4     
## df        1      -none-    numeric
## dim       2      -none-    numeric
## lambda    1      -none-    numeric
## dev.ratio 1      -none-    numeric
## nulldev   1      -none-    numeric
## npasses   1      -none-    numeric
## jerr      1      -none-    numeric
## offset    1      -none-    logical
## call      6      -none-    call   
## nobs      1      -none-    numeric
```

```r
# Make Predictions
machine$pred_prp_ridge_reg <- predict(model5, x, type = "link")

# Root Mean Squared Error
rmse(machine$prp, machine$pred_prp_ridge_reg)
```

```
## [1] 58.98
```

## 2)Least Absolute Shrinkage and Selection Operator (LASSO) regression LASSO 回归


```r
library(lars)
```

```
## Loaded lars 1.2
```

```r
x <- as.matrix(machine[, 3:8])
y <- as.matrix(machine[, 9])

# Create Model
model6 <- lars(x, y, type = "lasso")

# Summary of the model
summary(model6)
```

```
## LARS/LASSO
## Call: lars(x = x, y = y, type = "lasso")
##   Df     Rss      Cp
## 0  1 5380237 1288.09
## 1  2 3192630  682.18
## 2  3 2107836  382.74
## 3  4 1763844  289.15
## 4  5  773222   15.87
## 5  6  727512    5.16
## 6  7  726920    7.00
```

```r
# Select a step with minimum error

best_step <- model6$df[which.min(model6$RSS)]

# Make Predictions
machine$pred_prp_lasso <- predict(model6, x, s = best_step, type = "fit")$fit

# Root Mean Squared Error
rmse(machine$prp, machine$pred_prp_lasso)
```

```
## [1] 58.98
```

## 3)Elastic Net 弹性网络算法


```r
# Create Model
model7 <- glmnet(x, y, family = "gaussian", alpha = 0.5, lambda = 0.001)

# Summary of the model
summary(model7)
```

```
##           Length Class     Mode   
## a0        1      -none-    numeric
## beta      6      dgCMatrix S4     
## df        1      -none-    numeric
## dim       2      -none-    numeric
## lambda    1      -none-    numeric
## dev.ratio 1      -none-    numeric
## nulldev   1      -none-    numeric
## npasses   1      -none-    numeric
## jerr      1      -none-    numeric
## offset    1      -none-    logical
## call      6      -none-    call   
## nobs      1      -none-    numeric
```

```r
# Make Predictions

machine$pred_prp_elastic_net <- predict(model7, x, type = "link")

# Root Mean Squared Error
rmse(machine$prp, machine$pred_prp_elastic_net)
```

```
## [1] 58.98
```

# C)Non-Linear Regression 非线性回归

## 1)Multivariate Adaptive Regression Splines (MARS) 多元自适应样条回归


```r
library(earth)
```

```
## Loading required package: Formula
```

```
## Loading required package: plotmo
```

```
## Loading required package: plotrix
```

```
## Loading required package: TeachingDemos
```

```
## 
## Attaching package: 'TeachingDemos'
```

```
## The following object is masked from 'package:klaR':
## 
##     triplot
```

```r
# Create Model
model8 <- earth(prp ~ myct + mmin + mmax + cach + chmin + chmax, data = machine)

# Summary of the model
summary(model8)
```

```
## Call: earth(formula=prp~myct+mmin+mmax+cach+chmin+chmax, data=machine)
## 
##               coefficients
## (Intercept)        252.160
## h(38-myct)           2.221
## h(mmin-2000)         0.011
## h(mmin-8000)         0.006
## h(24000-mmax)       -0.002
## h(mmax-24000)        0.011
## h(cach-65)           1.340
## h(128-cach)         -0.868
## h(cach-128)         -2.344
## h(chmax-24)         -6.343
## h(chmax-32)          6.747
## h(chmax-52)         -7.733
## h(64-chmax)         -1.472
## h(chmax-64)          9.896
## 
## Selected 14 of 16 terms, and 5 of 6 predictors
## Termination condition: Reached nk 21
## Importance: mmax, cach, mmin, chmax, myct, chmin-unused
## Number of terms at each degree of interaction: 1 13 (additive model)
## GCV 1587    RSS 251568    GRSq 0.9389    RSq 0.9532
```

```r
# Summarize the importance of the input variables
evimp(model8)
```

```
##       nsubsets   gcv    rss
## mmax        13 100.0  100.0
## cach        12  41.9   42.9
## mmin        11  21.2   23.5
## chmax       10  12.8   16.3
## myct         3   3.5    6.5
```

```r
# Make Predictions
machine$pred_prp_mars <- predict(model8, newdata = machine)

# Root Mean Squared Error
rmse(machine$prp, machine$pred_prp_mars)
```

```
## [1] 34.69
```

## 2)Support Vector Machine 支持向量机回归


```r
library(kernlab)

# Create Model
model9 <- ksvm(prp ~ myct + mmin + mmax + cach + chmin + chmax, data = machine)

# Summary of the model
summary(model9)
```

```
## Length  Class   Mode 
##      1   ksvm     S4
```

```r
# Make Predictions
machine$pred_prp_svm <- predict(model9, newdata = machine)

# Root Mean Squared Error
rmse(machine$prp, machine$pred_prp_svm)
```

```
## [1] 88.2
```

```r
# Plot the prediction
ggplot(machine, aes(x = pred_prp_svm, y = prp)) +
  geom_point(alpha = 0.5, color = "black") +
  geom_smooth(aes(x = pred_prp_svm, y = prp), color = "#56B4E9") +
  geom_line(aes(x = prp, y = prp), color = "blue", linetype = 2) +
  xlab("Predicted Performance") +
  ylab("Published performance") +
  ggtitle("Support Vector Machine regression Analysis of Computer Performance")
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```

![unnamed-chunk-15-1](https://user-images.githubusercontent.com/12031874/66704061-72734d80-ed4b-11e9-888e-cfb4a3845ca4.png)

## 3)k-Nearest Neighbor K 近邻回归


```r
library(caret)

# Create Model
model10 <- knnreg(x, y, k = 3)

# Summary of the model
summary(model10)
```

```
##         Length Class  Mode   
## learn   2      -none- list   
## k       1      -none- numeric
## theDots 0      -none- list
```

```r
# Make Predictions
machine$pred_prp_knn <- predict(model10, x)

# Root Mean Squared Error
rmse(machine$prp, machine$pred_prp_knn)
```

```
## [1] 40.82
```

```r
# Plot the prediction
ggplot(machine, aes(x = pred_prp_knn, y = prp)) +
  geom_point(alpha = 0.5, color = "black") +
  geom_smooth(aes(x = pred_prp_knn, y = prp), color = "#56B4E9") +
  geom_line(aes(x = prp, y = prp), color = "blue", linetype = 2) +
  xlab("Predicted Performance") +
  ylab("Published performance") +
  ggtitle("Knn regression Analysis of Computer Performance")
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```

![unnamed-chunk-16-1](https://user-images.githubusercontent.com/12031874/66704062-730be400-ed4b-11e9-96e4-6c4098e7eb16.png)

## 4)Neural Network 神经网络


```r
library(nnet)

# Create Model
model11 <- nnet(prp ~ myct + mmin + mmax + cach + chmin + chmax,
  data = machine, size = 12, maxit = 500, linout = T, decay = 0.01
)
```

```
## # weights:  97
## initial  value 7688356.038539 
## iter  10 value 4790572.200063
## iter  20 value 4706918.645915
## iter  30 value 4500186.901237
## iter  40 value 4454766.017071
## iter  50 value 2999550.718244
## iter  60 value 2390162.384419
## iter  70 value 2342347.822074
## iter  80 value 2338564.872461
## iter  90 value 2302790.255602
## iter 100 value 2260422.713866
## iter 110 value 2256253.645096
## iter 120 value 2136459.610145
## iter 130 value 2126609.727695
## iter 140 value 2101817.781097
## iter 150 value 2082884.366803
## iter 160 value 2018251.014520
## iter 170 value 1900641.439437
## iter 180 value 1890290.873859
## iter 190 value 1875291.387449
## iter 200 value 1838745.167596
## iter 210 value 1828731.648735
## iter 220 value 1816038.249258
## iter 230 value 1017415.413065
## iter 240 value 691198.918712
## iter 250 value 527719.753669
## iter 260 value 481660.077269
## iter 270 value 410511.715960
## iter 280 value 385301.959348
## iter 290 value 369822.881175
## iter 300 value 326128.661313
## iter 310 value 322769.552350
## iter 320 value 317519.138995
## iter 330 value 312762.349156
## iter 340 value 297951.395176
## iter 350 value 287453.284596
## iter 360 value 269360.043208
## iter 370 value 268951.875251
## iter 380 value 268828.806727
## iter 390 value 268804.431013
## iter 400 value 268788.251213
## iter 410 value 268583.739791
## iter 420 value 268557.441608
## iter 430 value 268441.623574
## iter 440 value 264943.831850
## iter 450 value 264431.045898
## iter 460 value 262228.054114
## iter 470 value 261916.809292
## iter 480 value 261915.876660
## final  value 261911.411134 
## converged
```

```r
# Summary of the model
summary(model11)
```

```
## a 6-12-1 network with 97 weights
## options were - linear output units  decay=0.01
##   b->h1  i1->h1  i2->h1  i3->h1  i4->h1  i5->h1  i6->h1 
##    1.02  -29.60    0.56   -0.17    4.17   -6.78    6.85 
##   b->h2  i1->h2  i2->h2  i3->h2  i4->h2  i5->h2  i6->h2 
##   35.61    0.30    0.25   -0.05  -11.54   22.57   10.46 
##   b->h3  i1->h3  i2->h3  i3->h3  i4->h3  i5->h3  i6->h3 
##    0.00    0.00   -0.03   -0.23    0.00    0.00    0.00 
##   b->h4  i1->h4  i2->h4  i3->h4  i4->h4  i5->h4  i6->h4 
##   -0.01   -2.48   -0.51   -2.71    0.00   -0.01    0.00 
##   b->h5  i1->h5  i2->h5  i3->h5  i4->h5  i5->h5  i6->h5 
##    0.00    2.88    1.27    3.13    0.00    0.00    0.01 
##   b->h6  i1->h6  i2->h6  i3->h6  i4->h6  i5->h6  i6->h6 
##    0.00    0.13    0.14    0.20    0.01    0.00    0.00 
##   b->h7  i1->h7  i2->h7  i3->h7  i4->h7  i5->h7  i6->h7 
##   -0.01   -0.24   -0.44    0.44    0.53    0.01    0.16 
##   b->h8  i1->h8  i2->h8  i3->h8  i4->h8  i5->h8  i6->h8 
##   -3.72    0.00    0.00    0.00    0.00    0.00    0.01 
##   b->h9  i1->h9  i2->h9  i3->h9  i4->h9  i5->h9  i6->h9 
##   -0.17   -5.22   -5.54    0.84    1.23   -0.36   -0.89 
##  b->h10 i1->h10 i2->h10 i3->h10 i4->h10 i5->h10 i6->h10 
##    0.00   -0.07   -0.08   -0.18    0.00    0.00    0.00 
##  b->h11 i1->h11 i2->h11 i3->h11 i4->h11 i5->h11 i6->h11 
##    0.00   -0.02   -0.02   -0.09    0.00    0.00    0.00 
##  b->h12 i1->h12 i2->h12 i3->h12 i4->h12 i5->h12 i6->h12 
##   -0.36  -23.40   -0.09    0.02   11.10    6.20   10.64 
##    b->o   h1->o   h2->o   h3->o   h4->o   h5->o   h6->o   h7->o   h8->o 
##   15.88   82.72  -38.52    0.09    5.73   13.03   15.88   10.60 1083.28 
##   h9->o  h10->o  h11->o  h12->o 
##  -17.58    0.01    0.15   69.38
```

```r
# Make Predictions
x <- machine[, 3:8]
y <- machine[, 7]

machine$pred_prp_nnet <- predict(model11, x, type = "raw")

# Root Mean Squared Error
rmse(machine$prp, machine$pred_prp_nnet)
```

```
## [1] 34.59
```

```r
# Plot the prediction
ggplot(machine, aes(x = pred_prp_nnet, y = prp)) +
  geom_point(alpha = 0.5, color = "black") +
  geom_smooth(aes(x = pred_prp_nnet, y = prp), color = "#56B4E9") +
  geom_line(aes(x = prp, y = prp), color = "blue", linetype = 2) +
  xlab("Predicted Performance") +
  ylab("Published performance") +
  ggtitle("Neural Network regression Analysis of Computer Performance")
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```

![unnamed-chunk-17-1](https://user-images.githubusercontent.com/12031874/66704063-730be400-ed4b-11e9-8f07-3b68d158d52f.png)

# D)Decision Trees for Regression 决策树回归
## 1)Classification and Regression Trees (CART) 分类回归树


```r
library(rpart)

# Create Model
model12 <- rpart(prp ~ myct + mmin + mmax + cach + chmin + chmax,
  data = machine, control = rpart.control(minsplit = 5)
)

# Summary of the model
summary(model12)
```

```
## Call:
## rpart(formula = prp ~ myct + mmin + mmax + cach + chmin + chmax, 
##     data = machine, control = rpart.control(minsplit = 5))
##   n= 209 
## 
##        CP nsplit rel error xerror    xstd
## 1 0.55491      0   1.00000 1.0131 0.31803
## 2 0.24341      1   0.44509 0.6360 0.14610
## 3 0.04317      2   0.20168 0.2867 0.05164
## 4 0.04158      3   0.15851 0.2620 0.04990
## 5 0.01655      4   0.11693 0.2003 0.04375
## 6 0.01244      5   0.10039 0.1923 0.04353
## 7 0.01000      6   0.08795 0.1650 0.04106
## 
## Variable importance
##  mmax chmax  mmin  myct chmin  cach 
##    54    19    11     6     5     4 
## 
## Node number 1: 209 observations,    complexity param=0.5549
##   mean=105.6, MSE=2.574e+04 
##   left son=2 (205 obs) right son=3 (4 obs)
##   Primary splits:
##       mmax  < 48000 to the left,  improve=0.5549, (0 missing)
##       mmin  < 6620  to the left,  improve=0.4716, (0 missing)
##       chmin < 7.5   to the left,  improve=0.4429, (0 missing)
##       cach  < 56    to the left,  improve=0.4376, (0 missing)
##       myct  < 49    to the right, improve=0.4253, (0 missing)
##   Surrogate splits:
##       chmax < 152   to the left,  agree=0.99, adj=0.5, (0 split)
## 
## Node number 2: 205 observations,    complexity param=0.2434
##   mean=88.93, MSE=1.082e+04 
##   left son=4 (178 obs) right son=5 (27 obs)
##   Primary splits:
##       mmax  < 22480 to the left,  improve=0.5905, (0 missing)
##       chmin < 7.5   to the left,  improve=0.5635, (0 missing)
##       cach  < 40    to the left,  improve=0.5157, (0 missing)
##       mmin  < 6620  to the left,  improve=0.4947, (0 missing)
##       myct  < 49    to the right, improve=0.4814, (0 missing)
##   Surrogate splits:
##       mmin  < 6620  to the left,  agree=0.927, adj=0.444, (0 split)
##       myct  < 36.5  to the right, agree=0.898, adj=0.222, (0 split)
##       chmin < 14    to the left,  agree=0.893, adj=0.185, (0 split)
##       cach  < 151   to the left,  agree=0.873, adj=0.037, (0 split)
## 
## Node number 3: 4 observations
##   mean=961.2, MSE=4.424e+04 
## 
## Node number 4: 178 observations,    complexity param=0.04158
##   mean=57.8, MSE=2871 
##   left son=8 (141 obs) right son=9 (37 obs)
##   Primary splits:
##       cach  < 27    to the left,  improve=0.4377, (0 missing)
##       chmin < 7.5   to the left,  improve=0.3236, (0 missing)
##       myct  < 79.5  to the right, improve=0.2656, (0 missing)
##       mmax  < 14000 to the left,  improve=0.2326, (0 missing)
##       mmin  < 1155  to the left,  improve=0.2213, (0 missing)
##   Surrogate splits:
##       chmin < 7.5   to the left,  agree=0.860, adj=0.324, (0 split)
##       mmin  < 3550  to the left,  agree=0.848, adj=0.270, (0 split)
##       myct  < 45    to the right, agree=0.820, adj=0.135, (0 split)
##       mmax  < 18480 to the left,  agree=0.803, adj=0.054, (0 split)
## 
## Node number 5: 27 observations,    complexity param=0.04317
##   mean=294.1, MSE=1.471e+04 
##   left son=10 (21 obs) right son=11 (6 obs)
##   Primary splits:
##       mmin  < 12000 to the left,  improve=0.5849, (0 missing)
##       cach  < 56    to the left,  improve=0.4886, (0 missing)
##       chmin < 14    to the left,  improve=0.4287, (0 missing)
##       myct  < 44    to the right, improve=0.2094, (0 missing)
##       chmax < 22    to the left,  improve=0.1794, (0 missing)
##   Surrogate splits:
##       myct  < 24.5  to the right, agree=0.852, adj=0.333, (0 split)
##       chmin < 14    to the left,  agree=0.815, adj=0.167, (0 split)
## 
## Node number 8: 141 observations
##   mean=39.64, MSE=694 
## 
## Node number 9: 37 observations,    complexity param=0.01655
##   mean=127, MSE=5121 
##   left son=18 (31 obs) right son=19 (6 obs)
##   Primary splits:
##       cach  < 96.5  to the left,  improve=0.4699, (0 missing)
##       mmax  < 3810  to the right, improve=0.4200, (0 missing)
##       myct  < 27    to the right, improve=0.2972, (0 missing)
##       chmax < 9     to the left,  improve=0.1976, (0 missing)
##       chmin < 7     to the left,  improve=0.1600, (0 missing)
##   Surrogate splits:
##       mmax  < 7000  to the right, agree=0.946, adj=0.667, (0 split)
##       chmax < 59    to the left,  agree=0.892, adj=0.333, (0 split)
##       myct  < 27    to the right, agree=0.865, adj=0.167, (0 split)
##       mmin  < 1655  to the right, agree=0.865, adj=0.167, (0 split)
## 
## Node number 10: 21 observations,    complexity param=0.01244
##   mean=244.6, MSE=7175 
##   left son=20 (5 obs) right son=21 (16 obs)
##   Primary splits:
##       chmin < 7     to the left,  improve=0.4440, (0 missing)
##       cach  < 56    to the left,  improve=0.4252, (0 missing)
##       mmin  < 3000  to the left,  improve=0.2171, (0 missing)
##       myct  < 98.5  to the right, improve=0.1877, (0 missing)
##       chmax < 79    to the left,  improve=0.1693, (0 missing)
##   Surrogate splits:
##       myct < 98.5  to the right, agree=0.905, adj=0.6, (0 split)
##       mmin < 3000  to the left,  agree=0.857, adj=0.4, (0 split)
## 
## Node number 11: 6 observations
##   mean=467.7, MSE=2365 
## 
## Node number 18: 31 observations
##   mean=105.4, MSE=2116 
## 
## Node number 19: 6 observations
##   mean=238.5, MSE=5806 
## 
## Node number 20: 5 observations
##   mean=143.6, MSE=609.8 
## 
## Node number 21: 16 observations
##   mean=276.1, MSE=5045
```

```r
# Make Predictions
machine$pred_prp_cart <- predict(model12, x)

# Root Mean Squared Error
rmse(machine$prp, machine$pred_prp_cart)
```

```
## [1] 47.58
```

```r
# Plot the prediction
ggplot(machine, aes(x = pred_prp_cart, y = prp)) +
  geom_point(alpha = 0.5, color = "black") +
  geom_smooth(aes(x = pred_prp_cart, y = prp), color = "#56B4E9") +
  geom_line(aes(x = prp, y = prp), color = "blue", linetype = 2) +
  xlab("Predicted Performance") +
  ylab("Published performance") +
  ggtitle("CART Decision Tree regression Analysis of Computer Performance")
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```

```
## Warning in simpleLoess(y, x, w, span, degree = degree, parametric =
## parametric, : pseudoinverse used at 35.03
```

```
## Warning in simpleLoess(y, x, w, span, degree = degree, parametric =
## parametric, : neighborhood radius 70.389
```

```
## Warning in simpleLoess(y, x, w, span, degree = degree, parametric =
## parametric, : reciprocal condition number 1.2834e-030
```

```
## Warning in simpleLoess(y, x, w, span, degree = degree, parametric =
## parametric, : There are other near singularities as well. 4327.1
```

```
## Warning in predLoess(object$y, object$x, newx = if
## (is.null(newdata)) object$x else if (is.data.frame(newdata))
## as.matrix(model.frame(delete.response(terms(object)), : pseudoinverse used
## at 35.03
```

```
## Warning in predLoess(object$y, object$x, newx = if
## (is.null(newdata)) object$x else if (is.data.frame(newdata))
## as.matrix(model.frame(delete.response(terms(object)), : neighborhood radius
## 70.389
```

```
## Warning in predLoess(object$y, object$x, newx = if
## (is.null(newdata)) object$x else if (is.data.frame(newdata))
## as.matrix(model.frame(delete.response(terms(object)), : reciprocal
## condition number 1.2834e-030
```

```
## Warning in predLoess(object$y, object$x, newx = if
## (is.null(newdata)) object$x else if (is.data.frame(newdata))
## as.matrix(model.frame(delete.response(terms(object)), : There are other
## near singularities as well. 4327.1
```

![unnamed-chunk-18-1](https://user-images.githubusercontent.com/12031874/66704064-73a47a80-ed4b-11e9-82b5-c71449b2a58c.png)

## 2)Conditional Decision Trees 条件决策树


```r
library(party)
```

```
## Loading required package: grid
```

```
## Loading required package: mvtnorm
```

```
## Loading required package: modeltools
```

```
## 
## Attaching package: 'modeltools'
```

```
## The following object is masked from 'package:kernlab':
## 
##     prior
```

```
## Loading required package: strucchange
```

```
## Loading required package: sandwich
```

```r
# Create Model
model13 <- ctree(prp ~ myct + mmin + mmax + cach + chmin + chmax,
  data = machine,
  controls = ctree_control(minsplit = 2, minbucket = 2, testtype = "Univariate")
)

# Summary of the model
summary(model13)
```

```
##     Length      Class       Mode 
##          1 BinaryTree         S4
```

```r
# Make Predictions
machine$pred_prp_cdt <- predict(model13, x)

# Root Mean Squared Error
rmse(machine$prp, machine$pred_prp_cdt)
```

```
## [1] 40.74
```

## 3)Model Trees 模型树


```r
library(RWeka)

# Create Model
model14 <- M5P(prp ~ myct + mmin + mmax + cach + chmin + chmax, data = machine)

# Summary of the model
summary(model14)
```

```
## 
## === Summary ===
## 
## Correlation coefficient                 -0.7869
## Mean absolute error                    809.1862
## Root mean squared error               2175.3662
## Relative absolute error                843.6451 %
## Root relative squared error           1355.8286 %
## Total Number of Instances              209
```

```r
# Make Predictions
machine$pred_prp_mt <- predict(model14, x)

# Root Mean Squared Error
rmse(machine$prp, machine$pred_prp_mt)
```

```
## [1] 2175
```

```r
# Plot the prediction
ggplot(machine, aes(x = pred_prp_mt, y = prp)) +
  geom_point(alpha = 0.5, color = "black") +
  geom_smooth(aes(x = pred_prp_mt, y = prp), color = "#56B4E9") +
  geom_line(aes(x = prp, y = prp), color = "blue", linetype = 2) +
  xlab("Predicted Performance") +
  ylab("Published performance") +
  ggtitle("Model tree Decision Tree regression Analysis of Computer Performance")
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```

![unnamed-chunk-20-1](https://user-images.githubusercontent.com/12031874/66704065-73a47a80-ed4b-11e9-9d23-d86bb4b8176b.png)

## 4)Rule System 规则系统


```r
# Create Model
model15 <- M5Rules(prp ~ myct + mmin + mmax + cach + chmin + chmax, data = machine)

# Summary of the model
summary(model15)
```

```
## 
## === Summary ===
## 
## Correlation coefficient                  0.8984
## Mean absolute error                     38.3157
## Root mean squared error                 73.5126
## Relative absolute error                 39.9474 %
## Root relative squared error             45.8178 %
## Total Number of Instances              209
```

```r
# Make Predictions
machine$pred_prp_rs <- predict(model15, x)

# Root Mean Squared Error
rmse(machine$prp, machine$pred_prp_rs)
```

```
## [1] 73.51
```

```r
# Plot the prediction
ggplot(machine, aes(x = pred_prp_rs, y = prp)) +
  geom_point(alpha = 0.5, color = "black") +
  geom_smooth(aes(x = pred_prp_rs, y = prp), color = "#56B4E9") +
  geom_line(aes(x = prp, y = prp), color = "blue", linetype = 2) +
  xlab("Predicted Performance") +
  ylab("Published performance") +
  ggtitle("Rule System  Decision Tree regression Analysis of Computer Performance")
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```

![unnamed-chunk-21-1](https://user-images.githubusercontent.com/12031874/66704066-743d1100-ed4b-11e9-9a20-5673fbf0b48f.png)

## 5)Bagging CART 装袋 CART 


```r
library(ipred)

# Create Model
model16 <- bagging(prp ~ myct + mmin + mmax + cach + chmin + chmax, 
                   data = machine, control = rpart.control(minsplit = 5))

# Summary of the model
summary(model16)
```

```
##        Length Class      Mode   
## y      209    -none-     numeric
## X        6    data.frame list   
## mtrees  25    -none-     list   
## OOB      1    -none-     logical
## comb     1    -none-     logical
## call     4    -none-     call
```

```r
# Make Predictions
machine$pred_prp_bagging <- predict(model16, x)

# Root Mean Squared Error
rmse(machine$prp, machine$pred_prp_bagging)
```

```
## [1] 41.7
```

```r
# Plot the prediction
ggplot(machine, aes(x = pred_prp_bagging, y = prp)) +
  geom_point(alpha = 0.5, color = "black") +
  geom_smooth(aes(x = pred_prp_bagging, y = prp), color = "#56B4E9") +
  geom_line(aes(x = prp, y = prp), color = "blue", linetype = 2) +
  xlab("Predicted Performance") +
  ylab("Published performance") +
  ggtitle("Bagging CART Decision Tree regression Analysis of Computer Performance")
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```

![unnamed-chunk-22-1](https://user-images.githubusercontent.com/12031874/66704067-743d1100-ed4b-11e9-8c75-8317be0cf95d.png)

## 6)Random Forest 随机森林


```r
library(randomForest)

# Create Model
model17 <- randomForest(prp ~ myct + mmin + mmax + cach + chmin + chmax, data = machine)

# Summary of the model
summary(model17)
```

```
##                 Length Class  Mode     
## call              3    -none- call     
## type              1    -none- character
## predicted       209    -none- numeric  
## mse             500    -none- numeric  
## rsq             500    -none- numeric  
## oob.times       209    -none- numeric  
## importance        6    -none- numeric  
## importanceSD      0    -none- NULL     
## localImportance   0    -none- NULL     
## proximity         0    -none- NULL     
## ntree             1    -none- numeric  
## mtry              1    -none- numeric  
## forest           11    -none- list     
## coefs             0    -none- NULL     
## y               209    -none- numeric  
## test              0    -none- NULL     
## inbag             0    -none- NULL     
## terms             3    terms  call
```

```r
# Make Predictions
machine$pred_prp_random_forest <- predict(model17, x)

# Root Mean Squared Error
rmse(machine$prp, machine$pred_prp_random_forest)
```

```
## [1] 30.46
```

```r
# Plot the prediction
ggplot(machine, aes(x = pred_prp_random_forest, y = prp)) +
  geom_point(alpha = 0.5, color = "black") +
  geom_smooth(aes(x = pred_prp_random_forest, y = prp), color = "#56B4E9") +
  geom_line(aes(x = prp, y = prp), color = "blue", linetype = 2) +
  xlab("Predicted Performance") +
  ylab("Published performance") +
  ggtitle("Random Forest Decision Tree regression Analysis of Computer Performance")
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```

![unnamed-chunk-23-1](https://user-images.githubusercontent.com/12031874/66704068-74d5a780-ed4b-11e9-9b79-3713a6a5eb84.png)

## 7)Gradient Boosted Machine 梯度提升机


```r
library(gbm)

# Create Model
model18 <- gbm(prp ~ myct + mmin + mmax + cach + chmin + chmax,
  data = machine, distribution = "gaussian", n.minobsinnode = 1
)

# Summary of the model
summary(model18)
```

![unnamed-chunk-24-1](https://user-images.githubusercontent.com/12031874/66704069-74d5a780-ed4b-11e9-9649-6578ef947fe8.png)

```
##         var rel.inf
## mmax   mmax  62.593
## cach   cach  14.115
## mmin   mmin   9.683
## myct   myct   5.997
## chmin chmin   4.009
## chmax chmax   3.603
```

```r
# Make Predictions
machine$pred_prp_gbm <- predict(model18, x, n.trees = 1)

# Root Mean Squared Error
rmse(machine$prp, machine$pred_prp_gbm)
```

```
## [1] 151.6
```

```r
# Plot the prediction
ggplot(machine, aes(x = pred_prp_gbm, y = prp)) +
  geom_point(alpha = 0.5, color = "black") +
  geom_smooth(aes(x = pred_prp_gbm, y = prp), color = "#56B4E9") +
  geom_line(aes(x = prp, y = prp), color = "blue", linetype = 2) +
  xlab("Predicted Performance") +
  ylab("Published performance") +
  ggtitle("Gradient Boosted Machine Decision Tree regression Analysis of Computer Performance")
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```

```
## Warning in simpleLoess(y, x, w, span, degree = degree, parametric =
## parametric, : at 102.25
```

```
## Warning in simpleLoess(y, x, w, span, degree = degree, parametric =
## parametric, : radius 0.19578
```

```
## Warning in simpleLoess(y, x, w, span, degree = degree, parametric =
## parametric, : all data on boundary of neighborhood. make span bigger
```

```
## Warning in simpleLoess(y, x, w, span, degree = degree, parametric =
## parametric, : pseudoinverse used at 102.25
```

```
## Warning in simpleLoess(y, x, w, span, degree = degree, parametric =
## parametric, : neighborhood radius 0.44248
```

```
## Warning in simpleLoess(y, x, w, span, degree = degree, parametric =
## parametric, : reciprocal condition number 1
```

```
## Warning in simpleLoess(y, x, w, span, degree = degree, parametric =
## parametric, : There are other near singularities as well. 7909.9
```

```
## Warning in simpleLoess(y, x, w, span, degree = degree, parametric =
## parametric, : zero-width neighborhood. make span bigger
```

```
## Warning: Computation failed in `stat_smooth()`:
## NA/NaN/Inf in foreign function call (arg 5)
```

![unnamed-chunk-24-2](https://user-images.githubusercontent.com/12031874/66704070-756e3e00-ed4b-11e9-96a4-a29b1f668766.png)

## 8)Cubist


```r
library(Cubist)

# Create Model
model19 <- cubist(x, y)

# Summary of the model
summary(model19)
```

```
## 
## Call:
## cubist.default(x = x, y = y)
## 
## 
## Cubist [Release 2.07 GPL Edition]  Sat Oct 12 16:52:48 2019
## ---------------------------------
## 
##     Target attribute `outcome'
## 
## Read 209 cases (7 attributes) from undefined.data
## 
## Model:
## 
##   Rule 1: [209 cases, mean 4.7, range 0 to 52, est err 0.0]
## 
## 	outcome = 0 + 1 chmin
## 
## 
## Evaluation on training data (209 cases):
## 
##     Average  |error|                0.0
##     Relative |error|               0.00
##     Correlation coefficient        1.00
## 
## 
## 	Attribute usage:
## 	  Conds  Model
## 
## 	         100%    chmin
## 
## 
## Time: 0.0 secs
```

```r
# Make Predictions
machine$pred_prp_cubist <- predict(model19, x)

# Root Mean Squared Error
rmse(machine$prp, machine$pred_prp_cubist)
```

```
## [1] 186.1
```

```r
# Plot the prediction
ggplot(machine, aes(x = pred_prp_cubist, y = prp)) +
  geom_point(alpha = 0.5, color = "black") +
  geom_smooth(aes(x = pred_prp_cubist, y = prp), color = "#56B4E9") +
  geom_line(aes(x = prp, y = prp), color = "blue", linetype = 2) +
  xlab("Predicted Performance") +
  ylab("Published performance") +
  ggtitle("Cubist Decision Tree regression Analysis of Computer Performance")
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```

![unnamed-chunk-25-1](https://user-images.githubusercontent.com/12031874/66704072-756e3e00-ed4b-11e9-8ed3-5f2d907a59d9.png)

## 软件环境


```r
sessionInfo()
```

```
## R Under development (unstable) (2019-10-05 r77257)
## Platform: x86_64-w64-mingw32/x64 (64-bit)
## Running under: Windows 8.1 x64 (build 9600)
## 
## Matrix products: default
## 
## locale:
## [1] LC_COLLATE=Chinese (Simplified)_China.936 
## [2] LC_CTYPE=Chinese (Simplified)_China.936   
## [3] LC_MONETARY=Chinese (Simplified)_China.936
## [4] LC_NUMERIC=C                              
## [5] LC_TIME=Chinese (Simplified)_China.936    
## 
## attached base packages:
##  [1] grid      splines   stats4    stats     graphics  grDevices utils    
##  [8] datasets  methods   base     
## 
## other attached packages:
##  [1] Cubist_0.2.2               party_1.3-3               
##  [3] strucchange_1.5-1          sandwich_2.5-1            
##  [5] modeltools_0.2-22          mvtnorm_1.0-11            
##  [7] earth_5.1.1                plotmo_3.5.5              
##  [9] TeachingDemos_2.10         plotrix_3.7-6             
## [11] Formula_1.2-3              lars_1.2                  
## [13] glmnet_2.0-18              foreach_1.4.7             
## [15] Matrix_1.2-17              pls_2.7-2                 
## [17] PerformanceAnalytics_1.5.3 xts_0.11-2                
## [19] zoo_1.8-6                  C50_0.1.2                 
## [21] gbm_2.1.5                  randomForest_4.6-14       
## [23] ipred_0.9-9                RWeka_0.4-40              
## [25] rpart_4.1-15               e1071_1.7-2               
## [27] kernlab_0.9-27             nnet_7.3-12               
## [29] klaR_0.6-14                mda_0.4-10                
## [31] class_7.3-15               MASS_7.3-51.4             
## [33] caret_6.0-84               ggplot2_3.2.1             
## [35] lattice_0.20-38            VGAM_1.1-1                
## 
## loaded via a namespace (and not attached):
##  [1] readxl_1.3.1       backports_1.1.5    plyr_1.8.4        
##  [4] igraph_1.2.4.1     lazyeval_0.2.2     TH.data_1.0-10    
##  [7] odbc_1.1.6         digest_0.6.21      htmltools_0.4.0   
## [10] magrittr_1.5       memoise_1.1.0      clickhouse_0.0.2  
## [13] recipes_0.1.7      readr_1.3.1        modelr_0.1.5      
## [16] gower_0.2.1        matrixStats_0.55.0 colorspace_1.4-1  
## [19] blob_1.2.0         rvest_0.3.4        haven_2.1.1       
## [22] xfun_0.10          dplyr_0.8.3        crayon_1.3.4      
## [25] jsonlite_1.6       libcoin_1.0-5      zeallot_0.1.0     
## [28] survival_2.44-1.1  iterators_1.0.12   glue_1.3.1        
## [31] gtable_0.3.0       questionr_0.7.0    scales_1.0.0      
## [34] DBI_1.0.0          miniUI_0.1.1.1     Rcpp_1.0.2        
## [37] xtable_1.8-4       bit_1.1-14         lava_1.6.6        
## [40] prodlim_2018.04.18 htmlwidgets_1.5.1  httr_1.4.1        
## [43] DataExplorer_0.8.0 pkgconfig_2.0.3    rJava_0.9-11      
## [46] tidyselect_0.2.5   labeling_0.3       rlang_0.4.0       
## [49] reshape2_1.4.3     later_1.0.0        munsell_0.5.0     
## [52] cellranger_1.1.0   tools_4.0.0        generics_0.0.2    
## [55] RSQLite_2.1.2      broom_0.5.2        evaluate_0.14     
## [58] stringr_1.4.0      ModelMetrics_1.2.2 knitr_1.25        
## [61] bit64_0.9-7        purrr_0.3.2        coin_1.3-1        
## [64] nlme_3.1-141       mime_0.7           xml2_1.2.2        
## [67] compiler_4.0.0     rstudioapi_0.10    tibble_2.1.3      
## [70] stringi_1.4.3      highr_0.8          forcats_0.4.0     
## [73] RWekajars_3.9.3-1  vctrs_0.2.0        pillar_1.4.2      
## [76] lifecycle_0.1.0    networkD3_0.4      combinat_0.0-8    
## [79] data.table_1.12.4  httpuv_1.5.2       R6_2.4.0          
## [82] promises_1.1.0     gridExtra_2.3      codetools_0.2-16  
## [85] assertthat_0.2.1   withr_2.1.2        multcomp_1.4-10   
## [88] parallel_4.0.0     hms_0.5.1          quadprog_1.5-7    
## [91] tidyverse_1.2.1    timeDate_3043.102  tidyr_1.0.0       
## [94] rmarkdown_1.16     inum_1.0-1         partykit_1.2-5    
## [97] shiny_1.3.2        lubridate_1.7.4
```

```r
xfun::session_info('rmarkdown')
```

```
## R Under development (unstable) (2019-10-05 r77257)
## Platform: x86_64-w64-mingw32/x64 (64-bit)
## Running under: Windows 8.1 x64 (build 9600)
## 
## Locale:
##   LC_COLLATE=Chinese (Simplified)_China.936 
##   LC_CTYPE=Chinese (Simplified)_China.936   
##   LC_MONETARY=Chinese (Simplified)_China.936
##   LC_NUMERIC=C                              
##   LC_TIME=Chinese (Simplified)_China.936    
## 
## Package version:
##   base64enc_0.1.3 digest_0.6.21   evaluate_0.14   glue_1.3.1     
##   graphics_4.0.0  grDevices_4.0.0 highr_0.8       htmltools_0.4.0
##   jsonlite_1.6    knitr_1.25      magrittr_1.5    markdown_1.1   
##   methods_4.0.0   mime_0.7        Rcpp_1.0.2      rlang_0.4.0    
##   rmarkdown_1.16  stats_4.0.0     stringi_1.4.3   stringr_1.4.0  
##   tinytex_0.16    tools_4.0.0     utils_4.0.0     xfun_0.10      
##   yaml_2.2.0     
## 
## Pandoc version: 2.7.3
```

