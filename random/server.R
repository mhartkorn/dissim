library(shiny)
library(scatterplot3d)
library(ggplot2)

shinyServer(function(input, output) {
  vars <- reactiveValues(rawNum = runif(1500))
  
  observe({
    if(input$cbChoices == "RANDU") {
      # RANDU implementation
      RANDU <- function(a, c, m, r, seed) {
        if(r <= 0) {
          return(0)
        }

        x <- rep(0, r)
        x[1] <- seed
        for (i in 1:(r - 1)) {
          x[i+1] <-(a * x[i] + c) %% m
        }
        
        for(i in 1:r) {
          x[i] = x[i] / m
        }
        return(x)
      }
      
      MAXINT = 2^31-1
      vars$rawNum <- RANDU(a = 37, c = 1, r = input$numNumbers, 
                           m = MAXINT, seed = runif(1) * MAXINT)
    } else {
      RNGkind(input$cbChoices)
      vars$rawNum <- runif(input$numNumbers)
    }
  })
  
  computeCombine3 <- reactive({
    if(input$numNumbers < 3) {
      return(list(x = 0, y = 0, z = 0))
    }

    count <- input$numNumbers / 3
    x <- rep(0, count)
    y <- rep(0, count)
    z <- rep(0, count)

    j <- 1
    
    loops <-input$numNumbers
    if(loops %% 3 != 0) {
      loops <- loops - (loops %% 3)
    }
    
    for(i in seq(1, loops, 3)) {
      x[j] <- vars$rawNum[i]
      z[j] <- vars$rawNum[i + 1]
      y[j] <- vars$rawNum[i + 2]
      j <- j + 1
    }
    
    return(list("x" = x, "y" = y, "z" = z))
  })
  
  computeCombine2 <- reactive({
    count <- input$numNumbers / 2
    x <- rep(0, count)
    y <- rep(0, count)

    j <- 1
    
    loops <-input$numNumbers
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
  
  output$pSpectral2d <- renderPlot({
    combined <- computeCombine2()
    
    plot(combined$x, combined$y, pch=16)
  })

  output$pSpectral3d <- renderPlot({
    combined <- computeCombine3()
    
    scatterplot3d(combined$x, combined$y, combined$z, pch=16, angle=input$angle, xlab = "", ylab = "", zlab = "")
  })
  
  ksTest <- reactive({
    ks.test(vars$rawNum, y = punif)
  })
  
  output$tKsP <- renderText({
    paste("p-Wert =", ksTest()$p.value)
  })
  
  output$tKsD <- renderText({
    paste("D =", ksTest()$statistic)
  })
  
  output$tKsR <- renderText({
    if(ksTest()$p.value <= 0.05) {
      paste("Der p-Wert liegt unter 0,05. Es wird deshalb mit 95% Wahrscheinlichkeit davon
             ausgegangen, dass die Zahlen <strong>nicht</strong> gleichverteilt sind.")
    } else {
      paste("Der p-Wert liegt über 0,05. Es wird deshalb mit 95% Wahrscheinlichkeit davon 
             ausgegangen, dass die Zahlen gleichverteilt sind.")
    }
  })
  
  output$tKsV <- renderText({
    if(input$numNumbers <= 50) {
      paste('<span style="color:red;">Die Anzahl der Zufallszahlen ist
            mit weniger als 50 zu gering. Für eine gültige Aussage müssen 
            mindestens 50 Zahlen gegeben sein.</span>')
    } else {
      paste("Die Anzahl der Zufallszahlen ist mit über 50 ausreichend.")
    }
  })
  
  chiTest <- function() {
    # Use 100 cells
    breaks <- c(seq(0, 1, by=0.01))
    O <- table(cut(vars$rawNum, breaks=breaks))
    chisq.test(O, p=diff(punif(breaks)), rescale.p=T)
  }
  
  output$chiP <- renderText({
    paste("p-Wert =", chiTest()$p.value)
  })
  
  output$chiR <- renderText({
    if(chiTest()$p.value <= 0.05) {
      paste("Der p-Wert liegt unter 0,05. Es wird deshalb mit 95% Wahrscheinlichkeit davon
             ausgegangen, dass die Zahlen <strong>nicht</strong> gleichverteilt sind.")
    } else {
      paste("Der p-Wert liegt über 0,05. Es wird deshalb mit 95% Wahrscheinlichkeit davon 
             ausgegangen, dass die Zahlen gleichverteilt sind.")
    }
  })
  
  output$raw <- renderDataTable({
    table <- data.frame(Nummern = vars$rawNum)
  })
})
