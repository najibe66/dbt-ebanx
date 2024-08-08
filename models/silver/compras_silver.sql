SELECT
    COALESCE(CAST(id AS STRING), 'nao informado')           AS id,
    COALESCE(CAST(id_cliente AS STRING), 'nao informado')   AS id_cliente,
    SAFE_CAST(data_vencimento AS DATE) AS data_vencimento,
    CASE
        WHEN
            REGEXP_CONTAINS(data_pagamento, r'^\d{4}-\d{2}-\d{2}$')
            THEN PARSE_DATE('%Y-%m-%d', data_pagamento)
        WHEN
            REGEXP_CONTAINS(data_pagamento, r'^\d{2}-\d{2}-\d{4}$')
            THEN PARSE_DATE('%d-%m-%Y', data_pagamento)
    END                                                     AS data_pagamento,
    COALESCE(valor, 0.0)                                    AS valor,
    REGEXP_REPLACE(NORMALIZE(`categoria`, NFD), r'\pM', '') AS categoria,
    COALESCE(moeda, 'nao informado')                        AS moeda,
    COALESCE(status, 'nao informado')                       AS status,
    SAFE_CAST(c.updated_at AS TIMESTAMP)                    AS updated_at,
    CASE
        WHEN c.moeda = 'BRL' THEN ROUND(SAFE_DIVIDE(c.valor, ca.brl), 2)
        WHEN c.moeda = 'EUR' THEN ROUND(SAFE_DIVIDE(c.valor, ca.eur), 2)
        WHEN c.moeda = 'CNY' THEN ROUND(SAFE_DIVIDE(c.valor, ca.cny), 2)
        WHEN c.moeda = 'EGP' THEN ROUND(SAFE_DIVIDE(c.valor, ca.egp), 2)
        WHEN c.moeda = 'KRW' THEN ROUND(SAFE_DIVIDE(c.valor, ca.krw), 2)
        WHEN c.moeda = 'CLP' THEN ROUND(SAFE_DIVIDE(c.valor, ca.clp), 2)
        WHEN c.moeda = 'MXN' THEN ROUND(SAFE_DIVIDE(c.valor, ca.mxn), 2)
        ELSE c.valor
    END                                                     AS valor_dolar
FROM {{ ref('compras_bronze') }} AS c
LEFT JOIN {{ ref('cambio_bronze') }} AS ca
    ON EXTRACT(MONTH FROM c.data_vencimento) = ca.id_mes

