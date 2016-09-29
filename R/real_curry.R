#' @include utils.R
NULL

#' Perform strict currying of a function
#'
#' The \code{curry} function and \code{\%<\%} operator does not perform currying
#' in the strictest sense since it is really "just" a partial application of the
#' first argument. Strictly speaking currying transforms a function into a
#' function taking a single argument and returning a new function accepting a
#' new argument as long as the original function has arguments left. Once all
#' arguments has been consumed by function calls it evaluates the original call
#' and returns the result. Strict currying has less applicability in R as it
#' cannot work with functions containing `...` in its argument list as it will
#' never reach the end of the argument list and thus never evaluate the call.
#' Strict currying is still provided here for completeness. The \code{Curry()}
#' function turns a function into a curried function reducing the ariety to one.
#' The \code{\%<!\%} operator both transforms the function into a curried one
#' and calls it once with the first argument. Once a function is curried it is
#' still possible to use \code{\%<\%}, \code{\%-<\%}, and \code{\%><\%} though
#' they all performs the same operation as the function does only accept a
#' single argument. As with the other functions in the \code{curry} package,
#' argument names and defaults are retained when performing strict currying.
#' Calling a curried function without providing a value for it will call it with
#' the default or set the argument to missing.
#'
#' @param fun A function to be turned into a curried function.
#'
#' @param arg A value to be used when calling the curried function
#'
#' @return A function accepting a single argument and returing either a new
#' function accepting a single argument, or the result of the function call if
#' all arguments have been provided.
#'
#' @export
#'
#' @name strict_curry
#'
#' @examples
#' testfun <- function(x, y, z) {
#'   x + y + z
#' }
#' curriedfun <- Curry(testfun)
#' curriedfun(1)(2)(3)
#'
#' # Using the operator
#' testfun %<!% 1 %<!% 2 %<!% 3
#'
#' # The strict operator is only required for the first call
#' testfun %<!% 1 %<% 2 %<% 3
#'
`%<!%` <- function(fun, arg) {
    fun <- as.curried(fun)
    fun(arg)
}

#' @rdname strict_curry
#' @export
Curry <- function(fun) {
    as.curried(fun)
}

make_curry <- function(fun, from = parent.frame()) {
    if (!is.scaffold(fun)) fun <- scaffold(fun, from)

    fmls <- formals(fun)
    if ('...' %in% names(fmls)) {
        stop('Strict currying is not possible for functions using `...`', call. = FALSE)
    }

    arg_env <- copy_env(attr(fun, 'arg_env'))
    formals(fun) <- fmls[1]
    assign('missing_args', fmls[-1], envir = arg_env)
    body(fun) <- as.call(list(
        quote(`if`),
        quote(has_args()),
        quote(curry_once()),
        body(fun)
    ))
    structure(fun, class = 'curried', arg_env = arg_env)
}

is.curried <- function(fun) inherits(fun, 'curried')
as.curried <- function(fun) {
    if (is.curried(fun)) {
        fun
    } else {
        from <- parent.frame()
        make_curry(fun, from)
    }
}
has_args <- function() {
    length(attr(sys.function(sys.parent(1)), 'arg_env')$missing_args) != 0
}
curry_once <- function() {
    curry_fun <- sys.function(sys.parent(1))
    arg <- names(formals(curry_fun))
    arg_env <- copy_env(attr(curry_fun, 'arg_env'))
    val <- mget(arg, envir = parent.frame())
    if (!is_missing_arg(val[[1]])) {
        arg_env$args <- c(arg_env$args, val)
    }
    fmls <- arg_env$missing_args
    if (length(fmls) == 0) {
        formals(curry_fun) <- list()
    } else {
        formals(curry_fun) <- fmls[1]
        arg_env$missing_args <- fmls[-1]
    }
    structure(curry_fun, class = 'curried', arg_env = arg_env)
}
