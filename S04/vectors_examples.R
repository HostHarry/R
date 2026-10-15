a <- 1.0     # a appears to be a scalar
is.vector(a) # a is a vector of length 1
length(a)

"abc"[1]
100[1]

# using the c function
p <- c(1, 2, 3)
q <- c(p, 4, 5, 6)
m <- c(p, 10, 10, q)
n <- c(c(11, 12, 13), 10, p)


# p and q are identical
p <- c(1)
q <- 1
identical(p, q)

# concatenate iteratively with the c function
v <- 1
for (ii in 1:100) {
    v <- c(v, ii)
}
print(v)
length(v)

# using the length function
p <- c(1, 2, 3)
q <- c(c(11, 12, 13), 10, p)

length(q)
print(q)

length(q) <- length(q) - 3
print(q)

# :

vec <- 1:3
vec <- 3:1
vec <- -2:5
vec <- -(2:5)
vec <- 5:-2
vec

#
vec <- 11:15
print(vec[2])

print(vec[2:3])
print(vec[c(1, 4)])
print(vec[c(1, 4, 2:3)])

print(vec[c(TRUE, FALSE, FALSE, TRUE, FALSE)])

vec[3] <- 3
print(vec)

# character types

vec <- c("1", "2ab", "cd", "ef gh")
vec[3]
length(vec)

paste("ab", "bc", "cd")
paste("ab", "bc", "cd", sep = "-")
paste0("ab", "bc", "cd")

paste(c("ab", "bc"), "cd", sep = "-")

tolower("ApPle")
toupper("ApPle")
nchar(c("apple", "banana"))


# other character type functions

substr("abcdefg", start = 2, stop = 4)
grep("cd", c("iii", "abcde", "ooocd"), fixed = TRUE)
grepl("cd", c("iii", "abcde", "ooocd"), fixed = TRUE)

sub("a", "d", "arrange")
gsub("a", "d", "arrange")
sub("[c,o]", "-", c("iii", "abc,de", "ooocd"))
gsub("[c,o]", "-", c("iii", "abc,de", "ooocd"))
