library(shiny)

shinyUI(pageWithSidebar(
  
  titlePanel("Zufallszahlen"),
  
  sidebarPanel(
    numericInput("numNumbers", label = "Anzahl der Zufallszahlen", 
                 min = 100, max = 20000, value = 1500),
    selectInput("cbChoices", "Generatorname", 
                c("Mersenne-Twister", "Knuth-TAOCP-2002", "Middle-Square", "RANDU"))
  ),
  
  mainPanel(
    tabsetPanel(
      tabPanel("Spektral-Test",
               plotOutput("pSpectral2d", width = "400px", height = "400px"),
               sliderInput("angle", min = 0, max = 180, value = 48, 
                           label = "Winkel für 3D Graph"),
               plotOutput("pSpectral3d", width = "400px", height = "400px")
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
      tabPanel("Chi²-Test",
               h4("Beschreibung"),
               p("Der Chi²-Test untersucht, ob Zahlen im Vergleich 
                 zu einer Gleichtvereilung verhäuft auftreten."),
               h4("p-Wert"),
               textOutput("chiP"),
               h4("Gültigkeit"),
               htmlOutput("chiR")
               ),
      tabPanel("Rohdaten",
               dataTableOutput("raw")
      )
    )
  )
))
