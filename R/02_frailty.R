
# Experiment 2: Depletion of susceptibles

# 1. Parameters
t <- seq(0, 30, by = 0.1)

p_frail <- 0.5  # Frail individuals at baseline
HR <- 0.5       # Conditional treatment effect

# Control hazards within each subgroup
hF0 <- 0.20
hH0 <- 0.02

# Treatment hazards within each subgroup
hF1 <- HR * hF0
hH1 <- HR * hH0

# 2. Subgroup survival probabilities
SF0 <- exp(-hF0 * t)
SH0 <- exp(-hH0 * t)

SF1 <- exp(-hF1 * t)
SH1 <- exp(-hH1 * t)

# 3. Marginal survival in each treatment arm
S0 <- p_frail * SF0 + (1 - p_frail) * SH0
S1 <- p_frail * SF1 + (1 - p_frail) * SH1

# 4. Proportion of frail individuals among survivors
pF0 <- p_frail * SF0 / S0
pF1 <- p_frail * SF1 / S1

# 5. Marginal hazards: weighted by survivor composition
hm0 <- pF0 * hF0 + (1 - pF0) * hH0
hm1 <- pF1 * hF1 + (1 - pF1) * hH1

# 6. Marginal hazard ratio
HR_marginal <- hm1 / hm0

# 7. Plot survivor composition
plot(t, pF0, type = "l", col = "red", lwd = 2,
     ylim = c(0, 0.5),
     xlab = "Time",
     ylab = "Proportion frail among survivors",
     main = "Depletion of susceptibles")

lines(t, pF1, col = "blue", lwd = 2)

legend("topright",
       legend = c("Control", "Treatment"),
       col = c("red", "blue"), lty = 1, lwd = 2)

# 8. Plot marginal HR
plot(t, HR_marginal, type = "l",
     col = "purple", lwd = 2,
     xlab = "Time",
     ylab = "Hazard ratio",
     main = "Marginal vs conditional HR")

abline(h = HR, col = "black", lty = 2)

legend("topright",
       legend = c("Marginal HR", "Conditional HR"),
       col = c("purple", "black"),
       lty = c(1, 2), lwd = 2)
