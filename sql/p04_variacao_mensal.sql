-- P4. Variação percentual mensal no total pago.
-- Pico: +7,2% em abril/2020. Restante do ano: variações abaixo de ±2%.

WITH mensal AS (
    SELECT
        mes_competencia AS mes,
        SUM(valor_parcela) AS total
    FROM silver
    GROUP BY mes_competencia
)
SELECT
    mes,
    ROUND(total, 2) AS total_pago,
    ROUND(
        100.0 * (total - LAG(total) OVER (ORDER BY mes))
              / LAG(total) OVER (ORDER BY mes),
    2) AS variacao_pct
FROM mensal
ORDER BY mes;
