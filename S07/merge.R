# example with vectors ----
x <- c("m", "f", "u", "f", "f", "m", "m", "")
lookup <- c(m = "Male", f = "Female", u = NA)
lookup[x]

# example with data frame ----
df <- data.frame(
    name = c(
        "robert", "catelyn", "theon", "cersei", "sansa",
        "ned", "jaime", "sandor", "arya", "tyrion"
    ),
    gender = c(
        "m", "f", "u", "f", "f",
        "m", "m",  "", "f", "m"
    )
)
lookup[df[["gender"]]]
df_res <- df
df_res[["gender_formatted"]] <- lookup[df[["gender"]]]
df_res

# merge ----

df1 <- data.frame(
  birth_house = c(
    "baratheon", "stark", "stark", "stark", "stark",
    "lannister", "lannister", "lannister", "greyjoy", "clegane"
  ),
  name = c(
    "robert", "catelyn", "sansa", "ned", "arya",
    "cersei", "jaime", "tyrion", "theon", "sandor"
  )
)
match(df$name, df1$name)
df_res <- df
df_res[["birth_house"]] <- df1[match(df$name, df1$name), "birth_house"]
df_res


df3 <- merge(df, df1, by = "name")
df3
merge(df, df1)
