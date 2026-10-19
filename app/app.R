
library(shiny)

# ============================================================
# USER INTERFACE
# ============================================================

ui <- navbarPage(
  "The Hazards of Hazard Ratios",
  
  # ----------------------------------------------------------
  # EXPERIMENT 1: PROPORTIONAL HAZARDS
  # ----------------------------------------------------------
  
  tabPanel(
    "1. Proportional hazards",
    
    h3("Constant HR does not imply constant RR"),
    
    p("We impose proportional hazards between treatment
      and control. The hazards may decrease over time,
      but their ratio remains constant."),
    
    withMathJax(
      "$$\\lambda_1(t) = HR \\cdot \\lambda_0(t)$$"
    ),
    
    sidebarLayout(
      sidebarPanel(
        sliderInput("lambda0", "Initial control hazard:",
                    min = 0.01, max = 0.30,
                    value = 0.10, step = 0.01),
        
        sliderInput("hr", "Hazard ratio:",
                    min = 0.10, max = 1,
                    value = 0.50, step = 0.05),
        
        sliderInput("decay", "Hazard decay rate:",
                    min = 0, max = 0.5,
                    value = 0.2, step = 0.01),
        
        sliderInput("followup", "Follow-up:",
                    min = 1, max = 100, value = 30)
      ),
      
      mainPanel(
        h4("Marginal hazards"),
        plotOutput("hazardPlot"),
        
        h4("Hazard ratio versus cumulative risk ratio"),
        plotOutput("ratioPlot"),
        
        h4("Survival probabilities"),
        plotOutput("survivalPlot"),
        
        h4("Interpretation"),
        textOutput("interpretation")
      )
    )
  ),
  
  # ----------------------------------------------------------
  # EXPERIMENT 2: FRAILTY
  # ----------------------------------------------------------
  
  tabPanel(
    "2. Depletion of susceptibles",
    
    h3("How survival changes population composition"),
    
    p("Imagine a randomized trial with two types of
      individuals: frail and healthy. Frail individuals
      have a higher mortality hazard."),
    
    p("We assume that treatment multiplies the hazard
      by the same factor within both subpopulations."),
    
    withMathJax(
      "$$\\lambda_{F,1}=HR\\lambda_{F,0},
      \\qquad
      \\lambda_{H,1}=HR\\lambda_{H,0}$$"
    ),
    
    sidebarLayout(
      sidebarPanel(
        sliderInput("pF", "Proportion frail at baseline:",
                    min = 0.05, max = 0.95,
                    value = 0.50, step = 0.05),
        
        sliderInput("hF", "Frail control hazard:",
                    min = 0.05, max = 0.50,
                    value = 0.20, step = 0.01),
        
        sliderInput("hH", "Healthy control hazard:",
                    min = 0.005, max = 0.05,
                    value = 0.02, step = 0.005),
        
        sliderInput("hrF", "Conditional treatment HR:",
                    min = 0.10, max = 1,
                    value = 0.50, step = 0.05),
        
        sliderInput("timeF", "Follow-up:",
                    min = 1, max = 50, value = 30)
      ),
      
      mainPanel(
        h4("1. Composition of surviving populations"),
        
        p("The curves show the proportion of frail
          individuals among those still alive in
          each treatment arm."),
        
        plotOutput("frailtyPlot"),
        
        h4("2. Marginal versus conditional HR"),
        
        p("Although the conditional HR is fixed,
          the marginal HR can change because the
          frailty composition of survivors changes."),
        
        plotOutput("frailtyHRPlot"),
        
        h4("Interpretation"),
        textOutput("frailtyInterpretation")
      )
    )
  ),
  
  # ============================================================
  # EXPERIMENT 3: MARGINAL PH AND SURVIVOR SELECTION
  # ============================================================
  
  tabPanel(
    "3. Marginal PH and selection",
    
    h3("Can marginal PH hold despite survivor selection?"),
    
    p("We construct a randomized trial in which the
    marginal hazard ratio is exactly constant,
    but the composition of survivors changes."),
    
    withMathJax(
      "$$S_0(t)=e^{-\\lambda_0t},
       \\qquad
       S_1(t)=e^{-HR\\lambda_0t}$$"
    ),
    
    p("Each arm initially contains 50% frail and
    50% healthy individuals."),
    
    p("We construct subgroup survival functions so
    their average equals the marginal survival
    function in each arm."),
    
    withMathJax(
      "$$S_{F,x}(t)=S_x(t)^2,
       \\qquad
       S_{H,x}(t)=2S_x(t)-S_x(t)^2$$"
    ),
    
    sidebarLayout(
      sidebarPanel(
        
        sliderInput("lambda3", "Control hazard:",
                    min = 0.01, max = 0.30,
                    value = 0.10, step = 0.01),
        
        sliderInput("hr3", "Marginal HR:",
                    min = 0.10, max = 1,
                    value = 0.50, step = 0.05),
        
        sliderInput("time3", "Follow-up:",
                    min = 1, max = 50, value = 30)
      ),
      
      mainPanel(
        
        h4("1. Frailty among survivors"),
        
        p("Both groups start with identical frailty
        distributions. Treatment changes who survives
        to later times."),
        
        plotOutput("composition3"),
        
        h4("2. Marginal hazard ratio"),
        
        p("Despite the changing survivor composition,
        the marginal HR remains constant."),
        
        plotOutput("hrPlot3"),
        
        h4("3. Interpretation"),
        
        textOutput("interpretation3")
      )
    )
  )
  
)


# ============================================================
# SERVER
# ============================================================

server <- function(input, output, session) {
  
  # ----------------------------------------------------------
  # EXPERIMENT 1: SHARED MATHEMATICAL MODEL
  # ----------------------------------------------------------
  
  model <- reactive({
    
    t <- seq(0, input$followup, length.out = 500)
    
    lambda0 <- input$lambda0
    HR <- input$hr
    c <- input$decay
    
    # Time-varying control hazard
    h0 <- lambda0 * (0.1 + 0.9 * exp(-c * t))
    
    # Marginal proportional hazards
    h1 <- HR * h0
    
    # Control cumulative hazard
    if (c == 0) {
      H0 <- lambda0 * t
    } else {
      H0 <- lambda0 * (
        0.1 * t + 0.9 * (-expm1(-c * t)) / c
      )
    }
    
    H1 <- HR * H0
    
    # Survival probabilities
    S0 <- exp(-H0)
    S1 <- exp(-H1)
    
    # Cumulative event risks
    R0 <- -expm1(-H0)
    R1 <- -expm1(-H1)
    
    # Cumulative risk ratio
    RR <- ifelse(R0 == 0, NA_real_, R1 / R0)
    
    list(t = t, h0 = h0, h1 = h1,
         S0 = S0, S1 = S1,
         R0 = R0, R1 = R1,
         HR = rep(HR, length(t)), RR = RR)
  })
  
  # Marginal hazards
  output$hazardPlot <- renderPlot({
    m <- model()
    
    plot(m$t, m$h0, type = "l", col = "red",
         lwd = 2, ylim = c(0, max(m$h0) * 1.2),
         xlab = "Time", ylab = "Hazard")
    
    lines(m$t, m$h1, col = "blue", lwd = 2)
    
    legend("topright", c("Control", "Treatment"),
           col = c("red", "blue"), lty = 1, lwd = 2)
  })
  
  # HR versus RR
  output$ratioPlot <- renderPlot({
    m <- model()
    
    plot(m$t, m$HR, type = "l", col = "blue",
         lwd = 2, ylim = c(0, 1.1),
         xlab = "Time", ylab = "Ratio")
    
    lines(m$t, m$RR, col = "red", lwd = 2)
    
    abline(h = 1, lty = 2, col = "gray")
    
    legend("bottomright", c("HR", "RR"),
           col = c("blue", "red"), lty = 1, lwd = 2)
  })
  
  # Survival curves
  output$survivalPlot <- renderPlot({
    m <- model()
    
    plot(m$t, m$S0, type = "l", col = "red",
         lwd = 2, ylim = c(0, 1),
         xlab = "Time", ylab = "Survival probability")
    
    lines(m$t, m$S1, col = "blue", lwd = 2)
    
    legend("topright", c("Control", "Treatment"),
           col = c("red", "blue"), lty = 1, lwd = 2)
  })
  
  # Experiment 1 interpretation
  output$interpretation <- renderText({
    m <- model()
    n <- length(m$t)
    
    paste0(
      "At t = ", input$followup,
      ", HR = ", round(m$HR[n], 3),
      " and RR = ", round(m$RR[n], 3),
      ". Control risk = ", round(100 * m$R0[n], 1),
      "%; treatment risk = ",
      round(100 * m$R1[n], 1),
      "%. The marginal HR remains constant even ",
      "when both hazards change over time."
    )
  })
  
  
  # ----------------------------------------------------------
  # EXPERIMENT 2: FRAILTY MODEL
  # ----------------------------------------------------------
  
  frailtyModel <- reactive({
    
    # Follow-up times and baseline frailty proportion
    t <- seq(0, input$timeF, length.out = 500)
    p <- input$pF
    
    # Constant subgroup hazards
    hF0 <- input$hF
    hH0 <- input$hH
    
    # Treatment multiplies both hazards by the same HR
    hF1 <- input$hrF * hF0
    hH1 <- input$hrF * hH0
    
    # Survival functions within each subgroup
    SF0 <- exp(-hF0 * t)
    SH0 <- exp(-hH0 * t)
    
    SF1 <- exp(-hF1 * t)
    SH1 <- exp(-hH1 * t)
    
    # Marginal survival probabilities
    S0 <- p * SF0 + (1 - p) * SH0
    S1 <- p * SF1 + (1 - p) * SH1
    
    # Frailty proportions among survivors (Bayes)
    pF0 <- p * SF0 / S0
    pF1 <- p * SF1 / S1
    
    # Marginal hazards weighted by survivor composition
    hm0 <- pF0 * hF0 + (1 - pF0) * hH0
    hm1 <- pF1 * hF1 + (1 - pF1) * hH1
    
    # Marginal hazard ratio
    HRm <- hm1 / hm0
    
    list(t = t, pF0 = pF0, pF1 = pF1,
         hm0 = hm0, hm1 = hm1, HRm = HRm)
  })
  
  # Plot depletion of frail individuals
  output$frailtyPlot <- renderPlot({
    m <- frailtyModel()
    
    plot(m$t, m$pF0, type = "l",
         col = "red", lwd = 2,
         ylim = c(0, 1),
         xlab = "Time",
         ylab = "Proportion frail among survivors")
    
    lines(m$t, m$pF1, col = "blue", lwd = 2)
    
    legend("topright", c("Control", "Treatment"),
           col = c("red", "blue"),
           lty = 1, lwd = 2)
  })
  
  # Compare conditional and marginal HR
  output$frailtyHRPlot <- renderPlot({
    m <- frailtyModel()
    
    plot(m$t, m$HRm, type = "l",
         col = "purple", lwd = 2,
         ylim = range(c(m$HRm, input$hrF, 1)),
         xlab = "Time", ylab = "Hazard ratio")
    
    abline(h = input$hrF, col = "black", lty = 2)
    abline(h = 1, col = "gray", lty = 3)
    
    legend("topright",
           c("Marginal HR", "Conditional HR"),
           col = c("purple", "black"),
           lty = c(1, 2), lwd = 2)
  })
  
  # Interpret survivor selection numerically
  output$frailtyInterpretation <- renderText({
    m <- frailtyModel()
    n <- length(m$t)
    
    paste0(
      "At t = ", input$timeF,
      ", frail individuals represent ",
      round(100 * m$pF0[n], 1),
      "% of control survivors and ",
      round(100 * m$pF1[n], 1),
      "% of treated survivors. ",
      "The conditional HR is ", input$hrF,
      ", whereas the marginal HR is ",
      round(m$HRm[n], 3),
      ". This difference arises because the ",
      "composition of survivors changes over time."
    )
  })
  
  
  # ============================================================
  # EXPERIMENT 3: MARGINAL PH DESPITE SELECTION
  # ============================================================
  
  model3 <- reactive({
    
    # Follow-up sequence
    t <- seq(0, input$time3, length.out = 500)
    
    # User-selected parameters
    lambda0 <- input$lambda3
    HR <- input$hr3
    
    # Marginal hazards
    lambda1 <- HR * lambda0
    
    # Marginal survival probabilities
    S0 <- exp(-lambda0 * t)
    S1 <- exp(-lambda1 * t)
    
    # Subgroup survival probabilities
    # F = Frail, H = Healthy
    SF0 <- S0^2
    SH0 <- 2 * S0 - S0^2
    
    SF1 <- S1^2
    SH1 <- 2 * S1 - S1^2
    
    # Check that subgroup averages reproduce
    # marginal survival in both groups
    stopifnot(
      isTRUE(all.equal(0.5 * SF0 + 0.5 * SH0, S0)),
      isTRUE(all.equal(0.5 * SF1 + 0.5 * SH1, S1))
    )
    
    # Frailty prevalence among survivors (Bayes)
    pF0 <- 0.5 * SF0 / S0
    pF1 <- 0.5 * SF1 / S1
    
    # Marginal HR is constant by construction
    HRm <- rep(HR, length(t))
    
    list(
      t = t,
      pF0 = pF0,
      pF1 = pF1,
      HRm = HRm
    )
  })
  
  
  # ------------------------------------------------------------
  # Plot 1: Survivor composition
  # ------------------------------------------------------------
  
  output$composition3 <- renderPlot({
    
    m <- model3()
    
    plot(m$t, m$pF0,
         type = "l",
         col = "red",
         lwd = 2,
         ylim = c(0, 0.5),
         xlab = "Time",
         ylab = "Proportion frail among survivors",
         main = "Changing survivor composition")
    
    lines(m$t, m$pF1, col = "blue", lwd = 2)
    
    legend("topright",
           legend = c("Control", "Treatment"),
           col = c("red", "blue"),
           lty = 1, lwd = 2)
  })
  
  
  # ------------------------------------------------------------
  # Plot 2: Constant marginal HR
  # ------------------------------------------------------------
  
  output$hrPlot3 <- renderPlot({
    
    m <- model3()
    
    plot(m$t, m$HRm,
         type = "l",
         col = "purple",
         lwd = 2,
         ylim = c(0, 1.1),
         xlab = "Time",
         ylab = "Marginal HR",
         main = "Marginal proportional hazards")
    
    abline(h = 1, lty = 2, col = "gray")
  })
  
  
  # ------------------------------------------------------------
  # Dynamic interpretation
  # ------------------------------------------------------------
  
  output$interpretation3 <- renderText({
    
    m <- model3()
    n <- length(m$t)
    
    paste0(
      "At t = ", input$time3,
      ", frail individuals represent ",
      round(100 * m$pF0[n], 1),
      "% of control survivors and ",
      round(100 * m$pF1[n], 1),
      "% of treated survivors. ",
      
      "Nevertheless, the marginal HR remains ",
      round(m$HRm[n], 2),
      " at every time. ",
      
      "Proportional hazards therefore does not ",
      "guarantee comparability among survivors."
    )
  })
  
  
}

# Launch application
shinyApp(ui, server)
