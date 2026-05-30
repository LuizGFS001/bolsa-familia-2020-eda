-- P12. Total pago por região em cada mês (base para gráfico empilhado).
-- Composição regional estável ao longo do ano. Salto de abril visível em todas as regiões.

SELECT
    mes_competencia,
    regiao,
    ROUND(SUM(valor_parcela) / 1e6, 2) AS total_pago_milhoes
FROM silver
GROUP BY mes_competencia, regiao
ORDER BY mes_competencia, regiao;
