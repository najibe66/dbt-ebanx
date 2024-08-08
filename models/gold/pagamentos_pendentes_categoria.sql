WITH valor_pendente_dolar AS (
  SELECT 
    categoria,
    ROUND(SUM(valor_dolar), 2) AS total_valor_dolar_pendente,
    RANK() OVER (ORDER BY ROUND(SUM(valor_dolar), 2) DESC) AS ranking
  FROM {{ ref('compras_silver') }}
  WHERE status = 'Pendente'
  GROUP BY categoria
)

SELECT * 
FROM valor_pendente_dolar
WHERE ranking = 1
