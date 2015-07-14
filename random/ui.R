library(shiny)

shinyUI(pageWithSidebar(
  
  titlePanel("Zufallszahlen"),
  
  sidebarPanel(
    numericInput("numNumbers", label = "Anzahl der Zufallszahlen", 
                 min = 1, max = 20000, value = 1500),
    selectInput("cbChoices", "Generatorname", 
                c("Mersenne-Twister", "Wichmann-Hill", "Knuth-TAOCP-2002", "RANDU")),
    numericInput("numRandu", "RANDU-Multiplikator", 
                min = 2, max = 65539, value = 15)
  ),
  
  mainPanel(
    tabsetPanel(
      tabPanel("Rohdaten",
               dataTableOutput("raw")
      ),
      tabPanel("Kolmogorov-Smirnov",
               h4("Beschreibung"),
               p("Der Kolmogorov-Smirnov-Test untersucht, 
                 ob eine Menge einer vorgegebenen Verteilung entspricht.
                 In diesem Falle werden die Zufallszahlen auf eine Gleichverteilung getestet."),
               h4("Gültigkeit"),
               htmlOutput("tKsV"),
               h4("Maximaler vertikaler Abstand"),
               textOutput("tKsD"),
               h4("p-Wert"),
               textOutput("tKsP"),
               h4("Ergebnis"),
               htmlOutput("tKsR")
      ),
      tabPanel("Spektral-Test",
               plotOutput("pSpectral2d", width = "400px", height = "400px"),
               sliderInput("angle", min = 0, max = 180, value = 160, 
                           label = "Winkel für 3D Graph"),
               plotOutput("pSpectral3d", width = "400px", height = "400px")
      )
    )
  )
))
