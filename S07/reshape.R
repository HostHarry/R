morley

morley_wide <- reshape(
    morley,
    idvar = c("Expt"),
    timevar = "Run",
    v.names = "Speed",
    direction = "wide",
    sep = "_"
)
morley_wide

morley_long <- reshape(
    morley_wide,
    idvar = c("Expt"),
    direction = "long"
)
morley_long

# tidyr ----
install.packages("tidyr")
morley_wide <- tidyr::spread(
    morley,
    key = Run,
    value = Speed
)
morley_wide <- tidyr::pivot_wider(
    morley,
    names_from = Run,
    values_from = Speed
)
morley_wide


morley_long <- tidyr::gather(
    morley_wide,
    key = Run,
    value = Speed,
    names(morley_wide)[-1]
)
morley_long <- tidyr::pivot_longer(
    morley_wide,
    names_to = "Run",
    values_to = "Speed",
    -Expt
)
morley_long

