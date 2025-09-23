# Define UI for application that draws a histogram
fluidPage(
  theme = shinytheme("flatly"),
  #themeSelector(), # Choix du theme (pour tester les themes)
  
  navbarPage("Application Allocine",
             
             
             tabPanel("Page principale",  
                      # Logo Ponant
                      img(src = "logo_ponant.png", height = "58x"),
                      
                      # Sidebar with a slider input for number of bins
                      sidebarLayout(
                        sidebarPanel(
                          selectInput(inputId = "choix_indicateur", label = "Choix de l'indicateur :",
                                      choices = c("Nombre d'habitants", "Taux de résidences secondaires", "Prix au mètre carré")),
                          
                          checkboxGroupInput("choix_ile", "Choix d'une ou plusieurs îles : ",  
                                      choices = c("Toutes les îles", unique(data_Ponant$ile) %>% sort())),
                          
                          actionButton("go","Valider")
                        ),
                        
                        # Afficher le graphique d'évolution du nombre de films par an
                        mainPanel(
                          tabsetPanel(
                            tabPanel("Graphique", plotlyOutput("plot_evolution")),
                            tabPanel("Tableau", tableOutput("table_evolution"))
                          )
                        )
                      )
             ),
             tabPanel("A propos", # Page secondaire
                      "Ceci est une application d'exemple basée sur les données", strong("Allociné"))
  )
)
