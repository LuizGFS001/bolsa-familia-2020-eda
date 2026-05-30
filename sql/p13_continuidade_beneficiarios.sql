-- P13. Distribuição de quantos meses cada beneficiário recebeu em 2020.
-- 86,8% receberam todos os 12 meses — BF foi renda permanente, não eventual.

WITH meses_por_nis AS (
    SELECT
        nis,
        COUNT(DISTINCT mes_competencia) AS meses_recebidos
    FROM silver
    GROUP BY nis
)
SELECT
    meses_recebidos,
    COUNT(*) AS beneficiarios,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct
FROM meses_por_nis
GROUP BY meses_recebidos
ORDER BY meses_recebidos;
