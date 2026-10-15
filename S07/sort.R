# sort ----
v <- c(NA, 10, 8, 4, 4, NaN, NULL, 7, 13)
sort(v)
sort(v, decreasing = TRUE)


# order ----

v <- c(NA, 10, 8, 4, 4, NaN, NULL, 7, 13)
order(v)
v[order(v)]
v[order(v, decreasing = TRUE)]


df <- data.frame(
    name  = letters[1:8],
    age   = c(25,  25, 25,  20, 20,  15, 47, 33),
    score = c(97, 100, 90, 100, 95, 100, 90, 90)
)
df
df[order(df[["age"]]),]
df[order(df[["age"]], -df[["score"]]), ]
