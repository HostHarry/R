source("setup.R")

age_six <- episodes[episodes$Age == 6, ]
figure_6a <- ggplot(age_six, aes(x = BirthQuarter, y = CumEpisodes, fill = BirthQuarter)) +
    geom_boxplot(width = 0.5, outlier.shape = NA, alpha = 0.75) +
    geom_point(position = position_jitter(width = 0.05, height = 0, seed = 16524), size = 0.7) +
    scale_fill_manual(values = c("#1F77B4", "#FF7F0E", "#2CA02C", "#D62728")) +
    scale_x_discrete(labels = count_labels(age_six$BirthQuarter, "n=")) +
    scale_y_continuous(breaks = seq(0, 25, 5)) +
    labs(x = "Birth quarter", y = "Cumulative episodes", tag = "A", caption = supplement_note) +
    paper_theme +
    theme(legend.position = "none")
save_figure(figure_6a, "figure_6A", 8.2, 5.8)

risk_by_age <- do.call(rbind, lapply(1:6, function(i) {
    age_data <- episodes[episodes$Age %in% c(2 * i - 1, 2 * i), ]
    is_q4 <- age_data$BirthQuarter == "Q4"
    a <- sum(age_data$GotEpisode[is_q4] == "yes")
    n1 <- sum(is_q4)
    c <- sum(age_data$GotEpisode[!is_q4] == "yes")
    n0 <- sum(!is_q4)
    rr <- (a / n1) / (c / n0)
    ci <- exp(log(rr) + c(-1, 1) * qnorm(0.975) * sqrt(1 / a - 1 / n1 + 1 / c - 1 / n0))
    data.frame(AgeGroup = paste0(2 * i - 1, "-", 2 * i), RR = rr, Lower95 = ci[1], Upper95 = ci[2])
}))
risk_by_age$AgeGroup <- factor(risk_by_age$AgeGroup, levels = risk_by_age$AgeGroup)
figure_6b <- ggplot(risk_by_age, aes(x = AgeGroup, y = RR)) +
    geom_hline(yintercept = 1, linetype = 2, linewidth = 0.25, colour = "darkblue") +
    geom_errorbar(aes(ymin = Lower95, ymax = Upper95), width = 0.2) +
    geom_point(colour = "red") +
    labs(x = "Age group [years]", y = "Risk ratio (Q4)", tag = "B", caption = supplement_note) +
    paper_theme
save_figure(figure_6b, "figure_6B", 8.2, 5.8)

figure_6 <- wrap_plots(figure_6a + labs(caption = NULL), figure_6b + labs(caption = NULL), ncol = 1) +
    plot_annotation(caption = supplement_note,
        theme = theme(plot.caption = element_text(size = 9, hjust = 0)))
save_figure(figure_6, "figure_6", 8.2, 12)

if (interactive()) print(figure_6)
