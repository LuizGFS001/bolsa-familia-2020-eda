-- P1. Volume total de beneficiários e pagamentos em 2020.
-- Resultado: 168M pagamentos, 14,7M beneficiários únicos, R$32bi, média R$190.

SELECT
    COUNT(*)                     AS total_pagamentos,
    COUNT(DISTINCT nis)          AS beneficiarios_unicos,
    ROUND(SUM(valor_parcela), 2) AS total_pago_reais,
    ROUND(AVG(valor_parcela), 2) AS media_parcela
FROM silver;
