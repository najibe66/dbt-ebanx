SELECT
    id,
    id_cliente,
    data_vencimento,
    data_pagamento,
    valor,
    categoria,
    moeda,
    status,
    updated_at
FROM `case-ebanx.bronze.compras`
