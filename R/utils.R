.apply_args <- function(fun, args, last = FALSE) {
    fmls <- formals(fun)
    arg_env <- copy_env(attr(fun, 'arg_env'))
    formals(fun) <- fmls[!names(fmls) %in% names(args)]
    if (last) {
        assign('args_end', append(args, arg_env$args_end), envir = arg_env)
    } else {
        assign('args', append(arg_env$args, args), envir = arg_env)
    }
    structure(fun, class = 'scaffold', arg_env = arg_env)
}

is_missing_arg <- function(x) identical(x, quote(expr = ))
arg_getter <- function() {
    fun <- sys.function(sys.parent(1))
    arg_env <- attr(fun, 'arg_env')
    parent <- parent.frame()
    vals <- as.list(parent)
    if(!is.null(formals(fun)[['...']])) {
        vals <- c(vals, eval(quote(list(...)), parent))
    }
    c(arg_env$args, vals, arg_env$args_end)
}
copy_env <- function(env) list2env(as.list(env), parent = parent.env(env))
