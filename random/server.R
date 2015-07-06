library(shiny)
library(scatterplot3d)

shinyServer(function(input, output) {
  vars <- reactiveValues(rawNum = runif(3000))
  
  observe({
    RNGkind(input$cbChoices)
    vars$rawNum <- runif(input$numNumbers)
  })
  
  computeCombine3 <- reactive({
    x <- double(input$numNumbers / 3)
    y <- double(input$numNumbers / 3)
    z <- double(input$numNumbers / 3)
    j <- 1
    
    loops <-input$numNumbers
    if(loops %% 3 != 0) {
      loops <- loops - (loops %% 3)
    }
    
    for(i in 1:loops) {
      if(i %% 3 == 0) {
        z[j] <- vars$rawNum[i]
        j <- j + 1
      } else if (i %% 2 == 0) {
        y[j] <- vars$rawNum[i]
      } else {
        x[j] <- vars$rawNum[i]
      }
    }
    
    return(list("x" = x, "y" = y, "z" = z))
  })
  
  computeCombine2 <- reactive({
    x <- double(input$numNumbers / 2)
    y <- double(input$numNumbers / 2)
    j <- 1
    
    loops <-input$numNumbers
    if(loops %% 2 != 0) {
      loops <- loops - 1
    }
    
    for(i in 1:loops) {
      if(i %% 2 == 0) {
        y[j] <- vars$rawNum[i]
        j <- j + 1
      } else {
        x[j] <- vars$rawNum[i]
      }
    }
    
    return(list("x" = x, "y" = y))
  })
  
  output$pSpectral2d <- renderPlot({
    combined <- computeCombine2()
    
    plot(combined$x, combined$y, pch=16)
  })

  output$pSpectral3d <- renderPlot({
    combined <- computeCombine3()
    
    scatterplot3d(combined$x, combined$y, combined$z, pch=16)
  })
  
  ksTest <- reactive({
    ks.test(vars$rawNum, y = punif)
  })
  
  output$tKsP <- renderText({
    paste("p-value =", ksTest()$p.value)
  })
  
  output$tKsD <- renderText({
    paste("D =", ksTest()$statistic)
  })
  
  output$tKsR <- renderText({
    if(ksTest()$p.value <= 0.05) {
      paste("Der p-Wert liegt unter 0,05. Es wird deshalb davon ausgegangen,
            dass die Zahlen <strong>nicht</strong> gleichverteilt sind.")
    } else {
      paste("Der p-Wert liegt über 0,05. Es wird deshalb davon ausgegangen,
            dass die Zahlen gleichverteilt sind.")
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
  
  output$raw <- renderDataTable({
    table <- data.frame(Nummern = vars$rawNum)
  })
})
