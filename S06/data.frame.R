# list and attributes makes data.frame ----
# compare df and l
df <- data.frame(x = 1:3, y = letters[1:3])

l <- list(x = 1:3, y = letters[1:3])
attr(l, "class") <- "data.frame"
attr(l, "row.names") <- 1:3

identical(df, l)
attributes(df)


df1 <- as.data.frame(list(x = 1:3, y = letters[1:3]))
df2 <- as.data.frame(x = 1:3, y = letters[1:3])
identical(df, df1)
identical(df, df2)

is.data.frame(df1)
df1
attributes(df1)
?as.data.frame

# row/column functions ----
df <- data.frame(x = 1:3, y = letters[1:3])
df
rownames(df)
colnames(df)
names(df)

nrow(df)
ncol(df)
length(df)

t(df)

rbind(df, df)
cbind(df, df)

# exercise ----
df <- data.frame(x = 1:3, y = letters[1:3])
df2 <- rbind(df, df)

df2[["x"]][5]
df2[["x"]][nrow(df2)]
df2[[ncol(df2)]][nrow(df2)]
colnames(df2)[ncol(df2)]
identical(df2["y"], df2[["y"]])
df2[["x"]][2]


df3 <- cbind(a = df2, z = 1:nrow(df2)*10)
df3
df3["4", "z"]
(df3[["z"]] + 4)[2]
df3[[ncol(df3)]][nrow(df3)]
