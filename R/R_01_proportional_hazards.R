
# Experiment 1: Proportional hazards

# Parameters
lambda0 <- 0.10
HR <- 0.50
lambda1 <- HR * lambda0

# Follow-up
t <- seq(0, 30, by = 0.1)

# Hazards
h0 <- rep(lambda0, length(t))
h1 <- rep(lambda1, length(t))

# Survival probabilities
S0 <- exp(-lambda0 * t)
S1 <- exp(-lambda1 * t)

# Cumulative risks
R0 <- 1 - S0
R1 <- 1 - S1

# Risk ratio (undefined at t = 0)
RR <- R1 / R0

# Plot survival curves
plot(t, S0, type = "l", col = "red",
     ylim = c(0, 1),
     xlab = "Time", ylab = "Survival probability")
lines(t, S1, col = "blue")
legend("topright",
       legend = c("Control", "Treatment"),
       col = c("red", "blue"), lty = 1)
