# two columns ----
pressure
plot(pressure)
attributes(pressure)
summary(pressure)

# multiple columns ----
plot(morley)
plot(Indometh)

# vectors ----
plot(x = c(1, 2, 3), y = c(2, 5, 4))
plot(4:9)

plot(10:50)

# modifying plot elemtns ----

plot(cars)
plot(cars, type = "b",
    main = "cars dataset",
    xlab = "Speed (mph)", ylab = "Stopping distance (ft)",
    xlim = c(0, 30), ylim = c(0, 140),
    pch = 16, lty = "dashed", col = "blue",
    xaxs = "i", yaxs = "i"
)

# bar plot ----
v <- c("red" = 10, "black" = 13, "silver" = 20, "yellow" = 4)
barplot(v)


# boxplot ----
df <- data.frame(
    uniform = runif(100),
    normal = rnorm(100)
)
boxplot(df)

boxplot(count ~ spray, InsectSprays)

# matplot

matplot(
    cbind(
        sin(1:10) * 0.1,
        sin(1:10) * 3,
        sin(1:10) * 1.8
    ),
    type = "l", lty = 1,
    col = c("red", "blue", "black"),
)
legend(
    "topright",
    legend = c(
        "sin(1:10) * 0.1",
        "sin(1:10) * 3",
        "sin(1:10) * 1.8"
    ),
    col = c("red", "blue", "black"),
    lty = 1
)


# more on base graphics package ----
?graphics
library(help = "graphics")
