library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
  vars <- reactiveValues(rawNum = runif(1500), accept = c())

  observe({
    if(input$sFunctions == "Normalverteilung") {
      for(i in 1:length(vars$rawNum)){
        U = runif(1, 0, 1)
        if(dunif(vars$rawNum[i], 0, 1)*3*U <= dbeta(vars$rawNum[i], 6, 3)) {
          vars$accept[i] = 'Yes'
        }
        else if(dunif(vars$rawNum[i],0,1)*3*U > dbeta(vars$rawNum[i], 6, 3)) {
          vars$accept[i] = 'No'
        }
      }
      cat("YAY\n")
    }
  })
  
  output$pAccRej <- renderPlot({
    T = data.frame(vars$rawNum, accept = factor(vars$accept, levels= c('Yes','No')))
    qplot(vars$rawNum, data = T, geom = 'histogram', fill = vars$accept, binwidth=0.01)
  })
  
  output$raw <- renderDataTable({
    table <- data.frame(Nummern = vars$rawNum)
  })
})
