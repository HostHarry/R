# Base R ----

png(filename = file.path("S08", "fig", "fig_base.png"))
boxplot(count ~ spray, InsectSprays)
dev.off()


# ggplot ----
library("ggplot2")

xval <- seq(1, 10, 0.01)
df <- data.frame(
    "xval" = xval,
    "sin" = sin(xval),
    "cos" = cos(xval)
)
ggplot(df) +
    geom_line(aes(x = xval, y = sin)) +
    geom_line(aes(x = xval, y = cos))
ggsave(filename = file.path("S08", "fig", "fig_ggplot.png"))
