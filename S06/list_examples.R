# Vectors and lists ----
vec1 <- 1:3
vec2 <- c("a", "b")
vec3 <- c(TRUE, FALSE)

vec4 <- c(vec1, vec2, vec3)
vec4[6]

lst <- list(vec1, vec2, vec3)
lst[1]
typeof(lst[1])

lst[[1]]
lst[[3]][2]

typeof(lst[[1]])

typeof(lst[[3]][2])

# examples ----
l1 <- list(
    1:3,
    "abc",
    c(1.2, 3.8)
)
l1
typeof(l1)

l2 <- list(
    list(
        c(1, 2),
        list("w")
    ),
    "a"
)

l3 <- c(
    list(1, 2),
    c("3", "4"),
    list(5, 6)
)
l3
# example exercises ----

typeof(l1)
typeof(l1[1])
typeof(l1[[1]])
typeof(l2[[2]])
typeof(l3)

typeof(l2[[1]])
typeof(l3[[1]])

length(l1)
length(l1[1])
length(l1[[1]])

length(l2)
length(l2[1])
length(l2[[1]])

l1[[1]][4]


# unlist ----
unlist(l1)
unlist(l2)
unlist(l3)

# as.list ----
v <- 1:3
list(v)
as.list(v)
?as.list

list(v, v)

# names ----
l <- list(
    "a" = factor(c("apple", "apple", "banana")),
    "b" = c(1:10)
)
ll <- list(
    a = factor(c("apple", "apple", "banana")),
    b = c(1:10)
)
identical(l, ll)
l[["a"]]
l["a"]
typeof(l[["a"]])
typeof(l["a"])

typeof(l[["a"]][2])
class(l[["a"]][2])

typeof(l)
names(l)
attributes(l)

names(l) <- c("aa", "bb")
l[["aa"]]

attr(l, "names") <- c("n1", "n2")
attr(l, "des") <- "description of l"
