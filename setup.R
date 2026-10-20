packages <- c("ggplot2", "patchwork")
install.packages(setdiff(packages, rownames(installed.packages())), repos = "https://cloud.r-project.org")
library(ggplot2)
library(patchwork)

output_dir <- file.path("paper_1", "figures")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

episodes <- read.csv("spatioTemporalEpisodeHistories.csv")
episodes$GotEpisode <- factor(episodes$GotEpisode, levels = c("no", "yes"))

save_figure <- function(plot, name, width, height) {
    for (extension in c("png", "pdf")) {
        ggsave(file.path(output_dir, paste0(name, "_recreated.", extension)), plot,
            width = width, height = height, dpi = 180, bg = "white")
    }
}

count_labels <- function(x, sep) {
    counts <- table(x)
    setNames(paste0(names(counts), "\n(", sep, counts, ")"), names(counts))
}

paper_theme <- theme_gray(base_size = 13) +
    theme(
        legend.position = "top",
        legend.title = element_text(size = 13),
        legend.text = element_text(size = 12),
        axis.title = element_text(colour = "black"),
        plot.tag = element_text(size = 18),
        plot.caption = element_text(size = 9, hjust = 0),
        plot.margin = margin(10, 10, 10, 10)
    )
supplement_note <- "Recreated from original data following SupplementaryInfo.html."
clinical_colours <- c("no" = "#0073C2", "yes" = "#EFC000")
