# Define server logic required to draw a histogram
function(input, output, session) {
  
  # Fonction réactive "intermédiaire" pour la sélection du périmètre choisi par l'utilisateur
  #EventReactive : déclenchement seulement au clic du boutton
  perimetre <- eventReactive(input$go, {
    
    if (input$choix_genre != "Tous les genres") {
      data_allocine_plot <- data_allocine %>% 
        filter(genre == input$choix_genre) # Filtrer sur genre choisi par l'utilisateur 
    }
    
    else {
      data_allocine_plot <- data_allocine # Pas de filtre si "Tous les genres" choisis
    }
    
    if (input$choix_reprise == FALSE) {
      # Exclure les films repris si la boite est cochée
      data_allocine_plot <- data_allocine_plot %>% 
        filter(reprise != TRUE)
    }
    return(data_allocine_plot)
  })
  
  
  output$plot_evolution <- renderPlotly({
    # Graphique sur l'évolution du nombre de films par an (sur un genre donné)
    (perimetre() %>% # On repart de la fonction réactive de périmètre
       mutate(annee_sortie = year(date_sortie)) %>% 
       count(annee_sortie) %>% 
       ggplot() +
       geom_line(aes(x = annee_sortie, y = n), color = input$choix_couleur) +
       labs(title = "Evolution du nombre de films par an", subtitle = paste("Genre choisi : ", input$choix_genre))
    )%>% 
      ggplotly() # Conversion en graphique intéractif plotly
    
  })
  
  
  
  output$table_evolution <- renderTable({
    # Tableau sur l'évolution du nombre de films par an (sur un genre donné)
    perimetre() %>% 
      mutate(annee_sortie = year(date_sortie)) %>% 
      count(annee_sortie) 
  })
  
  
  # Fonction observe sur déclenchement pour prévenir l'utilisateur du périmètre choisi
  observeEvent(input$go, {
    showNotification(paste("Affichage des données sur : ", input$choix_genre))
  })
  
  
  
  
}
