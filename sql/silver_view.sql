-- View silver: normaliza colunas, converte tipos e adiciona coluna regiao.
-- Executar sobre os CSVs brutos em bronze/.
-- DuckDB: substituir <bronze_path> pelo caminho real dos CSVs.

CREATE OR REPLACE VIEW silver AS
SELECT
    "MÊS COMPETÊNCIA"                                      AS mes_competencia,
    "MÊS REFERÊNCIA"                                       AS mes_referencia,
    TRIM("UF")                                             AS uf,
    "CÓDIGO MUNICÍPIO SIAFI"                               AS cod_municipio,
    TRIM("NOME MUNICÍPIO")                                 AS municipio,
    "NIS FAVORECIDO"                                       AS nis,
    "NOME FAVORECIDO"                                      AS nome_favorecido,
    TRY_CAST(
        REPLACE(REPLACE("VALOR PARCELA", '.', ''), ',', '.') AS DOUBLE
    )                                                      AS valor_parcela,
    CASE TRIM("UF")
        WHEN 'AM' THEN 'Norte'        WHEN 'PA' THEN 'Norte'
        WHEN 'AC' THEN 'Norte'        WHEN 'RO' THEN 'Norte'
        WHEN 'RR' THEN 'Norte'        WHEN 'AP' THEN 'Norte'
        WHEN 'TO' THEN 'Norte'
        WHEN 'MA' THEN 'Nordeste'     WHEN 'PI' THEN 'Nordeste'
        WHEN 'CE' THEN 'Nordeste'     WHEN 'RN' THEN 'Nordeste'
        WHEN 'PB' THEN 'Nordeste'     WHEN 'PE' THEN 'Nordeste'
        WHEN 'AL' THEN 'Nordeste'     WHEN 'SE' THEN 'Nordeste'
        WHEN 'BA' THEN 'Nordeste'
        WHEN 'MT' THEN 'Centro-Oeste' WHEN 'MS' THEN 'Centro-Oeste'
        WHEN 'GO' THEN 'Centro-Oeste' WHEN 'DF' THEN 'Centro-Oeste'
        WHEN 'MG' THEN 'Sudeste'      WHEN 'ES' THEN 'Sudeste'
        WHEN 'RJ' THEN 'Sudeste'      WHEN 'SP' THEN 'Sudeste'
        WHEN 'PR' THEN 'Sul'          WHEN 'SC' THEN 'Sul'
        WHEN 'RS' THEN 'Sul'
        ELSE 'Outro'
    END                                                    AS regiao
FROM read_csv(
    '<bronze_path>/*.csv',
    delim         = ';',
    header        = true,
    encoding      = 'latin-1',
    ignore_errors = true
)
WHERE "VALOR PARCELA" IS NOT NULL
  AND TRIM("UF") != '';
