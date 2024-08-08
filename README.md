
# Documentação do Projeto Analytics Engineer - EBANX

Este projeto é responsável por transformar e analisar dados de clientes, compras e câmbio, utilizando uma arquitetura de camadas - medalhão (bronze, silver e gold). O objetivo é garantir a qualidade dos dados e responder a perguntas de negócios específicas.

## Estrutura do Projeto

### Camada Raw

Criada com o objetivo de armazenar, apenas, os arquivos dentro de um schema inicial dentro do BigQuery. Essa camada não está orquestrada no DBT; a utilidade dela é fornecer os dados para a camada Bronze que, por sua vez, será orquestrada dentro do DBT para a criação da lineage do projeto.

### Camada Bronze

As tabelas na camada bronze consomem diretamente as tabelas raw do schema Raw e são materializadas de forma incremental. Não possuem transformação.

**Arquivos:**

- `models/bronze/clientes_bronze.sql`
- `models/bronze/compras_bronze.sql`
- `models/bronze/cambio_bronze.sql`

### Camada Silver

A camada silver transforma os dados brutos da camada bronze, faz transformações intermediárias e padroniza linhas e colunas. As tabelas nessa camada foram materializadas como views.

**Arquivo:**

- `models/silver/compras_silver.sql`
- `models/silver/cambio_silver.sql`
- `models/silver/clientes_silver.sql`

### Camada Gold

A camada gold aplica transformações finais e gera tabelas analíticas que respondem a perguntas de negócios específicas. As tabelas nessa camada foram materializadas como tables.

**Arquivos:**

- `models/gold/categoria_pagamentos_mais_atrasados.sql`
- `models/gold/clientes_maiores_valores_dolar.sql`
- `models/gold/lista_categorias_cliente.sql`
- `models/gold/lista_multa_atrasos.sql`
- `models/gold/pagamentos_pendentes_categoria.sql`

## Testes de Dados

Os testes garantem a qualidade e a consistência dos dados nas camadas silver, com o objetivo de verificar se as transformações foram eficazes. Os testes estão definidos no arquivo `schema.yml`.

### Exemplo de Testes

- Unicidade e não-nulidade de chaves primárias.
- Verificação de colunas essenciais não nulas.
- Testes customizados para regras de negócios.

### Estrutura do Arquivo `schema.yml`

```yaml
version: 2

models:
    - name: clientes_silver
      description: "Tabela de clientes do schema bronze, com transformações"
      columns:
          - name: id
            description: "Chave primária da tabela (id do cliente)"
            tests:
                - unique
                - not_null

    - name: compras_silver
      description: "Tabela de compras do schema silver, com transformações"
      columns:
          - name: id
            description: "Chave primária da tabela (id da compra)"
            tests:
                - unique
                - not_null
          - name: id_cliente
            description: "ID do cliente que realizou a compra"
            tests:
                - not_null
    - name: cambio_silver
      description: "Tabela de cambio do schema silver, com transformações"
      columns:
          - name: id_mes
            description: "Chave primária da tabela (id do mes)"
            tests:
                - unique
                - not_null
          - name: mes
            description: "Mês que dá origem ao id_mes"
            tests:
                - not_null
                - unique
          
```

## Executando o Projeto

Para executar o projeto e os testes, é necessário utilizar os seguintes comandos:

```bash
dbt run
dbt test
```

