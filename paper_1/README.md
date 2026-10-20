# Paper 1: recreating the malaria plots in R

This project recreates **Figures 1A-C and 3-6** from Valletta et al.,
*Individual-level variations in malaria susceptibility and acquisition of
clinical protection*, [version 3](https://doi.org/10.12688/wellcomeopenres.16524.3).
All plots use the included original CSV.

**Figures 3-6 follow the authors' deposited `SupplementaryInfo.html` code.**
In particular, Figure 4 has two panels and Figure 5 plots `PrevEpisodes / Age`,
as in the supplement. These differ from the published article's three-panel
Figure 4 and unnormalized Figure 5. The original supplementary axis labels,
including their spelling, are retained; Figure 5's caption also states its
actual calculation.

Every code line in `solution.R` has a Chinese explanation. The transformations
use base R, and the plots use `ggplot2` and `patchwork`. The AAAS/JCO palette
colours and the Wald risk-ratio formula are specified directly, so `ggsci`
and `epitools` are not required.

## Data

**The original participant-year data are now included** at
[`spatioTemporalEpisodeHistories.csv`](../spatioTemporalEpisodeHistories.csv),
in the project root alongside `solution.R`.
The file was copied unchanged from the supplied
`/Users/hostharry/Downloads/dataverse_files/` folder on 20 October 2026. It contains
3,767 records for 544 children. Its SHA-256 is
`05adf583c66cc801a12e25edc92a961899d975abee9f5dc4d8b7b5f45959f2c9`.

The dataset source is
[Harvard Dataverse, doi:10.7910/DVN/WQCKJJ](https://doi.org/10.7910/DVN/WQCKJJ).
The deposit lists `spatioTemporalEpisodeHistories.tab` (file ID **4203471**).
Choose **Download → Original File Format** to obtain
`spatioTemporalEpisodeHistories.csv` if you need a fresh copy. The data dictionary
and the authors' supplementary analysis are also saved in `reference/`.

All figures are calculated directly from this original CSV. If the file is
missing or its path is incorrect, `read.csv()` stops with an error.

## Run

The installed R packages `ggplot2` and `patchwork` are needed. If necessary,
install them once:

```r
install.packages(c("ggplot2", "patchwork"))
```

From the project root in R/RStudio:

```r
source("solution.R")
```

Or from a terminal:

```sh
Rscript solution.R
```

The script sets the project directory and CSV path directly:

```r
project_dir <- "/Users/hostharry/Downloads/intro-r-lectures"
data_file <- "/Users/hostharry/Downloads/intro-r-lectures/spatioTemporalEpisodeHistories.csv"
```

The CSV is read from the explicit absolute path above, and figures are saved
under `paper_1/figures/` within `project_dir`. You can run the script from any
working directory; edit both `project_dir` and `data_file` if you move the
project to another location or computer. It reads local files and does not
attempt network downloads.

## Outputs

Calculated from the original CSV:

- `figures/figure_1_recreated.png` and `.pdf`: all three panels.
- `figures/figure_1A_recreated.png` and `.pdf`: the dual-axis line plot.
- `figures/figure_3_recreated.png` and `.pdf`: cumulative histories by birth year.
- `figures/figure_4_recreated.png` and `.pdf`: the supplement's two violin/boxplot panels.
- `figures/figure_5_recreated.png` and `.pdf`: age panels using `PrevEpisodes / Age`.
- `figures/figure_6A_recreated.png` and `.pdf`: the birth-quarter boxplot.
- `figures/figure_6B_recreated.png` and `.pdf`: risk ratios with 95% confidence intervals.
- `figures/figure_6_recreated.png` and `.pdf`: the complete Figure 6, with A above B.
- `figures/annual_summary_recreated.csv`: values used in panel A.
- `figures/episode_distribution_recreated.csv`: values used in panels B/C.
- `figures/birth_quarter_medians_recreated.csv`: medians at age six.
- `figures/risk_ratio_by_age_recreated.csv`: Figure 6B's counts, risk ratios and intervals.

## How the plots are calculated

- **Figure 1A:** sum `Episodes` in each year. Separately, count children with
  `Episodes > 0` and divide by the number observed in that year. Check that each
  participant occurs at most once per year. The second axis uses a factor of
  600, matching the published alignment of 300 episodes with a proportion of
  0.5. This is a graphical scale conversion, not a population denominator.
- **Figure 1B:** group positive child-year records into 1, 2 or 3+ episodes and
  sum their episode counts. A child with four episodes contributes four to the
  3+ segment. The published bar heights are episode contributions; simply
  counting children in each group would produce different heights.
- **Figure 1C:** divide each segment of panel B by that year's total episodes,
  so each bar sums to 100%. This is a distribution of episodes, not the
  proportion of all children who experienced malaria.
- **Figure 3:** select birth years 2007-2012, connect each child's `CumEpisodes`
  over `Year`, and colour AA blue and AS red. Facet by birth year in three
  columns. As in the supplementary code, orange rectangles span 2013-2014
  and 2017-2018, with their height set by the full dataset's maximum cumulative
  count.
- **Figure 4:** panel A compares `Age` between `GotEpisode == "no"` and `"yes"`
  using all observations. Panel B compares `PrevEpisodes` for the same two
  outcome groups after selecting `Genotype == "AA"`. Both use violin plots
  with narrow black boxplots and white outlines. These are the supplement's
  two panels, arranged side by side.
- **Figure 5:** select `Genotype == "AA"` and create 12 age panels. The plotted
  outcome is **`PrevEpisodes / Age`**, exactly as specified in the supplementary
  code, despite its original axis label saying "Previous number of epsisodes".
  All points are shown, with horizontal jitter only and a fixed seed.
- **Figure 6A:** select `Age == 6`, then plot `CumEpisodes` by `BirthQuarter`.
  Include children with sickle-cell trait. Jitter is horizontal only and uses
  a fixed seed; its exact placement need not match the supplementary points.
- **Figure 6B:** group ages into 1-2, 3-4, 5-6, 7-8, 9-10 and 11-12. In each
  group, calculate the proportion with `GotEpisode == "yes"` for Q4 births and
  for Q1-Q3 births; divide Q4's proportion by Q1-Q3's. Include both genotypes,
  and count child-year records, following the authors' code.

For Figure 6B, let `a` of `Na` Q4 observations and `b` of `Nb` Q1-Q3 observations
have an episode. The calculations reproduce the default Wald method in
`epitools::riskratio()`:

```text
RR = (a / Na) / (b / Nb)
SE(log RR) = sqrt(1/a - 1/Na + 1/b - 1/Nb)
95% CI = exp(log(RR) +/- qnorm(0.975) * SE(log RR))
```

All six groups have nonzero case counts, so no zero-cell adjustment is needed.
As in the supplement, the interval calculation treats the pooled child-year
observations as independent; it is not a model with child-specific effects.

## Validation and results

The data match the paper's age range of 1-12 years and study years 2006-2018.
The observed 3,767 child-years from 544 children agree with the paper. There
are no duplicate participant-year records, and `Episodes > 0` agrees with the
supplied `GotEpisode == "yes"` indicator for every record.

Figure 6A's quarter sample sizes are 97, 97, 107 and 71, matching its published
labels. The authors' `SupplementaryInfo.html` also confirms the factor of 600
for the secondary axis and the episode-weighted bars in Figure 1B.

Figure 3 includes 172 children born in 2007-2012. Figure 4's panel A counts
are 1,998 without and 1,769 with an episode; panel B's AA-only counts are 1,586
and 1,563. These agree with the labels in the supplementary images. Figure 5
uses all 3,149 AA child-years, with ratios ranging from 0 to 3.5.

Figure 6B's values, rounded here for display:

| Age group | Q4 cases / total | Q1-Q3 cases / total | Risk ratio | 95% CI |
| --- | --- | --- | --- | --- |
| 1-2 | 30 / 116 | 229 / 513 | 0.5794 | 0.4195-0.8001 |
| 3-4 | 55 / 128 | 327 / 585 | 0.7687 | 0.6218-0.9504 |
| 5-6 | 52 / 140 | 328 / 607 | 0.6874 | 0.5474-0.8631 |
| 7-8 | 65 / 145 | 277 / 566 | 0.9160 | 0.7505-1.1179 |
| 9-10 | 43 / 123 | 203 / 431 | 0.7422 | 0.5717-0.9636 |
| 11-12 | 39 / 97 | 121 / 316 | 1.0500 | 0.7935-1.3895 |

The original data give the following answers for the Paper 1 reading questions:

| Quantity | Result |
| --- | --- |
| Episodes in 2008-2010 inclusive | 768 |
| Year with the most episodes | 2014, with 534 episodes |
| Children with an episode in 2006 | 71 / 266 = 26.69% |
| Children with an episode in 2018 | 171 / 224 = 76.34% |
| Increase from 2006 to 2018 | 49.65 percentage points |
| Median cumulative episodes at age six, Q1-Q4 | 3, 4, 5, 1 |

The numeric calculations use the original observations. Plot dimensions,
font sizes, density estimates under different ggplot2 versions, and horizontal
jitter positions may differ from the supplementary images.

## Sources

Reference files:

- `reference/MRecker_spatioTemporalEpisodeHistories_Codebook.pdf`: the deposited
  variable descriptions.
- `reference/SupplementaryInfo.html`: the authors' deposited R analysis,
  including the Figure 1A/B and Figures 3-6 plotting code.
- `reference/figure_3_supplement.png` through `figure_6_supplement.png`: the
  actual embedded images extracted from that HTML, used as the reference
  targets for this reproduction.
- `reference/figure_3_published.jpg` through `figure_5_published.jpg`: the article
  images, retained to make the differences from the supplementary figures clear.
- [`figure_1_published.jpg`](reference/figure_1_published.jpg):
  [published Figure 1 image](https://cdn.ncbi.nlm.nih.gov/pmc/blobs/33d1/8914275/9ffc9a97ccfd/wellcomeopenres-6-19562-g0000.jpg).
- [`figure_6_published.jpg`](reference/figure_6_published.jpg):
  [published Figure 6 image](https://cdn.ncbi.nlm.nih.gov/pmc/blobs/33d1/8914275/09a15dccb405/wellcomeopenres-6-19562-g0005.jpg).
- `reference/dataverse_metadata.json`: dataset metadata, version 1.1, retrieved
  on 20 October 2026. This file contains descriptions and identifiers, not
  participant records.

Article and dataset attribution: Valletta et al. (2021), paper DOI above;
Recker, Mario (2020), *Replication Data for: Individual-level variations in
malaria susceptibility and acquisition of clinical protection*, Harvard
Dataverse, V1.1, DOI 10.7910/DVN/WQCKJJ. The article and deposited data state
CC BY 4.0 licensing. The reconstructed graphics are adaptations.
