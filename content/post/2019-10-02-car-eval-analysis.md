---
title: "Car Evaluation Analysis 翻译：汽车评估分析"
author: "黄湘云"
date: "2019-10-02"
categories:
  - 统计模型
tags:
  - 统计学习
slug: car-eval-analysis
toc: true
---

> 本文翻译自 Suraj Vidyadaran 的 <https://github.com/surajvv12/17_Classification>

# 1) Load the data 加载数据


```r
car_eval <- read.csv("../../data/car.data.txt", header = FALSE, stringsAsFactors = TRUE)
colnames(car_eval) <- c("buying", "maint", "doors", "persons", 
                        "lug_boot", "safety", "class")
head(car_eval)
```

```
##   buying maint doors persons lug_boot safety class
## 1  vhigh vhigh     2       2    small    low unacc
## 2  vhigh vhigh     2       2    small    med unacc
## 3  vhigh vhigh     2       2    small   high unacc
## 4  vhigh vhigh     2       2      med    low unacc
## 5  vhigh vhigh     2       2      med    med unacc
## 6  vhigh vhigh     2       2      med   high unacc
```

# 2) Exploratory Data Analysis 探索性数据分析


```r
summary(car_eval)
```

```
##    buying      maint       doors     persons     lug_boot    safety   
##  high :432   high :432   2    :432   2   :576   big  :576   high:576  
##  low  :432   low  :432   3    :432   4   :576   med  :576   low :576  
##  med  :432   med  :432   4    :432   more:576   small:576   med :576  
##  vhigh:432   vhigh:432   5more:432                                    
##    class     
##  acc  : 384  
##  good :  69  
##  unacc:1210  
##  vgood:  65
```

```r
str(car_eval)
```

```
## 'data.frame':	1728 obs. of  7 variables:
##  $ buying  : Factor w/ 4 levels "high","low","med",..: 4 4 4 4 4 4 4 4 4 ..
##  $ maint   : Factor w/ 4 levels "high","low","med",..: 4 4 4 4 4 4 4 4 4 ..
##  $ doors   : Factor w/ 4 levels "2","3","4","5more": 1 1 1 1 1 1 1 1 1 1 ..
##  $ persons : Factor w/ 3 levels "2","4","more": 1 1 1 1 1 1 1 1 1 2 ...
##  $ lug_boot: Factor w/ 3 levels "big","med","small": 3 3 3 2 2 2 1 1 1 3 ..
##  $ safety  : Factor w/ 3 levels "high","low","med": 2 3 1 2 3 1 2 3 1 2 ...
##  $ class   : Factor w/ 4 levels "acc","good","unacc",..: 3 3 3 3 3 3 3 3 ..
```

各个字段都没有缺失，太好了！


```r
DataExplorer::plot_missing(car_eval)
```

