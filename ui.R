# Define UI for application that draws a histogram
fluidPage(
  theme = shinytheme("flatly"),
  #themeSelector(), # Choix du theme (pour tester les themes)
  
  navbarPage("Application Allocine",
             sidebarPanel(
               # Logo Ponant
               img(src = "logo_ponant.png", height = "90x"),
               selectInput(inputId = "choix_indicateur", label = "Choix de l'indicateur :",
                           choices = c("Nombre d'habitants" = "nb_dhabitants",
                                       "Taux de résidences secondaires" = "taux_de_residendes_secondaires",
                                       "Prix au mètre carré" = "prix_median_du_bati_au_m2" )),
               
               checkboxGroupInput("choix_ile", "Choix d'une ou plusieurs îles : ",  
                                  choices = unique(data_Ponant$ile) %>% sort()),
               actionButton("cocher_ile","Cocher toutes les îles"),
               actionButton("decocher_ile","Décocher toutes les îles"),
               br(),
               br(),
               
               actionButton("go","Valider")
               
               
               ,width = 3), 
             
             tabPanel("Page principale",  
                      
                      
                      
                      # Afficher le graphique d'évolution du nombre de films par an
                      mainPanel(
                        tabsetPanel(
                          tabPanel("Graphique", plotlyOutput("plot_evolution",width = "100%", height = "800px")),
                          tabPanel("Tableau", DTOutput("table_evolution"))
                        )
                      )
                      
             ),
             tabPanel("Comparaison des ", # Page secondaire
                      
                      # Afficher le graphique d'évolution du nombre de films par an
                          
                      # Afficher le graphique d'évolution du nombre de films par an
                      mainPanel(
                        tabsetPanel(
                          tabPanel("Graphique", plotlyOutput("plot_comparaison",width = "100%", height = "800px"))
                        )
                      )
                      
                      )
  
             
        )
)