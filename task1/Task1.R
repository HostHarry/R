rm(list = ls())
# Paper 1: malaria episode histories
#
# Individual-level variations in malaria susceptibility and acquisition of clinical protection
#
# Data: paper_1/spatioTemporalEpisodeHistories.csv
#
# Each row describes one child in one year. Episodes is the number of episodes during that year; CumEpisodes includes episodes from previous years and the current year. A child can appear in several rows.
# Question 1: total episodes during a selected period
#
# How many malaria episodes were recorded between 2008 and 2010, inclusive of both?
#   
#   Hint: Read the CSV using read.csv(). Use [, ] to select the relevant rows and the columns Participant.ID, Year and Episodes. Extract Episodes using [[ ]], then calculate the total using sum().
#
# Check: add the approximate annual totals shown by the total-episodes line in Figure 1A.
csv <- read.csv("paper_1/spatioTemporalEpisodeHistories.csv")
med_Q1 <- csv[csv$Year >= 2008 & csv$Year <= 2010, "Episodes"]
result_Q1 <- sum(med_Q1)
print(result_Q1)
csv <- read.csv("paper_1/spatioTemporalEpisodeHistories.csv")
med_Q1 <- csv[csv$Year >= 2008 & csv$Year <= 2010, c("Participant.ID","Years","Episodes")]
result_Q1 <- sum(med_Q1[["Episodes"]])
print(result_Q1) #standard
# Question 2: the year with the most episodes
#
# Which year had the highest total number of malaria episodes?
#   
#   Hint: Use aggregate() to calculate total Episodes for each Year. Use max() and conditional filtering to identify the year and its total. Report the annual summary table as well.
#
# Check: the highest point on the total-episodes line in Figure 1A.
csv <- read.csv("paper_1/spatioTemporalEpisodeHistories.csv")
med_Q2 <- aggregate(Episodes ~ Year, csv, sum)
result_Q2 <- med_Q2[med_Q2$Episodes == max(med_Q2$Episodes), ]
# Question 3: the percentage experiencing an episode
#
# What percentage of children experienced at least one malaria episode in 2006 and in 2018?
#   
#   Hint: Filter each year separately. Compare the length of the Participant.ID vector with the length of its unique() values to check that each child appears only once within that year. This also rules out identical duplicate rows. Count the records with Episodes > 0 and divide by the total number of records for that year, then multiply by 100. Do not use mean(). Report the numerator and denominator for each percentage, and calculate the increase from 2006 to 2018 in percentage points.
#
# Check: the proportion-with-episode line and the right-hand axis in Figure 1A.
#
csv <- read.csv("paper_1/spatioTemporalEpisodeHistories.csv")
csv_Year_2006 <- csv[csv$Year == 2006, ]
csv_Year_2018 <- csv[csv$Year == 2018, ]
num_total_2006 <- nrow(csv_Year_2006)
num_total_2018 <- nrow(csv_Year_2018)
num_patients_2006 <-nrow(csv_Year_2006[csv_Year_2006$Episodes > 0, ])
percentage_2006 <- paste0(num_patients_2006, "/", num_total_2006)
print(percentage_2006)
num_patients_2018 <-nrow(csv_Year_2018[csv_Year_2018$Episodes > 0, ])
percentage_2018 <- paste0(num_patients_2018, "/", num_total_2018)
print(percentage_2018)
csv <- read.csv("paper_1/spatioTemporalEpisodeHistories.csv")
# 1. 分别筛选两个年份
csv_Year_2006 <- csv[csv$Year == 2006, ]
csv_Year_2018 <- csv[csv$Year == 2018, ]
# 2. 检查每年内是否每个儿童只出现一次
ids_2006 <- csv_Year_2006$Participant.ID
ids_2018 <- csv_Year_2018$Participant.ID
print(length(ids_2006) == length(unique(ids_2006)))  # TRUE
print(length(ids_2018) == length(unique(ids_2018)))  # TRUE
# 3. 分母：当年的儿童总人数
num_total_2006 <- nrow(csv_Year_2006)
num_total_2018 <- nrow(csv_Year_2018)
# 4. 分子：当年至少发作一次的儿童人数
num_patients_2006 <- nrow(csv_Year_2006[csv_Year_2006$Episodes > 0, ])
num_patients_2018 <- nrow(csv_Year_2018[csv_Year_2018$Episodes > 0, ])
# 5. 计算百分比
pct_2006 <- num_patients_2006 / num_total_2006 * 100
pct_2018 <- num_patients_2018 / num_total_2018 * 100
# 6. 计算增加的百分点，使用未四舍五入的百分比
increase_pp <- pct_2018 - pct_2006
# 7. 报告分子、分母和百分比
result_Q3 <- data.frame(
  Year = c(2006, 2018),
  Numerator = c(num_patients_2006, num_patients_2018),
  Denominator = c(num_total_2006, num_total_2018),
  Percentage = round(c(pct_2006, pct_2018), 2)
)
print(result_Q3)
print(round(increase_pp, 2)) #standard
# Question 4: birth quarter and cumulative episodes
#
# Among children aged exactly six years, which birth quarter had the lowest median cumulative number of episodes?
#   
#   Hint: Filter on Age, then use aggregate() and median() to summarise CumEpisodes by BirthQuarter. Report all four medians and identify the quarter with the lowest value.
#
# Check: the horizontal median lines inside the boxes in Figure 6A.
#
csv <- read.csv("paper_1/spatioTemporalEpisodeHistories.csv")
csv_Age_6 <- csv[csv$Age == 6, ]
csv_Age_6_Q1 <- csv_Age_6[csv_Age_6$BirthQuarter == "Q1", ]
csv_Age_6_Q2 <- csv_Age_6[csv_Age_6$BirthQuarter == "Q2", ]
csv_Age_6_Q3 <- csv_Age_6[csv_Age_6$BirthQuarter == "Q3", ]
csv_Age_6_Q4 <- csv_Age_6[csv_Age_6$BirthQuarter == "Q4", ]
Q1_med <- median(csv_Age_6_Q1$CumEpisodes)
Q2_med <- median(csv_Age_6_Q2$CumEpisodes)
Q3_med <- median(csv_Age_6_Q3$CumEpisodes)
Q4_med <- median(csv_Age_6_Q4$CumEpisodes)
minium <- min(Q1_med, Q2_med, Q3_med, Q4_med)
res = which.min(c(Q1 = Q1_med, Q2 = Q2_med, Q3 = Q3_med, Q4 = Q4_med))
names(res)
# 读取数据
csv <- read.csv(
  "paper_1/spatioTemporalEpisodeHistories.csv"
)
# 只保留年龄为 6 岁的儿童
csv_Age_6 <- subset(csv, Age == 6)
# 按出生季度计算 CumEpisodes 的中位数
medians <- aggregate(
  CumEpisodes ~ BirthQuarter,
  data = csv_Age_6,
  FUN = median,
  na.rm = TRUE
)
# 重命名结果列
names(medians)[2] <- "MedianCumEpisodes"
# 找到中位数最低的季度
lowest <- medians[which.min(medians$MedianCumEpisodes), ]
# 输出四个季度的中位数
cat("Median cumulative episodes by birth quarter:\n")
print(medians, row.names = FALSE)
# 输出最低季度及其数值
cat("\nLowest median:\n")
cat("Birth quarter:", as.character(lowest$BirthQuarter), "\n")
cat("Median cumulative episodes:", lowest$MedianCumEpisodes, "\n") #standard
# Question 5: change in median survival
#
# How much did median survival increase between 2003 and 2018 for females and males?
#
# Hint: Import the survival CSV. Using [, ] and conditions on year and sex, extract the four relevant p50 values. Calculate the increase for each sex. Report the starting value, ending value and increase in years.
#
# Check: the endpoints of both lines in Figure 1.
#
csv_2 <- read.csv("paper_2/data_files/csv/average_survival_by_sex.csv")
female_2003 <- csv_2[csv_2$year == 2003 & csv_2$sex == "f", "p50"]
female_2018 <- csv_2[csv_2$year == 2018 & csv_2$sex == "f", "p50"]
male_2003 <- csv_2[csv_2$year == 2003 & csv_2$sex == "m", "p50"]
male_2018 <- csv_2[csv_2$year == 2018 & csv_2$sex == "m", "p50"]
female_increase <- female_2018 - female_2003
male_increase <- male_2018 - male_2003
# Question 6: under-five mortality rates
#
# What was the under-five mortality rate in each four-year period?
#   
#   Hint: Import the mortality CSV. Select rows where agecat_1 < 5. Use aggregate() to sum deaths and PYO for each y_bloc. For each period, calculate:
#   
#   mortality rate = 1000 * total deaths / total PYO
#
# Report the total deaths, total person-years and rate per 1,000 person-years for each period. Use the pooled totals rather than averaging rates calculated for individual rows.
#
# Check: the "0–4 years, Total" rows in Table 2. Round rates to one decimal place for comparison.
#
csv_2_1 <- read.csv("paper_2/data_files/csv/master_ASMRs_with_births.csv")
under5 <- csv_2_1[csv_2_1$agecat_1 < 5, ]
total_death <- aggregate(deaths ~ y_bloc, data = under5, FUN = sum)
total_PYO <- aggregate(PYO ~ y_bloc, data = under5, FUN = sum)
rate <- 1000 * total_death$deaths / total_PYO$PYO
rate <- round(rate, 1)
# Question 7: reshape survival data to wide and back to long
#
# In which year was the female–male gap in median survival largest?
#
# Hint: Keep year, sex and p50. Use tidyr::pivot_wider() to create a wide table with one row per year and separate female and male survival columns. Calculate female minus male survival, and identify the year with the largest gap and the size of that gap.
#
# Then use tidyr::pivot_longer() to return the survival columns to long format, with columns year, sex and p50. Check that the original 32 observations and their values are recovered; row order may differ.
#
# Check: the widest vertical separation between the lines in Figure 1. The long table should again have two observations per year.
#
csv_2 <- read.csv("paper_2/data_files/csv/average_survival_by_sex.csv")
csv_2_sub <- csv_2[, c("year", "sex", "p50")]
csv_2_wide <- tidyr::pivot_wider(csv_2_sub, names_from = sex, values_from = p50)
csv_2_wide$gap <- csv_2_wide$f - csv_2_wide$m
largest_gap <- csv_2_wide[which.max(csv_2_wide$gap), ]
# Question 8: quality filtering and merging
#
# How many samples from each population are available after quality filtering and merging?
#
# Hint: Import both files. Keep metadata rows where QC pass equals "True", selecting the columns Sample and Population. Use merge() to attach Fws by Sample, keeping matched samples.
#
# Report the total number of matched samples and the count per population. Check that sample IDs are unique and that merging has preserved the number of samples passing quality control.
#
# Check: the regional sample sizes in the Figure 1 caption and the overall analysis-set size reported in the paper.
#
txt_1 <- read.delim("paper_3/File2_Pf_6_samples.txt", check.names = FALSE)
txt_2 <- read.delim("paper_3/File3_Pf_6_fws.txt")
txt_1_True <- txt_1[txt_1$"QC pass" == "True", c("Sample", "Population")]
matched <- merge(txt_1_True, txt_2, by = "Sample")
population_counts <- table(matched$Population)
population_counts
nrow(txt_1_True)
if (nrow(txt_1_True) == length(unique(txt_1_True$Sample)))
  print("unique")
