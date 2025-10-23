# Desafio - Modelagem Lógica de Banco de Dados (E-commerce)
## Objetivo
reproduzir a modelagem lógicaa de um cenário de ecommerce com regras:
- Clientes podem ser pessoa física ou pessoa jurídica. Uma conta **não** pode ter ambos os dados simultaneamnete.
- Um cliente pode possuir vários formas de pagamento cadastradas.
- entregas possuem status e códigos de rastreio.
- Mapear relacionamentos N:N (produtos, fornecedores, pedidos)
- Criar script SQL de criação de schema, insets de exemplo e queries para testes.

## Conteúdo do repositório 
- `ecommerce_schema.sql` Script completo (criação de banco, tabelas, constraints e insets de exemplo).
- `queries_exemples.sql` Queries de exemplo : SELECT, WHERE, devired attributes,  ORDER BY, HAVING, JOINs.

## Como rodar localmente 
1. abra o mysql workbench
2. Crie/execute o script `ecommerce_schema.sql`
3. Verifique tabelas e dados com ´select *from product limit 10´

## Perguntas que as queries respondem
- Quantos pedidos foram feitos por cada cliente ?
- Algum vendedor também é fornecedor ?
- Relação de produto, fornecedor e estoque.
- Relação de nomes de fornecedores e nomes de produtos.
- Top produtos vendidos por quantidade e receitas.

## Observações 
- A restrição PF/PJ foi implementada com `CHECK` para garantir que exatamente um dos campos (`person_id` ou `company_id`) esteja preenchido
- Relação N:N foram mapeadas comtabelas intermediárias (`product_supplier`, `order_item`).

## Autor
Glauciene de Sousa Luminato Silva
glaucienedesousaluminato@gmail.com
  ##
