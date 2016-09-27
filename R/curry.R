#' @export
`%<%` <- function(fun, arg) {
    if (is.curried(fun)) {
        extend_curry(fun, arg)
    } else {
        curry(fun, arg)
    }
}

curry <- function(fun, arg) {
    if (is.primitive(fun)) {
        fmls <- formals(args(fun))
    } else {
        fmls <- formals(fun)
    }
    if (is.null(fmls)) {
        stop(deparse(substitute(fun, parent.frame())), ' does not accept any parameters', call. = FALSE)
    }
    called_fmls <- stats::setNames(lapply(names(fmls), as.symbol), names(fmls))
    if (names(called_fmls)[1] == '...') {
        call <- as.call(c(substitute(fun, parent.frame()), list(arg), called_fmls))
        if (is.primitive(fun)) {
            fun <- function() {}
        }
        formals(fun) <- fmls
        body(fun) <- call
    } else {
        call <- as.call(c(substitute(fun, parent.frame()), called_fmls))
        applyArg <- bquote(.(argName) <- .(arg), as.environment(list(argName = called_fmls[[1]], arg = arg)))
        if (is.primitive(fun)) {
            fun <- function() {}
        }
        formals(fun) <- fmls[-1]
        body(fun) <- bquote({
            .(applyArg)
            .(call)
        }, as.environment(list(call = call, applyArg = applyArg)))
    }
    structure(fun, class = 'curried')
}
is.curried <- function(f) inherits(f, 'curried')
extend_curry <- function(fun, arg) {
    fmls <- formals(fun)
    if (is.null(fmls)) {
        stop(deparse(substitute(fun, parent.frame())), ' does not accept any parameters', call. = FALSE)
    }
    called_fmls <- stats::setNames(lapply(names(fmls), as.symbol), names(fmls))
    call <- as.list(body(fun))
    if (names(called_fmls)[1] == '...') {
        if (call[[1]] == quote(`{`)) {
            funCall <- as.list(call[[length(call)]])
            call[[length(call)]] <- as.call(append(funCall, list(arg), which(names(funCall) == '...') - 1))
        } else {
            call <- append(call, list(arg), which(names(call) == '...') - 1)
        }
        body(fun) <- as.call(call)
    } else {
        applyArg <- bquote(.(argName) <- .(arg), as.environment(list(argName = called_fmls[[1]], arg = arg)))
        call <- as.call(append(call, applyArg, length(call) - 1))
        formals(fun) <- fmls[-1]
        body(fun) <- call
    }
    structure(fun, class = 'curried')
}
