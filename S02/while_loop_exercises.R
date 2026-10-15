## what is the value of y at the end of the loop
x <- 2
y <- 0
while (x < 10) {
    x <- x + 3
    y <- y + 1
}

## what is the value of y at the end of the loop
x <- 2
y <- 0
while (x < 10) {
    if (x %% 3 == 0) {
        y <- y + 1
    }
    x <- x + 1
}