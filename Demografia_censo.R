#install.packages("sidrar")
library(sidrar)
#install.packages("dplyr")
library(dplyr)
#install.packages("gtsummary")
library(gtsummary)
#install.packages("stringr")
library(stringr)

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

acre_idade2022_filtrado <- acre_idade_2022 |> 
  select(-"Nível Territorial", -"Unidade de Medida")



# Olhar os dados da primeira tabela como exemplo
str(acre_idade2022_filtrado)

info_sidra(3145)

# Buscar dados de 2010 para o Acre
acre_idade_2010 <-   get_sidra(
    x = 1378,
    period = "2010", # ano do censo
    geo = "State",
    geo.filter = list(State = cod_uf_acre)
  )
acre_idade2010_filtrado <- acre_idade_2010 |> 
  select(-"Nível Territorial", -"Unidade de Medida") |> 
  filter(grepl("Total", `Condição no domicílio e o compartilhamento da responsabilidade pelo domicílio`))

pop_total_2022 <- acre_idade2022_filtrado |> 
  filter(Sexo == "Total" &
    Idade == "Total" & 
    `Forma de declaração da idade` == "Total") |> 
  select(Valor)
print(pop_total_2022)

pop_total_2010 <- acre_idade2010_filtrado |> 
  filter(Sexo == "Total" & 
    Idade == "Total" & 
    `Situação do domicílio` == "Total" & 
    `Condição no domicílio e o compartilhamento da responsabilidade pelo domicílio` == "Total") |> 
  select(Valor)
print(pop_total_2010)

pop_hm_2010 <- acre_idade2010_filtrado |> 
  filter(Sexo %in% c("Homens", "Mulheres") &
    Idade == "Total" &
    `Situação do domicílio` == "Total" &
    `Condição no domicílio e o compartilhamento da responsabilidade pelo domicílio` == "Total") |> 
  select(Valor, Sexo)
print(pop_hm_2010)
razao_sexo2010 <- (pop_hm_2010[1, "Valor"]/pop_hm_2010[2, "Valor"])*100
print(razao_sexo2010)

pop_hm_2022 <- acre_idade2022_filtrado |> 
  filter(Sexo %in% c("Homens", "Mulheres") &
    Idade == "Total" & 
    `Forma de declaração da idade` == "Total") |> 
  select(Valor, Sexo)
print(pop_hm_2022)
razao_sexo2022 <- (pop_hm_2022[1, "Valor"]/pop_hm_2022[2, "Valor"])*100
print(razao_sexo2022)

acre_idade2022_simples <- acre_idade2022_filtrado |> 
  filter(grepl("^[0-9]+ anos?$", Idade)) |>   # pega "1 ano", "2 anos", ..., "99 anos"
  mutate(Idade = as.numeric(sub(" anos?$", "", Idade))) |> 
  filter(Sexo %in% c("Homens", "Mulheres"), `Forma de declaração da idade` == "Total")
digito_final <- acre_idade2022_simples$Idade %% 10

# Agrupar por idade e somar valores (Homens + Mulheres)
pop_idade <- acre_idade2022_simples %>%
  group_by(Idade) %>%
  summarise(Pop = sum(Valor), .groups = "drop")

# Calcular dígito final da idade
pop_idade <- pop_idade %>%
  mutate(digito_final = Idade %% 10)

# Frequência por dígito final
pop_por_digito <- tapply(pop_idade$Pop, pop_idade$digito_final, sum)

# Proporção f_i
f_i <- pop_por_digito / sum(pop_por_digito)

# Índice de Myers (0 a 180)
indice_myers <- 100 * sum(abs(f_i - 1/10))
# Resultados
print(round(f_i * 100, 2)) # Distribuição %
cat("\nÍndice de Myers:", round(indice_myers, 2), "\n")

acre_idade2022_simples <- acre_idade2022_filtrado |> 
  filter(grepl("^[0-9]+ anos?$", Idade) | Idade %in% c("100 anos ou mais", "Menos de 1 ano")) |> 
  mutate(
    Idade = case_when(
      Idade == "Menos de 1 ano" ~ 0,
      Idade == "100 anos ou mais" ~ 100, # Para a mediana, vamos usar 100 para essa faixa
      TRUE ~ as.numeric(str_extract(Idade, "^[0-9]+"))
    )
  ) |>
  filter(Sexo %in% c("Homens", "Mulheres"), `Forma de declaração da idade` == "Total") |> 
  select(Ano = Ano, Sexo, Idade, Populacao = Valor)

idade_mediana_acre_2022 <- acre_idade2022_simples |> 
  group_by(Ano, Sexo) |> 
  arrange(Idade) |> # Garantir que as idades estão em ordem crescente
  mutate(
    populacao_acumulada = cumsum(Populacao),
    populacao_total = sum(Populacao)
  ) |> 
  filter(populacao_acumulada >= populacao_total / 2) |> 
  summarise(
    idade_mediana = first(Idade),
    populacao_total = first(populacao_total)
  ) |> 
  ungroup()

print("Idade Mediana por Sexo (Acre - Censo 2022):")
print(idade_mediana_acre_2022)

# O dataframe `acre_idade2022_simples` já está pronto com as colunas:
# Ano, Sexo, Idade, Populacao

razao_dependencia_acre_2022 <- acre_idade2022_simples |> 
  # Mapear as idades para as categorias de dependência
  mutate(
    categoria_idade = case_when(
      Idade >= 0 & Idade <= 14 ~ "Jovem",
      Idade >= 15 & Idade <= 64 ~ "Ativo",
      Idade >= 65 ~ "Idoso"
    )
  ) |> 
  
  # Agrupar os dados por ano e sexo
  group_by(Ano, Sexo) |> 
  
  # Calcular a população total em cada categoria de idade
  summarise(
    pop_jovem = sum(Populacao[categoria_idade == "Jovem"], na.rm = TRUE),
    pop_ativa = sum(Populacao[categoria_idade == "Ativo"], na.rm = TRUE),
    pop_idosa = sum(Populacao[categoria_idade == "Idoso"], na.rm = TRUE),
    .groups = "drop"
  ) |> 
  
  # Calcular as razões de dependência
  mutate(
    # Razão de Dependência Jovem
    razao_dep_jovem = (pop_jovem / pop_ativa) * 100,
    
    # Razão de Dependência Idosa
    razao_dep_idosa = (pop_idosa / pop_ativa) * 100,
    
    # Razão de Dependência Total
    razao_dep_total = ((pop_jovem + pop_idosa) / pop_ativa) * 100
  )

print("Razão de Dependência por Sexo (Acre - Censo 2022):")
print(razao_dependencia_acre_2022)
