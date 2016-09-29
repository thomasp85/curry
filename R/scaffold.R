#' @include utils.R
NULL

scaffold <- function(fun, from = parent.frame(), name) {
    if (is.primitive(fun)) {
        fmls <- formals(args(fun))
    } else {
        fmls <- formals(fun)
    }
    new_fun <- function() {}
    arg_env <- new.env(parent = emptyenv())
    assign('args', list(), envir = arg_env)
    assign('args_end', list(), envir = arg_env)
    formals(new_fun) <- fmls
    body(new_fun) <- bquote({
        args <- arg_getter()
        do.call(.(fun), args)
    }, list(fun = name))
    parent.env(environment(new_fun)) <- list2env(list(arg_getter = arg_getter, has_args = has_args, curry_once = curry_once), parent = from)
    structure(new_fun, class = 'scaffold', arg_env = arg_env)
}

is.scaffold <- function(fun) inherits(fun, 'scaffold')
as.scaffold <- function(fun, from = parent.frame(), name) {
    if (is.scaffold(fun)) {
        fun
    } else {
        scaffold(fun, from, name)
    }
}
