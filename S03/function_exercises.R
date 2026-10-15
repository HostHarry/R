rm(list = ls())
i <- 12
x <- 4
FuncA <- function(x = 10, y = 20) {
    x <- x * y
    return(x + i)
}
FuncA(20)


rm(list = ls())
i <- 12
x <- 4
FuncA <- function(x, y = 20) {
    x <- x * y
    return(x + i)
}
FuncA()


rm(list = ls())
i <- 12
x <- 4
FuncA <- function(x, y = 20) {
    i <- x * y
    return(x + i)
}
FuncA(5, 10)


rm(list = ls())
i <- 12
x <- 4
FuncA <- function(x, y = 20) {
    i <- x * y
    return(x + i)
}
FuncA(5, x = 10)


rm(list = ls())
i <- 12
x <- 4
FuncA <- function(x, y) {
    i <- x + y
    return(i)
}
FuncA(x = x + 10, y = x * 2)



rm(list = ls())
i <- 12
x <- 4
FuncA <- function(x, y = x * 2) {
    i <- x + y
    return(i)
}
FuncA(x = x + 10)




rm(list = ls())
x <- pi / 3
DoTrig <- function(x, func) {
    return(func(x))
}
DoTrig(x, sin)
DoTrig(x, cos)
