-- P2. Evolução mensal do número de beneficiários únicos.
-- Salto de ~13,2M para ~14,3M em abril/2020 (pandemia Covid-19).

SELECT
    mes_competencia,
    COUNT(*)            AS pagamentos,
    COUNT(DISTINCT nis) AS beneficiarios_unicos
FROM silver
GROUP BY mes_competencia
ORDER BY mes_competencia;
