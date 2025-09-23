
# Script à lancer au moment de l'initialisation de l'application

### Packages

library(shiny)
library(readr) # Tidyverse : chargement fichiers plats
library(dplyr) # Tidyverse : traitement de données
library(readxl) # Tidyverse : importation fichier Excel
library(ggplot2)
library(forcats)
library(lubridate)
library(shinythemes)
library(plotly)
library(rvest)
library(DT)
library(janitor)
library(fuzzyjoin)
### Importation Ponant
Data_Ponant <-  read_excel("//home-ens.univ-ubs.fr/e2203154/Mes documents/prog_stat/R/Ponan/Data_Ponant.xlsx",
    range = "A1:W18"
  ) %>%
  janitor::clean_names()


### table wikipedia extern
# URL de la page Wikipédia
url <- "https://fr.wikipedia.org/wiki/%C3%8Eles_du_Ponant"

# Lire la page HTML
page <- read_html(url)

# Extraire le tableau avec rvest
tableau <- page %>%
  html_nodes("table.wikitable") %>%
  html_table(fill = TRUE)

# Si plusieurs tableaux existent, afficher le premier
tableau_ponant <- tableau[[1]]

# Extraire toutes les images du tableau
toutes_les_images <- page %>%
  html_nodes("table.wikitable img") %>%
  html_attr("src")

# Afficher les premières images récupérées
head(toutes_les_images)

# Filtrer les images pour ne garder que celles des blasons
blasons <- toutes_les_images[seq(1, length(toutes_les_images), by = 3)]  

# Vérification du nombre d'images restantes et du nombre de lignes dans le tableau
cat("Nombre d'images des blasons : ", length(blasons), "\n")
cat("Nombre de lignes du tableau : ", nrow(tableau_ponant), "\n")

# Si le nombre d'images des blasons ne correspond pas au nombre de lignes, on ajuste
blasons <- blasons[1:nrow(tableau_ponant)]

# Ajouter les liens des blasons à notre tableau
tableau_ponant$Blason <- blasons

# Afficher le tableau avec les liens des blasons
head(tableau_ponant)  # Affiche les premières lignes du tableau avec les blasons


# -----
# Ajouter le préfixe "https:" aux URLs incomplètes
tableau_ponant$Blason <- paste0("https:", tableau_ponant$Blason)

# Convertir les liens en balises <img>
tableau_ponant$Blason <- paste0('<img src="', tableau_ponant$Blason, '" height="40"/>')
tableau_ponant <- tableau_ponant %>% select(Nom,Blason,'Superficie (km²)',Population,'Densité (hab./km²)', Région,Département,Coordonnées)
data <- stringdist_left_join(Data_Ponant, tableau_ponant, 
                                  by = c("ile" = "Nom"), 
                                  max_dist = 2,    # distance max acceptée (ajuste selon besoin)
                                  distance_col = "dist")




