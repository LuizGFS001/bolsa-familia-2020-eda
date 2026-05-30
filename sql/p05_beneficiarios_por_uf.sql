-- P5. Beneficiários únicos e total pago por estado.
-- Top: BA (1,89M), SP (1,69M), PE (1,21M), MG (1,12M), CE (1,11M).

SELECT
    uf,
    COUNT(DISTINCT nis)          AS beneficiarios_unicos,
    ROUND(SUM(valor_parcela), 2) AS total_pago
FROM silver
GROUP BY uf
ORDER BY beneficiarios_unicos DESC;
