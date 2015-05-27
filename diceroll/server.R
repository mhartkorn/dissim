library(shiny)

samplesize = 20000

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  vars <- reactiveValues(throws1 = sample(1:6, samplesize * 2, replace =  T),
                         throws2 = numeric(samplesize),
                         bins1 = seq(1, 6, length.out = 7), 
                         bins2 = seq(1, 12, length.out = 13))
  
  computeThrows1 <- reactive({
    vars$throws1[1:input$numThrows]
  })
  
  observe({
      vars$throws1 <- sample(1:input$numSides, samplesize * 2, replace = T)      
      vars$bins1 <- seq(1, input$numSides, length.out = input$numSides + 1)
      vars$bins2 <- seq(1, input$numSides * 2, length.out = input$numSides * 2 + 1)
  })
  
  output$distPlot <- renderPlot({
    # draw the histogram with the specified number of bins
    hist(computeThrows1(), breaks = vars$bins1, col = 'darkgray', border = 'white',
         xlab = 'Augenzahl', ylab = 'Häufigkeit', main = "Absolute Häufigkeit der Augenzahl")
  })
  
  output$densityPlot <- renderPlot({
    # draw the histogram with the specified number of bins
    dens <- density(computeThrows1())
    maxDens <- max(dens$y)

    hist(computeThrows1(), breaks = vars$bins1, col = 'darkgrey', border = 'white', probability = T,
         xlab = 'Augenzahl', ylab = 'Häufigkeit', main = "Relative Häufigkeit der Augenzahl",
         ylim = c(0, maxDens + maxDens * 0.05))
    lines(dens, col = 'red', lwd = 3)
  })
  
  output$data <- renderText({paste("Varianz =", round(var(computeThrows1()), 3), "|", "Durchschnitt =", round(mean(computeThrows1()), 3))})
  
  
  #
  ## 2 Würfel
  #
  
  computeThrows2 <- reactive({
    res <- numeric(input$numThrows)

    for(i in 1:input$numThrows) {
      res[i] <- vars$throws1[i] + vars$throws1[i + samplesize]
    }
    
    return(res)
  })
  
  output$distPlot2 <- renderPlot({
    # draw the histogram with the specified number of bins
    hist(computeThrows2(), breaks = vars$bins2, col = 'darkgray', border = 'white',
         xlab = 'Augenzahl', ylab = 'Häufigkeit', main = "Absolute Häufigkeit der Augenzahl")
  })
  
  output$densityPlot2 <- renderPlot({
    # draw the histogram with the specified number of bins
    dens <- density(computeThrows2())
    maxDens <- max(dens$y)
    
    hist(computeThrows2(), breaks = vars$bins2, col = 'darkgrey', border = 'white', probability = T,
         xlab = 'Augenzahl', ylab = 'Häufigkeit', main = "Relative Häufigkeit der Augenzahl",
         ylim = c(0, maxDens + maxDens * 0.05))
    lines(dens, col = 'red', lwd = 3)
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
    vars$throws
  })
})
