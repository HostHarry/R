a <- 10
b <- 20
ls()

rm("b")
ls()

rm(a)
ls()

a <- 10
b <- 20
ls()
rm(list = ls())
ls()