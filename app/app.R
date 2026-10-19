library(shiny)

# User interface
ui <- fluidPage(
  titlePanel("The Hazards of Hazard Ratios"),
  
  p("Experiment 1: Proportional hazards"),
  p("Explore how a constant HR can coexist
    with a changing cumulative risk ratio."),
  
  sidebarLayout(
    sidebarPanel(
      # Controls how quickly the baseline hazard decreases
      sliderInput("decay", "Hazard decay rate:",
                  min = 0, max = 0.5,
                  value = 0.2, step = 0.01),
      
      sliderInput("lambda0", "Baseline hazard:",
                  min = 0.01, max = 0.30,
                  value = 0.10, step = 0.01),
      
      sliderInput("hr", "Hazard ratio:",
                  min = 0.10, max = 1,
                  value = 0.50, step = 0.05),
      
      sliderInput("followup", "Follow-up time:",
                  min = 1, max = 100,
                  value = 30)
    ),
    
    mainPanel(
      plotOutput("hazardPlot"),
      plotOutput("ratioPlot"),
      plotOutput("survivalPlot"),
      
      h4("Interpretation"),
      textOutput("interpretation")
    )
  )
)

# Server calculations

server <- function(input, output, session) {
  
  # ============================================================
  # 1. SHARED MODEL
  # ============================================================
  
  # Calculate all quantities from the same hazard model.
  # Shiny updates these calculations whenever a slider changes.
  
  model <- reactive({
    
    # Follow-up time sequence
    t <- seq(0, input$followup, length.out = 500)
    
    # Retrieve user-selected parameters
    lambda0 <- input$lambda0
    HR <- input$hr
    c <- input$decay
    
    # Control hazard: decreases over time when c > 0
    h0 <- lambda0 * (0.1 + 0.9 * exp(-c * t))
    
    # Treatment hazard: proportional to control hazard
    h1 <- HR * h0
    
    # Control cumulative hazard
    # H0(t) = integral of h0(u) from 0 to t
    if (c == 0) {
      H0 <- lambda0 * t
    } else {
      H0 <- lambda0 * (
        0.1 * t + 0.9 * (-expm1(-c * t)) / c
      )
    }
    
    # Treatment cumulative hazard
    H1 <- HR * H0
    
    # Survival probabilities: S(t) = exp(-H(t))
    S0 <- exp(-H0)
    S1 <- exp(-H1)
    
    # Cumulative event risks: R(t) = 1 - S(t)
    R0 <- -expm1(-H0)
    R1 <- -expm1(-H1)
    
    # Cumulative risk ratio
    # Undefined at t = 0, where both risks equal zero
    RR <- ifelse(R0 == 0, NA_real_, R1 / R0)
    
    # Return calculated quantities
    list(
      t = t,
      h0 = h0,
      h1 = h1,
      S0 = S0,
      S1 = S1,
      R0 = R0,
      R1 = R1,
      HR = rep(HR, length(t)),
      RR = RR
    )
  })
  
  
  # ============================================================
  # 2. HAZARD PLOT
  # ============================================================
  
  output$hazardPlot <- renderPlot({
    
    # Retrieve model results
    m <- model()
    
    # Plot control hazard
    plot(m$t, m$h0,
         type = "l",
         col = "red",
         lwd = 2,
         ylim = c(0, max(m$h0, m$h1) * 1.2),
         xlab = "Time",
         ylab = "Hazard",
         main = "Marginal hazards")
    
    # Add treatment hazard
    lines(m$t, m$h1, col = "blue", lwd = 2)
    
    legend("topright",
           legend = c("Control", "Treatment"),
           col = c("red", "blue"),
           lty = 1, lwd = 2)
  })
  
  
  # ============================================================
  # 3. HAZARD RATIO VS CUMULATIVE RISK RATIO
  # ============================================================
  
  output$ratioPlot <- renderPlot({
    
    m <- model()
    
    # Set the y-axis range to display both ratios
    upper <- max(c(1, m$HR, m$RR), na.rm = TRUE) * 1.1
    
    # Plot hazard ratio
    plot(m$t, m$HR,
         type = "l",
         col = "blue",
         lwd = 2,
         ylim = c(0, upper),
         xlab = "Time",
         ylab = "Ratio",
         main = "HR versus cumulative RR")
    
    # Add cumulative risk ratio
    lines(m$t, m$RR, col = "red", lwd = 2)
    
    # Reference line at ratio = 1
    abline(h = 1, lty = 2, col = "gray")
    
    legend("topright",
           legend = c("HR", "RR"),
           col = c("blue", "red"),
           lty = 1, lwd = 2)
  })
  
  
  # ============================================================
  # 4. SURVIVAL CURVES
  # ============================================================
  
  output$survivalPlot <- renderPlot({
    
    m <- model()
    
    # Plot control survival
    plot(m$t, m$S0,
         type = "l",
         col = "red",
         lwd = 2,
         ylim = c(0, 1),
         xlab = "Time",
         ylab = "Survival probability",
         main = "Survival curves")
    
    # Add treatment survival
    lines(m$t, m$S1, col = "blue", lwd = 2)
    
    legend("topright",
           legend = c("Control", "Treatment"),
           col = c("red", "blue"),
           lty = 1, lwd = 2)
  })
  
  
  # ============================================================
  # 5. DYNAMIC INTERPRETATION
  # ============================================================
  
  output$interpretation <- renderText({
    
    m <- model()
    
    # Extract values at the end of follow-up
    n <- length(m$t)
    
    HR <- m$HR[n]
    RR <- m$RR[n]
    
    risk0 <- m$R0[n]
    risk1 <- m$R1[n]
    
    # Construct explanatory text
    paste0(
      "At time ", input$followup,
      ", the hazard ratio is ", round(HR, 2),
      ", while the cumulative risk ratio is ",
      round(RR, 3), ". ",
      
      "The cumulative event risk is ",
      round(100 * risk0, 1),
      "% in controls and ",
      round(100 * risk1, 1),
      "% in treated individuals. ",
      
      "The hazards may change over time, ",
      "but their ratio remains constant."
    )
  })
  
}


shinyApp(ui, server)
