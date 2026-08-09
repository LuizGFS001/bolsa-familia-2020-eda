import pandas as pd
import streamlit as st
import plotly.express as px

meses_pt = {1: "Jan", 2: "Fev", 3: "Mar", 4: "Abr", 5: "Mai", 6: "Jun",
            7: "Jul", 8: "Ago", 9: "Set", 10: "Out", 11: "Nov", 12: "Dez"}

@st.cache_data
def carregar_kpis():
    df = pd.read_csv("data/gold/kpis_gerais.csv")
    return df

@st.cache_data
def carregar_beneficiarios_mes():
    df = pd.read_csv("data/gold/beneficiarios_por_mes.csv")
    return df

@st.cache_data
def pagamentos_por_mes():
    df = pd.read_csv("data/gold/pagamentos_por_mes.csv")
    return df

@st.cache_data
def variacao_mensal():
    df = pd.read_csv("data/gold/variacao_mensal.csv")
    return df

@st.cache_data
def carregar_pct_uf():
    df = pd.read_csv("data/gold/pct_beneficiarios_por_uf.csv")
    return df

@st.cache_data
def carregar_benecifiarios_por_regiao():
    df = pd.read_csv("data/gold/beneficiarios_por_regiao.csv")
    return df

@st.cache_data
def total_por_regiao_mes():
    df = pd.read_csv("data/gold/total_por_regiao_mes.csv")
    return df

@st.cache_data
def media_parcela_por_uf():
    df = pd.read_csv("data/gold/media_parcela_por_uf.csv")
    return df

@st.cache_data
def top20_municipios_total():
    df = pd.read_csv("data/gold/top20_municipios_total.csv")
    return df

@st.cache_data
def top20_municipios_media():
    df = pd.read_csv("data/gold/top20_municipios_media.csv")
    return df

@st.cache_data
def media_meses_recebidos():
    df = pd.read_csv("data/gold/media_meses_recebidos.csv")
    return df

@st.cache_data
def continuidade():
    df = pd.read_csv("data/gold/continuidade.csv")
    return df

@st.cache_data
def amostra_distribuicao_valores():
    df = pd.read_csv("data/gold/amostra_distribuicao_valores.csv")
    return df

df_kpis = carregar_kpis()
total_beneficiarios = df_kpis['beneficiarios_unicos'].iloc[0]
t_pagamentos = df_kpis['total_pagamentos'].iloc[0]
t_pago_reais = df_kpis['total_pago_reais'].iloc[0]
m_parcela = df_kpis['media_parcela'].iloc[0]

st.title("Bolsa Família 2020")
st.caption("Fonte: Portal da Transparência — portaldatransparencia.gov.br/download-de-dados/bolsa-familia-pagamentos")

col1, col2, col3, col4 = st.columns(4)
col1.metric(label="Total de Beneficiários", value=f"{total_beneficiarios:,.0f}".replace(",", "."))
col2.metric(label="Total de Pagamentos", value=f"{t_pagamentos / 1_000_000:.1f} milhões")
col3.metric(label="Total Pago (R$)", value=f"R$ {t_pago_reais / 1_000_000_000:.1f} bi")
col4.metric(label="Média por Parcela", value=f"R$ {m_parcela:.2f}".replace(".", ","))

df_uf_ref = carregar_pct_uf()
lista_ufs = df_uf_ref["uf"].unique()
uf_selecionada = st.sidebar.selectbox("Filtrar por estado", options=["Todos"] + list(lista_ufs))

with st.sidebar.expander("Sobre o projeto"):
    st.write("""
    Dados de pagamentos do Bolsa Família em 2020, extraídos do Portal da
    Transparência (12 arquivos mensais, ~18GB, ~160 milhões de linhas).

    Pipeline: bronze (CSVs originais) → silver (view DuckDB com limpeza) →
    gold (agregados exportados aqui no dashboard).
    """)

