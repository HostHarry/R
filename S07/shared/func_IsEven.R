func_IsEven <- function(x) {
    res <- FALSE
    if (x %% 2 == 0) {
        res <- TRUE
    }
    return(res)
}

if (FALSE) {
    stopifnot(func_IsEven(2) == TRUE)
    stopifnot(func_IsEven(3) == FALSE)
}