nrow(matched)
if (nrow(matched) == nrow(txt_1_True))
  print("perserved")
# Question 9: median diversity by population
#
# Which populations have the lowest and highest median Fws?
#
# Hint: Using the merged data from Question 8, use aggregate() to calculate median Fws for each population. Report all eight medians, and identify the lowest and highest values using conditional extraction.
#
# Check: the median lines in Figure 2A. Some medians are too close to distinguish reliably from the plot alone.
#
txt_1 <- read.delim("paper_3/File2_Pf_6_samples.txt", check.names = FALSE)
txt_2 <- read.delim("paper_3/File3_Pf_6_fws.txt")
txt_1_True <- txt_1[txt_1$"QC pass" == "True", c("Sample", "Population")]
matched <- merge(txt_1_Ture, txt_2, by = "Sample")
matched_med <- aggregate(Fws ~ Population, data = matched, FUN = median)
matched_med
matched_med_high <- max(matched_med$Fws)
matched_med_low <- min(matched_med$Fws)
matched_med_high
matched_med_low
# Question 10: samples below a diversity threshold
#
# What percentage of samples have Fws < 0.95 in Africa and in Southeast Asia?
#
# Hint: Select African populations (WAF, CAF, EAF) and Southeast Asian populations (WSEA, ESEA) separately from the merged data. For each group, report the total number of samples, the number below the threshold using sum(), and the percentage below the threshold using mean().
#
# Check: the distributions in Figure 2A and the accompanying "Global population structure" results text. The boxplots support a comparison of distributions; the precise percentages come from your calculations.
#
txt_1 <- read.delim("paper_3/File2_Pf_6_samples.txt", check.names = FALSE)
txt_2 <- read.delim("paper_3/File3_Pf_6_fws.txt")
txt_1_True <- txt_1[txt_1$"QC pass" == "True", c("Sample", "Population")]
matched <- merge(txt_1_True, txt_2, by = "Sample")
matched_Afr <- matched[matched$Population %in% c("WAF", "CAF", "EAF"), ]
matched_SEA <- matched[matched$Population %in% c("WSEA", "ESEA"), ]
nrow(matched_Afr)
nrow(matched_SEA)
sum(matched_Afr$Fws<0.95)
sum(matched_SEA$Fws<0.95)
mean(matched_Afr$Fws<0.95)
mean(matched_SEA$Fws<0.95)
