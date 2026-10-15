# names

d <- c(21, 9770, 38)
attr(d, "region") <- "england"
attr(d, "description") <- "cases between week 40 2021 and week 14 2022"
attributes(d)

attr(d, "names") <- c("influenza", "SARS-CoV-2", "other")
names(d) <- c("influenza", "SARS-CoV-2", "other")
d["influenza"]

attr(d, "description")
attributes(d)
str(d)


# dim makes matrices

d <- c(1, 2, 3, 4, 5, 6)
attr(d, "dim") <- c(2, 3)
attr(d, "dim") <- c(3, 2)
d
d <- matrix(c(1, 2, 3, 4, 5, 6), nrow = 2, ncol = 3)
attributes(d)
d <- c(1, 2, 3, 4, 5, 6)
dim(d) <- c(2, 3)
d <- matrix(c(1, 2, 3, 4, 5, 6), nrow = 2, ncol = 3, byrow = TRUE)

d <- matrix(c(1, 2, 3, 4), nrow = 2, ncol = 3)
d <- matrix(c(1, 2, 3), nrow = 2, ncol = 3)
d <- matrix(c(1, 2, 3, 4, 5, 6, 7, 8), nrow = 2, ncol = 3)
d <- matrix(c(1, 2, 3, 4, 5, 6, 7, 8), nrow = 1, ncol = 4)
d

# factor
char_vec <- c("apple", "banana", "coconut", "apple", "apple", "banana")
f <- factor(char_vec)

attributes(char_vec)
attributes(f)
t <- table(char_vec)
attributes(t)
t["apple"]

gl(4, 3)

t <- table(floor(runif(100, 0, 10)))
typeof(t)
attributes(t)
