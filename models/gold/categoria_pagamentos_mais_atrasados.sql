WITH pagamentos_atrasados AS (
    SELECT
        categoria,
        DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS ranking,
        COUNT(*)                                   AS quantidade_pagamentos_atrasados
    FROM {{ ref('compras_silver') }}
    WHERE data_pagamento > data_vencimento
    --AND data_pagamento IS NOT NULL
    GROUP BY ALL
    ORDER BY quantidade_pagamentos_atrasados DESC
)


SELECT * FROM pagamentos_atrasados
WHERE ranking = 1
