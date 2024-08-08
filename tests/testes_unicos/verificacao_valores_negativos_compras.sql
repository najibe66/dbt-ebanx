SELECT id 
FROM 
{{ ref('compras_silver')}}
WHERE valor < 0 