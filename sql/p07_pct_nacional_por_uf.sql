-- P7. Participação percentual de cada estado no total nacional de beneficiários.
-- BA: 12,82%, SP: 11,47%, PE: 8,19%, MG: 7,62%, CE: 7,53%.

WITH total AS (
    SELECT COUNT(DISTINCT nis) AS n FROM silver
)
SELECT
    uf,
    COUNT(DISTINCT nis)                              AS beneficiarios,
    ROUND(100.0 * COUNT(DISTINCT nis) / MAX(total.n), 2) AS pct_nacional
FROM silver, total
GROUP BY uf
ORDER BY pct_nacional DESC;
