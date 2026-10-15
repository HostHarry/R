# set

s1 <- 1:5
s2 <- 3:7

union(s1, s2)
intersect(s1, s2)

setdiff(s1, s2)
setdiff(s2, s1)

setequal(1:5, 5:1)
setequal(c(1, 2, 2, 3), c(3, 3, 2, 1, 1))

is.element(5, s1)
is.element(c(1, 3, 7), s1)


a <- c(c("a", "b", "b", "c"), c("c", "c", "d", "e"))
a
ta <- table(a)
ta
typeof(ta)
length(ta)
names(ta)[2]


union(c(1, 2, 2, 3), c(3, 4))
