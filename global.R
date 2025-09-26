
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
library(stringdist)
library(stringr)
library(tidyr)
### Importation Ponant
data_Ponant <-  read_excel("//home-ens.univ-ubs.fr/e2203154/Mes documents/prog_stat/R/Ponan/data_Ponant.xlsx",
                           range = "A1:W18"
) %>%
  janitor::clean_names() %>% 
  filter(!ile %in% c("Locmaria","Le Palais","Sauzon","Bangor"))

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


# Remplacer manuellement les valeurs dans tableau_ponant$clean_Nom
tableau_ponant$clean_Nom <- tableau_ponant$Nom

# Remplacement des valeurs spécifiques
tableau_ponant$clean_Nom[tableau_ponant$Nom == "île de Bréhat"] <- "Île-de-Bréhat"
tableau_ponant$clean_Nom[tableau_ponant$Nom == "Île-de-Batz"] <- "Île-de-Batz"
tableau_ponant$clean_Nom[tableau_ponant$Nom == "Île d'Ouessant"] <- "Ouessant"
tableau_ponant$clean_Nom[tableau_ponant$Nom == "Île de Molène"] <- "Île-Molène"
tableau_ponant$clean_Nom[tableau_ponant$Nom == "Île de Sein"] <- "Île-de-Sein"
tableau_ponant$clean_Nom[tableau_ponant$Nom == "Archipel des Glénan"] <- "archipel des glénan"
tableau_ponant$clean_Nom[tableau_ponant$Nom == "Île de Groix"] <- "Groix"
tableau_ponant$clean_Nom[tableau_ponant$Nom == "Île d'Arz"] <- "Île-d'Arz"
tableau_ponant$clean_Nom[tableau_ponant$Nom == "Île aux Moines"] <- "Île-aux-Moines"
tableau_ponant$clean_Nom[tableau_ponant$Nom == "Belle-Île-en-Mer"] <- "Total Belle-île"
tableau_ponant$clean_Nom[tableau_ponant$Nom == "Île d'Houat"] <- "Île-d'Houat"
tableau_ponant$clean_Nom[tableau_ponant$Nom == "Île d'Hœdic"] <- "Hœdic"
tableau_ponant$clean_Nom[tableau_ponant$Nom == "Île d'Yeu"] <- "L'Île-d'Yeu"
tableau_ponant$clean_Nom[tableau_ponant$Nom == "Île d'Aix"] <- "Île-d'Aix"

# Maintenant effectuer la jointure avec stringdist_left_join
resultat <- left_join(
  data_Ponant, tableau_ponant, 
  by = c("nom_commune" = "clean_Nom"), 
)

data_longue <- resultat %>%
  pivot_longer(
    cols = matches("^(nb_dhabitants_|taux_de_residendes_secondaires_|prix_median_du_bati_au_m2_)"),
    names_to = "variable_annee",
    values_to = "valeur"
  )
data_long <- data_longue %>%
  separate(variable_annee, into = c("variable", "annee"), sep = "_(?=[0-9]{4}$)") %>%
  mutate(annee = as.integer(annee))


tableau_propre <- resultat %>% 
  select(nom_commune,Blason,Région,Département,Coordonnées)
