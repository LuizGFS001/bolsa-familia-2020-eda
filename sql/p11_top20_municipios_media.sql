-- P11. Top 20 municípios por parcela média (mín. 1.000 pagamentos no ano).
-- Uiramutã (RR): R$445 — 2,3x a média nacional. Top 20 dominado por municípios indígenas amazônicos.

SELECT
    municipio,
    uf,
    COUNT(*)                     AS pagamentos,
    ROUND(AVG(valor_parcela), 2) AS media_parcela
FROM silver
GROUP BY municipio, uf
HAVING pagamentos >= 1000
ORDER BY media_parcela DESC
LIMIT 20;
