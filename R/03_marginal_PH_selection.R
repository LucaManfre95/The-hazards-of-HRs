
# ============================================================
# Experiment 3: Marginal PH despite survivor selection
# ============================================================

# 1. Parameters
t <- seq(0, 30, by = 0.1)

lambda0 <- 0.10
HR <- 0.50
lambda1 <- HR * lambda0

pF <- 0.50  # Baseline proportion frail

# 2. Marginal survival functions
S0 <- exp(-lambda0 * t)
S1 <- exp(-lambda1 * t)

# 3. Subgroup survival functions
# Constructed to preserve marginal PH

SF0 <- S0^2
SH0 <- 2 * S0 - S0^2

SF1 <- S1^2
SH1 <- 2 * S1 - S1^2

# 4. Verify marginal survival
S0_check <- pF * SF0 + (1 - pF) * SH0
S1_check <- pF * SF1 + (1 - pF) * SH1

stopifnot(
  isTRUE(all.equal(S0, S0_check)),
  isTRUE(all.equal(S1, S1_check))
)

# 5. Frailty proportion among survivors
pF0 <- pF * SF0 / S0
pF1 <- pF * SF1 / S1

# 6. Marginal hazards and hazard ratio
h0 <- rep(lambda0, length(t))
h1 <- rep(lambda1, length(t))

HR_marginal <- h1 / h0

# 7. Verify proportional hazards
stopifnot(all(abs(HR_marginal - HR) < 1e-10))

# 8. Plot survivor composition
par(mfrow = c(1, 2))

plot(t, pF0, type = "l", col = "red", lwd = 2,
     ylim = c(0, 0.5),
     xlab = "Time",
     ylab = "Proportion frail",
     main = "Frailty among survivors")

lines(t, pF1, col = "blue", lwd = 2)

legend("topright",
       legend = c("Control", "Treatment"),
       col = c("red", "blue"),
       lty = 1, lwd = 2)

# 9. Plot marginal HR
plot(t, HR_marginal, type = "l",
     col = "purple", lwd = 2,
     ylim = c(0, 1),
     xlab = "Time",
     ylab = "Marginal HR",
     main = "Marginal proportional hazards")

abline(h = 1, lty = 2, col = "gray")

# Restore plotting layout
par(mfrow = c(1, 1))

# 10. Display results at t = 10
i <- which.min(abs(t - 10))

cat("At t = 10:\n")
cat("Frail among controls:", round(pF0[i], 3), "\n")
cat("Frail among treated:", round(pF1[i], 3), "\n")
cat("Marginal HR:", HR_marginal[i], "\n")
