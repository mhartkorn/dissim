library(shiny)

shinyUI(pageWithSidebar(
  
  titlePanel("Zufallszahlen"),
  
  sidebarPanel(
    numericInput("numNumbers", label = "Anzahl der Zufallszahlen", 
                 min = 1, max = 5000, value = 2000),
    selectInput("sFunctions", "Funktion", 
                c("Normalverteilung", "Beta-Verteilung", "Gleichverteilung")),
    conditionalPanel(
      condition = "input.sFunctions == 'Beta-Verteilung'",
      sliderInput("nBeta1", label = "Alpha",
                   min = 2, max = 9, value = 3, step = 1),
      sliderInput("nBeta2", label = "Beta",
                   min = 2, max = 9, value = 4, step = 1)),
    conditionalPanel(
      condition = "input.sFunctions == 'Normalverteilung'",
      sliderInput("nNormSd", label = "Standardabweichung",
                   min = 0.1, max = 2, value = 0.5, step = 0.1))
  ),
  
  mainPanel(
    tabsetPanel(
      tabPanel("Graph",
               plotOutput("pAccRej"),
               textOutput("tPercent")
      ),
      tabPanel("Rohdaten",
               dataTableOutput("raw")
      )
    )
  )
))
