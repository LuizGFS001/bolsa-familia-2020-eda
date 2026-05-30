-- P3. Total pago em reais por mês.
-- Baseline jan-mar ~R$2,5bi, novo patamar jul-dez ~R$2,73bi.

SELECT
    mes_competencia,
    ROUND(SUM(valor_parcela), 2) AS total_pago
FROM silver
GROUP BY mes_competencia
ORDER BY mes_competencia;
