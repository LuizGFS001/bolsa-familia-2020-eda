-- P10. Top 20 municípios por total pago no ano.
-- São Paulo: R$889M, Rio de Janeiro: R$548M, Fortaleza: R$468M.

SELECT
    municipio,
    uf,
    COUNT(*)                     AS pagamentos,
    ROUND(SUM(valor_parcela), 2) AS total_pago,
    ROUND(AVG(valor_parcela), 2) AS media_parcela
FROM silver
GROUP BY municipio, uf
ORDER BY total_pago DESC
LIMIT 20;