tab1, tab2, tab3, tab4 = st.tabs(["Visão Geral", "Geografia", "Municípios", "Perfil"])
with tab1:
    df_mes = carregar_beneficiarios_mes()
    df_mes["mes_num"] = df_mes["mes_competencia"] % 100
    df_mes["mes_nome"] = df_mes["mes_num"].map(meses_pt)
    fig = px.line(df_mes, x="mes_nome", y="beneficiarios_unicos", title="Beneficiários Únicos por Mês")
    st.plotly_chart(fig)
    

    df_mes = pagamentos_por_mes()
    df_mes["mes_num"] = df_mes["mes_competencia"] % 100
    df_mes["mes_nome"] = df_mes["mes_num"].map(meses_pt)
    fig = px.line(df_mes, x="mes_nome", y="total_pago", title="Pagamentos por Mês")
    st.plotly_chart(fig)

    df_mes = variacao_mensal()
    df_mes["mes_num"] = df_mes["mes"] % 100
    df_mes["mes_nome"] = df_mes["mes_num"].map(meses_pt)
    fig = px.line(df_mes, x="mes_nome", y="variacao_pct", title="Variação Mensal")
    st.plotly_chart(fig)
    
with tab2:
    df_uf = carregar_pct_uf()
    if uf_selecionada != "Todos":
        df_uf = df_uf[df_uf["uf"] == uf_selecionada]
    fig_uf = px.bar(df_uf, x="pct_nacional", y="uf", orientation="h",
                    title="Beneficiários por Estado (% do total nacional)")
    fig_uf.update_yaxes(autorange="reversed")
    st.plotly_chart(fig_uf, key="grafico_uf")
    
    df_regiao = carregar_benecifiarios_por_regiao()
    fig = px.pie(df_regiao, names="regiao", values="beneficiarios_unicos", title="Total por Região")
    st.plotly_chart(fig, key="grafico_pizza_regiao")
    
    df_regiao = total_por_regiao_mes()
    df_regiao["mes_num"] = df_regiao["mes_competencia"] % 100
    df_regiao["mes_nome"] = df_regiao["mes_num"].map(meses_pt)
    fig = px.line(df_regiao, x="mes_nome", y="total_pago_mi", color="regiao", title="Evolução por região ao longo do ano")
    st.plotly_chart(fig, key="grafico_regiao_mes")
    
    df_media_uf = media_parcela_por_uf()
    if uf_selecionada != "Todos":
        df_media_uf = df_media_uf[df_media_uf["uf"] == uf_selecionada]
    fig = px.bar(df_media_uf, x="media_parcela", y="uf", orientation="h", title="Valor Médio da Parcela por Estado") 
    fig.update_yaxes(autorange="reversed")
    st.plotly_chart(fig, key="grafico_media_uf")
    
with tab3:
    df_mes = top20_municipios_total()
    st.subheader("Top 20 Municípios por Total Pago")
    st.dataframe(df_mes,
                column_config={
                    "total_pago": st.column_config.NumberColumn("Total Pago", format="R$ %.0f"),
                    "media_parcela": st.column_config.NumberColumn("Média da Parcela", format="R$ %.2f"),})
    
    df_mes = top20_municipios_media()
    st.subheader("Top 20 Municípios por Média da Parcela")
    st.dataframe(df_mes,
                column_config={
                    "total_pago": st.column_config.NumberColumn("Total Pago", format="R$ %.0f"),
                    "media_parcela": st.column_config.NumberColumn("Média da Parcela", format="R$ %.2f"),})
    
with tab4:
    df_meses_resumo = media_meses_recebidos()
    media = df_meses_resumo['media_meses'].iloc[0]
    mediana = df_meses_resumo['mediana_meses'].iloc[0]
    st.subheader("Resumo de Continuidade")
    
    col1, col2 = st.columns(2)
    col1.metric(label="Média", value=f"{media:.1f} meses")
    col2.metric(label="Mediana", value=f"{mediana:.0f} meses")
    
    df_continuidade = continuidade()
    fig = px.bar(df_continuidade, x="meses_recebidos", y="beneficiarios", title="Quantos meses cada pessoa recebeu o benefício")
    st.plotly_chart(fig, key="grafico_continuidade")
    
    distribuicao = amostra_distribuicao_valores()
    fig = px.histogram(distribuicao, x="valor", title="Distribuição dos Valores")
    st.plotly_chart(fig, key="grafico_distribuicao")