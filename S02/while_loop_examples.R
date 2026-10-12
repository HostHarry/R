#### while loop examples ----
# Print all integers with values between x and 10
x <- 2
while (x <= 10) {
    print(x)
    x <- x + 1
}

x <- 2
while (x <= 10) {
    print(x)
    if (x == 6) {
        break
    }
    x <- x + 1
}

x <- 2
while (x <= 10) {
    x <- x + 1
    if (x == 6) {
        next
    }
    print(x)
}

# Print the next integer that's greater than x which is
# divisible by 6

x <- 8
while (x %% 6 != 0) {
    x <- x + 1
}
print(x)

# with break
x_start <- 12
x <- x_start
while (x < x_start + 5) {
    if (x %% 6 == 0) {
        break
    }
    x <- x + 1
}
print(x)

# with next
x_start <- 12
x <- x_start - 1
while (x < x_start + 5) {
    x <- x + 1
    if (x %% 6 != 0) {
        next
    }
    print(x)
}
