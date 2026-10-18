# Paper reading task I: Data Manipulation

Create a private repository under <https://github.com/oxford-mgh-2627> to store your work. There should be one R script named `solution.R` at the root of the repository that contains all answers (including workings). The necessary data files should also be stored in this repository. The `solution.R` script should be able to produce all answers without any modification to the repository.

Keep committing and pushing to this repository (no branching is needed) as you work through the questions.

Complete the following 10 questions using standard R functions, except for Question 7, which uses `tidyr::pivot_wider()` and `tidyr::pivot_longer()`. Install tidyr if needed using `install.packages("tidyr")`; the `tidyr::` notation lets you use these functions without calling `library(tidyr)`. The three papers are separate studies: analyse each study independently and only merge files belonging to the same study.

Use comments to separate your answer to each question, and comment on your answer where necessary. Calculate exact answers from the data; refer to figures of the papers to check approximate values and patterns. You are not requested to reproduce the figures.

Where the question refer to a file with a relative path (e.g. `paper_1/spatioTemporalEpisodeHistories.csv`), this path is indicative-only and your repository may apply a different structure as long as your solution script can access the files correctly.

## Paper 1: malaria episode histories

[Individual-level variations in malaria susceptibility and acquisition of clinical protection](https://doi.org/10.12688/wellcomeopenres.16524.3)

**Data:** `paper_1/spatioTemporalEpisodeHistories.csv`

Each row describes one child in one year. `Episodes` is the number of episodes during that year; `CumEpisodes` includes episodes from previous years and the current year. A child can appear in several rows.

### Question 1: total episodes during a selected period

How many malaria episodes were recorded between **2008 and 2010, inclusive of both**?

**Hint:** Read the CSV using `read.csv()`. Use `[, ]` to select the relevant rows and the columns `Participant.ID`, `Year` and `Episodes`. Extract `Episodes` using `[[ ]]`, then calculate the total using `sum()`.

**Check:** add the approximate annual totals shown by the total-episodes line in Figure 1A.

### Question 2: the year with the most episodes

Which year had the highest total number of malaria episodes?

**Hint:** Use `aggregate()` to calculate total `Episodes` for each `Year`. Use `max()` and conditional filtering to identify the year and its total. Report the annual summary table as well.

**Check:** the highest point on the total-episodes line in Figure 1A.

### Question 3: the percentage experiencing an episode

What percentage of children experienced at least one malaria episode in **2006** and in **2018**?

**Hint:** Filter each year separately. Compare the length of the `Participant.ID` vector with the length of its `unique()` values to check that each child appears only once within that year. This also rules out identical duplicate rows. Count the records with `Episodes > 0` and divide by the total number of records for that year, then multiply by 100. Do not use `mean()`. Report the numerator and denominator for each percentage, and calculate the increase from 2006 to 2018 in **percentage points**.

**Check:** the proportion-with-episode line and the right-hand axis in Figure 1A.

### Question 4: birth quarter and cumulative episodes

Among children aged **exactly six years**, which birth quarter had the lowest median cumulative number of episodes?

**Hint:** Filter on `Age`, then use `aggregate()` and `median()` to summarise `CumEpisodes` by `BirthQuarter`. Report all four medians and identify the quarter with the lowest value.

**Check:** the horizontal median lines inside the boxes in Figure 6A.

## Paper 2: mortality and survival in Kilifi

[Mortality in rural coastal Kenya measured using the Kilifi Health and Demographic Surveillance System: a 16-year descriptive analysis](https://doi.org/10.12688/wellcomeopenres.17307.2)

**Survival data for Questions 5 and 7:** `paper_2/data_files/csv/average_survival_by_sex.csv`

**Mortality data for Question 6:** `paper_2/data_files/csv/master_ASMRs_with_births.csv`

In the survival file, `p50` is the estimated median survival time in years; `sex` is `f` for female and `m` for male. In the mortality file, each row summarises a sex, year, age-group and location combination. `PYO` means person-years of observation, `agecat_1` contains age-group lower boundaries in years, and `y_bloc` identifies a four-year period.

### Question 5: change in median survival

How much did median survival increase between **2003 and 2018** for females and males?

**Hint:** Import the survival CSV. Using `[, ]` and conditions on `year` and `sex`, extract the four relevant `p50` values. Calculate the increase for each sex. Report the starting value, ending value and increase in years.

**Check:** the endpoints of both lines in Figure 1.

### Question 6: under-five mortality rates

What was the under-five mortality rate in each four-year period?

**Hint:** Import the mortality CSV. Select rows where `agecat_1 < 5`. Use `aggregate()` to sum `deaths` and `PYO` for each `y_bloc`. For each period, calculate:

`mortality rate = 1000 * total deaths / total PYO`

Report the total deaths, total person-years and rate per 1,000 person-years for each period. Use the pooled totals rather than averaging rates calculated for individual rows.

**Check:** the "0–4 years, Total" rows in Table 2. Round rates to one decimal place for comparison.

### Question 7: reshape survival data to wide and back to long

In which year was the female–male gap in median survival largest?

**Hint:** Keep `year`, `sex` and `p50`. Use `tidyr::pivot_wider()` to create a **wide** table with one row per year and separate female and male survival columns. Calculate female minus male survival, and identify the year with the largest gap and the size of that gap.

Then use `tidyr::pivot_longer()` to return the survival columns to **long** format, with columns `year`, `sex` and `p50`. Check that the original 32 observations and their values are recovered; row order may differ.

**Check:** the widest vertical separation between the lines in Figure 1. The long table should again have two observations per year.

## Paper 3: parasite genome variation

[An open dataset of Plasmodium falciparum genome variation in 7,000 worldwide samples](https://doi.org/10.12688/wellcomeopenres.16168.2)

**Sample metadata:** `paper_3/File2_Pf_6_samples.txt`

**Within-host diversity:** `paper_3/File3_Pf_6_fws.txt`

These files are tab-delimited. Import them using `read.csv()` with `sep = "\t"` and `check.names = FALSE`. The latter preserves the space in the column name `QC pass`, which can be accessed using `[["QC pass"]]`. Its values are the text strings `"True"` and `"False"`.

`Sample` identifies a sample and links the two files. `Fws` measures within-host diversity; values below 0.95 indicate evidence of genetically mixed infections in the paper's analysis.

| Population code | Region |
|---|---|
| SAM | South America |
| WAF | West Africa |
| CAF | Central Africa |
| EAF | East Africa |
| SAS | South Asia |
| WSEA | Western Southeast Asia |
| ESEA | Eastern Southeast Asia |
| OCE | Oceania |

### Question 8: quality filtering and merging

How many samples from each population are available after quality filtering and merging?

**Hint:** Import both files. Keep metadata rows where `QC pass` equals `"True"`, selecting the columns `Sample` and `Population`. Use `merge()` to attach `Fws` by `Sample`, keeping matched samples.

Report the total number of matched samples and the count per population. Check that sample IDs are unique and that merging has preserved the number of samples passing quality control.

**Check:** the regional sample sizes in the Figure 1 caption and the overall analysis-set size reported in the paper.

### Question 9: median diversity by population

Which populations have the lowest and highest median `Fws`?

**Hint:** Using the merged data from Question 8, use `aggregate()` to calculate median `Fws` for each population. Report all eight medians, and identify the lowest and highest values using conditional extraction.

**Check:** the median lines in Figure 2A. Some medians are too close to distinguish reliably from the plot alone.

### Question 10: samples below a diversity threshold

What percentage of samples have `Fws < 0.95` in **Africa** and in **Southeast Asia**?

**Hint:** Select African populations (`WAF`, `CAF`, `EAF`) and Southeast Asian populations (`WSEA`, `ESEA`) separately from the merged data. For each group, report the total number of samples, the number below the threshold using `sum()`, and the percentage below the threshold using `mean()`.

**Check:** the distributions in Figure 2A and the accompanying "Global population structure" results text. The boxplots support a comparison of distributions; the precise percentages come from your calculations.
