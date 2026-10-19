# Model answers for exam_paper.md.
# Run from the project root (intro-r-material), e.g. line by line in RStudio.

malaria <- read.csv(file.path("up_to_06_exam", "malaria.csv"))

# Part 1 ----

# 1.1
nrow(malaria) # 20
ncol(malaria) # 6

# 1.2 a data frame is a list of columns, so length() counts columns
length(malaria) # 6

# 1.3
dim(malaria) # 20 6

# 1.4
head(malaria)

# 1.5
tail(malaria)

# 1.6 any two of these
names(malaria)
colnames(malaria)

# 1.7
str(malaria) # summary() is also accepted

# 1.8
any(is.na(malaria))
# accepted: anyNA(malaria)

# Part 2 ----

# 2.1
malaria$cases

# 2.2 the paper asks for `deaths`, which is not in the data; `cases` (column 5) is used here
malaria[["cases"]]
malaria[[5]]
which(names(malaria) == "cases") # 5
# accepted: match("cases", names(malaria))

# 2.3 [ ] keeps the data frame, [[ ]] drops to a vector
class(malaria["cases"]) # "data.frame"
class(malaria[["cases"]]) # "integer" (read.csv reads whole numbers as integer)

# 2.4
malaria[4, "parasite"] # "P. vivax"

# 2.5 the comma is required
malaria[10:15, ]

# 2.6
malaria[c(1, 3, 5), c(1, 4)]

# 2.7
malaria[, -c(1, 3)]

# 2.8
malaria[, c(FALSE, TRUE, FALSE, TRUE, TRUE, FALSE)]

# 2.9
malaria[!malaria$high_burden, ] # 9 rows
# accepted: malaria[malaria$high_burden == FALSE, ]

# Part 3 ----

# 3.1
malaria[malaria$parasite == "P. falciparum", ] # 10 rows

# 3.2 every row passes, because the smallest value is 13907
malaria[malaria$cases > 3000, c("country", "cases")]

# 3.3 $ then [ ] returns a vector
unique(malaria$country[malaria$who_region == "Americas"]) # "Brazil" "Colombia" "Venezuela"
# accepted: unique(malaria[malaria$who_region == "Americas", "country"])

# 3.4
malaria[malaria$who_region == "Africa" & malaria$parasite == "P. falciparum", ] # rows 1, 3

# 3.5 == joined with |
malaria[malaria$who_region == "South-East Asia" | malaria$who_region == "Americas", ] # rows 5 to 14

# 3.6 ! or == FALSE both accepted
malaria[!malaria$high_burden & malaria$cases > 30000, c("country", "parasite", "cases")] # rows 5, 6, 12, 14

# 3.7 a logical vector, one value per row
malaria$cases >= 100000

# 3.8
sum(malaria$cases[malaria$parasite == "P. vivax" & malaria$who_region == "Americas"]) # 252151

# 3.9 the mean is not typed in
malaria[malaria$cases > mean(malaria$cases), ]
