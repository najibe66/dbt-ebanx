WITH ranking_compras AS (
    SELECT
        c.id_cliente                             AS id_cliente,
        cl.name                                  AS nome_cliente,
        cl.pais                                  AS nacionalidade,
        SUM(c.valor)                             AS total_valor_dolar,
        RANK() OVER (ORDER BY SUM(c.valor) DESC) AS ranking
    FROM {{ ref('compras_silver') }} AS c
    LEFT JOIN {{ ref('clientes_silver') }} AS cl
        ON c.id_cliente = cl.id
    WHERE
        c.moeda = 'USD'
        AND c.status = 'Pago'
    GROUP BY ALL
)


SELECT * FROM ranking_compras
WHERE ranking <= 5
ORDER BY ranking 
