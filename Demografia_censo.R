#install.packages("sidrar")
library(sidrar)
#install.packages("dplyr")
library(dplyr)
#install.packages("gtsummary")
library(gtsummary)

info_sidra(1209)

# Código do Acre é 12
cod_uf_acre <- 12

# Buscar dados de 2022 para o Acre
acre_idade_2022 <-   get_sidra(
    x = 9514,
    period = "2022", # anos do censo
    geo = "State",
    geo.filter = list(State = cod_uf_acre)
  )

acre_idade_filtrado <- acre_idade_2022 %>%
  select(-contains("(Código)")) %>%
  select(-"Nível Territorial", -"Unidade de Medida") %>%
  filter(!grepl("Total", Sexo))


# Olhar os dados da primeira tabela como exemplo
str(acre_idade_filtrado)

info_sidra(3145)

# Buscar dados de 2010 para o Acre
acre_idade_2010 <-   get_sidra(
    x = 1378,
    period = "2010", # ano do censo
    geo = "State",
    geo.filter = list(State = cod_uf_acre)
  )
