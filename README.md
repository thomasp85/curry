
<!-- README.md is generated from README.Rmd. Please edit that file -->
curry
=====

`curry` is yet another attempt at providing a native currying mechanism in R. Other examples of implementations of function composition can be found in [`purrr`](https://CRAN.R-project.org/package=purrr) and [`functional`](https://CRAN.R-project.org/package=functional) (and probably others). `curry` sets itself apart in the manner it is used and in the functions it creates. `curry` uses the `%<%` operator to perform currying and a curried function retains named arguments for easier autocomplete.

Example
-------

``` r
library(curry)

list_with_5 <- list %<% 5
list_with_5(10)
#> [[1]]
#> [1] 5
#> 
#> [[2]]
#> [1] 10

chained_curry <- pmin %<% sample(10) %<% sample(10)
chained_curry()
#>  [1] 1 4 2 6 5 7 1 4 2 3
chained_curry(1:10)
#>  [1] 1 2 2 4 5 6 1 4 2 3
```

Installation
------------

`curry` is still a work in progress but can be installed through devtools:

``` r
if (!require(devtools)) {
    install.packages(devtools)
}
devtools::install_github('thomasp85/curry')
```
