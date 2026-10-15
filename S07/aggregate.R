dtf <- data.frame(
    p1 = rep(1:2, 4:5),
    p2 = rep(letters[2:3], 5:4),
    v1 = rnorm(9, mean = 10),
    v2 = rnorm(9, mean = 20)
)
dtf

aggregate(
    dtf$v1,
    by = list(p1 = dtf$p1, p2 = dtf$p2),
    FUN = mean
)
aggregate(
    dtf[, 3:4],
    by = list(p1 = dtf$p1, p2 = dtf$p2),
    FUN = mean
)

dtf2 <- dplyr::group_by(dtf, p1, p2)
dplyr::summarise(dtf2, v1.avg = mean(v1), v2.max = max(v2))
