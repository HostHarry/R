sample(1:10, size = 3)
sample(1:10, size = 10)
sample(1:10, size = 11) #?
sample(1:10, size = 20, replace = TRUE)

sp <- sample(c("a", "b", "c"), size = 100, prob = c(10, 10, 20), replace = TRUE)
table(sp)

set.seed(1)
v <- c(1, 2, 2, 3, 3, 3, 4, 4, 4, 4)
sample(v, size = 5)


# Latin Hypercube Sampling

install.packages("lhs")
install.packages("ggplot2")
library("lhs")
library("ggplot2")

B <- lhs::randomLHS(1000, 2) # 1000 samples of 2 parameters
B[, 1] <- qnorm(B[, 1], mean = 7, sd = 1) # X1 is normally distributed
ggplot(data = data.frame(B)) +
    geom_point(mapping = aes(x = X1, y = X2)) +
    geom_density(mapping = aes(x = X1), color = "#00A087FF", size = 2) +
    scale_x_continuous(limits = c(2, 12), breaks = seq(2, 12, by = 1)) +
    scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, by = 0.2))
