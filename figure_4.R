source("setup.R")

aa_episodes <- episodes[episodes$Genotype == "AA", ]
figure_4a <- ggplot(episodes, aes(x = GotEpisode, y = Age, fill = GotEpisode)) +
    geom_violin(width = 0.6) +
    geom_boxplot(width = 0.15, outlier.shape = NA, colour = "white", fill = "black") +
    scale_y_continuous(breaks = seq(2, 15, 2)) +
    scale_x_discrete(labels = count_labels(episodes$GotEpisode, "N = ")) +
    scale_fill_manual(values = clinical_colours) +
    labs(x = "Clinical episode", y = "Age [years]", tag = "A") +
    paper_theme +
    theme(legend.position = "none")

figure_4b <- ggplot(aa_episodes, aes(x = GotEpisode, y = PrevEpisodes, fill = GotEpisode)) +
    geom_violin(width = 0.9) +
    geom_boxplot(width = 0.1, outlier.shape = NA, colour = "white", fill = "black") +
    scale_x_discrete(labels = count_labels(aa_episodes$GotEpisode, "N = ")) +
    scale_fill_manual(values = clinical_colours) +
    labs(x = "Clinical episode", y = "Previous epsisodes", tag = "B") +
    paper_theme +
    theme(legend.position = "none")

figure_4 <- wrap_plots(figure_4a, figure_4b, nrow = 1) +
    plot_annotation(caption = supplement_note,
        theme = theme(plot.caption = element_text(size = 9, hjust = 0)))
save_figure(figure_4, "figure_4", 9, 6)

if (interactive()) print(figure_4)
