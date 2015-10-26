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
      tabPanel("Informationen",
               conditionalPanel(
                 condition = "input.cbChoices == 'Mersenne-Twister'",
                 "Mersenne-Twister (MT19927) ist ein weit verbreiteter 
                 Pseudo-Zufallszahlen-Generator mit einer sehr langen Periode
                 von 2^19927-1. Die Zufallszahlen sind
                 nach einer längeren Aufwärmphase gleichverteilt."
               ),
               conditionalPanel(
                 condition = "input.cbChoices == 'Knuth-TAOCP-2002'",
                 "Bei Knuth-TAOCP-2002 handelt es sich um einen Pseudo-Zufallszahlen-generator, der
                 von Donald Knuth in seinem Buch The Art of Computer Programming in der Auflage aus 2002
                 beschrieben wurde. Die Periode ist mit 2^65-1 kleiner als bei Mersenne-Twister,
                 benötigt aber keine Aufwärmphase."
               ),
               conditionalPanel(
                 condition = "input.cbChoices == 'Middle-Square'",
                 "Die Middle-Square Method, auf deutsch Mittelquadratmethode, ist eine 1949 von
                 John von Neumann beschriebene Methode Zufallszahlen aus Quadratzahlen zu generieren.
                 Dazu wird initial eine 4-stellige Zahl quadriert. Anschließend werden die mittleren 4
                 Ziffern herausgetrennt und ergeben die Zufallszahl. Für eine weitere Zufallszahl wird
                 das Ergebnis der vorherigen Berechnung als Anfganszahl verwendet. Die Zahlen folgen
                 keiner besonderen Verteilung und wiederholen sich schnell."
               ),
               conditionalPanel(
                 condition = "input.cbChoices == 'RANDU'",
                 "RANDU ist ein alter, in den 1970er Jahren in Fortran verwendeter, 
                 Pseudo-Zufallszahlen-Generator. Die Zahlen werden nach dem Polynom
                 X_{i+1} = (a * X_i) mod 2^31 generiert. Die Zufallszahlen genügen
                 heutigen Standards nicht mehr und RANDU ist hier nur als
                 Beispiel für einen schlechten Algorithmus genannt."
               )
      ),
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
