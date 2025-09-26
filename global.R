
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
library(janitor) # Nettoyer le nom des variables


### Importation
data_allocine <- read_csv2("Data/data_allocine.csv")

# Importation fichier excel
data_Ponant <- read_excel("//home-ens.univ-ubs.fr/e2202958/Mes documents/M1/Data visualisation/Rshiny/Ponanttttttttttt/Ponant/Data/Data_Ponant.xlsx", 
                          range = "A1:W18") %>% clean_names()


### Filtrage
data_Ponant <- data_Ponant %>% filter(!ile %in% c("Locmaria", "Le Palais", "Sauzon", "Bangor")) # Filtrer les communes de Belle-Ile





