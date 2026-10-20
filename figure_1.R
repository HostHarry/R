source("setup.R")

years <- 2006:2018
figure_note <- "Recreated from the original participant-year CSV; Valletta et al. (2021)."
group_colours <- c("1" = "#440154", "2" = "#21908C", "3+" = "#FDE725")

annual <- aggregate(Episodes ~ Year, episodes, sum)
names(annual)[2] <- "TotalEpisodes"
annual$ProportionWithEpisode <- aggregate(Episodes ~ Year, episodes, function(x) mean(x > 0))$Episodes

positive <- episodes[episodes$Episodes > 0, ]
positive$EpisodeGroup <- ifelse(positive$Episodes >= 3, "3+", positive$Episodes)
episode_distribution <- merge(
    expand.grid(Year = years, EpisodeGroup = names(group_colours)),
    aggregate(Episodes ~ Year + EpisodeGroup, positive, sum),
    all.x = TRUE
)
episode_distribution$Episodes[is.na(episode_distribution$Episodes)] <- 0
episode_distribution$EpisodeShare <- episode_distribution$Episodes /
    annual$TotalEpisodes[match(episode_distribution$Year, annual$Year)]

axis_conversion <- 600
figure_1a <- ggplot(annual, aes(x = Year)) +
    geom_line(aes(y = TotalEpisodes, colour = "Total number of episodes"), linewidth = 0.9) +
    geom_line(aes(y = ProportionWithEpisode * axis_conversion, colour = "Proportion with episode"),
        linewidth = 1.3) +
    scale_colour_manual(name = NULL, values = c(
        "Proportion with episode" = "#0073C2", "Total number of episodes" = "#EFC000")) +
    scale_x_continuous(breaks = seq(2006, 2018, 2), minor_breaks = years) +
    scale_y_continuous(
        name = "Total number of episodes", breaks = seq(100, 500, 100),
        sec.axis = sec_axis(~ . / axis_conversion,
            name = "Proportion of individuals with episodes", breaks = c(0.25, 0.50, 0.75))
    ) +
    coord_cartesian(ylim = c(75, 535)) +
    labs(x = "Year") +
    paper_theme

figure_1b <- ggplot(episode_distribution, aes(x = Year, y = Episodes, fill = EpisodeGroup)) +
    geom_col(width = 0.7) +
    scale_fill_manual(name = "# episodes", values = group_colours) +
    scale_x_continuous(breaks = years, minor_breaks = seq(2006, 2018, 0.5)) +
    scale_y_continuous(breaks = c(0, 200, 400)) +
    labs(x = "Year", y = "Total number of episodes") +
    paper_theme

figure_1c <- ggplot(episode_distribution, aes(x = Year, y = EpisodeShare, fill = EpisodeGroup)) +
    geom_col(width = 0.7) +
    scale_fill_manual(name = "# episodes", values = group_colours) +
    scale_x_continuous(breaks = years, minor_breaks = seq(2006, 2018, 0.5)) +
    scale_y_continuous(breaks = seq(0, 1, 0.25), labels = function(x) paste0(100 * x, "%")) +
    labs(x = "Year", y = "Episode distribution") +
    paper_theme

figure_1 <- wrap_plots(figure_1a, figure_1b, figure_1c, ncol = 1) +
    plot_annotation(tag_levels = "A", caption = figure_note,
        theme = theme(plot.caption = element_text(size = 10, hjust = 0)))
save_figure(figure_1, "figure_1", 8.2, 14.5)
save_figure(figure_1a + labs(tag = "A", caption = figure_note), "figure_1A", 8.2, 5)

if (interactive()) print(figure_1)
