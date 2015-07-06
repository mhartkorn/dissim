library(shiny)

shinyUI(pageWithSidebar(
  
  headerPanel("Zufallszahlen"),
  
  sidebarPanel(
    numericInput("numNumbers", label = "Anzahl der Zufallszahlen", 
                 min = 1, max = 20000, value = 3000),
    selectInput("cbChoices", "Generatorname", 
                c("Mersenne-Twister", "Wichmann-Hill", "Knuth-TAOCP-2002"))
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
               plotOutput("pSpectral3d", width = "400px", height = "400px")
      )
    )
  )
))
