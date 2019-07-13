---
title: 学者主页
author: 黄湘云
date: '2019-06-16'
slug: researcher-homepage
categories:
  - 推荐文章
tags:
  - 学者主页
thumbnail: https://wp-contents.netlify.com/2019/06/lixingzhu.png
description: "当年读硕士，在看论文的过程中收集的中外学者主页（部分），缩略图是我和祖师爷朱力行教授的合照"
---

|学者                        |主页                                                                      |
|:---------------------------|:-------------------------------------------------------------------------|
|吴建福                      |https://www2.isye.gatech.edu/~jeffwu/                                     |
|林夕虹                      |https://www.hsph.harvard.edu/xihong-lin/                                  |
|朱力行                      |http://www.math.hkbu.edu.hk/~lzhu/                                        |
|姚琦伟                      |http://stats.lse.ac.uk/q.yao/                                             |
|范剑青                      |https://orfe.princeton.edu/~jqfan/index.html                              |
|蔡天文                      |http://www-stat.wharton.upenn.edu/~tcai/                                  |
|李润泽                      |http://personal.psu.edu/ril4/                                             |
|孟晓犁                      |https://statistics.fas.harvard.edu/people/xiao-li-meng                    |
|Jiahua Chen                 |https://www.stat.ubc.ca/~jhchen/                                          |
|Erich Leo Lehmann 1917-2019 |https://en.wikipedia.org/wiki/Erich_Leo_Lehmann                           |
|Peter Hall 1951-2016        |https://en.wikipedia.org/wiki/Peter_Gavin_Hall                            |
|Sebastian Sauer             |https://data-se.netlify.com                                               |
|Peter J. Diggle             |https://www.lancaster.ac.uk/staff/diggle/                                 |
|Rob J Hyndman               |https://robjhyndman.com/                                                  |
|Julian Faraway              |https://farawaystatistics.wordpress.com/                                  |
|Andrew Gelman               |https://andrewgelman.com/                                                 |
|Norm Matloff                |https://matloff.wordpress.com/                                            |
|Brian Ripley                |http://www.stats.ox.ac.uk/~ripley/                                        |
|John Fox                    |https://socialsciences.mcmaster.ca/jfox/                                  |
|Charlie Geyer               |http://users.stat.umn.edu/~geyer/                                         |
|Michael L. Stein            |http://www.stat.uchicago.edu/faculty/stein.shtml                          |
|Paula Moraga                |https://paula-moraga.github.io                                            |
|Francesco Bailo             |http://www.francescobailo.net/                                            |
|Edzer Pebesma               |https://www.r-spatial.org/                                                |
|Håvard Rue                  |http://www.r-inla.org/                                                    |
|Douglas Bates               |https://www.stat.wisc.edu/~bates/                                         |
|Jenny Bryan                 |https://jennybryan.org/                                                   |
|John Chambers               |http://statweb.stanford.edu/~jmc4/                                        |
|Peter Dalgaard              |http://staff.pubhealth.ku.dk/~pd/                                         |
|Uwe Ligges                  |https://www.statistik.tu-dortmund.de/ligges.html                          |
|Martin Mächler              |https://people.math.ethz.ch/~maechler/                                    |
|Di Cook                     |https://dicook.org/                                                       |
|Frank Harrell               |http://www.fharrell.com/                                                  |
|Ross Ihaka                  |https://www.stat.auckland.ac.nz/~ihaka/                                   |
|Martyn Plummer              |https://warwick.ac.uk/fac/sci/statistics/staff/academic-research/plummer/ |
|Bettina Grün                |http://ifas.jku.at/gruen/                                                 |
|Simo Särkkä                 |https://users.aalto.fi/~ssarkka/                                          |
|Charles Bouveyron           |https://math.unice.fr/~cbouveyr/                                          |
|Luke Tierney                |https://homepage.divms.uiowa.edu/~luke/                                   |
|Patrick Breheny             |https://myweb.uiowa.edu/pbreheny/index.html                               |
|Martin Wainwright           |https://people.eecs.berkeley.edu/~wainwrig/                               |
|Tim Davis                   |http://faculty.cse.tamu.edu/davis/welcome.html                            |
|Mehryar Mohri               |https://cs.nyu.edu/~mohri/mlbook/                                         |
|Larry Wasserman             |https://www.stat.cmu.edu/~larry/                                          |
|John F Monahan              |https://www4.stat.ncsu.edu/~monahan/                                      |
|Richard Glennie             |http://www.richardglennie.co.uk/                                          |
|Jane-Ling                   |http://www.stat.ucdavis.edu/~wang/                                        |



---

下面这段代码是继[工具](https://github.com/kent666a/py-chrome-bookmarks-markdown)导出书签后，将 md 文件的信息提取整理为表格

```r
rtc <- readLines(con = "content/post/2019-06-19-statistician.md", encoding = "UTF-8") 
extract2 <- function(x){
  unlist(regmatches(x, regexec("\\[(.*?)\\]\\((.*?)\\)", x)))[-1]
}
library(magrittr)
lapply(rtc, extract2) %>%
  unlist() %>%
  matrix(., ncol = 2, byrow = TRUE) %>%
  knitr::kable(., col.names = c("学者", "主页"))
```  
