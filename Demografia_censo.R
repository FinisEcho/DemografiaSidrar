#install.packages("sidrar")
library(sidrar)
#install.packages("dplyr")
library(dplyr)

info_sidra(1209)

# Códigos das tabelas SIDRA
tab_censos <- c(200, 1209, 9514)

# Código do Acre é 12
cod_uf_acre <- 12

# Para cada tabela, buscar dados de 2010 e 2022 para o Acre
acre_idade_2022 <-   get_sidra(
    x = 9514,
    period = "2022", # anos do censo
    geo = "State",
    geo.filter = list(State = cod_uf_acre)
  )

acre_idade_filtrado <- acre_idade_2022 %>%
  select(-contains("(Código)"))

# Olhar os dados da primeira tabela como exemplo
str(acre_idade_filtrado)
