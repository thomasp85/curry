#' @include utils.R
NULL

#' Curry a function from the start
#'
#' The \code{curry} function and the \code{\%<\%} operator performs currying on
#' a function by partially applying the first argument, returning a function
#' that accepts all but the first arguments of the former function. If the first
#' argument is \code{...} the curried argument will be interpreted as part of
#' the ellipsis and the ellipsis will be retained in the returned function. It
#' is thus possible to curry functions comtaining ellipis arguments to infinity
#' (though not adviced).
#'
#' @note Multiple currying does not result in multiple nested calls, so while
#' the first currying adds a layer around the curried function, potentially
#' adding a very small performance hit, currying multiple times will not add to
#' this effect.
#'
#' @param fun A function to be curried. Can be any function (normal,
#' already curried, primitives).
#'
#' @param arg The value that should be applied to the first argument.
#'
#' @return A function with the same arguments as \code{fun} except for the
#' first, unless the first is \code{...} in which case it will be retained.
#'
#' @family partials
#'
#' @export
#'
#' @name curry
#'
#' @examples
#' # Equivalent to curry(`+`, 5)
#' add_5 <- `+` %<% 5
#' add_5(10)
#'
#' # ellipsis are retained when currying
#' bind_5 <- cbind %<% 5
#' bind_5(1:10)
#'
`%<%` <- function(fun, arg) {
    fun <- as.scaffold(fun)
    .curry(fun, arg)
}
#' @rdname curry
#' @export
curry <- `%<%`

.curry <- function(fun, arg) {
    args <- list(arg)
    fmls_names <- names(formals(fun))
    if (is.null(fmls_names)) {
        stop(deparse(substitute(fun, parent.frame())), ' does not accept any parameters', call. = FALSE)
    }
    if (fmls_names[1] != '...') {
        names(args) <- fmls_names[1]
    }
    .apply_args(fun, args)
}
