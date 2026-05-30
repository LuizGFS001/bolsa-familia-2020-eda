-- P15. Concentração do gasto nacional por estado (%).
-- Top 5 estados = 46,4% do total — programa mais distribuído do que parece.

WITH total AS (
    SELECT SUM(valor_parcela) AS grand_total FROM silver
)
SELECT
    uf,
    regiao,
    ROUND(SUM(valor_parcela) / 1e9, 2)                        AS total_pago_bilhoes,
    ROUND(100.0 * SUM(valor_parcela) / MAX(total.grand_total), 2) AS pct_nacional
FROM silver, total
GROUP BY uf, regiao
ORDER BY pct_nacional DESC;
