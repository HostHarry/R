## Plotting with Base R
t <- seq(-5, 5, 0.01)
plot(t, sin(t), type = "l", xlab = "t", ylab = "sin(t)")

## Plotting with ggplot2 package
# run this in the console only once per computer:
install.packages("ggplot2")
# run this at the beginning every script that uses ggplot2:
library("ggplot2")

ggplot(data = data.frame( "t" = t, "sin_t" = sin(t))) +
    geom_line(mapping = aes(x = t, y = sin_t))

## Without library("ggplot2"), but ggplot2 has been installed:
ggplot2::ggplot(data = data.frame( "t" = t, "sin_t" = sin(t))) +
    ggplot2::geom_line(mapping = ggplot2::aes(x = t, y = sin_t))

