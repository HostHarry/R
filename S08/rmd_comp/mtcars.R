# demo.R -- a plain R script
# Everything here is R code.
# Human words only live in comments (#).

mtcars

# Summarise fuel economy by number of cylinders
avg_mpg <- aggregate(mpg ~ cyl, data = mtcars, FUN = mean)
avg_mpg

# Plot it
barplot(
  avg_mpg$mpg,
  names.arg = avg_mpg$cyl,
  xlab = "Cylinders",
  ylab = "Mean MPG",
  main = "Fuel economy by cylinder count"
)
