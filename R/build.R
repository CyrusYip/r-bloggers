# rmarkdown::render(input = paste("content/post", list.files(path = "content/post", pattern = "[.]Rmd"), sep = "/"),
#                   output_format = "blogdown::html_page")
# blogdown::build_dir(dir = 'static/rmd')

# knit Rmd to md
oldwd <- getwd()
setwd("content/post")

input_files <- list.files(path = ".", pattern = "[.]Rmd$")
for (rmd in input_files) {
  knitr::knit(input = rmd, output = sub(pattern = "[.]Rmd", replacement = "\\.md", x = rmd))  
}

setwd(oldwd)
