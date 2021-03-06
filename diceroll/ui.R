library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Würfeln"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      numericInput("numSides", label 
                   = "Seiten pro Würfel (Änderung würfelt neu)", min = 2, max = 100, value = 6),
      numericInput("numThrows", label = "Anzahl der Würfe", min = 1, max = 20000, value = 50)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("1 Würfel",
                 #plotOutput("distPlot"),
                 plotOutput("densityPlot"),
                 textOutput("data")
        ),
        tabPanel("2 Würfel",
                 #plotOutput("distPlot2"),
                 plotOutput("densityPlot2"),
                 textOutput("data2")
        ),
        tabPanel("Rohdaten",
                 dataTableOutput("raw")
        )
      )
    )
  )
))
