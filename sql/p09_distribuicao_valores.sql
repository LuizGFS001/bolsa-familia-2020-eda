-- P9. Amostra para histograma de distribuição dos valores de parcela.
-- Distribuição multimodal: picos em R$89, R$171, R$205 refletem faixas do programa.

SELECT valor_parcela AS valor
FROM silver
USING SAMPLE 500000;
