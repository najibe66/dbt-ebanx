WITH data_atualizacao AS (
    SELECT
        id,
        name,
        pais,
        `data nascimento`,
        updated_at,
        ROW_NUMBER() OVER (PARTITION BY id ORDER BY updated_at DESC) AS data_atualizacao_mais_recente
    FROM {{ ref('clientes_bronze') }}
)


SELECT
    COALESCE(CAST(id AS STRING), 'nao informado')                                 AS id,
    COALESCE(REGEXP_REPLACE(NORMALIZE(`name`, NFD), r'\pM', ''), 'nao informado') AS name,
    COALESCE(REGEXP_REPLACE(NORMALIZE(`pais`, NFD), r'\pM', ''), 'nao informado') AS pais,
    CASE
        WHEN
            REGEXP_CONTAINS(`data nascimento`, r'^\d{2}/\d{2}/\d{4}$')
            THEN PARSE_DATE('%d/%m/%Y', `data nascimento`)
        WHEN
            REGEXP_CONTAINS(`data nascimento`, r'^\d{4}-\d{2}-\d{2}$')
            THEN PARSE_DATE('%Y-%m-%d', `data nascimento`)
        ELSE NULL
    END                                                                          AS data_nascimento,
    SAFE_CAST(updated_at AS TIMESTAMP)                                           AS updated_at
FROM data_atualizacao
WHERE data_atualizacao_mais_recente = 1

