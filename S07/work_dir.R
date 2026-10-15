# working directory ----
getwd()
dir()

file.path(".", "S07")
file.path("S07")
file.path(getwd(), "S07")


# global environment (revision) ----
a <- 10
b <- 20
ls()
rm("b")
rm(a)
a <- 10
b <- 20
rm(list = ls())

func_IsEven(2)

# source ----
source(file = file.path(
    "S07",
    "shared",
    "func_IsEven.R"
))
source(file = file.path(
    "S07",
    "shared",
    "variable_defs.R"
))

ls()

# recap on global environment ----
a <- 10
b <- 20
ls()
rm("b")
rm(a)

a <- 10
b <- 20
rm(list = ls())

# save / load to .RData ----
a <- 10
save(a, file = "a.RData")
save.image(file = "img.RData")
rm(list = ls())
load("img.RData")
