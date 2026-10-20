source("setup.R")

high_transmission <- data.frame(start = c(2013, 2017), end = c(2014, 2018))
figure_3 <- ggplot(episodes[episodes$BirthYear %in% 2007:2012, ],
        aes(x = Year, y = CumEpisodes, group = Participant.ID, colour = Genotype)) +
    geom_line() +
    facet_wrap(~BirthYear, labeller = label_both, ncol = 3) +
    scale_x_continuous(breaks = seq(2007, 2018, 2)) +
    scale_colour_manual(values = c("AA" = "#3B4992", "AS" = "#EE0000")) +
    geom_rect(data = high_transmission, inherit.aes = FALSE,
        aes(xmin = start, xmax = end), ymin = 0, ymax = max(episodes$CumEpisodes),
        colour = "transparent", fill = "orange", alpha = 0.1) +
    labs(x = "Year", y = "Cumulative episodes", caption = supplement_note) +
    paper_theme +
    theme(legend.position = "right")
save_figure(figure_3, "figure_3", 10.8, 6.3)

if (interactive()) print(figure_3)
