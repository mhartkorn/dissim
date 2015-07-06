library(shiny)
library(ggplot2)

samplesize = 20000

shinyServer(function(input, output) {
  vars <- reactiveValues(throws1 = sample(1:6, samplesize * 2, replace =  T),
                         throws2 = numeric(samplesize))
  
  observe({
      vars$throws1 <- sample(1:input$numSides, samplesize * 2, replace = T)
  })
  
  
  #
  ## 1 Dice
  #
  
  computeThrows1 <- reactive({
    vars$throws1[1:input$numThrows]
  })
  
  output$distPlot <- renderPlot({
    histData = data.frame(x = computeThrows1())
    ggplot(histData, aes(x)) +
      geom_histogram(binwidth = 1, origin = -0.5, col = "white", fill = "darkgray") +
      scale_x_continuous(breaks = 1:input$numSides) +
      ylab("Absolute Häufigkeit") +
      xlab("Augenzahl") +
      theme_classic()
  })
  
  output$densityPlot <- renderPlot({
    histData = data.frame(x = computeThrows1())
    ggplot(histData, aes(x, y = ..density..)) +
      #geom_histogram(binwidth = 1, origin = -0.5, col = "white", fill = "darkgray") +
      geom_density() +
      scale_x_continuous(breaks = 1:input$numSides, name = "Augenzahl") +
      ylab("Relative Häufigkeit") +
      xlab("Augenzahl") +
      theme_classic()
  })
  
  output$data <- renderText({paste("Varianz =", round(var(computeThrows1()), 3), "|", "Durchschnitt =", round(mean(computeThrows1()), 3))})
  
  
  #
  ## 2 Dice
  #
  
  computeThrows2 <- reactive({
    res <- numeric(input$numThrows)

    for(i in 1:input$numThrows) {
      res[i] <- vars$throws1[i] + vars$throws1[i + samplesize]
    }
    
    return(res)
  })
  
  output$distPlot2 <- renderPlot({
    histData = data.frame(x = computeThrows2())
    ggplot(histData, aes(x)) +
      geom_histogram(binwidth = 1, origin = -0.5, col = "white", fill = "darkgray") +
      scale_x_continuous(breaks = 1:(input$numSides * 2)) +
      ylab("Absolute Häufigkeit") +
      xlab("Augenzahl") +
      theme_classic()
  })
  
  output$densityPlot2 <- renderPlot({
    histData = data.frame(x = computeThrows2())
    ggplot(histData, aes(x = x, y = ..density..)) +
      #geom_histogram(binwidth = 1, origin = -0.5, col = "white", fill = "darkgray") +
      geom_density(name = "Relative Häufigkeit") +
      scale_x_continuous(breaks = 1:(input$numSides * 2)) +
      ylab("Relative Häufigkeit") +
      xlab("Augenzahl") +
      theme_classic()
  })
  
  output$dataTable2 <- renderDataTable({
    res <- NULL
    res.var <- round(var(computeThrows2()), 3)
    res.round <- round(mean(computeThrows2()), 3)
    return(res)
  })
  
  output$data2 <- renderText({paste("Varianz =", round(var(computeThrows2()), 3), "|", "Durchschnitt =", round(mean(computeThrows2()), 3))})
  
  
  #
  ## Raw
  #
  
  output$raw <- renderDataTable({
    table <- data.frame(roll1 = vars$throws1, roll2 = computeThrows2())
  })
})
