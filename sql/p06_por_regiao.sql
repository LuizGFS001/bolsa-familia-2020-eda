-- P6. Beneficiários únicos, total pago e parcela média por região.
-- Nordeste: 49,4% dos beneficiários, 51,1% do gasto. Norte: maior parcela média (R$210).

SELECT
    regiao,
    COUNT(DISTINCT nis)                AS beneficiarios_unicos,
    ROUND(SUM(valor_parcela) / 1e9, 2) AS total_pago_bilhoes,
    ROUND(AVG(valor_parcela), 2)       AS media_parcela
FROM silver
GROUP BY regiao
ORDER BY beneficiarios_unicos DESC;
