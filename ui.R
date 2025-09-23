# Define UI for application that draws a histogram
fluidPage(
  theme = shinytheme("flatly"),
  #themeSelector(), # Choix du theme (pour tester les themes)
  
  navbarPage("Application Allocine",
             tabPanel("Page principale",  
                      # Logo Allociné
                      img(src = "Allocine_Logo.svg.png", height = "58x"),
                      
                      # Sidebar with a slider input for number of bins
                      sidebarLayout(
                        sidebarPanel(
                          selectInput("choix_genre", "Choix du genre : ", 
                                      choices = c("Tous les genres", unique(data_allocine$genre))),
                          selectInput(inputId = "choix_couleur", label = "Choix de la couleur :",
                                      choices = c("red", "blue", "green")),
                          checkboxInput("choix_reprise","Inclure les films repris"),
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
