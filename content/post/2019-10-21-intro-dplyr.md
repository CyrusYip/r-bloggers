---
title: "翻译：dplyr 入门帮助文档"
author: "黄湘云"
date: "2019-10-21"
categories:
  - 统计软件
tags:
  - dplyr
slug: intro-dplyr
toc: yes
thumbnail: https://raw.githubusercontent.com/tidyverse/dplyr/master/man/figures/logo.png
---


> 本文翻译自 dplyr 包的帮助文档 [Introduction to dplyr](https://dplyr.tidyverse.org/articles/dplyr.html)


```r
knitr::opts_chunk$set(collapse = T, comment = "#>")
options(tibble.print_min = 4L, tibble.print_max = 4L)
library(dplyr)
library(ggplot2)
set.seed(1014)
```

当你与数据打交道的时候，必须：

* 搞清楚你想做什么

* 以计算机程序的形式描述你的任务

* 执行程序

dplyr 包可以高效地实现这些操作：

* 帮助你思考数据操作挑战

* 提供核心的基本操作函数实现最常用的数据操作任务，将你的思考快速翻译成代码

* 使用高效的后端，花在机器上的时间大大减少

本帮助文档介绍 dplyr 基本工具集，展示如何将它们应用到数据操作上。dplyr 通过 dbplyr 包支持数据库，一旦安装，可阅读 R 包文档 `vignette("dbplyr")` 学习更多内容。


## 数据集 nycflights13

以 `nycflights13::flights` 为例探索 dplyr 提供的基本数据操作。flights 数据集记录了 2013 年从纽约市出发的所有航班记录，总共 336776 条。数据集最初来自 [美国交通统计局](http://www.transtats.bts.gov/DatabaseInfo.asp?DB_ID=120&Link=0)，各个字段的详细描述见帮助文档 `?nycflights13`


```r
library(nycflights13)
dim(flights)
#> [1] 336776     19
flights
#> # A tibble: 336,776 x 19
#>    year month   day dep_time sched_dep_time dep_delay arr_time
#>   <int> <int> <int>    <int>          <int>     <dbl>    <int>
#> 1  2013     1     1      517            515         2      830
#> 2  2013     1     1      533            529         4      850
#> 3  2013     1     1      542            540         2      923
#> 4  2013     1     1      544            545        -1     1004
#> # ... with 336,772 more rows, and 12 more variables: sched_arr_time <int>,
#> #   arr_delay <dbl>, carrier <chr>, flight <int>, tailnum <chr>,
#> #   origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
#> #   minute <dbl>, time_hour <dttm>
```

注意 `nycflights13::flights` 是一个 tibble 类型的数据对象，是一种现代化的数据框重构。在操作大型数据集的时候特别有用，因为它只打印前几行。你可以在网站 <http://tibble.tidyverse.org> 了解到更多关于 tibble 的介绍。特别地，你可以通过函数 `as_tibble()` 将数据框 data.frame 转化为 tibble。


## 基本操作 

dplyr 目标是将每一个数据操作拆解为核心的基本操作，为基本操作提供一个函数

* `filter()` 基于属性值筛选行
* `arrange()` 按某一（些）列对行排序
* `select()` 和 `rename()` 基于属性名称筛选列变量
* `mutate()` 和 `transmute()` 基于已有的变量的操作添加新的变量
* `summarise()` 将多个值压缩为单个值
* `sample_n()` 和 `sample_frac()` 随机抽取样本

###  筛选行 `filter()` 

`filter()` 筛选数据框行的子集，和所有基本操作函数一样，第一个参数是 tibble 或 data.frame 类型的数据框。第二个和后续的参数是选择满足表达式条件的行。

比如，筛选 1 月 1 日的所有航班

```r
filter(flights, month == 1, day == 1)
#> # A tibble: 842 x 19
#>    year month   day dep_time sched_dep_time dep_delay arr_time
#>   <int> <int> <int>    <int>          <int>     <dbl>    <int>
#> 1  2013     1     1      517            515         2      830
#> 2  2013     1     1      533            529         4      850
#> 3  2013     1     1      542            540         2      923
#> 4  2013     1     1      544            545        -1     1004
#> # ... with 838 more rows, and 12 more variables: sched_arr_time <int>,
#> #   arr_delay <dbl>, carrier <chr>, flight <int>, tailnum <chr>,
#> #   origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
#> #   minute <dbl>, time_hour <dttm>
```

如果用 Base R 代码来写的话，基本等价于

```r
flights[flights$month == 1 & flights$day == 1, ]
```

### 排序 `arrange()` 

`arrange()` 和 `filter()` 的工作方式类似，除了后者用来筛选行，而前者用来排序！ 如果提供多个列名，则每增加一列将用于打破前面各列的值的联系：


```r
arrange(flights, year, month, day)
#> # A tibble: 336,776 x 19
#>    year month   day dep_time sched_dep_time dep_delay arr_time
#>   <int> <int> <int>    <int>          <int>     <dbl>    <int>
#> 1  2013     1     1      517            515         2      830
#> 2  2013     1     1      533            529         4      850
#> 3  2013     1     1      542            540         2      923
#> 4  2013     1     1      544            545        -1     1004
#> # ... with 336,772 more rows, and 12 more variables: sched_arr_time <int>,
#> #   arr_delay <dbl>, carrier <chr>, flight <int>, tailnum <chr>,
#> #   origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
#> #   minute <dbl>, time_hour <dttm>
```

使用 `desc()` 函数达到降序排列的目的


```r
arrange(flights, desc(arr_delay))
#> # A tibble: 336,776 x 19
#>    year month   day dep_time sched_dep_time dep_delay arr_time
#>   <int> <int> <int>    <int>          <int>     <dbl>    <int>
#> 1  2013     1     9      641            900      1301     1242
#> 2  2013     6    15     1432           1935      1137     1607
#> 3  2013     1    10     1121           1635      1126     1239
#> 4  2013     9    20     1139           1845      1014     1457
#> # ... with 336,772 more rows, and 12 more variables: sched_arr_time <int>,
#> #   arr_delay <dbl>, carrier <chr>, flight <int>, tailnum <chr>,
#> #   origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
#> #   minute <dbl>, time_hour <dttm>
```

### 筛选列 `select()`

从一个大数据集上筛选部分列 `select()` :


```r
# 按变量名筛选
select(flights, year, month, day)
#> # A tibble: 336,776 x 3
#>    year month   day
#>   <int> <int> <int>
#> 1  2013     1     1
#> 2  2013     1     1
#> 3  2013     1     1
#> 4  2013     1     1
#> # ... with 336,772 more rows
# 选择变量 year 和 day 之间所有的列 (inclusive)
select(flights, year:day)
#> # A tibble: 336,776 x 3
#>    year month   day
#>   <int> <int> <int>
#> 1  2013     1     1
#> 2  2013     1     1
#> 3  2013     1     1
#> 4  2013     1     1
#> # ... with 336,772 more rows
# 和上面正好相反，除了 year 和 day 之间的列都选择
select(flights, -(year:day))
#> # A tibble: 336,776 x 16
#>   dep_time sched_dep_time dep_delay arr_time sched_arr_time arr_delay
#>      <int>          <int>     <dbl>    <int>          <int>     <dbl>
#> 1      517            515         2      830            819        11
#> 2      533            529         4      850            830        20
#> 3      542            540         2      923            850        33
#> 4      544            545        -1     1004           1022       -18
#> # ... with 336,772 more rows, and 10 more variables: carrier <chr>,
#> #   flight <int>, tailnum <chr>, origin <chr>, dest <chr>, air_time <dbl>,
#> #   distance <dbl>, hour <dbl>, minute <dbl>, time_hour <dttm>
```

这有很多有用的函数可以在 `select()` 内使用，比如 `starts_with()`, `ends_with()`, `matches()` 和 `contains()`。这些函数都有点正则匹配的意思了，当然能够更加方便地选择更大范围的数据块，实现更加复杂的筛选条件。

变量重命名

```r
select(flights, tail_num = tailnum)
#> # A tibble: 336,776 x 1
#>   tail_num
#>   <chr>   
#> 1 N14228  
#> 2 N24211  
#> 3 N619AA  
#> 4 N804JB  
#> # ... with 336,772 more rows
```

但是，由于 `select()` 扔掉所有变量而不显式地提醒, 所以我们推荐使用 `rename()`:


```r
rename(flights, tail_num = tailnum)
#> # A tibble: 336,776 x 19
#>    year month   day dep_time sched_dep_time dep_delay arr_time
#>   <int> <int> <int>    <int>          <int>     <dbl>    <int>
#> 1  2013     1     1      517            515         2      830
#> 2  2013     1     1      533            529         4      850
#> 3  2013     1     1      542            540         2      923
#> 4  2013     1     1      544            545        -1     1004
#> # ... with 336,772 more rows, and 12 more variables: sched_arr_time <int>,
#> #   arr_delay <dbl>, carrier <chr>, flight <int>, tail_num <chr>,
#> #   origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
#> #   minute <dbl>, time_hour <dttm>
```

### 添加新列/变异 `mutate()`

除了从已有的列中选择子集，还可以根据已有的列添加新的列，这常常是很有用的。这个工作由函数 `mutate()`完成:


```r
mutate(flights,
  gain = arr_delay - dep_delay,
  speed = distance / air_time * 60
)
#> # A tibble: 336,776 x 21
#>    year month   day dep_time sched_dep_time dep_delay arr_time
#>   <int> <int> <int>    <int>          <int>     <dbl>    <int>
#> 1  2013     1     1      517            515         2      830
#> 2  2013     1     1      533            529         4      850
#> 3  2013     1     1      542            540         2      923
#> 4  2013     1     1      544            545        -1     1004
#> # ... with 336,772 more rows, and 14 more variables: sched_arr_time <int>,
#> #   arr_delay <dbl>, carrier <chr>, flight <int>, tailnum <chr>,
#> #   origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
#> #   minute <dbl>, time_hour <dttm>, gain <dbl>, speed <dbl>
```

`dplyr::mutate()` 类似于 Base R 中的 `transform()` 函数, 并且允许使用刚刚创建的新变量（这个功能需要借助 Base R 中的 `within` 函数来实现）:


```r
mutate(flights,
  gain = arr_delay - dep_delay,
  gain_per_hour = gain / (air_time / 60)
)
#> # A tibble: 336,776 x 21
#>    year month   day dep_time sched_dep_time dep_delay arr_time
#>   <int> <int> <int>    <int>          <int>     <dbl>    <int>
#> 1  2013     1     1      517            515         2      830
#> 2  2013     1     1      533            529         4      850
#> 3  2013     1     1      542            540         2      923
#> 4  2013     1     1      544            545        -1     1004
#> # ... with 336,772 more rows, and 14 more variables: sched_arr_time <int>,
#> #   arr_delay <dbl>, carrier <chr>, flight <int>, tailnum <chr>,
#> #   origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
#> #   minute <dbl>, time_hour <dttm>, gain <dbl>, gain_per_hour <dbl>
```

如果你只想保持住创建的新变量，可以使用函数 `transmute()`:


```r
transmute(flights,
  gain = arr_delay - dep_delay,
  gain_per_hour = gain / (air_time / 60)
)
#> # A tibble: 336,776 x 2
#>    gain gain_per_hour
#>   <dbl>         <dbl>
#> 1     9          2.38
#> 2    16          4.23
#> 3    31         11.6 
#> 4   -17         -5.57
#> # ... with 336,772 more rows
```

### 汇总统计 `summarise()`

最后一个动词是 `summarise()` 它将数据框浓缩成一个单行，有汇总的效果


```r
summarise(flights,
  delay = mean(dep_delay, na.rm = TRUE)
)
#> # A tibble: 1 x 1
#>   delay
#>   <dbl>
#> 1  12.6
```

学了  `group_by()` 函数后，会发现它很有用，因为分组汇总嘛！。

### 随机抽样 `sample_n()` 和 `sample_frac()`

 `sample_n()` 和 `sample_frac()` 用于对行进行随机抽样，函数 `sample_n()` 抽取指定数目的行，而函数 `sample_frac()` 抽取指定的比例。


```r
sample_n(flights, 10)
#> # A tibble: 10 x 19
#>    year month   day dep_time sched_dep_time dep_delay arr_time
#>   <int> <int> <int>    <int>          <int>     <dbl>    <int>
#> 1  2013     9     9     1440           1429        11     1649
#> 2  2013     5    15     1427           1429        -2     1728
#> 3  2013     8    14     1121           1120         1     1228
#> 4  2013     8     4     1448           1429        19     1657
#> # ... with 6 more rows, and 12 more variables: sched_arr_time <int>,
#> #   arr_delay <dbl>, carrier <chr>, flight <int>, tailnum <chr>,
#> #   origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
#> #   minute <dbl>, time_hour <dttm>
sample_frac(flights, 0.01)
#> # A tibble: 3,368 x 19
#>    year month   day dep_time sched_dep_time dep_delay arr_time
#>   <int> <int> <int>    <int>          <int>     <dbl>    <int>
#> 1  2013    11     7     1855           1900        -5     2238
#> 2  2013     3    10     1930           1935        -5     2213
#> 3  2013     2    22     1622           1615         7     1820
#> 4  2013     8     9      602            605        -3      744
#> # ... with 3,364 more rows, and 12 more variables: sched_arr_time <int>,
#> #   arr_delay <dbl>, carrier <chr>, flight <int>, tailnum <chr>,
#> #   origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
#> #   minute <dbl>, time_hour <dttm>
```

使用 `replace = TRUE` 参数选项可以实现重抽样（或者说 boostrap 抽样）。如果需要，启用 weight 参数可以实现按比例抽样.

### 共同点

你可能已经注意到这些操作的语法和函数具有相似性

* 第一个参数是一个数据框

* 后面的参数描述对该数据框的操作，可以通过 `$` 直接引用数据框中的列

* 结果是一个新数据框

这些特性合在一起就很容易将多个简单的步骤串起来实现一个复杂的结果。

这 5 个函数提供了数据操作语法的基石。对某些行重新排列 `arrange()`，筛选感兴趣的观测值和变量 `filter()` 和 `select()`，基于存在的变量添加新的变量 `mutate()`，或者汇总统计多个变量值`summarise()`。下面介绍这5个函数如何应用到不同的数据类型，比如分组数据。


## 数据操作模式 Patterns of operations

dplyr 可以按照完成的数据操作的类型来分类，我们可以称之为语义 **semantics**（表达的意思）。最重要、最有用的数据操作是分组与否的区别。此外，掌握选择 select 和变异 mutate 操作之间的区别也是有帮助的。


### 分组操作 Grouped operations

dplyr 提供的 5 个基本操作配合分组操作 `group_by` 可以变得更加强大。它将一个数据集按指定的方式分组，这个时候再使用5个基本函数，会自动将该函数作用到每个分组上。

分组对数据操作的影响：

* 分组选择 `select()` 和不分组选择 `select()` 是一致的，只是分组的变量总是保存的下来的。
   
* 分组排序 `arrange()` 和不分组排序也是一样。 如果设置参数 `.by_group = TRUE`， 在这种情况下，它先按分组变量排序。

* `mutate()` 和 `filter()` 与窗口函数一起使用是很有用的， 比如 `rank()` 或者 `min(x) == x`。详细描述见 `vignette("window-functions")`.
  
* `sample_n()` 和 `sample_frac()` 在每个组里按指定的样本量/比例采样。

* `summarise()` 计算每一组的统计量。

在下面这个例子里，首先将完整的数据集按航班分组 `group_by`，然后计算每个航班的飞行次数`count = n()`，平均飞行距离`dist = mean(distance, na.rm = TRUE)`和平均延误`delay = mean(arr_delay, na.rm = TRUE)`，最后用 ggplot2 显示结果



```r
by_tailnum <- group_by(flights, tailnum)
delay <- summarise(by_tailnum,
  count = n(),
  dist = mean(distance, na.rm = TRUE),
  delay = mean(arr_delay, na.rm = TRUE))
delay <- filter(delay, count > 20, dist < 2000)

# Interestingly, the average delay is only slightly related to the
# average distance flown by a plane.
ggplot(delay, aes(dist, delay)) +
  geom_point(aes(size = count), alpha = 1/2) +
  geom_smooth() +
  scale_size_area()
```

![](https://user-images.githubusercontent.com/12031874/67177166-dbb82800-f3ff-11e9-999c-bd56bdb071c9.png)

将 `summarise()` 和聚合函数一起使用， 这些函数接受一个向量，输出一个值。在 Base R 内有很多这样的函数，比如 `min()`, `max()`, `mean()`, `sum()`, `sd()`, `median()`, 和 `IQR()`. dplyr 还提供一些其他有用的函数：

* `n()`: 当前组中观测的个/行数

* `n_distinct(x)`: `x` 中唯一的值的个数，一组值去重后的数量。

* `first(x)`， `last(x)` 和 `nth(x, n)`，这些操作和 `x[1]`, `x[length(x)]`, 和 `x[n]` 是类似的，对于值缺失的情况，给你更多的控制，。

比如，我们可以使用这些操作找到飞机的数量以及飞往每个可能目的地的航班数量：


```r
destinations <- group_by(flights, dest)
summarise(destinations,
  planes = n_distinct(tailnum),
  flights = n()
)
#> # A tibble: 105 x 3
#>   dest  planes flights
#>   <chr>  <int>   <int>
#> 1 ABQ      108     254
#> 2 ACK       58     265
#> 3 ALB      172     439
#> 4 ANC        6       8
#> # ... with 101 more rows
```

当按多个变量分组时，每个摘要都会剥离分组的一个级别。 这样可以轻松地逐步汇总数据集：


```r
daily <- group_by(flights, year, month, day)
(per_day   <- summarise(daily, flights = n()))
#> # A tibble: 365 x 4
#> # Groups:   year, month [12]
#>    year month   day flights
#>   <int> <int> <int>   <int>
#> 1  2013     1     1     842
#> 2  2013     1     2     943
#> 3  2013     1     3     914
#> 4  2013     1     4     915
#> # ... with 361 more rows
(per_month <- summarise(per_day, flights = sum(flights)))
#> # A tibble: 12 x 3
#> # Groups:   year [1]
#>    year month flights
#>   <int> <int>   <int>
#> 1  2013     1   27004
#> 2  2013     2   24951
#> 3  2013     3   28834
#> 4  2013     4   28330
#> # ... with 8 more rows
(per_year  <- summarise(per_month, flights = sum(flights)))
#> # A tibble: 1 x 2
#>    year flights
#>   <int>   <int>
#> 1  2013  336776
```

但是，在逐步汇总这样的汇总时，必须要小心：求和和计数是可以的，但是您需要考虑对均值和方差进行加权（不能对中位数进行加权）。


### 选择操作 Selecting operations

dplyr 吸引人的功能之一是可以引用小标题中的列，就像它们是常规变量一样。 但是，引用裸列名称的语法统一性掩盖了整个动词的语义差异。提供给 `select()` 的列符号与提供给 `mutate()` 的符号没有相同的含义。

选择操作需要列名和位置。 因此，当您使用裸变量名调用`select()`时，它们实际上表示了自己在小标题中的位置。 从 dplyr 的角度来看，以下调用完全等效：


```r
# `year` 表示整数 1
select(flights, year)
#> # A tibble: 336,776 x 1
#>    year
#>   <int>
#> 1  2013
#> 2  2013
#> 3  2013
#> 4  2013
#> # ... with 336,772 more rows
select(flights, 1)
#> # A tibble: 336,776 x 1
#>    year
#>   <int>
#> 1  2013
#> 2  2013
#> 3  2013
#> 4  2013
#> # ... with 336,772 more rows
```

同样，这意味着如果变量与列之一具有相同的名称，则不能引用周围上下文中的变量。在下面这个例子， `year` 仍然表示 1 而不是 5:

```r
year <- 5
select(flights, year)
```

一个有用的技巧是仅适用于裸名和类似 `c(year, month, day)` 或者 `year:day` 的选择操作。在其它所有情况下，数据框的列都不会放在 scope 里，这使得你可以在 select 操作中使用上下文环境变量


```r
year <- "dep"
select(flights, starts_with(year))
#> # A tibble: 336,776 x 2
#>   dep_time dep_delay
#>      <int>     <dbl>
#> 1      517         2
#> 2      533         4
#> 3      542         2
#> 4      544        -1
#> # ... with 336,772 more rows
```

这些语义通常是直观的，但是注意其中微妙的区别


```r
year <- 5
select(flights, year, identity(year))
#> # A tibble: 336,776 x 2
#>    year sched_dep_time
#>   <int>          <int>
#> 1  2013            515
#> 2  2013            529
#> 3  2013            540
#> 4  2013            545
#> # ... with 336,772 more rows
```

第一个参数， `year` 表示它自己的位置 1。 第二个参数 `year` 根据上下文计算表示第5列。

在很长一段时间里 `select()` 仅能理解列的位置，从 dplyr 版本 0.6 开始，它也能理解列名。这使得用 `select()` 编程比较容易:


```r
vars <- c("year", "month")
select(flights, vars, "day")
#> # A tibble: 336,776 x 3
#>    year month   day
#>   <int> <int> <int>
#> 1  2013     1     1
#> 2  2013     1     1
#> 3  2013     1     1
#> 4  2013     1     1
#> # ... with 336,772 more rows
```

值得注意的是上述代码有些不太安全，因为你可能已经添加了一个叫 `vars` 的列，或者你可能将其应用到另一个包含这样的列的数据框中。为了防止这个问题，你可以使用 `identity()` 包装一下这个变量，调用我们上面提到的，这也会传递列名。然而，但是，一种适用于所有 dplyr 动词的更明确，更通用的方法是用 `!!` 操作符取消对变量的引用。 这告诉 dplyr 绕过数据框并直接在上下文中查找：


```r
# Let's create a new `vars` column:
flights$vars <- flights$year

# The new column won't be an issue if you evaluate `vars` in the
# context with the `!!` operator:
vars <- c("year", "month", "day")
select(flights, !! vars)
#> # A tibble: 336,776 x 3
#>    year month   day
#>   <int> <int> <int>
#> 1  2013     1     1
#> 2  2013     1     1
#> 3  2013     1     1
#> 4  2013     1     1
#> # ... with 336,772 more rows
```

这个操作非常有用，特别是需要在 dplyr 内使用自定义的函数时。文档  `vignette("programming")` 介绍了更多这方面的东西。理解取消引用的动词语义是很重要的。如你所见，以 select 为例，`select()` 支持列名和位置，但是在其它动词中不会这样，比如 `mutate()` ，因为它们有不同的语义。


### 添加新列的操作/变异操作 Mutating operations

Mutate 和 selection 操作是很不一样的。其中 `select()` 使用列名或位置， `mutate()` 使用列向量
*column vectors*. 让我们创建一个更小的 tibble 来说明一下：


```r
df <- select(flights, year:dep_time)
```

当我们使用 `select()`, 裸列名称表示它们自己在 tibble 中的位置。另一方面，`mutate()` 列符号表示存储在 tibble 中的实际列向量。思考一下，如果我们传递一个字符串和数字给 `mutate()` 会发生什么？


```r
mutate(df, "year", 2)
#> # A tibble: 336,776 x 6
#>    year month   day dep_time `"year"`   `2`
#>   <int> <int> <int>    <int> <chr>    <dbl>
#> 1  2013     1     1      517 year         2
#> 2  2013     1     1      533 year         2
#> 3  2013     1     1      542 year         2
#> 4  2013     1     1      544 year         2
#> # ... with 336,772 more rows
```

`mutate()` 得到长度为1的向量，它会解释为数据框中的一个新的列。这些向量会循环去匹配行的长度。这就是为什么提供这样的表达式 `"year" + 10` 给 `mutate()` 没有意义。这等价于将 10 加到一个字符串上！正确的表达式是:


```r
mutate(df, year + 10)
#> # A tibble: 336,776 x 5
#>    year month   day dep_time `year + 10`
#>   <int> <int> <int>    <int>       <dbl>
#> 1  2013     1     1      517        2023
#> 2  2013     1     1      533        2023
#> 3  2013     1     1      542        2023
#> 4  2013     1     1      544        2023
#> # ... with 336,772 more rows
```

同样，你能取消引用内容中的值，如果这些值表示一个有效的列。它们必须要么长度是1（这样它们可以循环补齐）或者与数据框的行数一样。在下面这个例子中，我们创建一个新的向量，添加到数据框，成为数据框中的列。


```r
var <- seq(1, nrow(df))
mutate(df, new = var)
#> # A tibble: 336,776 x 5
#>    year month   day dep_time   new
#>   <int> <int> <int>    <int> <int>
#> 1  2013     1     1      517     1
#> 2  2013     1     1      533     2
#> 3  2013     1     1      542     3
#> 4  2013     1     1      544     4
#> # ... with 336,772 more rows
```

一个典型的例子是 `group_by()`，尽管你会认为它有 select 选择语义，事实上它还有 mutate 变异语义。这很方便，因为它允许按修改后的列分组。


```r
group_by(df, month)
#> # A tibble: 336,776 x 4
#> # Groups:   month [12]
#>    year month   day dep_time
#>   <int> <int> <int>    <int>
#> 1  2013     1     1      517
#> 2  2013     1     1      533
#> 3  2013     1     1      542
#> 4  2013     1     1      544
#> # ... with 336,772 more rows
group_by(df, month = as.factor(month))
#> # A tibble: 336,776 x 4
#> # Groups:   month [12]
#>    year month   day dep_time
#>   <int> <fct> <int>    <int>
#> 1  2013 1         1      517
#> 2  2013 1         1      533
#> 3  2013 1         1      542
#> 4  2013 1         1      544
#> # ... with 336,772 more rows
group_by(df, day_binned = cut(day, 3))
#> # A tibble: 336,776 x 5
#> # Groups:   day_binned [3]
#>    year month   day dep_time day_binned
#>   <int> <int> <int>    <int> <fct>     
#> 1  2013     1     1      517 (0.97,11] 
#> 2  2013     1     1      533 (0.97,11] 
#> 3  2013     1     1      542 (0.97,11] 
#> 4  2013     1     1      544 (0.97,11] 
#> # ... with 336,772 more rows
```

这是你为什么不可以提供一个列名给 `group_by()` 的原因。 这等价于你创建一个新的列，这个新的列包含一个字符串，字符串重复补齐达到数据框的行数。


```r
group_by(df, "month")
#> # A tibble: 336,776 x 5
#> # Groups:   "month" [1]
#>    year month   day dep_time `"month"`
#>   <int> <int> <int>    <int> <chr>    
#> 1  2013     1     1      517 month    
#> 2  2013     1     1      533 month    
#> 3  2013     1     1      542 month    
#> 4  2013     1     1      544 month    
#> # ... with 336,772 more rows
```

既然带选择语义的分组也很有用，我们添加 `group_by_at()` 的变体。在 dplyr 里，变体的后缀 `_at()` 在第二个参数中支持选择语义。仅仅需要使用 `vars()` 包装选择。


```r
group_by_at(df, vars(year:day))
#> # A tibble: 336,776 x 4
#> # Groups:   year, month, day [365]
#>    year month   day dep_time
#>   <int> <int> <int>    <int>
#> 1  2013     1     1      517
#> 2  2013     1     1      533
#> 3  2013     1     1      542
#> 4  2013     1     1      544
#> # ... with 336,772 more rows
```

在帮助页面 `?scoped` 中提供了更多关于 `_at()` 和 `_if()` 的变体的介绍.


## 管道 {#Piping}

函数调用不会有副作用，但是你必须总是保存它们的结果。这不会产生优雅的代码，特别地，如果你想一次性做很多操作。你也必须一步步来。


```r
a1 <- group_by(flights, year, month, day)
a2 <- select(a1, arr_delay, dep_delay)
a3 <- summarise(a2,
  arr = mean(arr_delay, na.rm = TRUE),
  dep = mean(dep_delay, na.rm = TRUE))
a4 <- filter(a3, arr > 30 | dep > 30)
```

如果你不想给中间结果命名，你需要将函数嵌套着使用。


```r
filter(
  summarise(
    select(
      group_by(flights, year, month, day),
      arr_delay, dep_delay
    ),
    arr = mean(arr_delay, na.rm = TRUE),
    dep = mean(dep_delay, na.rm = TRUE)
  ),
  arr > 30 | dep > 30
)
#> Adding missing grouping variables: `year`, `month`, `day`
#> # A tibble: 49 x 5
#> # Groups:   year, month [11]
#>    year month   day   arr   dep
#>   <int> <int> <int> <dbl> <dbl>
#> 1  2013     1    16  34.2  24.6
#> 2  2013     1    31  32.6  28.7
#> 3  2013     2    11  36.3  39.1
#> 4  2013     2    27  31.3  37.8
#> # ... with 45 more rows
```

这是很难去阅读的，因为数据操作的顺序是从里到外的。因此，参数是以一种很长的方式远离了函数，为了处理这个问题， dplyr 借助 magrittr 包提供 `%>%` 管道操作. `x %>% f(y)` 转化为 `f(x, y)`，这样，你就能够用它重写多个操作，也能从左到右，从上到下地读代码：


```r
flights %>%
  group_by(year, month, day) %>%
  select(arr_delay, dep_delay) %>%
  summarise(
    arr = mean(arr_delay, na.rm = TRUE),
    dep = mean(dep_delay, na.rm = TRUE)
  ) %>%
  filter(arr > 30 | dep > 30)
```

## 其它数据源 {#other-data-source}

和 data.frame 一样， dplyr 也能处理以其他形式存储的数据，如 data.table、 数据库和多维数组

### data.table {#data-table}

dplyr 通过 [dtplyr](http://github.com/hadley/dtplyr) 包为前面介绍的操作也提供 [data.table](https://github.com/Rdatatable/data.table) 方法，如果你已经在使用 data.table ，这会让你使用 dplyr 语法用于数据操作。

对于多个操作，data.table 可以更快，因为您通常同时将其与多个动词一起使用。 例如，使用数据表 data.table，您可以在一个步骤中进行编译 mutate 和选择 select 操作。data.table 足够聪明地知道根据要丢弃的行计算新变量毫无意义。

相比于 data.table，dplyr 的优势是：

* 对于常见的数据处理任务，它使您与 data.tables 的引用语义相隔离，并防止意外修改数据。

* data.table 的复杂操作是基于索引下标符 `[` 构建的，特点是结硬寨，打呆仗！一次做一件事，但是做很好！步步为营！

### 数据库 {#database}

dplyr 提供相同的操作语法去操作数据库里的数据。 dplyr 会生成 SQL，这样可以避免不断切换语言的认知挑战。要使用这些功能，需要安装 dbplyr 包，然后阅读
`vignette("dbplyr")` 了解详细信息。


### 多维数组和立方体 {#array-cube}

函数 `tbl_cube()` 为多维数据或立方体数据提供实验性的接口。如果你正在使用这种形式的数据，请联系我，这样我就能更好地理解你的需求。

## 比较 {#comparis}

与所有存在的可选项比较， dplyr:

* 抽象了数据存储层面，因此，你可以在 data.frame、 data.table 和远程数据库上使用相同的函数操作 这让你可以集中在你想实现的内容上，而不是在数据存储的逻辑上。

* 提供了周到的默认的 `print()` 方法，它不会自动将数据打印到屏幕。这受到 data table 输出的影响

与 Base R 的数据操作函数比较:

* dplyr 操作更加一致; 函数有相同的接口。一旦你掌握一个，你能轻易地掌握其它的函数操作。

* Base R 操作函数倾向于在 vector 向量层面操作。而 dplyr 基于 data.frame 数据框层面操作

与 plyr 相比， dplyr：

* 快很多

* 更好的 join 操作

* 仅提供工具用于操作数据框，比如 dplyr 的大多数操作等价于 `ddply()` + 各种函数, `do()` 等价于 `dlply()`

与实际的数据框方法比较:

* 它不假定你有一个数据框，比如，如果你想用 `lm` 做回归，你仍然需要手动将数据拉下来。

* 它不提供 R 统计函数的方法，比如 `mean()`, 或者 `sum()`

