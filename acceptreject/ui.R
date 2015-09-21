library(shiny)

shinyUI(pageWithSidebar(
  
  titlePanel("Zufallszahlen"),
  
  sidebarPanel(
    numericInput("numNumbers", label = "Anzahl der Zufallszahlen", 
                 min = 1, max = 5000, value = 2000),
    selectInput("sFunctions", "Funktion", 
                c("Normalverteilung", "Beta-(3,4)-Verteilung", "Gleichverteilung"))
  ),
  
  mainPanel(
    tabsetPanel(
      tabPanel("Graph",
               plotOutput("pAccRej")
      ),
      tabPanel("Rohdaten",
               dataTableOutput("raw")
      )
    )
  )
))
