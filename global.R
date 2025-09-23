
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

### Importation

# Importation fichier csv
data_allocine <- read_csv2("Data/data_allocine.csv")

# Importation fichier excel correspondance
correspondances <- read_excel("Data/correspondances_allocine.xlsx") %>% 
  rename(nationalite = nationalité)


### Pré-traitements

# Enrichir data_allocine avec les colonnes de correspondances_allocine
data_allocine <- data_allocine %>% 
  left_join(correspondances, by = "nationalite")