![unnamed-chunk-3-1](https://user-images.githubusercontent.com/12031874/66122716-feca9580-e612-11e9-8e74-9ca23b160cff.png)

7 个字段都是类别型的


```r
DataExplorer::plot_intro(car_eval)
```

![unnamed-chunk-4-1](https://user-images.githubusercontent.com/12031874/66122718-feca9580-e612-11e9-9cda-f8d2139e9f66.png)

# 3) Classification Analysis 分类分析

## A) Linear Classification 线性分类

### 1) Logistic Regression 逻辑回归


```r
library(VGAM)

# Build the model 创建模型
model1 <- vglm(class ~ buying + maint + doors + persons + lug_boot + safety, 
               family = "multinomial", data = car_eval)

# Summarize the model 模型输出
summary(model1)
```

```
## 
## Call:
## vglm(formula = class ~ buying + maint + doors + persons + lug_boot + 
##     safety, family = "multinomial", data = car_eval)
## 
## Pearson residuals:
##                      Min       1Q    Median        3Q   Max
## log(mu[,1]/mu[,4]) -3.80 -0.02249 -0.000878 -8.89e-08  2.54
## log(mu[,2]/mu[,4]) -4.75 -0.00765 -0.000040 -1.35e-07  1.65
## log(mu[,3]/mu[,4]) -2.54 -0.00194  0.000293  8.82e-03 21.10
## 
## Coefficients: 
##                 Estimate Std. Error z value Pr(>|z|)    
## (Intercept):1    18.0095     3.4660    5.20  2.0e-07 ***
## (Intercept):2     1.3810     3.6702    0.38  0.70672    
## (Intercept):3    31.2141     3.0950   10.09  < 2e-16 ***
## buyinglow:1     -11.4458     1.7709   -6.46  1.0e-10 ***
## buyinglow:2      -2.2995     2.2260   -1.03  0.30161    
## buyinglow:3     -15.8724     1.8436   -8.61  < 2e-16 ***
## buyingmed:1      -8.5899     1.6400   -5.24  1.6e-07 ***
## buyingmed:2      -1.7570     2.1896   -0.80  0.42231    
## buyingmed:3     -12.2198     1.7026   -7.18  7.1e-13 ***
## buyingvhigh:1     0.1218     2.0464    0.06  0.95253    
## buyingvhigh:2     0.0703     3.0559    0.02  0.98164    
## buyingvhigh:3     1.9859     2.0761    0.96  0.33880    
## maintlow:1       -5.8496     0.9569   -6.11  9.8e-10 ***
## maintlow:2        2.2736     1.8073    1.26  0.20840    
## maintlow:3       -8.8454     1.0458   -8.46  < 2e-16 ***
## maintmed:1       -4.4988     0.8616   -5.22  1.8e-07 ***
## maintmed:2        1.7046     1.8174    0.94  0.34829    
## maintmed:3       -7.6027     0.9634   -7.89  3.0e-15 ***
## maintvhigh:1      5.4395     1.5945    3.41  0.00065 ***
## maintvhigh:2      4.3844     2.8191    1.56  0.11989    
## maintvhigh:3      7.9962     1.6405    4.87  1.1e-06 ***
## doors3:1         -1.7936     0.8001   -2.24  0.02499 *  
## doors3:2         -0.8425     0.7418   -1.14  0.25602    
## doors3:3         -3.4667     0.8821   -3.93  8.5e-05 ***
## doors4:1         -3.1080     0.8407   -3.70  0.00022 ***
## doors4:2         -1.8031     0.8012   -2.25  0.02442 *  
## doors4:3         -5.3029     0.9225   -5.75  9.0e-09 ***
## doors5more:1     -3.1080     0.8407   -3.70  0.00022 ***
## doors5more:2     -1.8031     0.8012   -2.25  0.02442 *  
## doors5more:3     -5.3029     0.9225   -5.75  9.0e-09 ***
## persons4:1       -6.3234     2.5011   -2.53  0.01146 *  
## persons4:2       -2.3457     2.0396   -1.15  0.25011    
## persons4:3      -20.9094     1.9563  -10.69  < 2e-16 ***
## personsmore:1    -6.9219     2.5210   -2.75  0.00604 ** 
## personsmore:2    -2.9705     2.0629   -1.44  0.14988    
## personsmore:3   -21.1626     1.9714  -10.74  < 2e-16 ***
## lug_bootmed:1     2.2581     0.6398    3.53  0.00042 ***
## lug_bootmed:2     1.4210     0.6113    2.32  0.02009 *  
## lug_bootmed:3     3.5161     0.7231    4.86  1.2e-06 ***
## lug_bootsmall:1   9.2938     1.5410    6.03  1.6e-09 ***
## lug_bootsmall:2   6.1428     1.4469    4.25  2.2e-05 ***
## lug_bootsmall:3  13.2362     1.5980    8.28  < 2e-16 ***
## safetylow:1       7.0423     2.6253    2.68  0.00731 ** 
## safetylow:2       2.7490     2.2665    1.21  0.22519    
## safetylow:3      22.2111     2.0488   10.84  < 2e-16 ***
## safetymed:1       9.0863     1.4909    6.09  1.1e-09 ***
## safetymed:2       6.4682     1.3996    4.62  3.8e-06 ***
## safetymed:3      11.7802     1.5266    7.72  1.2e-14 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Names of linear predictors: log(mu[,1]/mu[,4]), log(mu[,2]/mu[,4]), 
## log(mu[,3]/mu[,4])
## 
## Residual deviance: 499.3 on 5136 degrees of freedom
## 
## Log-likelihood: -249.7 on 5136 degrees of freedom
## 
## Number of Fisher scoring iterations: 16 
## 
## Warning: Hauck-Donner effect detected in the following estimate(s):
## '(Intercept):3', 'maintvhigh:1', 'lug_bootsmall:1', 'lug_bootsmall:2', 'safetylow:3', 'safetymed:1', 'safetymed:2'
## 
## 
## Reference group is level  4  of the response
```



```r
# Predict using the model 模型预测
x <- car_eval[, 1:6]
y <- car_eval[, 7]
probability <- predict(model1, x, type = "response")
```

```
## Warning in object@family@linkinv(predictor, extra = new.extra): fitted
## probabilities numerically 0 or 1 occurred
```

```r
car_eval$pred_log_reg <- apply(probability, 1, which.max)

car_eval$pred_log_reg[which(car_eval$pred_log_reg == "1")] <- levels(car_eval$class)[1]
car_eval$pred_log_reg[which(car_eval$pred_log_reg == "2")] <- levels(car_eval$class)[2]
car_eval$pred_log_reg[which(car_eval$pred_log_reg == "3")] <- levels(car_eval$class)[3]
car_eval$pred_log_reg[which(car_eval$pred_log_reg == "4")] <- levels(car_eval$class)[4]
```



```r
# Accuracy of the model 模型表现
mtab <- table(car_eval$pred_log_reg, car_eval$class)
library(caret)
confusionMatrix(mtab)
```

```
## Confusion Matrix and Statistics
## 
##        
##          acc good unacc vgood
##   acc    340    5    47     2
##   good     8   59     1     0
##   unacc   31    0  1162     0
##   vgood    5    5     0    63
## 
## Overall Statistics
##                                         
##                Accuracy : 0.94          
##                  95% CI : (0.928, 0.951)
##     No Information Rate : 0.7           
##     P-Value [Acc > NIR] : <2e-16        
##                                         
##                   Kappa : 0.87          
##                                         
##  Mcnemar's Test P-Value : NA            
## 
## Statistics by Class:
## 
##                      Class: acc Class: good Class: unacc Class: vgood
## Sensitivity               0.885      0.8551        0.960       0.9692
## Specificity               0.960      0.9946        0.940       0.9940
## Pos Pred Value            0.863      0.8676        0.974       0.8630
## Neg Pred Value            0.967      0.9940        0.910       0.9988
## Prevalence                0.222      0.0399        0.700       0.0376
## Detection Rate            0.197      0.0341        0.672       0.0365
## Detection Prevalence      0.228      0.0394        0.690       0.0422
## Balanced Accuracy         0.923      0.9248        0.950       0.9816
```

### 2) Linear Discriminant Analysis 线性判别分析


```r
library(MASS)

# Build the model
model2 <- lda(class ~ buying + maint + doors + persons + lug_boot + safety,
              data = car_eval)

# Summarize the model
summary(model2)
```

```
##         Length Class  Mode     
## prior    4     -none- numeric  
## counts   4     -none- numeric  
## means   60     -none- numeric  
## scaling 45     -none- numeric  
## lev      4     -none- character
## svd      3     -none- numeric  
## N        1     -none- numeric  
## call     3     -none- call     
## terms    3     terms  call     
## xlevels  6     -none- list
```



```r
# Predict using the model
car_eval$pred_lda <- predict(model2, x)$class
```



```r
# Accuracy of the model
mtab <- table(car_eval$pred_lda, car_eval$class)
confusionMatrix(mtab)
```

```
## Confusion Matrix and Statistics
## 
##        
##          acc good unacc vgood
##   acc    361   44    70    27
##   good    10   23     2     3
##   unacc   13    0  1138     0
##   vgood    0    2     0    35
## 
## Overall Statistics
##                                         
##                Accuracy : 0.901         
##                  95% CI : (0.886, 0.915)
##     No Information Rate : 0.7           
##     P-Value [Acc > NIR] : <2e-16        
##                                         
##                   Kappa : 0.788         
##                                         
##  Mcnemar's Test P-Value : NA            
## 
## Statistics by Class:
## 
##                      Class: acc Class: good Class: unacc Class: vgood
## Sensitivity               0.940      0.3333        0.940       0.5385
## Specificity               0.895      0.9910        0.975       0.9988
## Pos Pred Value            0.719      0.6053        0.989       0.9459
## Neg Pred Value            0.981      0.9728        0.875       0.9823
## Prevalence                0.222      0.0399        0.700       0.0376
## Detection Rate            0.209      0.0133        0.659       0.0203
## Detection Prevalence      0.291      0.0220        0.666       0.0214
## Balanced Accuracy         0.918      0.6621        0.958       0.7686
```

## B) Non-Linear Classification 非线性分类

### 1) Mixture Discriminant Analysis 混合判别分析


```r
library(mda)

# Build the model
model3 <- mda(class ~ buying + maint + doors + persons + lug_boot + safety, 
              data = car_eval)

# Summarize the model
summary(model3)
```

```
##                   Length Class   Mode   
## percent.explained  11    -none-  numeric
## values             11    -none-  numeric
## means             132    -none-  numeric
## theta.mod         121    -none-  numeric
## dimension           1    -none-  numeric
## sub.prior           4    -none-  list   
## fit                 4    polyreg list   
## call                3    -none-  call   
## weights             4    -none-  list   
## prior               4    table   numeric
## assign.theta        4    -none-  list   
## deviance            1    -none-  numeric
## confusion          16    table   numeric
## terms               3    terms   call
```



```r
# Predict using the model
car_eval$pred_mda <- predict(model3, x)
```



```r
# Accuracy of the model
mtab <- table(car_eval$pred_mda, car_eval$class)
confusionMatrix(mtab)
```

```
## Confusion Matrix and Statistics
## 
##        
##          acc good unacc vgood
##   acc    278   12    54     2
##   good    12   50     3     0
##   unacc   73    0  1153     0
##   vgood   21    7     0    63
## 
## Overall Statistics
##                                         
##                Accuracy : 0.894         
##                  95% CI : (0.878, 0.908)
##     No Information Rate : 0.7           
##     P-Value [Acc > NIR] : <2e-16        
##                                         
##                   Kappa : 0.766         
##                                         
##  Mcnemar's Test P-Value : NA            
## 
## Statistics by Class:
## 
##                      Class: acc Class: good Class: unacc Class: vgood
## Sensitivity               0.724      0.7246        0.953       0.9692
## Specificity               0.949      0.9910        0.859       0.9832
## Pos Pred Value            0.803      0.7692        0.940       0.6923
## Neg Pred Value            0.923      0.9886        0.886       0.9988
## Prevalence                0.222      0.0399        0.700       0.0376
## Detection Rate            0.161      0.0289        0.667       0.0365
## Detection Prevalence      0.200      0.0376        0.709       0.0527
## Balanced Accuracy         0.837      0.8578        0.906       0.9762
```

### 2) Quadratic Discriminant Analysis 二次判别分析


```r
library(MASS)
# Build the model
model4 <- qda(class ~ buying + maint + doors + persons + lug_boot + safety, 
              data = car_eval)

# Summarize the model
summary(model4)
```



```r
# Predict using the model
car_eval$pred_qda <- predict(model4, x)
```



```r
# Accuracy of the model
mtab <- table(car_eval$pred_qda, car_eval$class)
confusionMatrix(mtab)
```

### 3) Regularized Discriminant Analysis 正则判别分析


```r
library(klaR)

# Build the model
model5 <- rda(class ~ buying + maint + doors + persons + lug_boot + safety, 
              data = car_eval, gamma = 0.05, lambda = 0.01)

# Summarize the model
summary(model5)
```

```
##                Length Class  Mode     
## call             5    -none- call     
## regularization   2    -none- numeric  
## classes          4    -none- character
## prior            4    -none- numeric  
## error.rate       1    -none- numeric  
## varnames        15    -none- character
## means           60    -none- numeric  
## covariances    900    -none- numeric  
## covpooled      225    -none- numeric  
## converged        1    -none- logical  
## iter             1    -none- numeric  
## terms            3    terms  call     
## xlevels          6    -none- list
```



```r
# Predict using the model
car_eval$pred_rda <- predict(model5, x)$class
```



```r
# Accuracy of the model
mtab <- table(car_eval$pred_rda, car_eval$class)
confusionMatrix(mtab)
```

```
## Confusion Matrix and Statistics
## 
##        
##          acc good unacc vgood
##   acc    317    0   134     0
##   good    45   63     4     0
##   unacc    0    0  1072     0
##   vgood   22    6     0    65
## 
## Overall Statistics
##                                         
##                Accuracy : 0.878         
##                  95% CI : (0.862, 0.893)
##     No Information Rate : 0.7           
##     P-Value [Acc > NIR] : <2e-16        
##                                         
##                   Kappa : 0.757         
##                                         
##  Mcnemar's Test P-Value : NA            
## 
## Statistics by Class:
## 
##                      Class: acc Class: good Class: unacc Class: vgood
## Sensitivity               0.826      0.9130        0.886       1.0000
## Specificity               0.900      0.9705        1.000       0.9832
## Pos Pred Value            0.703      0.5625        1.000       0.6989
## Neg Pred Value            0.948      0.9963        0.790       1.0000
## Prevalence                0.222      0.0399        0.700       0.0376
## Detection Rate            0.183      0.0365        0.620       0.0376
## Detection Prevalence      0.261      0.0648        0.620       0.0538
## Balanced Accuracy         0.863      0.9418        0.943       0.9916
```

### 4) Neural Network 神经网络


```r
library(nnet)

# Build the model
model6 <- nnet(class ~ buying + maint + doors + persons + lug_boot + safety, 
               data = car_eval, size = 4, decay = 0.0001, maxit = 500)
```

```
## # weights:  84
## initial  value 3191.106533 
## iter  10 value 675.419923
## iter  20 value 339.062823
## iter  30 value 200.104370
## iter  40 value 108.781768
## iter  50 value 85.575159
## iter  60 value 67.712174
## iter  70 value 50.815778
## iter  80 value 46.425543
## iter  90 value 42.426263
## iter 100 value 29.471017
## iter 110 value 27.983279
## iter 120 value 26.741224
## iter 130 value 25.765849
## iter 140 value 25.023670
## iter 150 value 24.676321
## iter 160 value 24.454771
## iter 170 value 24.253768
## iter 180 value 24.201612
## iter 190 value 24.084661
## iter 200 value 23.958461
## iter 210 value 23.897082
## iter 220 value 23.786269
## iter 230 value 23.553069
## iter 240 value 23.434948
## iter 250 value 23.384710
## iter 260 value 23.341843
## iter 270 value 23.302738
## iter 280 value 23.273914
## iter 290 value 23.229443
## iter 300 value 23.216463
## iter 310 value 23.199813
## iter 320 value 23.006813
## iter 330 value 21.471923
## iter 340 value 20.547818
## iter 350 value 20.356040
## iter 360 value 20.321716
## iter 370 value 20.186214
## iter 380 value 19.864607
## iter 390 value 19.110492
## iter 400 value 18.688761
## iter 410 value 18.392153
## iter 420 value 17.729656
## iter 430 value 16.961779
## iter 440 value 16.805388
## iter 450 value 16.669731
## iter 460 value 16.583233
## iter 470 value 16.504496
## iter 480 value 16.460316
## iter 490 value 16.426928
## iter 500 value 16.394392
## final  value 16.394392 
## stopped after 500 iterations
```

```r
# Summarize the model
summary(model6)
```

```
## a 15-4-4 network with 84 weights
## options were - softmax modelling  decay=1e-04
##   b->h1  i1->h1  i2->h1  i3->h1  i4->h1  i5->h1  i6->h1  i7->h1  i8->h1 
##    3.46   -7.28   -5.90    1.48   -2.80   -1.31    8.15    1.95    4.40 
##  i9->h1 i10->h1 i11->h1 i12->h1 i13->h1 i14->h1 i15->h1 
##    4.40    7.32    9.56   -4.28   -8.93   -0.93   -8.90 
##   b->h2  i1->h2  i2->h2  i3->h2  i4->h2  i5->h2  i6->h2  i7->h2  i8->h2 
##    3.95   -2.67   -3.09    4.18   -8.73   -7.77    4.34    0.19   -0.72 
##  i9->h2 i10->h2 i11->h2 i12->h2 i13->h2 i14->h2 i15->h2 
##   -0.72   -1.33   -2.39    1.07   -2.12    0.44   -2.53 
##   b->h3  i1->h3  i2->h3  i3->h3  i4->h3  i5->h3  i6->h3  i7->h3  i8->h3 
##   -8.27    2.14    1.62    2.17   -1.40   -1.11   -1.45    8.38    7.39 
##  i9->h3 i10->h3 i11->h3 i12->h3 i13->h3 i14->h3 i15->h3 
##    7.38   27.42   13.50   -1.70   -8.92  -28.48   -3.76 
##   b->h4  i1->h4  i2->h4  i3->h4  i4->h4  i5->h4  i6->h4  i7->h4  i8->h4 
##    6.00   -2.29   -1.93    3.52   -1.38   -1.07    1.60   -0.07   -0.36 
##  i9->h4 i10->h4 i11->h4 i12->h4 i13->h4 i14->h4 i15->h4 
##   -0.36   -4.37   -4.67    0.43    0.90   11.30    0.93 
##   b->o1  h1->o1  h2->o1  h3->o1  h4->o1 
##   -0.73   14.54  -21.27    5.48   42.38 
##   b->o2  h1->o2  h2->o2  h3->o2  h4->o2 
##    6.35  -14.84   -9.68   39.59  -79.45 
##   b->o3  h1->o3  h2->o3  h3->o3  h4->o3 
##  -11.98  -34.02   13.30  -58.54  141.44 
##   b->o4  h1->o4  h2->o4  h3->o4  h4->o4 
##    6.29   34.32   17.65   13.45 -104.36
```



```r
# Predict using the model
car_eval$pred_nnet <- predict(model6, x, type = "class")
```



```r
# Accuracy of the model
mtab <- table(car_eval$pred_nnet, car_eval$class)
confusionMatrix(mtab)
```

```
## Confusion Matrix and Statistics
## 
##        
##          acc good unacc vgood
##   acc    381    0     0     0
##   good     2   69     0     0
##   unacc    1    0  1210     0
##   vgood    0    0     0    65
## 
## Overall Statistics
##                                     
##                Accuracy : 0.998     
##                  95% CI : (0.995, 1)
##     No Information Rate : 0.7       
##     P-Value [Acc > NIR] : <2e-16    
##                                     
##                   Kappa : 0.996     
##                                     
##  Mcnemar's Test P-Value : NA        
## 
## Statistics by Class:
## 
##                      Class: acc Class: good Class: unacc Class: vgood
## Sensitivity               0.992      1.0000        1.000       1.0000
## Specificity               1.000      0.9988        0.998       1.0000
## Pos Pred Value            1.000      0.9718        0.999       1.0000
## Neg Pred Value            0.998      1.0000        1.000       1.0000
## Prevalence                0.222      0.0399        0.700       0.0376
## Detection Rate            0.220      0.0399        0.700       0.0376
## Detection Prevalence      0.220      0.0411        0.701       0.0376
## Balanced Accuracy         0.996      0.9994        0.999       1.0000
```

### 5) Flexible Discriminant Analysis 灵活判别分析


```r
library(mda)

# Build the model
model7 <- fda(class ~ buying + maint + doors + persons + lug_boot + safety, 
              data = car_eval)

# Summarize the model
summary(model7)
```

```
##                   Length Class   Mode   
## percent.explained  3     -none-  numeric
## values             3     -none-  numeric
## means             12     -none-  numeric
## theta.mod          9     -none-  numeric
## dimension          1     -none-  numeric
## prior              4     table   numeric
## fit                4     polyreg list   
## call               3     -none-  call   
## terms              3     terms   call   
## confusion         16     table   numeric
```



```r
# Predict using the model
car_eval$pred_fda <- predict(model7, x, type = "class")
```



```r
# Accuracy of the model
mtab <- table(car_eval$pred_fda, car_eval$class)
confusionMatrix(mtab)
```

```
## Confusion Matrix and Statistics
## 
##        
##          acc good unacc vgood
##   acc    361   44    72    27
##   good    10   23     2     3
##   unacc   13    0  1136     0
##   vgood    0    2     0    35
## 
## Overall Statistics
##                                         
##                Accuracy : 0.9           
##                  95% CI : (0.885, 0.914)
##     No Information Rate : 0.7           
##     P-Value [Acc > NIR] : <2e-16        
##                                         
##                   Kappa : 0.786         
##                                         
##  Mcnemar's Test P-Value : NA            
## 
## Statistics by Class:
## 
##                      Class: acc Class: good Class: unacc Class: vgood
## Sensitivity               0.940      0.3333        0.939       0.5385
## Specificity               0.894      0.9910        0.975       0.9988
## Pos Pred Value            0.716      0.6053        0.989       0.9459
## Neg Pred Value            0.981      0.9728        0.872       0.9823
## Prevalence                0.222      0.0399        0.700       0.0376
## Detection Rate            0.209      0.0133        0.657       0.0203
## Detection Prevalence      0.292      0.0220        0.665       0.0214
## Balanced Accuracy         0.917      0.6621        0.957       0.7686
```

### 6) Support Vector Machine 支持向量机


```r
library(kernlab)
```

```
## 
## Attaching package: 'kernlab'
```

```
## The following object is masked from 'package:ggplot2':
## 
##     alpha
```

```
## The following object is masked from 'package:VGAM':
## 
##     nvar
```

```r
# Build the model
model8 <- ksvm(class ~ buying + maint + doors + persons + lug_boot + safety, 
               data = car_eval)

# Summarize the model
summary(model8)
```

```
## Length  Class   Mode 
##      1   ksvm     S4
```



```r
# Predict using the model
car_eval$pred_svm <- predict(model8, x, type = "response")
```



```r
# Accuracy of the model
mtab <- table(car_eval$pred_svm, car_eval$class)
confusionMatrix(mtab)
```

```
## Confusion Matrix and Statistics
## 
##        
##          acc good unacc vgood
##   acc    375    0    33     0
##   good     8   60     3     0
##   unacc    0    0  1174     0
##   vgood    1    9     0    65
## 
## Overall Statistics
##                                         
##                Accuracy : 0.969         
##                  95% CI : (0.959, 0.976)
##     No Information Rate : 0.7           
##     P-Value [Acc > NIR] : <2e-16        
##                                         
##                   Kappa : 0.933         
##                                         
##  Mcnemar's Test P-Value : NA            
## 
## Statistics by Class:
## 
##                      Class: acc Class: good Class: unacc Class: vgood
## Sensitivity               0.977      0.8696        0.970       1.0000
## Specificity               0.975      0.9934        1.000       0.9940
## Pos Pred Value            0.919      0.8451        1.000       0.8667
## Neg Pred Value            0.993      0.9946        0.935       1.0000
## Prevalence                0.222      0.0399        0.700       0.0376
## Detection Rate            0.217      0.0347        0.679       0.0376
## Detection Prevalence      0.236      0.0411        0.679       0.0434
## Balanced Accuracy         0.976      0.9315        0.985       0.9970
```

### 7) k-Nearest Neighbors K 近邻


```r
library(caret)

# Build the model
model9 <- knn3(class ~ buying + maint + doors + persons + lug_boot + safety,
               data = car_eval, k = 5)

# Summarize the model
summary(model9)
```

```
##         Length Class  Mode   
## learn   2      -none- list   
## k       1      -none- numeric
## terms   3      terms  call   
## xlevels 6      -none- list   
## theDots 0      -none- list
```



```r
# Predict using the model
car_eval$pred_knn <- predict(model9, x, type = "class")
```



```r
# Accuracy of the model
mtab <- table(car_eval$pred_knn, car_eval$class)
confusionMatrix(mtab)
```

```
## Confusion Matrix and Statistics
## 
##        
##          acc good unacc vgood
##   acc    337   42    11    18
##   good     6   15     0     5
##   unacc   41    8  1199     0
##   vgood    0    4     0    42
## 
## Overall Statistics
##                                         
##                Accuracy : 0.922         
##                  95% CI : (0.908, 0.934)
##     No Information Rate : 0.7           
##     P-Value [Acc > NIR] : <2e-16        
##                                         
##                   Kappa : 0.823         
##                                         
##  Mcnemar's Test P-Value : NA            
## 
## Statistics by Class:
## 
##                      Class: acc Class: good Class: unacc Class: vgood
## Sensitivity               0.878     0.21739        0.991       0.6462
## Specificity               0.947     0.99337        0.905       0.9976
## Pos Pred Value            0.826     0.57692        0.961       0.9130
## Neg Pred Value            0.964     0.96827        0.977       0.9863
## Prevalence                0.222     0.03993        0.700       0.0376
## Detection Rate            0.195     0.00868        0.694       0.0243
## Detection Prevalence      0.236     0.01505        0.722       0.0266
## Balanced Accuracy         0.912     0.60538        0.948       0.8219
```

### 8) Naive Bayes 朴素贝叶斯


```r
library(e1071)

# Build the model
model10 <- naiveBayes(class ~ buying + maint + doors + persons + lug_boot + safety, 
                      data = car_eval, k = 5)

# Summarize the model
summary(model10)
```

```
##           Length Class  Mode     
## apriori   4      table  numeric  
## tables    6      -none- list     
## levels    4      -none- character
## isnumeric 6      -none- logical  
## call      5      -none- call
```



```r
# Predict using the model
car_eval$pred_naive <- predict(model10, x)
```



```r
# Accuracy of the model
mtab <- table(car_eval$pred_naive, car_eval$class)
confusionMatrix(mtab)
```

```
## Confusion Matrix and Statistics
## 
##        
##          acc good unacc vgood
##   acc    289   46    47    26
##   good    10   21     2     0
##   unacc   85    0  1161     0
##   vgood    0    2     0    39
## 
## Overall Statistics
##                                         
##                Accuracy : 0.874         
##                  95% CI : (0.857, 0.889)
##     No Information Rate : 0.7           
##     P-Value [Acc > NIR] : <2e-16        
##                                         
##                   Kappa : 0.714         
##                                         
##  Mcnemar's Test P-Value : NA            
## 
## Statistics by Class:
## 
##                      Class: acc Class: good Class: unacc Class: vgood
## Sensitivity               0.753      0.3043        0.960       0.6000
## Specificity               0.911      0.9928        0.836       0.9988
## Pos Pred Value            0.708      0.6364        0.932       0.9512
## Neg Pred Value            0.928      0.9717        0.898       0.9846
## Prevalence                0.222      0.0399        0.700       0.0376
## Detection Rate            0.167      0.0122        0.672       0.0226
## Detection Prevalence      0.236      0.0191        0.721       0.0237
## Balanced Accuracy         0.832      0.6486        0.898       0.7994
```

## C) Non-Linear Classification with Decision Trees 非线性分类之决策树

### 1) Classification and Regression Trees(CART) 分类回归树


```r
library(rpart)

# Build the model
model11 <- rpart(class ~ buying + maint + doors + persons + lug_boot + safety, 
                 data = car_eval)

# Summarize the model
# summary(model11)
```



```r
# Predict using the model
car_eval$pred_cart <- predict(model11, x, type = "class")
```



```r
# Accuracy of the model
mtab <- table(car_eval$pred_cart, car_eval$class)
confusionMatrix(mtab)
```

```
## Confusion Matrix and Statistics
## 
##        
##          acc good unacc vgood
##   acc    358    0    45    13
##   good    16   60     4     0
##   unacc    7    0  1161     0
##   vgood    3    9     0    52
## 
## Overall Statistics
##                                         
##                Accuracy : 0.944         
##                  95% CI : (0.932, 0.954)
##     No Information Rate : 0.7           
##     P-Value [Acc > NIR] : <2e-16        
##                                         
##                   Kappa : 0.881         
##                                         
##  Mcnemar's Test P-Value : NA            
## 
## Statistics by Class:
## 
##                      Class: acc Class: good Class: unacc Class: vgood
## Sensitivity               0.932      0.8696        0.960       0.8000
## Specificity               0.957      0.9879        0.986       0.9928
## Pos Pred Value            0.861      0.7500        0.994       0.8125
## Neg Pred Value            0.980      0.9945        0.912       0.9922
## Prevalence                0.222      0.0399        0.700       0.0376
## Detection Rate            0.207      0.0347        0.672       0.0301
## Detection Prevalence      0.241      0.0463        0.676       0.0370
## Balanced Accuracy         0.945      0.9288        0.973       0.8964
```

### 2) C4.5


```r
library(RWeka)

# Build the model
model12 <- J48(class ~ buying + maint + doors + persons + lug_boot + safety, 
               data = car_eval)

# Summarize the model
summary(model12)
```

```
## 
## === Summary ===
## 
## Correctly Classified Instances        1664               96.2963 %
## Incorrectly Classified Instances        64                3.7037 %
## Kappa statistic                          0.9207
## Mean absolute error                      0.0248
## Root mean squared error                  0.1114
## Relative absolute error                 10.8411 %
## Root relative squared error             32.9501 %
## Total Number of Instances             1728     
## 
## === Confusion Matrix ===
## 
##     a    b    c    d   <-- classified as
##   380    2    0    2 |    a = acc
##     9   57    0    3 |    b = good
##    35    3 1172    0 |    c = unacc
##     4    6    0   55 |    d = vgood
```



```r
# Predict using the model
car_eval$pred_c45 <- predict(model12, x)

# Accuracy of the model
mtab <- table(car_eval$pred_c45, car_eval$class)
confusionMatrix(mtab)
```

```
## Confusion Matrix and Statistics
## 
##        
##          acc good unacc vgood
##   acc    380    9    35     4
##   good     2   57     3     6
##   unacc    0    0  1172     0
##   vgood    2    3     0    55
## 
## Overall Statistics
##                                         
##                Accuracy : 0.963         
##                  95% CI : (0.953, 0.971)
##     No Information Rate : 0.7           
##     P-Value [Acc > NIR] : <2e-16        
##                                         
##                   Kappa : 0.921         
##                                         
##  Mcnemar's Test P-Value : NA            
## 
## Statistics by Class:
## 
##                      Class: acc Class: good Class: unacc Class: vgood
## Sensitivity               0.990      0.8261        0.969       0.8462
## Specificity               0.964      0.9934        1.000       0.9970
## Pos Pred Value            0.888      0.8382        1.000       0.9167
## Neg Pred Value            0.997      0.9928        0.932       0.9940
## Prevalence                0.222      0.0399        0.700       0.0376
## Detection Rate            0.220      0.0330        0.678       0.0318
## Detection Prevalence      0.248      0.0394        0.678       0.0347
## Balanced Accuracy         0.977      0.9097        0.984       0.9216
```

### 3) PART


```r
library(RWeka)

# Build the model
model13 <- PART(class ~ buying + maint + doors + persons + lug_boot + safety,
                data = car_eval)

# Summarize the model
summary(model13)
```

```
## 
## === Summary ===
## 
## Correctly Classified Instances        1698               98.2639 %
## Incorrectly Classified Instances        30                1.7361 %
## Kappa statistic                          0.9622
## Mean absolute error                      0.0127
## Root mean squared error                  0.0795
## Relative absolute error                  5.5245 %
## Root relative squared error             23.5216 %
## Total Number of Instances             1728     
## 
## === Confusion Matrix ===
## 
##     a    b    c    d   <-- classified as
##   374    1    6    3 |    a = acc
##     3   63    1    2 |    b = good
##    13    1 1196    0 |    c = unacc
##     0    0    0   65 |    d = vgood
```



```r
# Predict using the model
car_eval$pred_part <- predict(model13, x)
```



```r
# Accuracy of the model
mtab <- table(car_eval$pred_part, car_eval$class)
confusionMatrix(mtab)
```

```
## Confusion Matrix and Statistics
## 
##        
##          acc good unacc vgood
##   acc    374    3    13     0
##   good     1   63     1     0
##   unacc    6    1  1196     0
##   vgood    3    2     0    65
## 
## Overall Statistics
##                                         
##                Accuracy : 0.983         
##                  95% CI : (0.975, 0.988)
##     No Information Rate : 0.7           
##     P-Value [Acc > NIR] : <2e-16        
##                                         
##                   Kappa : 0.962         
##                                         
##  Mcnemar's Test P-Value : NA            
## 
## Statistics by Class:
## 
##                      Class: acc Class: good Class: unacc Class: vgood
## Sensitivity               0.974      0.9130        0.988       1.0000
## Specificity               0.988      0.9988        0.986       0.9970
## Pos Pred Value            0.959      0.9692        0.994       0.9286
## Neg Pred Value            0.993      0.9964        0.973       1.0000
## Prevalence                0.222      0.0399        0.700       0.0376
## Detection Rate            0.216      0.0365        0.692       0.0376
## Detection Prevalence      0.226      0.0376        0.696       0.0405
## Balanced Accuracy         0.981      0.9559        0.987       0.9985
```

### 4) Bagging CART 装袋 CART


```r
library(ipred)

# Build the model
model14 <- bagging(class ~ buying + maint + doors + persons + lug_boot + safety, 
                   data = car_eval)

# Summarize the model
# summary(model14)
```



```r
# Predict using the model
car_eval$pred_bagging <- predict(model14, x)
```



```r
# Accuracy of the model
mtab <- table(car_eval$pred_bagging, car_eval$class)
confusionMatrix(mtab)
```

```
## Confusion Matrix and Statistics
## 
##        
##          acc good unacc vgood
##   acc    384    0     0     0
##   good     0   69     0     0
##   unacc    0    0  1210     0
##   vgood    0    0     0    65
## 
## Overall Statistics
##                                     
##                Accuracy : 1         
##                  95% CI : (0.998, 1)
##     No Information Rate : 0.7       
##     P-Value [Acc > NIR] : <2e-16    
##                                     
##                   Kappa : 1         
##                                     
##  Mcnemar's Test P-Value : NA        
## 
## Statistics by Class:
## 
##                      Class: acc Class: good Class: unacc Class: vgood
## Sensitivity               1.000      1.0000          1.0       1.0000
## Specificity               1.000      1.0000          1.0       1.0000
## Pos Pred Value            1.000      1.0000          1.0       1.0000
## Neg Pred Value            1.000      1.0000          1.0       1.0000
## Prevalence                0.222      0.0399          0.7       0.0376
## Detection Rate            0.222      0.0399          0.7       0.0376
## Detection Prevalence      0.222      0.0399          0.7       0.0376
## Balanced Accuracy         1.000      1.0000          1.0       1.0000
```

### 5) Random Forest 随机森林


```r
library(randomForest)
```

```
## randomForest 4.6-14
```

```
## Type rfNews() to see new features/changes/bug fixes.
```

```
## 
## Attaching package: 'randomForest'
```

```
## The following object is masked from 'package:ggplot2':
## 
##     margin
```

```r
# Build the model
model15 <- randomForest(class ~ buying + maint + doors + persons + lug_boot + safety, 
                        data = car_eval)

# Summarize the model
summary(model15)
```

```
##                 Length Class  Mode     
## call               3   -none- call     
## type               1   -none- character
## predicted       1728   factor numeric  
## err.rate        2500   -none- numeric  
## confusion         20   -none- numeric  
## votes           6912   matrix numeric  
## oob.times       1728   -none- numeric  
## classes            4   -none- character
## importance         6   -none- numeric  
## importanceSD       0   -none- NULL     
## localImportance    0   -none- NULL     
## proximity          0   -none- NULL     
## ntree              1   -none- numeric  
## mtry               1   -none- numeric  
## forest            14   -none- list     
## y               1728   factor numeric  
## test               0   -none- NULL     
## inbag              0   -none- NULL     
## terms              3   terms  call
```



```r
# Predict using the model
car_eval$pred_randomforest <- predict(model15, x)

# Accuracy of the model
mtab <- table(car_eval$pred_randomforest, car_eval$class)
confusionMatrix(mtab)
```

```
## Confusion Matrix and Statistics
## 
##        
##          acc good unacc vgood
##   acc    384    0     2     0
##   good     0   69     0     0
##   unacc    0    0  1208     0
##   vgood    0    0     0    65
## 
## Overall Statistics
##                                     
##                Accuracy : 0.999     
##                  95% CI : (0.996, 1)
##     No Information Rate : 0.7       
##     P-Value [Acc > NIR] : <2e-16    
##                                     
##                   Kappa : 0.997     
##                                     
##  Mcnemar's Test P-Value : NA        
## 
## Statistics by Class:
## 
##                      Class: acc Class: good Class: unacc Class: vgood
## Sensitivity               1.000      1.0000        0.998       1.0000
## Specificity               0.999      1.0000        1.000       1.0000
## Pos Pred Value            0.995      1.0000        1.000       1.0000
## Neg Pred Value            1.000      1.0000        0.996       1.0000
## Prevalence                0.222      0.0399        0.700       0.0376
## Detection Rate            0.222      0.0399        0.699       0.0376
## Detection Prevalence      0.223      0.0399        0.699       0.0376
## Balanced Accuracy         0.999      1.0000        0.999       1.0000
```

### 6) Gradient Boosted Machine 梯度提升机


```r
library(gbm)
```

```
## Loaded gbm 2.1.5
```

```r
# Build the model
model16 <- gbm(class ~ buying + maint + doors + persons + lug_boot + safety, 
               data = car_eval, distribution = "multinomial")

# Summarize the model
summary(model16)
```

![unnamed-chunk-48-1](https://user-images.githubusercontent.com/12031874/66122719-ff632c00-e612-11e9-9f66-ca78b27ac94e.png)

```
##               var rel.inf
## safety     safety  39.608
## persons   persons  36.479
## buying     buying  10.419
## maint       maint   8.724
## lug_boot lug_boot   3.645
## doors       doors   1.124
```



```r
# Predict using the model
probability <- predict(model16, x, n.trees = 1)
car_eval$pred_gbm <- colnames(probability)[apply(probability, 1, which.max)]

# Accuracy of the model
mtab <- table(car_eval$pred_gbm, car_eval$class)
mtab
```

```
##        
##          acc good unacc vgood
##   unacc  384   69  1210    65
```

### 7) Boosted C5.0 提升 C5.0


```r
library(C50)

# Build the model
model17 <- C5.0(class ~ buying + maint + doors + persons + lug_boot + safety, 
                data = car_eval, trials = 10)

# Summarize the model
# summary(model17)
```



```r
# Predict using the model
car_eval$pred_c50 <- predict(model17, x)

# Accuracy of the model
mtab <- table(car_eval$pred_c50, car_eval$class)
confusionMatrix(mtab)
```

```
## Confusion Matrix and Statistics
## 
##        
##          acc good unacc vgood
##   acc    383    0     3     2
##   good     0   69     0     0
##   unacc    1    0  1207     0
##   vgood    0    0     0    63
## 
## Overall Statistics
##                                         
##                Accuracy : 0.997         
##                  95% CI : (0.992, 0.999)
##     No Information Rate : 0.7           
##     P-Value [Acc > NIR] : <2e-16        
##                                         
##                   Kappa : 0.992         
##                                         
##  Mcnemar's Test P-Value : NA            
## 
## Statistics by Class:
## 
##                      Class: acc Class: good Class: unacc Class: vgood
## Sensitivity               0.997      1.0000        0.998       0.9692
## Specificity               0.996      1.0000        0.998       1.0000
## Pos Pred Value            0.987      1.0000        0.999       1.0000
## Neg Pred Value            0.999      1.0000        0.994       0.9988
## Prevalence                0.222      0.0399        0.700       0.0376
## Detection Rate            0.222      0.0399        0.698       0.0365
## Detection Prevalence      0.225      0.0399        0.699       0.0365
## Balanced Accuracy         0.997      1.0000        0.998       0.9846
```

# 4) Session Information 软件信息

运行上述算法，需要的 R 包和软件环境如下：


```r
xfun::session_info()
```

```
## R Under development (unstable) (2019-09-30 r77236)
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
##   askpass_1.1         assertthat_0.2.1    backports_1.1.4    
##   base64enc_0.1.3     BH_1.69.0.1         bit_1.1-14         
##   bit64_0.9-7         blob_1.2.0          broom_0.5.2        
##   C50_0.1.2           callr_3.3.2         caret_6.0-84       
##   cellranger_1.1.0    class_7.3-15        classInt_0.4.1     
##   cli_1.1.0           clickhouse_0.0.2    clipr_0.7.0        
##   codetools_0.2-16    colorspace_1.4-1    combinat_0.0-8     
##   compiler_4.0.0      crayon_1.3.4        Cubist_0.2.2       
##   curl_4.2            data.table_1.12.2   DataExplorer_0.8.0 
##   DBI_1.0.0           dbplyr_1.4.2        digest_0.6.21      
##   dplyr_0.8.3         e1071_1.7-2         ellipsis_0.3.0     
##   evaluate_0.14       fansi_0.4.0         forcats_0.4.0      
##   foreach_1.4.7       Formula_1.2-3       fs_1.3.1           
##   gbm_2.1.5           generics_0.0.2      ggplot2_3.2.1      
##   glue_1.3.1          gower_0.2.1         graphics_4.0.0     
##   grDevices_4.0.0     grid_4.0.0          gridExtra_2.3      
##   gtable_0.3.0        haven_2.1.1         highr_0.8          
##   hms_0.5.1           htmltools_0.3.6     htmlwidgets_1.3    
##   httpuv_1.5.2        httr_1.4.1          igraph_1.2.4.1     
##   inum_1.0-1          ipred_0.9-9         iterators_1.0.12   
##   jsonlite_1.6        kernlab_0.9-27      KernSmooth_2.23.15 
##   klaR_0.6-14         knitr_1.25          labeling_0.3       
##   labelled_2.2.1      later_0.8.0         lattice_0.20-38    
##   lava_1.6.6          lazyeval_0.2.2      libcoin_1.0-5      
##   lifecycle_0.1.0     lubridate_1.7.4     magrittr_1.5       
##   markdown_1.1        MASS_7.3-51.4       Matrix_1.2-17      
##   mda_0.4-10          memoise_1.1.0       methods_4.0.0      
##   mgcv_1.8.29         mime_0.7            miniUI_0.1.1.1     
##   ModelMetrics_1.2.2  modelr_0.1.5        munsell_0.5.0      
##   mvtnorm_1.0-11      networkD3_0.4       nlme_3.1-141       
##   nnet_7.3-12         numDeriv_2016.8.1.1 odbc_1.1.6         
##   openssl_1.4.1       parallel_4.0.0      partykit_1.2-5     
##   pillar_1.4.2        pkgconfig_2.0.3     plogr_0.2.0        
##   plyr_1.8.4          prettyunits_1.0.2   processx_3.4.1     
##   prodlim_2018.04.18  progress_1.2.2      promises_1.0.1     
##   ps_1.3.0            purrr_0.3.2         questionr_0.7.0    
##   R6_2.4.0            randomForest_4.6-14 RColorBrewer_1.1.2 
##   Rcpp_1.0.2          readr_1.3.1         readxl_1.3.1       
##   recipes_0.1.7       rematch_1.0.1       reprex_0.3.0       
##   reshape2_1.4.3      rJava_0.9-11        rlang_0.4.0        
##   rmarkdown_1.16      rpart_4.1-15        RSQLite_2.1.2      
##   rstudioapi_0.10     rvest_0.3.4         RWeka_0.4-40       
##   RWekajars_3.9.3-1   scales_1.0.0        selectr_0.4.1      
##   shiny_1.3.2         sourcetools_0.1.7   splines_4.0.0      
##   SQUAREM_2017.10.1   stats_4.0.0         stats4_4.0.0       
##   stringi_1.4.3       stringr_1.4.0       survival_2.44-1.1  
##   sys_3.3             tibble_2.1.3        tidyr_1.0.0        
##   tidyselect_0.2.5    tidyverse_1.2.1     timeDate_3043.102  
##   tinytex_0.16        tools_4.0.0         utf8_1.1.4         
##   utils_4.0.0         vctrs_0.2.0         VGAM_1.1-1         
##   viridisLite_0.3.0   whisker_0.4         withr_2.1.2        
##   xfun_0.10           xml2_1.2.2          xtable_1.8-4       
##   yaml_2.2.0          zeallot_0.1.0
```

