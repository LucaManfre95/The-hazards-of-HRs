# The-hazards-of-HRs

An interactive educational project in R, inspired by Hernán (2010), *The Hazards of Hazard Ratios*.

## Objective

To investigate the interpretation of hazard ratios $(HRs)$ in survival analysis for causal inference.

The project uses mathematical examples, simulations, and interactive visualizations to explore:

- HRs versus cumulative risk ratios $(RR)$.
- Proportional hazards $(\lambda)$ and time-varying baseline hazards.
- Depletion of susceptibles and survivor selection.
- Marginal versus conditional HRs.

## Experiments

### Experiment 1: Proportional hazards

**Question:** Can the HR remain constant while the cumulative RR changes over time?

We impose marginal proportional hazards and investigate the relationship between hazards, survival probabilities, and cumulative risks.

- [R script](R/R_01_proportional_hazards.R)
- Interactive visualization: Tab 1 of the Shiny app

### Experiment 2: Depletion of susceptibles

**Question:** Can conditional proportional hazards hold while the marginal HR changes over time?

We introduce baseline frailty and demonstrate how survivor selection changes the composition of treatment groups.

- [R script](R/02_frailty.R)
- [Mathematical explanation](docs/02_depletion_of_susceptibles.md)
- Interactive visualization: Tab 2 of the Shiny app

### Experiment 3: Marginal proportional hazards despite survivor selection

**Question:** Can marginal proportional hazards hold while the composition of survivors differs between treatment groups?

We impose marginal proportional hazards and demonstrate that survivor selection can occur even when the marginal HR remains constant over time.

- [R script](R/03_marginal_PH_selection.R)
- [Mathematical explanation](docs/03_marginal_PH_selection.md)
- Interactive visualization: Tab 3 of the Shiny app

## Interactive application

Both experiments are available in our Shiny application.

To run locally:

```r
shiny::runApp("app")
```

Source code: [app/app.R](app/app.R)

## Reference

Hernán MA. The Hazards of Hazard Ratios. *Epidemiology*. 2010;21(1):13–15.

DOI: https://doi.org/10.1097/EDE.0b013e3181c1ea43
