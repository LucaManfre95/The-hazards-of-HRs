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
      plotOutput("ratioPlot"),
      
      p("The hazard ratio stays constant, while
        the cumulative risk ratio approaches 1
        as follow-up increases.")
    )
  )
)

# Server calculations
server <- function(input, output, session) {
  
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
}

shinyApp(ui, server)
