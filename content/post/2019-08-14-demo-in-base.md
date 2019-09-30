---
title: R 帮助文档中的演示
author: 黄湘云
date: '2019-08-17'
slug: demo-in-base
categories:
  - 统计计算
tags: 
  - R 语言
---

Base R 包含如下四个演示

error.catching
: More examples on catching and handling errors

is.things
: Explore some properties of R objects and is.FOO() functions. Not for newbies!

recursion
: Using recursion for adaptive integration

scoping
: An illustration of lexical scoping.


## 抓住错误

> 异常处理

R 包内的演示，可以在控制台中，运行 `demo("error.catching", package = "base")` 然后你会看到这样的提示，回车之后便开始运行代码


```
        demo(error.catching)
        ---- ~~~~~~~~~~~~~~

Type  <Return>   to start : 
```

这个叫 `error.catching` 的演示其实是由一个 R 脚本写成的，甚至就是一段 R 代码而已，请运行下面一行命令打开该脚本

```r
file.show(system.file('demo/error.catching.R', package = 'base'))
```
```
	##================================================================##
	###  In longer simulations, aka computer experiments,		 ###
	###  you may want to						 ###
	###  1) catch all errors and warnings (and continue)		 ###
	###  2) store the error or warning messages			 ###
	###								 ###
	###  Here's a solution	(see R-help mailing list, Dec 9, 2010):	 ###
	##================================================================##

##' Catch *and* save both errors and warnings, and in the case of
##' a warning, also keep the computed result.
##'
##' @title tryCatch both warnings (with value) and errors
##' @param expr an \R expression to evaluate
##' @return a list with 'value' and 'warning', where
##'   'value' may be an error caught.
##' @author Martin Maechler;
##' Copyright (C) 2010-2012  The R Core Team
tryCatch.W.E <- function(expr)
{
    W <- NULL
    w.handler <- function(w){ # warning handler
	W <<- w
	invokeRestart("muffleWarning")
    }
    list(value = withCallingHandlers(tryCatch(expr, error = function(e) e),
				     warning = w.handler),
	 warning = W)
}

str( tryCatch.W.E( log( 2 ) ) )
str( tryCatch.W.E( log( -1) ) )
str( tryCatch.W.E( log("a") ) )
```

这是一个标准的 demo 应该具有的东西，其包含三个例子，说明该 demo 的功能

```r
str( tryCatch.W.E( log( 2 ) ) )
```
```
List of 2
 $ value  : num 0.693
 $ warning: NULL
```
```r
str( tryCatch.W.E( log( -1) ) )
```
```
List of 2
 $ value  : num NaN
 $ warning:List of 2
  ..$ message: chr "NaNs produced"
  ..$ call   : language log(-1)
  ..- attr(*, "class")= chr [1:3] "simpleWarning" "warning" "condition"
```
```r
str( tryCatch.W.E( log("a") ) )
```
```
List of 2
 $ value  :List of 2
  ..$ message: chr "non-numeric argument to mathematical function"
  ..$ call   : language log("a")
  ..- attr(*, "class")= chr [1:3] "simpleError" "error" "condition"
 $ warning: NULL
```

## 对象类型

> 对象或类型判断

```r
file.show(system.file('demo/is.things.R', package = 'base'))
```

`demo("is.things", package = "base")`

```r
#  Copyright (C) 1997-2018 The R Core Team

### The Base package has a couple of non-functions:
##
## These may be in "base" when they exist;  discount them here
## (see also  'dont.mind' in checkConflicts() inside library()) :
xtraBaseNms <- c("last.dump", "last.warning", ".Last.value",
                 ".Random.seed", ".Traceback")
ls.base <- Filter(function(nm) is.na(match(nm, xtraBaseNms)),
                  ls("package:base", all=TRUE))
base.is.f <- sapply(ls.base, function(x) is.function(get(x)))
cat("\nNumber of all base objects:\t", length(ls.base),
    "\nNumber of functions from these:\t", sum(base.is.f),
    "\n\t starting with 'is.' :\t  ",
    sum(grepl("^is\\.", ls.base[base.is.f])), "\n", sep = "")
```
```
Number of all base objects:     1350
Number of functions from these: 1307
         starting with 'is.' :    50
```

R 版本及其包含的对象判断函数数量

 R ver.| #{`is*()`}
 ------+---------
 0.14  : 31
 0.50  : 33
 0.60  : 34
 0.63  : 37
 1.0.0 : 38
 1.3.0 : 41
 1.6.0 : 45
 2.0.0 : 45
 2.7.0 : 48
 3.0.0 : 49


```r
if(interactive()) {
    nonDots <- function(nm) substr(nm, 1L, 1L) != "."
    cat("Base non-functions not starting with \".\":\n")
    Filter(nonDots, ls.base[!base.is.f])
}
```

