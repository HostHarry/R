library(ggplot2)

data_file <- "spatioTemporalEpisodeHistories.csv"
output_dir <- "outputs"
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

episodes <- read.csv(data_file)


annual <- aggregate(Episodes ~ Year, data = episodes, FUN = sum)
names(annual)[names(annual) == "Episodes"] <- "TotalEpisodes"

annual_proportion <- aggregate(Episodes ~ Year, data = episodes, FUN = function(x) mean(x > 0))
names(annual_proportion)[names(annual_proportion) == "Episodes"] <- "ProportionWithEpisode"

annual <- merge(annual, annual_proportion, by = "Year", sort = TRUE)

axis_conversion <- 600

figure_1A <- (
  ggplot(annual, aes(x = Year))
  + geom_line(aes(y = TotalEpisodes, colour = "Total number of episodes"), linewidth = 0.9)
  + geom_line(aes(y = ProportionWithEpisode * axis_conversion, colour = "Proportion with episode"), linewidth = 1.3)
  + scale_colour_manual(name = NULL, values = c("Proportion with episode" = "#0073C2", "Total number of episodes" = "#EFC000"), breaks = c("Proportion with episode", "Total number of episodes"))
  + scale_x_continuous(breaks = seq(2006, 2018, by = 2), minor_breaks = 2006:2018)
  + scale_y_continuous(name = "Total number of episodes", breaks = seq(100, 500, by = 100), sec.axis = sec_axis(~ . / axis_conversion, name = "Proportion of individuals with episodes", breaks = c(0.25, 0.50, 0.75)))
  + coord_cartesian(ylim = c(75, 535))
  + labs(x = "Year", tag = "A")
  + theme_gray(base_size = 13)
  + theme(legend.position = "top", legend.text = element_text(size = 12), axis.title = element_text(colour = "black"), plot.tag = element_text(size = 18), plot.margin = margin(10, 10, 10, 10))
)

ggsave(file.path(output_dir, "figure_1A_reproduced.png"), figure_1A, width = 8.2, height = 5, dpi = 180, bg = "white")

