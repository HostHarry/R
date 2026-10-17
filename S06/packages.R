## Plotting with Base R
t <- seq(-5, 5, 0.01)
plot(t, sin(t), type = "l", xlab = "t", ylab = "sin(t)")

## Plotting with ggplot2 package
install.packages("ggplot2")
library("ggplot2")

ggplot(data = data.frame( "t" = t, "sin_t" = sin(t))) +
    geom_line(mapping = aes(x = t, y = sin_t))

## Without library("ggplot2"), a new session is needed
ggplot2::ggplot(data = data.frame( "t" = t, "sin_t" = sin(t))) +
    ggplot2::geom_line(mapping = ggplot2::aes(x = t, y = sin_t))