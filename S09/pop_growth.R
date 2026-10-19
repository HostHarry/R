rm(list = ls())

# Population Growth Models ----

P0 <- 10       # initial state P0
T_LAST <- 100  # time length
T_INTR <- 0.01 # time interval
EXP_R <- 0.1   # growth proportionality constant

q <- 10

# Exponential growth ----

# 1 - Differential equation
ExpGrowth <- function(t, state, parms) {
    dp <- parms["r"] * state["p"]
    return(list(c(dp)))
}
## Using the `with` construct:
# ExpGrowth <- function(t, state, parms) {
#   with(as.list(c(state, parms)), {
#     dp <- r * p
#     return(list(c(dp)))
#   })
# }

# 2 - Initial state
init_state <- c(p = P0)

# 3 - Parameters
parameters <- c(r = EXP_R)

# 4 - Time
tps <- seq(0, T_LAST, by = T_INTR)

# 5 - Ode (model integration)
out_exp <- deSolve::ode(y = init_state, times = tps, func = ExpGrowth, parms = parameters)

plot(out_exp, xlab = "Time (t)", ylab = "Population (P)", main = "Exponential growth")

# t-controlled intervention

ExpGrowthIntv <- function(t, state, parms) {
    if (t > 80 && t < 90) {
        dp <- 0
    } else {
        dp <- parms["r"] * state["p"]
    }
    return(list(c(dp)))
}
out_exp_intv <- deSolve::ode(y = init_state, times = tps, func = ExpGrowthIntv, parms = parameters)
lines(out_exp_intv, col = "blue", lwd = 2)


# Using with

ExpGrowthIntvWith <- function(t, state, parms) {
    with(as.list(c(state, parms)), {
        if (t > 80 && t < 90) {
            dp <- -1000
        } else {
            dp <- r * p
        }
        return(list(c(dp)))
    })
}
out_exp_intv <- deSolve::ode(y = init_state, times = tps, func = ExpGrowthIntvWith, parms = parameters)
lines(out_exp_intv, col = "red", lwd = 2)


ExpGrowthIntvWithError <- function(t, state, parms) {
    with(as.list(c(state, parms)), {
        if (t > 80 && t < 90) {
            dp <- -1000
        } else {
            dp <- r * q
        }
        return(list(c(dp)))
    })
}
out_exp_intv <- deSolve::ode(y = init_state, times = tps, func = ExpGrowthIntvWithError, parms = parameters)
lines(out_exp_intv, col = "pink", lwd = 2)
