
# Flipping a fair coin
CoinFunc <- function(n) {
    res <- c("head" = 0, "tail" = 0) # number of events counter
    for (ii in seq_len(n)) {
        if (runif(1) < 0.5) {
            res["tail"] <- res["tail"] + 1
        } else {
            res["head"] <- res["head"] + 1
        }
    }
    return(res)
}
nc <- CoinFunc(10000)
print(paste(
    "nc[\"tail\"]:", nc["tail"],
    "nc[\"head\"]:", nc["head"]
))
barplot(nc)

