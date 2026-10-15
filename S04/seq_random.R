# Using the runif function
?runif
runif(n, min = 0, max = 1)

runif(1)
runif(100)

mean(runif(100))
mean(runif(10000))
sum(runif(10000))

set.seed(1)
runif(5)
runif(5)

set.seed(1)
runif(5)
set.seed(1)
runif(5)

plot(table(floor(runif(1000, min = 0, max = 10))))

vec <- floor(runif(10000, min = 0, max = 10))
tb <- table(vec)
tb
typeof(tb)
attributes(tb)

?table

set.seed(1)
set.seed(10)

runif(2)
runif(1000)

vec_x <- runif(10)
vec_y <- runif(10)
plot(x = vec_x, y = vec_y)


# normal distribution
?rnorm
rnorm(1, mean = 10, sd = 4)
mean(rnorm(10000, mean = 10, sd = 4))
sd(rnorm(10000, mean = 10, sd = 4))

plot(table(floor(rnorm(1000, mean = 10, sd = 4))))


table(rpois(100, 4))


# pdf / cdf / quantile

par(mfrow = c(1, 3))
x <- seq(-3, 3, 0.1)
plot(x, dnorm(x), type = "l")
plot(x, pnorm(x), type = "l")
p <- seq(0, 1, by = 0.01)
plot(p, qnorm(p), type = "l")


mode(1:10)
?rnorm
?qpois
