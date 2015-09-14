library(shiny)

shinyUI(pageWithSidebar(
  
  titlePanel("Zufallszahlen"),
  
  sidebarPanel(
    selectInput("sFunctions", "Funktion", 
                c("Normalverteilung"))
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
