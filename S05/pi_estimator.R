# MonteCarloPi Version 1

MonteCarloPiV1 <- function(n) {
    stopifnot(n > 1)
    n_inside_count <- 0
    for (ii in seq_len(n)) {
        x <- runif(1)
        y <- runif(1)
        if (x^2 + y^2 < 1) {
            n_inside_count <- n_inside_count + 1
        }
    }
    return(n_inside_count / n * 4)
}

MonteCarloPiV1(100)

N <- 500000
MonteCarloPiV1(N)

system.time(MonteCarloPiV1(N))
#    user  system elapsed
#    1.06    0.08    1.39



# MonteCarloPi Version 2

MonteCarloPiV2 <- function(n) {
    stopifnot(n > 1)
    n_inside_count <- 0
    x_sq <- runif(n)
    y_sq <- runif(n)
    for (ii in seq_along(x_sq)) {
        if (x_sq[ii]^2 + y_sq[ii]^2 < 1) {
            n_inside_count <- n_inside_count + 1
        }
    }
    return(n_inside_count / n * 4)
}

system.time(MonteCarloPiV2(N))
system.time(MonteCarloPiV2(N * 10))
#    user  system elapsed
#    0.42    0.00    0.45


# MonteCarloPi Version 3

MonteCarloPiV3 <- function(n) {
    stopifnot(n > 1)
    n_inside_count <- 0
    x_sq <- runif(n)
    y_sq <- runif(n)

    d_sq <- x_sq^2 + y_sq^2
    d_sq_bol <- d_sq < 1

    n_inside_count <- length(d_sq_bol[d_sq_bol == TRUE])

    return(n_inside_count / n * 4)
}
system.time(MonteCarloPiV3(N))
system.time(MonteCarloPiV3(N * 10))
#    user  system elapsed
#    0.22    0.01    0.24


# MonteCarloPi Version 4

MonteCarloPiV4 <- function (n) {
    stopifnot(n > 1)
    n_inside_count <- 0
    x_sq <- runif(n)
    y_sq <- runif(n)

    d_sq <- x_sq^2 + y_sq^2
    d_sq_bol <- d_sq < 1

    n_inside_count <- sum(d_sq_bol, na.rm = TRUE)

    return(n_inside_count / n * 4)
}
system.time(MonteCarloPiV4(N))
system.time(MonteCarloPiV4(N * 10))
#    user  system elapsed
#    0.14    0.00    0.17


# microbenchmark

N <- 500000
# N <- N * 10
if (!exists("mb_res1")) {
    mb_res1 <- microbenchmark::microbenchmark(
        times = 100, unit = "ms",
        MonteCarloPiV1(N),
        MonteCarloPiV2(N),
        MonteCarloPiV3(N),
        MonteCarloPiV4(N)
    )
}

# print(mb_res)
# boxplot(mb_res)

ggplot2::autoplot(mb_res1)
