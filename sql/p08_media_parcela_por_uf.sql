-- P8. Valor médio e mediano da parcela por estado.
-- AC: R$272 (maior), RO: R$155 (menor). Variação reflete composição familiar, não arbitrariedade.

SELECT
    uf,
    ROUND(AVG(valor_parcela), 2)    AS media_parcela,
    ROUND(MEDIAN(valor_parcela), 2) AS mediana_parcela,
    COUNT(*)                        AS pagamentos
FROM silver
GROUP BY uf
ORDER BY media_parcela DESC;
