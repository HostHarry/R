# Operators are functions too
`+`(3, 5)
?`+`
`^`(3, 2)
`**`(3, 2)
?`**`

# Packing operations

print("hello")
print("welcome")

PrintBoth <- function() {
    print("hello")
    print("welcome")
}
PrintBoth()

FunctionName <- function() {
    # the set of operations
}
FunctionName() # calling the function


# Print all integers that are divisible by 3 between x and y

x <- 10
y <- 20
vec <- x:y
for (vv in vec) {
    if (vv %% 3 == 0) {
        print(vv)
    }
}

PrintMulti3 <- function() {
    x <- 10
    y <- 20
    vec <- x:y
    for (vv in vec) {
        if (vv %% 3 == 0) {
            print(vv)
        }
    }
}
PrintMulti3()


PrintMulti3 <- function(x, y, d) {
    vec <- x:y
    for (vv in vec) {
        if (vv %% d == 0) {
            print(vv)
        }
    }
}
PrintMulti3(x = 10, y = 20, d = 3)
PrintMulti3(y = 20, x = 10, d = 3)
PrintMulti3(20, 10, 3)

PrintMulti3 <- function(x, y, d = 3) {
    vec <- x:y
    for (vv in vec) {
        if (vv %% d == 0) {
            print(vv)
        }
    }
}
PrintMulti3(x = 10, y = 20)
PrintMulti3(x = 10, y = 20, d = 6)



# Function Input/Output with IsEven

IsEven <- function(x) {
    res <- FALSE
    if (x %% 2 == 0) {
        res <- TRUE
    }
    return(res)
}
# a <- IsEven(x = 7)
IsEven(x = 8)

IsEven(IsEven(x = 8))
IsEven(IsEven(IsEven(x = 8)))
as.numeric(TRUE)

# Function Environment
rm(list = ls())
FuncA <- function(x) {
    a <- x + 1
    return(a)
}
FuncA(2)
print(a)
ls()

rm(list = ls())
a <- 10
FuncA <- function(x) {
    return(a)
}
FuncA(2)
print(a)
ls()

rm(list = ls())
a <- 10
FuncA <- function(x) {
    a <- x + 1
    return(a)
}
FuncA(2)
print(a)
ls()




res <- FALSE
rm(list = ls())
IsEven <- function(x) {
    if (x %% 2 == 0) {
        res <- TRUE
    }
    return(res)
}
IsEven(7)
res
