# Experiment 2: Depletion of Susceptibles

## 1. Objective

To demonstrate how survivor selection can produce a time-varying marginal hazard ratio, even when the conditional hazard ratio is constant.

This experiment illustrates a central argument in Hernán (2010): hazard ratios compare individuals who remain at risk, and the composition of these populations can change over time.

## 2. Experimental setting

Consider a randomized trial comparing treatment \(X=1\) with control \(X=0\).

Individuals belong to two subpopulations:

- **Frail (F):** Higher mortality hazard.
- **Healthy (H):** Lower mortality hazard.

At baseline, both treatment arms contain 50% frail and 50% healthy individuals.

We assume that treatment reduces the mortality hazard by 50% within each subpopulation.

| Subpopulation | Control hazard | Treatment hazard |
|---|---|---|
| Frail | 0.20 | 0.10 |
| Healthy | 0.02 | 0.01 |

All four hazards are constant over time.

## 3. Conditional proportional hazards

Within each frailty category, the hazard ratio is:

$$
HR_F(t)=\frac{0.10}{0.20}=0.5
$$

$$
HR_H(t)=\frac{0.01}{0.02}=0.5
$$

Therefore, conditional proportional hazards holds exactly:

$$
HR(t\mid F)=HR(t\mid H)=0.5.
$$

The treatment effect on the hazard is identical in both subpopulations and constant over time.

## 4. Survival probabilities

Because the subgroup hazards are constant, their survival functions follow exponential distributions:

$$
S(t)=e^{-\lambda t}.
$$

For the control arm:

$$
S_{F,0}(t)=e^{-0.20t}
$$

$$
S_{H,0}(t)=e^{-0.02t}.
$$

For the treatment arm:

$$
S_{F,1}(t)=e^{-0.10t}
$$

$$
S_{H,1}(t)=e^{-0.01t}.
$$

The marginal survival function is the weighted average of the subgroup survival functions:

$$
S_x(t)=0.5S_{F,x}(t)+0.5S_{H,x}(t).
$$

## 5. Depletion of susceptibles

Frailty increases mortality risk. Therefore, frail individuals tend to experience the event earlier than healthy individuals.

Treatment improves survival among both types, so frail individuals are depleted more slowly in the treated arm.

The proportion of frail individuals among survivors is obtained through Bayes' theorem:

$$
P(F\mid T\ge t,X=x)
=
\frac{0.5S_{F,x}(t)}{S_x(t)}.
$$

At baseline, this proportion equals 0.5 in both arms.

As time passes, it decreases faster in the control arm.

For example, at \(t=10\), approximately:

- 14.2% of control survivors are frail.
- 28.9% of treated survivors are frail.

Thus, although randomization ensures baseline comparability, the populations surviving at later times may have different frailty distributions.

## 6. Marginal hazards

The marginal hazard is the average of subgroup-specific hazards weighted by their proportions among survivors.

For control:

$$
\lambda_0(t)
=
p_{F,0}(t)(0.20)
+
[1-p_{F,0}(t)](0.02).
$$

For treatment:

$$
\lambda_1(t)
=
p_{F,1}(t)(0.10)
+
[1-p_{F,1}(t)](0.01).
$$

Here,

$$
p_{F,x}(t)=P(F\mid T\ge t,X=x).
$$

Since the weights evolve differently between treatment arms, the marginal hazards need not remain proportional.

Consequently,

$$
HR_{\text{marginal}}(t)
=
\frac{\lambda_1(t)}{\lambda_0(t)}
$$

can change over time, despite the constant conditional HR of 0.5.

In our example:

$$
HR_{\text{marginal}}(0)=0.5
$$

but

$$
HR_{\text{marginal}}(10)\approx0.79.
$$

## 7. Causal interpretation

Randomization ensures that treatment assignment is independent of baseline frailty, in expectation.

However, survival depends on both treatment and frailty.

Conditioning on survival can therefore introduce an association between treatment and frailty:

$$
X\perp F
$$

at baseline, but generally,

$$
X\not\perp F\mid T\ge t.
$$

This is a form of **collider stratification bias**, also called survivor selection.

The marginal hazard ratio compares two populations that may differ in their distribution of prognostic characteristics.

Therefore, a change in the marginal HR does not necessarily indicate a change in the individual-level treatment effect.

## 8. Main conclusions

1. Conditional proportional hazards can hold while marginal proportional hazards fails.
2. Randomization guarantees baseline comparability, not comparability among survivors.
3. Depletion of susceptibles changes the composition of the risk sets.
4. Marginal hazard ratios reflect both subgroup-specific hazards and the evolving composition of survivors.
5. Cumulative survival and risk curves offer complementary information about treatment effects in the original randomized populations.

**Important limitation:** This experiment assumes a common conditional treatment HR of 0.5. It does not demonstrate a time-varying individual-level treatment effect. Nor does it demonstrate survivor selection under exactly constant *marginal* proportional hazards. That requires a different construction.

## 9. Reproducibility

The R implementation is available in:

`R/02_frailty.R`

The experiment uses analytical survival functions rather than randomly generated individual-level observations.

## Reference

Hernán MA. The Hazards of Hazard Ratios. *Epidemiology*. 2010;21(1):13–15.

https://doi.org/10.1097/EDE.0b013e3181c1ea43
