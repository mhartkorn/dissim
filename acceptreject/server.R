library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
  # Initial values
  vars <- reactiveValues(rawNum = runif(2000), num = 2000, maxF = 2)

  #  
  # Functions
  #

  # Distribution function
  f <- function(x) { 
    # Normal distribution centered on 0.5
    if(input$sFunctions == "Normalverteilung") {
      return(dnorm(x, mean = 0.5, sd = input$nNormSd))
    }
    # Beta distribution
    else if(input$sFunctions == "Beta-Verteilung") {
      return(dbeta(x, input$nBeta1, input$nBeta2))
    }
    # Normal distribution
    else {
      return(dunif(x))
    }
  }
  
  # Upper boundary
  t <- function(x) { vars$maxF }

  observe({
    # Limit the random numbers to a maximum of 5000
    if(input$numNumbers > 5000) {
      vars$num = 5000
    } else {
      vars$num = input$numNumbers
    }

    # Regenerate the numbers after a change
    vars$rawNum <- runif(vars$num)
  })
  
  output$pAccRej <- renderPlot({
    x <- seq(0, 1, 1 / (vars$num - 1))

    # Precalculate all values (because we need them later anyways)
    yf <- f(x)
    # Get highest value to calculate t(x), not perfect but enough in this case
    vars$maxF <- max(yf)
    yt <- t(x)

    # Data frame which holds all values
    result <- data.frame(x = x, y = yt * vars$rawNum, 
                         type = character(vars$num),
                         yt, yf,
                         stringsAsFactors = FALSE)
    
    # Counter for accepted numbers
    accCount <- 0
    
    # Iterate over the values to check whether they are accepted or rejected
    for(i in 1:vars$num) {
      if(result$y[i] < yf[i]) {
        result$type[i] <- "accepted"
        accCount <- accCount + 1
      } else {
        result$type[i] <- "rejected"
      }
    }
    
    # Update count string
    output$tPercent <- renderText({
      paste((accCount / vars$num)  * 100, "% der generierten Zahlen wurden akzeptiert.",
            sep="")
    })
    
    output$raw <- renderDataTable({
      # Multiply random numbers with t(x) for a normalization towards the upper boundary
      table <- data.frame(Zahlen = vars$rawNum * yt, Status = result$type)
    })
    
    # Draw the plot
    ggplot(result, aes(x)) +
      geom_line(aes(y=yt), color="red") +
      geom_line(aes(y=yf), color="blue") +
      geom_point(data=result[result$type=="accepted",], aes(x=x, y=y), color="blue") +
      geom_point(data=result[result$type=="rejected",], aes(x=x, y=y), color="red")
  })
})
