#
q <- c(3, 5, 7)
p <- c("a", "b", "c", "d", "e")

vec <- c(1:2, q[3], q)
vec <- c(length(q), q[2:1])
vec <- p[q[2]]
vec <- p[q[2]:1]
vec <- c(p[q[1]], q[2:1])

vec

#
p <- c(10, 50, 20)
q <- c(TRUE, FALSE, TRUE)

vec1 <- c(p, q)
vec2 <- p + q
vec3 <- p[p * q]
vec3 <- p[c(1, 0, 2)]
vec4 <- p[q]

vec <- q[p]

vec

#
paste(1, "apple", sep = "-")

v <- c(1, 2, "apple")
v <- c(length(v):2)
paste(v)

paste(v, collapse = "")

p <- c(3, 1, 2)
q <- c("a", "b", "c")
q[p/p]
