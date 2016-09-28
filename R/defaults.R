#' @importFrom utils modifyList
#' @export
set_defaults <- function(fun, defaults) {
    if (is.primitive(fun)) {
        stop("Defaults cannot be set on primitive functions", call. = FALSE)
    }
    fmls <- formals(fun)
    defaults <- defaults[names(defaults) %in% names(fmls)]
    formals(fun) <- modifyList(fmls, defaults)
    fun
}

#' @export
`%<?%` <- set_defaults
