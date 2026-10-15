# Driving Age

age <- 30
if (age >= 17) {
    print("may drive")
} else {
    print("may not drive")
}


## Teenager age
age <- 20
if (age >= 13 && age <= 19) {
    print("age is teenager")
} else {
    print("age is not teenager")
}

if (age >= 13) {
    if (age <= 19) {
        print("age is teenager")
    } else {
        print("age is not teenager")
    }
} else {
    print("age is not teenager")
}


## Leap Year
y <- 2000
if (y %% 400 == 0) {
    print("Leap Year")
} else if (y %% 4 == 0 && y %% 100 != 0) {
    print("Leap Year")
} else {
    print("Not Leap Year")
}


##
x <- 5
x <- 20
if (x > 10) {
    print("a")
    if (x %% 3 == 0) {
        print("b")
    } else {
        print("c")
    }
} else {
    x <- x * x
    if (x > 50) {
        print("d")
    }
    if (x < 30) {
        print("e")
    } else {
        print("f")
    }
}
