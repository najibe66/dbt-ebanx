SELECT 
    cl.name                                AS nome_cliente,
    STRING_AGG(DISTINCT c.categoria, ', ') AS categorias_compradas
FROM {{ ref('clientes_silver') }} cl
JOIN {{ ref('compras_silver') }} c
ON cl.id = c.id_cliente
GROUP BY cl.name