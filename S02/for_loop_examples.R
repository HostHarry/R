#### for loop examples ----

# basic vector definition
x <- 11
y <- 15
vec <- x:y
vec

for (vv in vec) {
    print(vv)
}

# while loop equivalence
x <- 11
y <- 15
vec <- x:y
vec

ii <- 1
while (ii <= length(vec)) {
    print(vec[ii])
    ii <- ii + 1
}

# read-only
vec <- 11:15

for (vv in vec) {
    vv <- vv + 1
}
for (vv in vec) {
    print(vv)
}

# modifies elements
vec <- 11:15

for (ii in seq_along(vec)) {
    vec[ii] <- vec[ii] + 1
}
for (vv in vec) {
    print(vv)
}
vec

# for with break
vec <- 21:30
for (vv in vec) {
    if (vv == 25) {
        break
    }
    print(vv)
}

# for with next
vec <- 21:30
for (vv in vec) {
    if (vv == 25) {
        next
    }
    print(vv)
}

