# Print all integers with values between x and 10
x <- 15
vec <- x:10
for (v in vec) {
    print(v)
}

# Print all integers divisible by 3 between 10 and 20
vec <- 10:20
for (v in vec) {
    if (v %% 3 == 0) {
        print(v)
    }
}

# Find all occurrences of 5 in vec and replace them with 10
vec <- c(3, 5, 6, 7, 5, 9, 4)
for (i in seq_along(vec)) {
    if (vec[i] == 5) {
        vec[i] <- 10
    }
}
vec

#
vec1 <- 1:3
vec2 <- c(10, 20, 30)
for (v1 in vec1) {
    for (v2 in vec2) {
        print(v1 + v2)
    }
}

#
vec1 <- c(TRUE, FALSE, FALSE, TRUE)
vec2 <- c(10, 20, 30, 40)
for (i in seq_along(vec1)) {
    if (vec1[i]) {
        print(vec2[i])
    }
}
