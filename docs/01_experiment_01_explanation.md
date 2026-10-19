
## Experiment 1: Proportional hazards

We assume a time-varying control hazard:

$$
\lambda_0(t)=\lambda_0(0.1+0.9e^{-ct})
$$

and impose proportional hazards:

$$
\lambda_1(t)=HR\cdot\lambda_0(t).
$$

The interactive application allows users to change the baseline hazard, hazard ratio, decay parameter, and follow-up duration.


**Important:** This experiment specifies marginal hazards directly. It does not yet simulate individual frailty or survivor selection.

## Running the application

Install Shiny in R:

```r
install.packages("shiny")
```

Run the app from the project directory:

```r
shiny::runApp("app")
```

## Reference

Hernán MA. The Hazards of Hazard Ratios. *Epidemiology*. 2010;21(1):13–15.

DOI: https://doi.org/10.1097/EDE.0b013e3181c1ea43
