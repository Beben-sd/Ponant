function(input, output, session) {
  
  # eventReactive déclenché uniquement au clic sur le bouton 'go'
  perimetre <- eventReactive(input$go, {
    data_filtered <- data_long %>% 
      filter(variable == input$choix_indicateur) %>% 
      filter(ile %in% input$choix_ile)
    
    list(
      data = data_filtered,
      indicateur = input$choix_indicateur
    )
  })
  
  output$plot_evolution <- renderPlotly({
    p <- perimetre()  # récupère la liste avec data + indicateur
    data <- p$data
    
    gg <- ggplot(data, aes(x = annee, y = valeur, color = ile)) +
      geom_line(size = 1) +
      geom_point(size = 2) +
      labs(
        title = paste0("Évolution ", p$indicateur),  # titre dynamique au clic
        x = "Année",
        y = "Nombre d'habitants",
        color = "Île"
      ) +
      theme_minimal() +
      theme(
        plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
        axis.title = element_text(size = 12)
      )
    
    ggplotly(gg)
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
                buttons = list('copy', 'csv', 'excel')
              ),
              extensions = 'Buttons'
    )
  })
  
}
