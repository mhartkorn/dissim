library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
  vars <- reactiveValues(rawNum = runif(2000), num = 2000)

  #  
  # Functions
  #
  
  # Upper boundary
  t <- function(x) { 2.5 }
  # Distribution function
  f <- function(x) { 
    if(input$sFunctions == "Normalverteilung") {
      return(dnorm(x))
    } else if(input$sFunctions == "Beta-(3,4)-Verteilung") {
      return(dbeta(x, 4, 3))
    } else {
      return(dunif(x))
    }
  }

  observe({
    if(input$numNumbers > 5000) {
      vars$num = 5000
    } else {
      vars$num = input$numNumbers
    }

    vars$rawNum <- runif(vars$num)
  })
  
  computeCombine2 <- reactive({
    count <- vars$num / 2
    x <- rep(0, count)
    y <- rep(0, count)
    
    j <- 1
    
    loops <-vars$num
    if(loops %% 2 != 0) {
      loops <- loops - 1
    }
    
    for(i in seq(1, loops, 2)) {
      x[j] <- vars$rawNum[i]
      y[j] <- vars$rawNum[i + 1]
      j <- j + 1
    }
    
    return(list("x" = x, "y" = y))
  })
  
  checkStatus <- function(x, position, yf) {
    return((t(position) * vars$rawNum[position]) < yf[position])
  }
  
  output$pAccRej <- renderPlot({
    x <- seq(0, 1, 1 / vars$num)

    # Precalculate all values (because we need them later anyways)
    yt <- t(x)
    yf <- f(x)

    accCount <- 0
    accX <- numeric(vars$num)
    accY <- numeric(vars$num)
    rejCount <- 0
    rejX <- numeric(vars$num)
    rejY <- numeric(vars$num)
    
    for(i in 1:vars$num) {
      if(checkStatus(x, i, yf)) {
        accX[accCount + 1] <- x[i]
        accY[accCount + 1] <- vars$rawNum[i] * t(i)
        accCount <- accCount + 1
      } else {
        rejX[rejCount + 1] <- x[i]
        rejY[rejCount + 1] <- vars$rawNum[i] * t(i)
        rejCount <- rejCount + 1
      }
    }
    
    if(accCount > 0) {
      accepted <- data.frame(accX=accX[1:(accCount+1)], accY=accY[1:(accCount+1)])
    } else {
      accepted <- data.frame(accX=0, accY=0)
    }
    if(rejCount > 0) {
      rejected <- data.frame(rejX=rejX[1:(rejCount+1)], rejY=rejY[1:(rejCount+1)])
    } else {
      rejected <- data.frame(rejX=0, rejY=0)
    }
    
    df <- data.frame(x, yt, yf)
    
    ggplot(df, aes(x)) +
      geom_line(aes(y=yt), color="red") +
      geom_line(aes(y=yf), color="blue") +
      geom_point(data=accepted, aes(x=accX, y=accY), color="blue") +
      geom_point(data=rejected, aes(x=rejX, y=rejY), color="red")
    
  })
  
  output$raw <- renderDataTable({
    table <- data.frame(Nummern = vars$rawNum)
  })
})
