WITH calculo_atraso AS (
    SELECT
        id_cliente,
        categoria,
        data_pagamento,
        data_vencimento,
        DATE_DIFF(data_pagamento, data_vencimento, DAY) * 0.25 AS multa_atraso
    FROM {{ ref('compras_silver') }}
    WHERE DATE_DIFF(data_pagamento, data_vencimento, DAY) > 0
)

SELECT
    name              AS nome_cliente,
    id_cliente        AS id_cliente,
    categoria         AS id_categoria,
    SUM(multa_atraso) AS total_multa
FROM calculo_atraso AS atr
LEFT JOIN {{ ref('clientes_silver') }} AS cli
ON atr.id_cliente = cli.id
GROUP BY ALL
ORDER BY total_multa DESC, categoria DESC
