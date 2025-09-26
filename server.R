# Define server logic required to draw a histogram
function(input, output, session) {
  
  # Fonction réactive "intermédiaire" pour la sélection du périmètre choisi par l'utilisateur
  #EventReactive : déclenchement seulement au clic du boutton
  perimetre <- eventReactive(input$go, {
    
    data_habitant_long <- data_long %>% 
      filter(variable == input$choix_indicateur) %>% 
      filter(ile %in% input$choix_ile)
    return(data_habitant_long)
  })
  
  
    # Code ici sera exécuté uniquement lorsque 'choix_indicateur' change
  output$plot_evolution <- renderPlotly({
    
    # Graphique sur l'évolution du nombre de films par an (sur un genre donné)
    (perimetre() %>%  # On utilise la fonction réactive 'perimetre'
        ggplot(aes(x = annee, y = valeur, color = ile)) +
        geom_line(size = 1) +       # ligne pour évolution
        geom_point(size = 2) +      # points sur chaque année
        labs(title = paste0("Évolution ",input$choix_indicateur),  # Utilisation de 'input$choix_indicateur' pour le titre
             x = "Année",
             y = "Nombre d'habitants",
             color = "Île") +
        theme_minimal() +           # thème épuré
        theme(
          plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
          axis.title = element_text(size = 12)
        )
    ) %>%
      ggplotly()  # Conversion en graphique interactif
  })

  
  observeEvent(input$cocher_ile, {
    updateCheckboxGroupInput(
      session,
      inputId = "choix_ile",
      selected = sort(unique(data_Ponant$ile))
    )
  })
  
  observeEvent(input$decocher_ile, {
    updateCheckboxGroupInput(
      session,
      inputId = "choix_ile",
      selected = character(0)
    )
  })
  
  output$table_evolution <- renderDT({
    datatable(tableau_propre, escape = FALSE, 
              options = list(
                paging = TRUE,
                searching = TRUE,
                autoWidth = TRUE,
                pageLength = 25,  
                buttons = list('copy', 'csv', 'excel')  # Liste des boutons
              ),
              extensions = 'Buttons'  # Charge l'extension des boutons
    )
  })
  
  
}