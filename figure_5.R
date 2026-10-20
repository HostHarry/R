source("setup.R")

aa_episodes <- episodes[episodes$Genotype == "AA", ]
aa_episodes$AgePanel <- factor(paste(aa_episodes$Age, "years"), levels = paste(1:12, "years"))
figure_5 <- ggplot(aa_episodes, aes(x = GotEpisode, y = PrevEpisodes / Age, fill = GotEpisode)) +
    geom_boxplot(outlier.shape = NA) +
    geom_point(position = position_jitter(width = 0.05, height = 0, seed = 16524), size = 0.25) +
    facet_wrap(~AgePanel, ncol = 4) +
    scale_fill_manual(values = clinical_colours) +
    labs(x = "Clinical episode", y = "Previous number of epsisodes",
        caption = paste(supplement_note, "Y = PrevEpisodes / Age.", sep = "\n")) +
    paper_theme +
    theme(legend.position = "none")
save_figure(figure_5, "figure_5", 9, 9)

if (interactive()) print(figure_5)
