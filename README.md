# Bolsa Família 2020 — Análise Exploratória de Dados

Análise dos pagamentos do programa Bolsa Família ao longo de 2020 usando dados abertos do governo federal brasileiro. O projeto processa **~160 milhões de registros (17,6 GB)** com DuckDB e extrai insights sobre cobertura, distribuição regional e o impacto da pandemia de Covid-19 no programa.

---

## Principais Achados

1. **A pandemia está visível nos dados** — o total pago saltou +7,2% em abril de 2020 (mês do lockdown nacional) e nunca voltou ao patamar anterior. Foram ~1,2M de novas famílias incluídas de forma permanente.

2. **Nordeste domina em volume, Norte em intensidade** — o Nordeste concentra 49,4% dos beneficiários e 51,1% do gasto. Já o Norte tem a maior parcela média regional (R$ 210/família), refletindo famílias maiores e pobreza mais profunda.

3. **O programa é mais distribuído do que parece** — os top 5 estados concentram apenas 46% do gasto total, indicando calibração pela incidência de pobreza, não por peso político.

4. **Municípios indígenas amazônicos lideram em parcela média** — Uiramutã (RR) registra R$ 445 por parcela, 2,3× a média nacional. O top 20 é dominado por municípios do Acre, Amazonas e Roraima.

5. **86,8% dos beneficiários receberam em todos os 12 meses** — o Bolsa Família foi renda permanente, não eventual, para 12,7 milhões de famílias em 2020.

---

## Dataset

| Atributo | Detalhe |
|---|---|
| Fonte | [Portal da Transparência — Bolsa Família Pagamentos](https://portaldatransparencia.gov.br/download-de-dados/bolsa-familia-pagamentos) |
| Período | Janeiro–Dezembro 2020 (12 arquivos mensais) |
| Volume | ~17,6 GB, ~160 milhões de linhas |
| Formato | CSV com separador `;`, decimal `,`, encoding Latin-1 |

> Os CSVs brutos não estão incluídos no repositório. Baixe os 12 arquivos de 2020 no Portal da Transparência e coloque em `data/bronze/`.

---

## Stack

| Camada | Tecnologia | Motivo |
|---|---|---|
| Query engine | **DuckDB** | Lê CSV direto sem carregar em memória, SQL analítico nativo |
| Análise | **Python + Pandas** | Manipulação de DataFrames |
| Visualização | **Matplotlib + Seaborn** | Gráficos para o notebook |
| Notebook | **Jupyter** | Formato padrão de portfólio |

---

## Estrutura do Projeto

```
bolsa-familia-2020/
├── data/
│   ├── bronze/    → CSVs brutos do Portal da Transparência (não versionados, 17 GB)
│   ├── silver/    → não materializado — silver é uma DuckDB VIEW gerada em tempo de execução
│   └── gold/      → resultados agregados: 9 CSVs + 13 PNGs
├── notebooks/
│   └── 01-EDA.ipynb   → notebook principal com 15 perguntas de análise
├── sql/
│   ├── silver_view.sql → definição da view de limpeza (DuckDB)
│   └── p01_*.sql … p15_*.sql → queries de análise documentadas
└── README.md
```

### Arquitetura bronze → silver → gold

- **Bronze:** CSVs brutos, sem modificação. Fonte imutável.
- **Silver:** View DuckDB criada em tempo de execução — normaliza colunas (snake_case), converte `VALOR PARCELA` de string BR para `DOUBLE` e deriva a coluna `regiao` a partir da UF. Não é materializada em disco para evitar duplicar 17 GB.
- **Gold:** Resultados das 15 queries exportados como CSV e PNG.

---

## Visualização

O notebook completo pode ser visualizado sem instalação pelo NBViewer:

[Abrir 01-EDA.ipynb no NBViewer](https://nbviewer.org/github/LuizGFS001/bolsa-familia-2020-eda/blob/main/notebooks/01-EDA.ipynb)

---

## Como Executar

### Requisitos

```bash
pip install duckdb pandas matplotlib seaborn jupyter
```

### Dados

Baixe os 12 arquivos mensais de 2020 em:
https://portaldatransparencia.gov.br/download-de-dados/bolsa-familia-pagamentos

Coloque todos em `data/bronze/`.

### Rodar o notebook

```bash
jupyter notebook notebooks/01-EDA.ipynb
```

Execute todas as células em ordem (Kernel → Restart & Run All). Os resultados serão exportados automaticamente para `data/gold/`.

> **Tempo estimado:** 30–60 minutos dependendo do hardware (leitura e processamento de 17 GB via DuckDB).

---

## Perguntas Respondidas

| # | Pergunta |
|---|---|
| P1 | Volume total: beneficiários, pagamentos e gasto em 2020 |
| P2 | Evolução mensal do número de beneficiários |
| P3 | Evolução mensal do total pago (R$) |
| P4 | Variação percentual mensal no total pago |
| P5 | Estados com mais beneficiários únicos |
| P6 | Distribuição por região (beneficiários e gasto) |
| P7 | Participação de cada estado no total nacional |
| P8 | Valor médio de parcela por estado |
| P9 | Distribuição dos valores de parcela (histograma) |
| P10 | Top 20 municípios por total pago |
| P11 | Top 20 municípios por parcela média (mín. 1.000 pagamentos) |
| P12 | Total pago por região em cada mês (evolução empilhada) |
| P13 | Distribuição de meses recebidos por beneficiário |
| P14 | Média e mediana de meses recebidos |
| P15 | Concentração do gasto por estado (% do total nacional) |
