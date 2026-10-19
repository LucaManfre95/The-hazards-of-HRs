library(shiny)

# User interface
ui <- fluidPage(
  titlePanel("The Hazards of Hazard Ratios"),
  
  p("Experiment 1: Proportional hazards"),
  p("Explore how a constant HR can coexist
    with a changing cumulative risk ratio."),
  
  sidebarLayout(
    sidebarPanel(
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
  
  
  # Plot the marginal hazards for both groups
  output$hazardPlot <- renderPlot({
    
    # Create the follow-up time sequence
    t <- seq(0, input$followup, length.out = 500)
    
    # Define the constant hazards
    lambda0 <- input$lambda0
    lambda1 <- lambda0 * input$hr
    
    # Generate the hazard values at every time
    h0 <- rep(lambda0, length(t))
    h1 <- rep(lambda1, length(t))
    
    # Plot control hazard
    plot(t, h0, type = "l",
         col = "red", lwd = 2,
         ylim = c(0, max(h0, h1) * 1.2),
         xlab = "Time",
         ylab = "Hazard",
         main = "Marginal hazards")
    
    # Add treatment hazard
    lines(t, h1, col = "blue", lwd = 2)
    
    # Add legend
    legend("topright",
           legend = c("Control", "Treatment"),
           col = c("red", "blue"),
           lty = 1, lwd = 2)
  })
  
  
  output$ratioPlot <- renderPlot({
    
    t <- seq(0.001, input$followup, length.out = 500)
    
    lambda0 <- input$lambda0
    lambda1 <- input$hr * lambda0
    
    S0 <- exp(-lambda0 * t)
    S1 <- exp(-lambda1 * t)
    
    RR <- (1 - S1) / (1 - S0)
    HR <- rep(input$hr, length(t))
    
    plot(t, RR, type = "l", col = "red",
         lwd = 2, ylim = c(0, 1),
         xlab = "Time", ylab = "Ratio",
         main = "HR versus cumulative RR")
    
    lines(t, HR, col = "blue", lwd = 2)
    
    legend("bottomright",
           legend = c("HR", "RR"),
           col = c("blue", "red"),
           lty = 1, lwd = 2)
  })
  
  
  output$survivalPlot <- renderPlot({
    
    t <- seq(0, input$followup, length.out = 500)
    
    S0 <- exp(-input$lambda0 * t)
    S1 <- exp(-input$lambda0 * input$hr * t)
    
    plot(t, S0, type = "l", col = "red", lwd = 2,
         ylim = c(0, 1),
         xlab = "Time",
         ylab = "Survival probability",
         main = "Survival curves")
    
    lines(t, S1, col = "blue", lwd = 2)
    
    legend("topright",
           legend = c("Control", "Treatment"),
           col = c("red", "blue"),
           lty = 1, lwd = 2)
  })
  
  
  # Generate an interpretation based on slider values
  output$interpretation <- renderText({
    
    # Retrieve the parameters selected by the user
    t <- input$followup       # Follow-up duration
    h <- input$hr             # Hazard ratio
    lambda0 <- input$lambda0  # Baseline hazard (control)
    
    # Calculate cumulative event risks at time t
    # Under constant hazards: Risk(t) = 1 - exp(-lambda * t)
    risk0 <- -expm1(-lambda0 * t)       # Control risk
    risk1 <- -expm1(-lambda0 * h * t)   # Treatment risk
    
    # Calculate cumulative risk ratio
    RR <- risk1 / risk0
    
    # Construct the text displayed in the application
    paste0(
      "At time ", t,
      ", the hazard ratio is ", round(h, 2),
      ", while the cumulative risk ratio is ",
      round(RR, 3), ". ",
      "The cumulative event risk is ",
      round(100 * risk0, 1), "% in controls and ",
      round(100 * risk1, 1), "% in treated individuals."
    )
  })
  
}

shinyApp(ui, server)
