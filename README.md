
<!-- README.md is generated from README.Rmd. Please edit that file -->
curry
=====

[![Travis-CI Build Status](https://travis-ci.org/thomasp85/curry.svg?branch=master)](https://travis-ci.org/thomasp85/curry) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/thomasp85/curry?branch=master&svg=true)](https://ci.appveyor.com/project/thomasp85/curry) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/curry)](https://CRAN.R-project.org/package=curry) [![CRAN\_Download\_Badge](http://cranlogs.r-pkg.org/badges/grand-total/curry)](https://CRAN.R-project.org/package=curry)

`curry` is yet another attempt at providing a native currying/partial application mechanism in R. Other examples of implementations of this can be found in [`purrr`](https://CRAN.R-project.org/package=purrr) and [`functional`](https://CRAN.R-project.org/package=functional) (and probably others). `curry` sets itself apart in the manner it is used and in the functions it creates. `curry` is operator based and a partially applied function retains named arguments for easier autocomplete etc. `curry` provides three mechanisms for partial application: `%<%` (`curry()`), `%-<%` (`tail_curry()`), and `%><%` (`partial()`) - see the examples for the differences

Example
-------

### Currying

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

### Tail currying

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

### Partial function application

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

### Real currying

The above uses a very loose (incorrect) definition of currying. The correct definition is that currying a function returns a function taking a single argument (the first from the original function). Calling a curried function will return a new function accepting the second argument of the original function and so on. Once all arguments of the original function has been consumed it evaluates the call and returns the result. Thus:

``` r
# Correct currying
foo(arg1)(arg2)(arg3)

# Incorrect currying
foo(arg1)(arg2, arg3)
```

True currying is less useful in R as it does not play nice with function containing `...` as the argument list will never be consumed. Still, it is available in `curry` using the `Curry()` function or the `%<!%` operator:

``` r
testfun <- function(x = 10, y, z) {
  x + y + z
}
curriedfun <- Curry(testfun)
curriedfun(1)(2)(3)
#> [1] 6

# Using the operator
testfun %<!% 1 %<!% 2 %<!% 3
#> [1] 6

# The strict operator is only required for the first call
testfun %<!% 1 %<% 2 %<% 3
#> [1] 6
```

As with the partial application functionality the strict currying retains argument names and defaults at each step of the currying sequence:

``` r
args(curriedfun)
#> function (x = 10) 
#> NULL
```

### Weak partial function application

The last functionality provided by `curry` is a *"weak"* partial function application in the sense that it sets (or changes) argument defaults. Thus, compared to partial application it returns a function with the same arguments, but if the defaulted arguments are ignored it will be equivalent to a partial application. Defaults can be set or changed using the `set_defaults()` function or the `%<?%` operator:

``` r
testfun <- function(x = 1, y = 2, z = 3) {
  x + y + z
}
testfun()
#> [1] 6
testfun2 <- testfun %<?% list(y = 10)
testfun3 <- testfun %><% list(y = 10)
testfun2()
#> [1] 14
testfun3()
#> [1] 14

testfun2(y = 20)
#> [1] 24
testfun3(y = 20)
#> Error in testfun3(y = 20): unused argument (y = 20)
```

Installation
------------

`curry` can be installed from CRAN:

``` r
install.packages('curry')
```

or GitHub for the latest version:

``` r
if (!require(devtools)) {
    install.packages(devtools)
}
devtools::install_github('thomasp85/curry')
```
