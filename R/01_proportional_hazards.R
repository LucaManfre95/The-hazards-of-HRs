
# Experiment 1: Proportional hazards

# Parameters
lambda0 <- 0.10 # baselin hazard = tasso istantaneo di Y per X = 0
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
RR <- R1 / R0 # oss: il primo valore è NaN perchè RR non è definito in t = 0

# Plot survival curves
plot(t, S0, type = "l", col = "red",
     ylim = c(0, 1),
     xlab = "Time", ylab = "Survival probability")
lines(t, S1, col = "blue")
legend("topright",
       legend = c("Control", "Treatment"),
       col = c("red", "blue"), lty = 1)



# Hazard ratio over time
HR_t <- h1 / h0

# Plot HR and RR side by side
par(mfrow = c(1, 2))

plot(t, HR_t, type = "l", col = "blue", lwd = 2,
     ylim = c(0, 1),
     xlab = "Time", ylab = "HR",
     main = "Hazard Ratio")

plot(t, RR, type = "l", col = "red", lwd = 2,
     ylim = c(0, 1),
     xlab = "Time", ylab = "RR",
     main = "Cumulative Risk Ratio")

abline(h = 1, lty = 2, col = "gray")

# Restore plotting layout
par(mfrow = c(1, 1))
