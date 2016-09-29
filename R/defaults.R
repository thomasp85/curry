#' @include utils.R
NULL

#' Change the defaults of a function
#'
#' The \code{set_defaults} function and the \code{\%<?\%} operator modifies the
#' defaults of a function, returning a new function. As such it can be thought
#' of as a soft partial application in that the arguments does not become fixed
#' and the arity doesn't change, but the arguments can be ignored when making
#' the final call.
#'
#' @param fun A function whose argument default(s) should be changed
#'
#' @param defaults A named list of values. The values will be set as default for
#' the arguments matching their name. Non-matching elements will be ignored
#'
#' @return A new function with changed defaults
#'
#' @importFrom utils modifyList
#' @export
#'
#' @examples
#' testfun <- function(x = 1, y = 2, z = 3) {
#'   x + y + z
#' }
#' testfun()
#'
#' testfun2 <- testfun %<?% list(y = 10)
#' testfun2()
#'
set_defaults <- function(fun, defaults) {
    if (!is.curried(fun)) {
        fun <- as.scaffold(fun)
    }
    fun_class <- class(fun)
    arg_env <- copy_env(attr(fun, 'arg_env'))
    fmls <- formals(fun)
    defaults <- defaults[names(defaults) %in% names(fmls)]
    formals(fun) <- modifyList(fmls, defaults)
    structure(fun, class = fun_class, arg_env = arg_env)
}

#' @rdname set_defaults
#' @export
`%<?%` <- set_defaults
