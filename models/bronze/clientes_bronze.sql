{{ config(
    materialized='incremental',
    unique_key='id'
) }}
SELECT
    id,
    name,
    pais,
    `data nascimento`,
    updated_at
FROM `case-ebanx.raw.clientes_raw`
    {% if is_incremental() %}
    WHERE updated_at > (SELECT MAX(updated_at) FROM {{ this }})
    {% endif %}

