-- P14. Média e mediana de meses recebidos por beneficiário.
-- Média: 11,42 meses. Mediana: 12. Confirma concentração no extremo superior.

WITH meses_por_nis AS (
    SELECT
        nis,
        COUNT(DISTINCT mes_competencia) AS meses_recebidos
    FROM silver
    GROUP BY nis
)
SELECT
    ROUND(AVG(meses_recebidos), 2)    AS media_meses,
    ROUND(MEDIAN(meses_recebidos), 0) AS mediana_meses,
    COUNT(*)                          AS total_beneficiarios
FROM meses_por_nis;
