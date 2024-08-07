{{
    config(
        unique_key= 'mes'
    )
}}
SELECT
    REGEXP_REPLACE(NORMALIZE(`Mês`, NFD), r'\pM', '') AS mes,
    ROUND(SAFE_CAST(brl AS FLOAT64), 2)               AS brl,
    ROUND(SAFE_CAST(eur AS FLOAT64), 2)               AS eur,
    ROUND(SAFE_CAST(cny AS FLOAT64), 2)               AS cny,
    ROUND(SAFE_CAST(egp AS FLOAT64), 2)               AS egp,
    ROUND(SAFE_CAST(krw AS FLOAT64), 2)               AS krw,
    ROUND(SAFE_CAST(clp AS FLOAT64), 2)               AS clp,
    ROUND(SAFE_CAST(mxn AS FLOAT64), 2)               AS mxn
FROM {{ ref('cambio_bronze') }}
  {% if is_incremental() %}
  WHERE REGEXP_REPLACE(NORMALIZE(`Mês`, NFD), r'\pM', '') NOT IN (SELECT mes FROM {{ this }})
  {% endif %}

