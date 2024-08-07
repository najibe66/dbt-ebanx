{{
  config(
    unique_key='id' 
  )
}}
SELECT
    COALESCE(CAST(id AS STRING), 'nao informado')           AS id,
    COALESCE(CAST(id_cliente AS STRING), 'nao informado')   AS id_cliente,
    SAFE_CAST(data_vencimento AS DATE)                      AS data_vencimento,
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
    SAFE_CAST(updated_at AS TIMESTAMP)                      AS updated_at
FROM {{ ref('compras_bronze') }}
{% if is_incremental() %}
WHERE updated_at > (SELECT MAX(updated_at) FROM {{ this }})
{% endif %}

