Data_Ponant <-  read_excel("//home-ens.univ-ubs.fr/e2203154/Mes documents/prog_stat/R/Ponan/Data_Ponant.xlsx",
                           range = "A1:W18"
) %>%
  janitor::clean_names() %>% 
  filter(!ile %in% c("Locmaria","Le Palais","Sauzon","Bangor"))

data_long <- Data_Ponant %>%
  pivot_longer(
    cols = matches("^(nb_dhabitants_|taux_de_residendes_secondaires_|prix_median_du_bati_au_m2_)"),
    names_to = "variable_annee",
    values_to = "valeur"
  )
data_long <- data_long %>%
  separate(variable_annee, into = c("variable", "annee"), sep = "_(?=[0-9]{4}$)") %>%
  mutate(annee = as.integer(annee))


data_habitant_long <- data_long %>% filter(variable == "taux_de_residendes_secondaires")

ggplot(data_habitant_long, aes(x = annee, y = valeur, color = ile)) +
  geom_line(size = 1) +       # ligne pour évolution
  geom_point(size = 2) +      # points sur chaque année
  labs(title = "Évolution du nombre d'habitants par île",
       x = "Année",
       y = "Nombre d'habitants",
       color = "Île") +
  theme_minimal() +           # thème épuré
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    axis.title = element_text(size = 12)
  )