```r
## Do we have a method (probably)?
is.method <- function(fname) {
    isFun <- function(name) (exists(name, mode="function") &&
                             is.na(match(name, c("is", "as"))))
    np <- length(sp <- strsplit(fname, split = "\\.")[[1]])
    if(np <= 1 )
        FALSE
    else
        (isFun(paste(sp[1:(np-1)], collapse = '.')) ||
         (np >= 3 &&
          isFun(paste(sp[1:(np-2)], collapse = '.'))))
}

is.ALL <- function(obj, func.names = ls(pos=length(search())),
                   not.using = c("is.single", "is.real", "is.loaded",
                     "is.empty.model", "is.R", "is.element", "is.unsorted"),
                   true.only = FALSE, debug = FALSE)
{
    ## Purpose: show many 'attributes' of  R object __obj__
    ## -------------------------------------------------------------------------
    ## Arguments: obj: any R object
    ## -------------------------------------------------------------------------
    ## Author: Martin Maechler, Date: 6 Dec 1996

    is.fn <- func.names[substring(func.names,1,3) == "is."]
    is.fn <- is.fn[substring(is.fn,1,7) != "is.na<-"]
    use.fn <- is.fn[ is.na(match(is.fn, not.using))
                    & ! sapply(is.fn, is.method) ]

    r <- if(true.only) character(0)
    else structure(vector("list", length= length(use.fn)), names= use.fn)
    for(f in use.fn) {
        if(any(f == c("is.na", "is.finite"))) {
            if(!is.list(obj) && !is.vector(obj) && !is.array(obj)) {
                if(!true.only) r[[f]] <- NA
                next
            }
        }
        if(any(f == c("is.nan", "is.finite", "is.infinite"))) {
            if(!is.atomic(obj)) {
                if(!true.only) r[[f]] <- NA
                next
            }
        }
        if(debug) cat(f,"")
        fn <- get(f)
        rr <- if(is.primitive(fn) || length(formals(fn))>0)  fn(obj) else fn()
        if(!is.logical(rr)) cat("f=",f," --- rr  is NOT logical  = ",rr,"\n")
        ##if(1!=length(rr))   cat("f=",f," --- rr NOT of length 1; = ",rr,"\n")
        if(true.only && length(rr)==1 && !is.na(rr) && rr) r <- c(r, f)
        else if(!true.only) r[[f]] <- rr
    }
    if(debug)cat("\n")
    if(is.list(r)) structure(r, class = "isList") else r
}

print.isList <- function(x, ..., verbose = getOption("verbose"))
{
    ## Purpose:  print METHOD  for `isList' objects
    ## ------------------------------------------------
    ## Author: Martin Maechler, Date: 12 Mar 1997
    if(is.list(x)) {
        if(verbose) cat("print.isList(): list case (length=",length(x),")\n")
        nm <- format(names(x))
        rr <- lapply(x, stats::symnum, na = "NA")
        for(i in seq_along(x)) cat(nm[i],":",rr[[i]],"\n", ...)
    } else NextMethod("print", ...)
}
```

R 内置有大量的类型判断函数

```r
apropos('^is\\.')
```
```
 [1] "is.array"                "is.atomic"               "is.call"                
 [4] "is.character"            "is.complex"              "is.data.frame"          
 [7] "is.double"               "is.element"              "is.empty.model"         
[10] "is.environment"          "is.expression"           "is.factor"              
[13] "is.finite"               "is.function"             "is.infinite"            
[16] "is.integer"              "is.language"             "is.leaf"                
[19] "is.list"                 "is.loaded"               "is.logical"             
[22] "is.matrix"               "is.mts"                  "is.na"                  
[25] "is.na.data.frame"        "is.na.numeric_version"   "is.na.POSIXlt"          
[28] "is.na<-"                 "is.na<-.default"         "is.na<-.factor"         
[31] "is.na<-.numeric_version" "is.name"                 "is.nan"                 
[34] "is.null"                 "is.numeric"              "is.numeric.Date"        
[37] "is.numeric.difftime"     "is.numeric.POSIXt"       "is.numeric_version"     
[40] "is.object"               "is.ordered"              "is.package_version"     
[43] "is.pairlist"             "is.primitive"            "is.qr"                  
[46] "is.R"                    "is.raster"               "is.raw"                 
[49] "is.recursive"            "is.relistable"           "is.single"              
[52] "is.stepfun"              "is.symbol"               "is.table"               
[55] "is.ts"                   "is.tskernel"             "is.unsorted"            
[58] "is.vector"   
```

```r
is.ALL(NULL)
##fails: is.ALL(NULL, not.using = c("is.single", "is.loaded"))
is.ALL(NULL,   true.only = TRUE)
all.equal(NULL, pairlist())
## list() != NULL == pairlist() :
is.ALL(list(), true.only = TRUE)

(pl <- is.ALL(pairlist(1,    list(3,"A")), true.only = TRUE))
(ll <- is.ALL(    list(1,pairlist(3,"A")), true.only = TRUE))
all.equal(pl[pl != "is.pairlist"],
          ll[ll != "is.vector"])## TRUE

is.ALL(1:5)
is.ALL(array(1:24, 2:4))
is.ALL(1 + 3)
e13 <- expression(1 + 3)
is.ALL(e13)
is.ALL(substitute(expression(a + 3), list(a=1)), true.only = TRUE)
is.ALL(y ~ x) #--> NA    for is.na & is.finite

is0 <- is.ALL(numeric(0))
is0.ok <- 1 == (lis0 <- sapply(is0, length))
is0[!is0.ok]
is0 <- unlist(is0)
is0
ispi <- unlist(is.ALL(pi))
all(ispi[is0.ok] == is0)

is.ALL(numeric(0), true=TRUE)
is.ALL(array(1,1:3), true=TRUE)
is.ALL(cbind(1:3), true=TRUE)

is.ALL(structure(1:7, names = paste("a",1:7,sep="")))
is.ALL(structure(1:7, names = paste("a",1:7,sep="")), true.only = TRUE)

x <- 1:20 ; y <- 5 + 6*x + rnorm(20)
lm.xy <- lm(y ~ x)
is.ALL(lm.xy)
is.ALL(structure(1:7, names = paste("a",1:7,sep="")))
is.ALL(structure(1:7, names = paste("a",1:7,sep="")), true.only = TRUE)
```
