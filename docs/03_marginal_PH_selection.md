# Experiment 3: Marginal Proportional Hazards Despite Survivor Selection

## 1. Objective

To demonstrate that **marginal proportional hazards can hold exactly even when treatment and control survivors have different frailty distributions**.

This experiment illustrates that a constant marginal HR does not guarantee comparability between the populations contributing to the hazards.

Unlike Experiment 2, where conditional PH holds but marginal PH fails, we now impose marginal PH directly.

## 2. Experimental setting

Consider a randomized trial with two treatment arms:

- $X=0$: Control
- $X=1$: Treatment

Each arm initially contains 50% frail and 50% healthy individuals.

We assume the following marginal survival functions:

$$
S_0(t)=e^{-0.10t}
$$

$$
S_1(t)=e^{-0.05t}.
$$

The corresponding marginal hazards are:

$$
\lambda_0(t)=0.10,\qquad \lambda_1(t)=0.05.
$$

Therefore,

$$
\boxed{HR_{\text{marginal}}(t)=0.5}
$$

for every \(t\).

Marginal proportional hazards holds exactly by construction.

## 3. Introducing frailty

Let $F$ denote frail individuals and $H$ healthy individuals.

We define their subgroup-specific survival functions as:

$$
S_{F,x}(t)=S_x(t)^2
$$

and

$$
S_{H,x}(t)=2S_x(t)-S_x(t)^2.
$$

These functions are constructed to preserve the specified marginal survival probabilities.

Because baseline frailty prevalence is 50%:

$$
\begin{aligned}
S_x(t)
&=0.5S_{F,x}(t)+0.5S_{H,x}(t)\\
&=0.5S_x(t)^2+0.5[2S_x(t)-S_x(t)^2]\\
&=S_x(t).
\end{aligned}
$$

Hence, the marginal survival functions remain unchanged.

Furthermore, both subgroup survival functions are valid, and frail individuals have lower survival probabilities than healthy individuals at every positive time.

## 4. Frailty distribution among survivors

At baseline:

$$
P(F\mid X=0)=P(F\mid X=1)=0.5.
$$

However, the proportion of frail individuals among survivors is:

$$
P(F\mid T\ge t,X=x) = \frac{P(T\ge t\mid F,X=x)P(F\mid X=x)}
{P(T\ge t\mid X=x)}.
$$

Substituting:

$$
=\frac{0.5S_{F,x}(t)}{S_x(t)}.
$$

Since $\(S_{F,x}(t)=S_x(t)^2\)$:

$$
\boxed{
P(F\mid T\ge t,X=x)=\frac{S_x(t)}{2}
}
$$

Therefore:

$$
P(F\mid T\ge t,X=0)=\frac{e^{-0.10t}}{2}
$$

$$
P(F\mid T\ge t,X=1)=\frac{e^{-0.05t}}{2}.
$$

The proportion of frail survivors decreases more slowly under treatment.

## 5. Numerical results

At \(t=10\):

Control:

$$
P(F\mid T\ge10,X=0)
=\frac{e^{-1}}{2}
\approx0.184.
$$

Treatment:

$$
P(F\mid T\ge10,X=1)
=\frac{e^{-0.5}}{2}
\approx0.303.
$$

| Quantity | Control | Treatment |
|---|---:|---:|
| Frail at baseline | 50.0% | 50.0% |
| Frail among survivors at \(t=10\) | 18.4% | 30.3% |
| Marginal hazard | 0.10 | 0.05 |

Thus, the treatment group retains a larger proportion of frail survivors, even though the marginal HR remains exactly 0.5.

## 6. Why this does not violate PH

Marginal hazards are calculated over the populations still at risk:

$$
\lambda_x(t)=
P(F\mid T\ge t,X=x)\lambda_{F,x}(t)
+
P(H\mid T\ge t,X=x)\lambda_{H,x}(t).
$$

Their values depend on both subgroup-specific hazards and the composition of survivors.

In our construction, these components combine to produce:

$$
\lambda_0(t)=0.10,\qquad \lambda_1(t)=0.05
$$

at every time.

**Marginal proportional hazards constrains the ratio of hazards, not the composition of the surviving populations.**

Importantly, we do not assume that the conditional treatment HR equals 0.5 within both frailty categories.

## 7. Causal interpretation

Randomization ensures that treatment assignment is independent of baseline frailty, in expectation:

$$
X\perp F.
$$

However, survival depends on both treatment and frailty.

Conditioning on survival may therefore induce an association:

$$
X\not\perp F\mid T\ge t.
$$

This is survivor selection, a form of collider stratification.

Consequently, even though the marginal HR is constant, the hazards compare populations with different distributions of frailty.

A constant marginal HR therefore cannot, by itself, be interpreted as a constant individual-level causal effect.

Importantly, randomization still permits causal comparisons of marginal survival probabilities and cumulative risks in the original baseline populations.

## 8. Conclusions

1. Marginal PH can hold exactly despite survivor selection.
2. Randomization ensures baseline comparability, not comparability among survivors.
3. A constant marginal HR does not imply a constant conditional or individual-level treatment effect.
4. The HR alone does not describe the full causal effect of treatment on survival.


## 9. Reproducibility

The R implementation is available in:

`R/03_marginal_PH_selection.R`

The interactive version is available in Tab 3 of the Shiny application:

`app/app.R`
