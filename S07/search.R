
# unique, duplicated ----

unique(c(NA, 1, 1, 10, NULL, NaN, NaN))

x <- c(4, 1:5, 3:6)
duplicated(x)
duplicated(x, fromLast = TRUE)


## multiple columns
df <- data.frame(c(1, 2, 1, 4, 2, 2), c(2, 3, 2, 6, 2, 3))
df
duplicated(df[, 1:2])
dp <- duplicated(df[, 1:2])
df[!dp, ] # remove duplicated rows from data frame
df[dp, ]  # show duplicated rows
anyDuplicated(df[, 1:2])


# match, %in% ----
match(c(1, NA, 10, NaN), c(1:4, NA, NaN))

match("c", letters[1:10])
is.element("c", letters[1:10])

3 %in% 1:10
9:11 %in% 1:10

# any, all ----

s1 <- 1:5
s2 <- 3:7

any(is.element(s1, s2))
all(is.element(s1, s2))

any(c(1, "a", "bc") %in% letters)
any(c(1, "a", "bc") %in% LETTERS)
all(c(1, "a", "bc") %in% letters)


# which, which.min, which.max ----

which(LETTERS == "E")
which(11:15 > 13)

v <- c(11:15, 9:14)
which(v > 13)
v[which(v > 13)]

v <- c(5, 3, 5, 2, 7)
which.min(v)
which.max(v)
which.min(c(v, 2))
which.max(c(7, v))


## what about matrices
m <- matrix(1:15, nrow = 3, ncol = 5)
m
which.max(m)
which(m == max(m))
which(m == max(m), arr.ind = TRUE)
arrayInd(which.max(m), dim(m))



