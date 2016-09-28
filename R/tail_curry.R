#' @include utils.R
NULL
#' Curry a function from the end
#'
#' The \code{tail_curry} function and the \code{\%-<\%} operator performs
#' currying on a function by partially applying the last argument, returning a
#' function that accepts all but the last arguments of the former function. If
#' the last argument is \code{...} the curried argument will be interpreted as
#' the last named argument. If the only argument to the function is \code{...}
#' the curried argument will be interpreted as part of the ellipsis and the
#' ellipsis will be retained in the returned function. It is thus possible to
#' curry functions comtaining ellipis arguments to infinity (though not
#' adviced).
#'
#' @note Multiple tail_currying does not result in multiple nested calls, so
#' while the first tail_currying adds a layer around the curried function,
#' potentially adding a very small performance hit, tail_currying multiple times
#' will not add to this effect.
#'
#' @param fun A function to be curried from the end. Can be any function
#' (normal, already (tail_)curried, primitives).
#'
#' @param arg The value that should be applied to the last argument.
#'
#' @return A function with the same arguments as \code{fun} except for the
#' last named argument, unless the only one is \code{...} in which case it will
#' be retained.
#'
#' @family partials
#'
#' @export
#'
#' @name tail_curry
#'
#' @examples
#' # Equivalent to tail_curry(`/`, 5)
#' divide_by_5 <- `/` %-<% 5
#' divide_by_5(10)
#'
#' no_factors <- data.frame %-<% FALSE
#' no_factors(x = letters[1:5])
#'
`%-<%` <- function(fun, arg) {
    fun <- as.scaffold(fun)
    .tail_curry(fun, arg)
}
#' @rdname tail_curry
#' @export
tail_curry <- `%-<%`

.tail_curry <- function(fun, arg) {
    args <- list(arg)
    fmls_names <- names(formals(fun))
    if (is.null(fmls_names)) {
        stop(deparse(substitute(fun, parent.frame())), ' does not accept any parameters', call. = FALSE)
    }
    n_fmls <- length(fmls_names)
    if (fmls_names[n_fmls] != '...') {
        names(args) <- fmls_names[n_fmls]
    } else if (n_fmls > 1) {
        names(args) <- fmls_names[n_fmls - 1]
    }
    .apply_args(fun, args, last = TRUE)
}
