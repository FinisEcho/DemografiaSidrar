# Análise Demográfica do Acre (2010-2022) com R
Este repositório contém os scripts e a documentação para uma análise demográfica comparativa do estado do Acre, utilizando dados dos Censos Demográficos de 2010 e 2022, disponibilizados pelo Instituto Brasileiro de Geografia e Estatística (IBGE).

O projeto foi desenvolvido como parte da disciplina de Demografia I, da graduação em Estatística da Universidade Federal da Paraíba (UFPB).

## Objetivo
O objetivo principal do trabalho é analisar a transição demográfica e o processo de envelhecimento populacional no Acre, comparando a estrutura etária do estado entre os dois últimos censos.

## Indicadores Analisados
Os seguintes indicadores demográficos foram calculados e analisados, com base na população por sexo e idade:

Idade Mediana: A idade que divide a população em duas metades iguais (50% mais jovens e 50% mais velhos).

Razão de Dependência: A proporção da população "dependente" (jovens e idosos) em relação à população em idade de trabalhar (15 a 64 anos).

Índice de Envelhecimento: A razão entre a população idosa (65+ anos) e a população jovem (0-14 anos).

Pirâmide Etária: A representação gráfica da distribuição da população por sexo e faixas etárias.

## Metodologia
A metodologia se baseia na utilização do software R e de pacotes especializados para a coleta, manipulação e visualização dos dados. Os principais pacotes utilizados são:

sidrar: Para a busca automatizada e direta dos dados das tabelas do SIDRA/IBGE.

dplyr: Para a manipulação eficiente dos dataframes.

ggplot2: Para a construção de gráficos, como a Pirâmide Etária.

Os scripts estão organizados para permitir a reprodução de toda a análise, desde a coleta dos dados até a geração dos resultados e gráficos.

## Resultados
Os resultados do projeto demonstram o avanço do processo de envelhecimento populacional no Acre, evidenciado pelo aumento da idade mediana e do índice de envelhecimento entre os censos de 2010 e 2022. A análise da Razão de Dependência revela uma mudança na composição da dependência, com uma tendência de aumento da dependência idosa. A Pirâmide Etária visualiza a redução da base (população jovem) e o alargamento do topo (população idosa), confirmando as tendências observadas nos indicadores.
