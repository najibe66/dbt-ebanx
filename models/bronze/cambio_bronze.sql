{{ config(
    materialized='incremental',
    unique_key='id_mes'
) }}
SELECT
    CASE
        WHEN `Mês` = 'Janeiro' THEN 1
        WHEN `Mês` = 'Fevereiro' THEN 2
        WHEN `Mês` = 'Março' THEN 3
        WHEN `Mês` = 'Abril' THEN 4
        WHEN `Mês` = 'Maio' THEN 5
        WHEN `Mês` = 'Junho' THEN 6
        WHEN `Mês` = 'Julho' THEN 7
        WHEN `Mês` = 'Agosto' THEN 8
        WHEN `Mês` = 'Setembro' THEN 9
        WHEN `Mês` = 'Outubro' THEN 10
        WHEN `Mês` = 'Novembro' THEN 11
        WHEN `Mês` = 'Dezembro' THEN 12
        ELSE 0
    END AS id_mes,
    `Mês`,
    BRL,
    EUR,
    CNY,
    EGP,
    KRW,
    CLP,
    MXN,
    updated_at
FROM `case-ebanx.raw.cambio_raw`
    {% if is_incremental() %}
    WHERE updated_at > (SELECT MAX(updated_at) FROM {{ this }})
    {% endif %}

