
# Experiment 1: Proportional Hazards and Cumulative Risk

## 1. Objective

To investigate the relationship between hazard ratios (HR),
survival probabilities, and cumulative risk ratios (RR)
under the proportional hazards assumption.

In particular, we demonstrate that a constant HR does not
imply a constant cumulative RR.

This experiment is inspired by Hernán (2010),
*The Hazards of Hazard Ratios*.

## 2. Experimental setting

Consider a randomized trial with two treatment arms:

- X = 0: Control
- X = 1: Treatment

Let T denote the time until the event, such as all-cause death.

We directly specify the marginal hazard functions for
the two populations.

### 2.1 Control hazard

We assume:

```math
\lambda_0(t)=a(0.1+0.9e^{-ct})
```

where:

- a > 0: Initial control hazard.
- c >= 0: Rate at which the hazard decreases.
- t: Follow-up time.

At baseline:

```math
\lambda_0(0)=a.
```

For c > 0, the hazard decreases toward:

```math
\lim_{t\to\infty}\lambda_0(t)=0.1a.
```

When c = 0, the hazard remains constant at a.

This model was selected for its mathematical simplicity.
It is not derived from a biological mortality process.

### 2.2 Treatment hazard

We impose proportional hazards:

```math
\lambda_1(t)=\theta\lambda_0(t)
```

where theta is the hazard ratio.

Consequently:

```math
HR(t)=\frac{\lambda_1(t)}{\lambda_0(t)}
=\theta.
```

The HR remains constant for every t, regardless of how
the baseline hazard evolves.

Thus, if the control hazard decreases, the treatment
hazard decreases proportionally.

## 3. From hazards to survival probabilities

Recall the relationship between the hazard and
survival functions:

```math
\lambda_x(t)=-\frac{d}{dt}\log S_x(t).
```

Therefore:

```math
S_x(t)=\exp[-H_x(t)]
```

where H is the cumulative hazard:

```math
H_x(t)=\int_0^t\lambda_x(u)\,du.
```

### 3.1 Control survival

Integrating the control hazard gives:

```math
H_0(t)=a\left[
0.1t+0.9\frac{1-e^{-ct}}{c}
\right].
```

This expression applies when c > 0.

For c = 0, the cumulative hazard becomes:

```math
H_0(t)=at.
```

Hence:

```math
S_0(t)=e^{-H_0(t)}.
```

### 3.2 Treatment survival

Under proportional hazards:

```math
H_1(t)=\theta H_0(t).
```

Therefore:

```math
S_1(t)=e^{-\theta H_0(t)}
=S_0(t)^\theta.
```

This relationship holds for any baseline hazard
under the proportional hazards assumption.

## 4. Cumulative risks and risk ratios

The cumulative risk of experiencing the event
by time t is:

```math
R_x(t)=P(T\leq t\mid X=x)=1-S_x(t).
```

Therefore:

```math
R_0(t)=1-e^{-H_0(t)}
```

and

```math
R_1(t)=1-e^{-\theta H_0(t)}.
```

The cumulative risk ratio is:

```math
RR(t)=
\frac{1-e^{-\theta H_0(t)}}
{1-e^{-H_0(t)}}.
```

Unlike the HR, the cumulative RR generally depends
on time.

This follows because the two measures represent
different quantities:

- HR compares instantaneous event rates among
  individuals who remain at risk at time t.
- RR compares the cumulative probability of experiencing
  the event by time t in the original treatment groups.

## 5. Why HR and RR differ

Consider the special case c = 0.

The hazards are constant:

```math
\lambda_0(t)=a,
\qquad
\lambda_1(t)=\theta a.
```

The HR is:

```math
HR(t)=\theta.
```

The cumulative RR becomes:

```math
RR(t)=
\frac{1-e^{-\theta at}}
{1-e^{-at}}.
```

For example, take:

- a = 0.10
- theta = 0.50

At t = 10:

```math
RR(10)=
\frac{1-e^{-0.5}}
{1-e^{-1}}
\approx 0.622.
```

Thus:

| Measure | Value at t = 10 |
|---|---:|
| HR | 0.500 |
| Control cumulative risk | 0.632 |
| Treatment cumulative risk | 0.393 |
| RR | 0.622 |

Although treatment halves the instantaneous hazard,
it does not halve the cumulative event risk at t = 10.

Importantly, this difference does not require frailty
or survivor-selection bias.

It arises from the mathematical distinction between
instantaneous rates and cumulative probabilities.

## 6. When do HR and RR converge?

For small cumulative hazards:

```math
1-e^{-H}\approx H.
```

Therefore:

```math
RR(t)\approx
\frac{\theta H_0(t)}{H_0(t)}
=\theta.
```

Hence, when the event is rare over the follow-up period:

```math
RR(t)\approx HR.
```

In the constant-hazard example, this occurs when at
is small.

As follow-up increases, the cumulative risks increase.

Because our specified control hazard remains positive
in the long term, both cumulative hazards diverge
as t approaches infinity.

For theta > 0:

```math
\lim_{t\to\infty}R_0(t)=
\lim_{t\to\infty}R_1(t)=1.
```

Consequently:

```math
\lim_{t\to\infty}RR(t)=1.
```

However:

```math
HR(t)=\theta
```

at every finite time.

Thus, the cumulative RR approaches 1 even though
the HR remains constant.

This illustrates why the follow-up time is crucial
when interpreting cumulative risk ratios.

## 7. Interactive experiment

The Shiny application allows users to modify:

1. Initial control hazard (a).
2. Hazard ratio (theta).
3. Hazard decay rate (c).
4. Follow-up duration.

The application displays:

- Marginal hazards for treatment and control.
- Hazard ratio and cumulative risk ratio.
- Survival probabilities.
- A numerical interpretation at the selected
  follow-up time.

### Suggested explorations

**Experiment A: Constant hazards**

Set c = 0 and theta = 0.5.

Observe that both hazards and the HR remain constant,
while the cumulative RR changes over time.

**Experiment B: Decreasing hazards**

Increase c while keeping theta fixed.

Both hazards decrease over time, but their ratio
remains constant.

**Experiment C: Rare events**

Reduce a or shorten follow-up.

Observe how the cumulative RR approaches the HR
when cumulative event probabilities are small.

**Experiment D: Long follow-up**

Increase the follow-up duration.

Observe how the cumulative RR approaches 1
while the HR remains unchanged.

## 8. Causal interpretation

In a randomized trial, treatment assignment is
independent of baseline characteristics in expectation.

However, the hazard at time t is defined among
individuals who have survived up to t.

The populations contributing to the treatment
and control hazards may therefore differ in
their prognostic characteristics.

Proportional hazards does not guarantee that
these survivor populations remain comparable.

A constant marginal HR should not automatically
be interpreted as a constant individual-level
causal effect.

By contrast, cumulative risk comparisons in a
randomized trial can describe causal effects
in the original baseline populations, under
the usual assumptions.

## 9. Limitations

This experiment directly specifies marginal hazards.

It does not generate individual-level observations
or explicitly model frailty.

Therefore, it does not demonstrate how depletion
of susceptible individuals produces changes
in the composition of survivors.

These mechanisms are investigated in:

- Experiment 2: Depletion of susceptibles.
- Experiment 3: Marginal PH despite survivor selection.

Additionally, the decreasing hazard function is
chosen for illustration and is not intended to
represent a realistic all-cause mortality process.

## 10. Reproducibility

The original constant-hazard analysis is available in:

`R/R_01_proportional_hazards.R`

The interactive time-varying hazard model is available in:

`app/app.R`

The application is implemented in R using Shiny.

