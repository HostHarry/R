# definition of differential equations ----

Lorenz <- function(t, state, parms) {
    dx <- parms["a"] * (state["y"] - state["x"])
    dy <- state["x"] * (parms["b"] - state["z"]) - state["y"]
    dz <- state["x"] * state["y"] - parms["c"] * state["z"]
    return(list(c(dx, dy, dz)))
}

# initial state ----

init_state_1 <- c(x = 1, y = 1, z = 1)
init_state_2 <- c(x = 1.01, y = 1, z = 1)

# parameters ----

parameters <- c(a = 10, b = 28, c = 8 / 3)

# time ----

tps <- seq(0, 20, by = 0.01)

# solve ODE ----

out_1 <- deSolve::ode(y = init_state_1, times = tps, func = Lorenz, parms = parameters)
out_2 <- deSolve::ode(y = init_state_2, times = tps, func = Lorenz, parms = parameters)

attributes(out_1)
typeof(out_1)
head(out_1)
