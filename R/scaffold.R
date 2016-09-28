#' @include utils.R
NULL

scaffold <- function(fun, from = parent.frame()) {
    if (is.primitive(fun)) {
        fmls <- formals(args(fun))
    } else {
        fmls <- formals(fun)
    }
    new_fun <- function() {}
    arg_env <- new.env(parent = emptyenv())
    assign('args', list(), envir = arg_env)
    assign('args_end', list(), envir = arg_env)
    arg_getter <- getArgs(arg_env)
    formals(new_fun) <- fmls
    body(new_fun) <- bquote({
        args <- arg_getter()
        do.call(.(fun), args)
    }, list(fun = substitute(fun, from)))
    structure(new_fun, class = 'scaffold', arg_env = arg_env)
}

is.scaffold <- function(fun) inherits(fun, 'scaffold')
as.scaffold <- function(fun) {
    if (is.scaffold(fun)) {
        fun
    } else {
        from <- parent.frame()
        scaffold(fun, from)
    }
}
