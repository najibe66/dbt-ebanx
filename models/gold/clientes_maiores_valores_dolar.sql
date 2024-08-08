WITH ranking_compras AS (
    SELECT
        c.id_cliente,
        c.id AS id_compra,
        cl.name AS nome_cliente,
        cl.pais AS nacionalidade,
        c.valor_dolar AS total_valor_dolar,
        RANK() OVER (ORDER BY c.valor_dolar DESC) AS ranking
    FROM {{ ref('compras_silver') }} AS c
    LEFT JOIN {{ ref('clientes_silver') }} AS cl
        ON c.id_cliente = cl.id
    WHERE c.status = 'Pago'
)


SELECT
    nome_cliente,
    nacionalidade,
    id_compra,
    total_valor_dolar
FROM ranking_compras
WHERE ranking <= 5
ORDER BY ranking
