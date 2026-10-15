?read.table

# 1. read.table ----
getwd()
csv_file <- file.path(
    "S07",
    "data",
    "data_2021-Oct-05.csv"
)
# csv_file <- file.choose()
d <- read.table(file = csv_file, sep = ",")
head(d)
typeof(d)
class(d)
summary(d)

d <- read.table(file = csv_file, sep = ",", header = TRUE)
summary(d)

d <- read.csv(file = csv_file)
summary(d)

# 2. read.csv ----
d <- read.csv(csv_file, stringsAsFactors = TRUE)
summary(d)

d <- read.csv(csv_file, stringsAsFactors = TRUE, as.is = c(1, 2))
summary(d)

# compare column 1 and column 3
is.factor(d$areaCode)
is.factor(d$areaType)
typeof(d$areaCode)
typeof(d$areaType)

d <- read.csv(csv_file, stringsAsFactors = TRUE, strip.white = TRUE)
summary(d)

d$date <- as.Date(d$date)
summary(d)

# 3. write.table ----
write.csv(
    d,
    file = file.path(
        "S07",
        "data",
        "write_d.csv"
    ),
    row.names = FALSE
)

d[2, 3] <- NA
row.names(d)
write.csv(
    d,
    file = file.path(
        "S07",
        "data",
        "write_d.csv"
    ),
    row.names = FALSE
)
write.csv(
    d,
    file = file.path(
        "S07",
        "data",
        "write_d.csv"
    ),
    row.names = FALSE,
    na = "missing"
)

# 4. Excel ----

# library(readxl)
# the package comes with example data files
# readxl_example()
# file_name <- readxl_example("datasets.xlsx")
xls_file <- file.path(
    "S07",
    "data",
    "datasets.xlsx"
)

readxl::read_excel(xls_file) # reads sheet 1 by default
readxl::excel_sheets(xls_file)
readxl::read_excel(xls_file, sheet = "quakes")
readxl::read_excel(xls_file, sheet = "quakes", range = "B4:D8") # no header

