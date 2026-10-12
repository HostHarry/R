
## Even number example

x <- 11
if (x %% 2 == 0) {
    print("x is an even number")
} else {
    print("x is NOT an even number")
}

x <- 11
if (x %% 2 == 0) {
    print("x is an even number")
}

x <- 11
if (x %% 2 == 0) {
    print("x is an even number")
} else if (x %% 3 == 0) {
    print("x is divisible by 3")
} else if (x %% 5 == 0) {
    print("x is divisible by 5")
} else {
    print("x is not divisible by 2, 3, and 5")
}

x <- 12
if (x %% 2 == 0) {
    if (x %% 3 == 0) {
        print("x is divisible by 6")
    } else {
        print("x is not divisible by 3")
    }
    print("x is an even number")
} else {
    print("x is an odd number")
    if (x %% 3 == 0) {
        print("x is divisible by 3")
    } else {
        print("x is not divisible by 3")
    }
}



