{{ config(
    materialized='incremental',
    unique_key='id'
) }}
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
FROM `case-ebanx.raw.compras_raw`
    {% if is_incremental() %}
    WHERE updated_at > (SELECT MAX(updated_at) FROM {{ this }})
    {% endif %}

