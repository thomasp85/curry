#' @include utils.R
NULL

#' Apply arguments partially to a function
#'
#' The \code{partial} function and the \code{\%><\%} operator allows you to
#' partially call a function with a list of arguments. Named elements in the
#' list will be matched to function arguments and these arguments will be
#' removed from the returned function. Unnamed elements are only allowed for
#' functions containing an ellipsis, in which case they are considered part of
#' the ellipsis.
#'
#' @note Multiple partial application does not result in multiple nested calls,
#' so while the first partial call adds a layer around the called function,
#' potentially adding a very small performance hit, partially calling multiple
#' times will not add to this effect.
#'
#' @param fun A function to be partially applied. Can be any function (normal,
#' already partially applied, primitives).
#'
#' @param args A list of values that should be applied to the function.
#'
#' @return A function with the same arguments as \code{fun} except for the ones
#' given in \code{args}
#'
#' @family partials
#'
#' @export
#'
#' @name partial
#'
#' @examples
#' dummy_lengths <- vapply %><% list(FUN = length, FUN.VALUE = integer(1))
#' test_list <- list(a = 1:5, b = 1:10)
#' dummy_lengths(test_list)
#'
`%><%` <- function(fun, args) {
    fun <- as.scaffold(fun)
    .partial(fun, args)
}
#' @rdname partial
#' @export
partial <- `%><%`

.partial <- function(fun, args) {
    fmls_names <- names(formals(fun))
    if (!'...' %in% fmls_names && !all(names(args) %in% fmls_names)) {
        stop('The provided arguments to ',
             deparse(substitute(fun, parent.frame())),
             ' does not match its definition',
             call. = FALSE)
    }
    .apply_args(fun, args)
}
