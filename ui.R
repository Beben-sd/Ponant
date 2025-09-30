# Define UI for application that draws a histogram
fluidPage(
  theme = shinytheme("flatly"),
  #themeSelector(), # Choix du theme (pour tester les themes)
  
  navbarPage("Application Iles Ponant",
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
               
               actionButton("go"," Valider",icon = icon("check"))
               
               
             ,width = 3), 
             
             tabPanel("Page principale",  
                     
                      

                        # Afficher le graphique d'évolution du nombre de films par an
                        mainPanel("", plotlyOutput("plot_evolution",width = "100%", height = "800px")),
                          
                          
                        
                      
             ),
             tabPanel("Comparaison des Iles sur la dernière années",
                      mainPanel("",plotlyOutput("plot_comparaison",width = "100%", height = "800px"))),
             tabPanel("Tableau des observations" ,
                      mainPanel("", DTOutput("table_evolution"))),
             tabPanel("Informations complémentaires",
                      downloadButton("telecharger_md", "Télécharger le rapport ci dessous ↓"), 
                      includeMarkdown("a_afficher.md"))
  )
)