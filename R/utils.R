.apply_args <- function(fun, args, last = FALSE) {
    fmls <- formals(fun)
    arg_env <- attr(fun, 'arg_env')
    formals(fun) <- fmls[!names(fmls) %in% names(args)]
    if (last) {
        assign('args_end', append(args, arg_env$args_end), envir = arg_env)
    } else {
        assign('args', append(arg_env$args, args), envir = arg_env)
    }
    structure(fun, class = 'scaffold', arg_env = arg_env)
}

is_missing_arg <- function(x) identical(x, quote(expr = ))
getArgs <- function(added_env) {
    function() {
        env <- parent.frame()
        args <- names(formals(sys.function(sys.parent(1))))

        vals <- mget(args, envir = env)
        ellipsis <- names(vals) == '...'
        if (any(ellipsis)) {
            vals <- append(vals, eval(quote(list(...)), env), which(ellipsis))
            vals[ellipsis] <- NULL
        }
        vals <- vals[!vapply(vals, is_missing_arg, logical(1))]

        c(added_env$args, vals, added_env$args_end)
    }
}
