
<!-- README.md is generated from README.Rmd. Please edit that file -->
curry
=====

[![Travis-CI Build Status](https://travis-ci.org/thomasp85/curry.svg?branch=master)](https://travis-ci.org/thomasp85/curry) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/thomasp85/curry?branch=master&svg=true)](https://ci.appveyor.com/project/thomasp85/curry) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/curry)](https://cran.r-project.org/package=curry) [![CRAN\_Download\_Badge](http://cranlogs.r-pkg.org/badges/grand-total/curry)](http://cran.r-project.org/package=curry)

`curry` is yet another attempt at providing a native currying/partial application mechanism in R. Other examples of implementations of this can be found in [`purrr`](https://CRAN.R-project.org/package=purrr) and [`functional`](https://CRAN.R-project.org/package=functional) (and probably others). `curry` sets itself apart in the manner it is used and in the functions it creates. `curry` is operator based and a partially applied function retains named arguments for easier autocomplete etc. `curry` provides three mechanisms for partial application: `%<%` (`curry()`), `%-<%` (`tail_curry()`), and `%><%` (`partial()`) - see the examples for the differences

Example
-------

Currying is the reduction of the arity of a function by fixing the first argument, returning a new function lacking this.

``` r
# Equivalent to curry(`+`, 5)
add_5 <- `+` %<% 5
add_5(10)
#> [1] 15

# ellipsis are retained when currying
bind_5 <- cbind %<% 5
bind_5(1:10)
#>       [,1] [,2]
#>  [1,]    5    1
#>  [2,]    5    2
#>  [3,]    5    3
#>  [4,]    5    4
#>  [5,]    5    5
#>  [6,]    5    6
#>  [7,]    5    7
#>  [8,]    5    8
#>  [9,]    5    9
#> [10,]    5   10
```

Tail currying is just like currying except it reduces the arity of the function from the other end by fixing the last argument.

``` r
# Equivalent to tail_curry(`/`, 5)
divide_by_5 <- `/` %-<% 5
divide_by_5(10)
#> [1] 2

no_factors <- data.frame %-<% FALSE
df <- no_factors(x = letters[1:5])
class(df$x)
#> [1] "character"
```

When the argument you wish to fix is not in either end of the argument list it is necessary to use a more generalised approach. Using `%><%` (or `partial()`) it is possible to fix any (and multiple) arguments in a function using a list of values to fix.

``` r
dummy_lengths <- vapply %><% list(FUN = length, FUN.VALUE = integer(1))
test_list <- list(a = 1:5, b = 1:10)
dummy_lengths(test_list)
#>  a  b 
#>  5 10
```

Other efforts in this has the drawback of returning a new function with just an ellipsis, making argument checks and autocomplete impossible. With `curry` the returned functions retains named arguments (minus the fixed ones).

``` r
args(no_factors)
#> function (..., row.names = NULL, check.rows = FALSE, check.names = TRUE, 
#>     fix.empty.names = TRUE) 
#> NULL
args(dummy_lengths)
#> function (X, ..., USE.NAMES = TRUE) 
#> NULL
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
