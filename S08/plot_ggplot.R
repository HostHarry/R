# install.packages("ggplot2")
library("ggplot2")
summary(pressure)
ggplot(pressure)

ggplot(data = pressure) +
    geom_point(
        mapping = aes(x = temperature, y = pressure)
    ) +
    geom_line(
        mapping = aes(x = temperature, y = pressure)
    )

# ----

ggplot(
    data = pressure,
    mapping = aes(x = temperature, y = pressure)
) +
    geom_point() +
    geom_line()

# ----

ggplot(
    data = pressure,
    mapping = aes(x = temperature, y = pressure)
) +
    geom_point() +
    geom_line(mapping = aes(y = temperature, x = pressure))

# ----
?pressure
ggplot(
    data = pressure,
    mapping = aes(x = temperature, y = pressure)
) +
    geom_point() +
    geom_line() +
    labs(
        x = "Temperature (deg C)",
        y = "Pressure (mm)",
        title = "Vapor Pressure of Mercury"
    )


# geom_bar() ----
v <- c("red" = 10, "black" = 13, "silver" = 20, "yellow" = 4)
vdf <- data.frame(col_names = names(v), freq = unname(v))
ggplot(data = vdf) + geom_bar(aes(x = col_names, y = freq), stat = "identity")

?geom_bar

# geom_bar() and geom_histogram ----
v <- data.frame(val = floor(rnorm(10000, mean = 100, sd = 10)))
head(v)
ggplot(data = v) +
    geom_bar(aes(x = val))

v <- data.frame(val = rnorm(10000, mean = 100, sd = 10))
head(v)
ggplot(data = v) +
    geom_histogram(aes(x = val), binwidth = 5)

# geom_boxplot() ----
df <- data.frame(
    uniform = runif(100),
    normal = rnorm(100)
)
boxplot(df)

df2 <- cbind(df, id = seq_along(df))
df_long <- tidyr::pivot_longer(
    df2,
    names_to = "Distribution",
    values_to = "Value",
    -id
)

ggplot(data = df_long, aes(x = Distribution, y = Value)) +
    geom_boxplot() +
    geom_jitter(width = .1)

# geom_violin ----

ggplot(data = df_long, aes(x = Distribution, y = Value)) +
    geom_violin() +
    geom_jitter(width = .1)

# geom_line ----
xval <- seq(1, 10, 0.01)
df <- data.frame(
    "xval" = xval,
    "sin" = sin(xval),
    "cos" = cos(xval)
)
ggplot(df) +
    geom_line(aes(x = xval, y = sin)) +
    geom_line(aes(x = xval, y = cos))

# group by colour ----
xval <- seq(1, 100, 0.1)
df <- data.frame(
    "xval" = xval,
    "sin()" = sin(xval),
    "cos()" = cos(xval),
    "log10()" = log10(xval),
    "log2()" = log2(xval)
)
df_long <- tidyr::pivot_longer(
    df,
    names_to = "Function",
    values_to = "yval",
    -xval
)
ggplot(data = df_long, aes(x = xval, y = yval, colour = Function)) +
    geom_line()

# facet_grid() ----

ggplot(data = df_long, aes(x = xval, y = yval)) +
    geom_line() +
    facet_grid(rows = vars(Function))

# ----
summary(Indometh)
head(Indometh)

ggplot(Indometh, aes(x = time, y = conc, colour = Subject)) +
    geom_line() +



?facet_wrap



