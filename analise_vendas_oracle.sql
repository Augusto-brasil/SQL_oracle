
SELECT * FROM orders where rownum < 11;
SELECT * FROM customer where rownum < 11;
SELECT * FROM product where rownum < 11;
SELECT * FROM localization where rownum > 11

SELECT
*
FROM orders o INNER JOIN product p ON (o.product_id = p.product_id)
              INNER JOIN customer c ON (o.customer_id = c.customer_id)
              INNER JOIN localization l ON (o.order_id = l.order_id)
WHERE ROWNUM < 11; 


SELECT * FROM product where rownum < 111;

SELECT count( distinct category) FROM product 
--ANALISE DE PRODUTOS
SELECT category FROM product group by CATEGORY
--- a empresa superstore trabalha com 03 categorias de produtos ( tecnologia( Technology ), mobilia( furniture ) e material de escritorio( Office Supplies )
SELECT sub_category FROM product where category = 'Office Supplies' group by sub_category;
-- as categorias se subdividem em 4 de mobbilia, 4 de tecnologia e  9 de materias de escritorio
SELECT count( distinct product_id) FROM product
-- sua variadade de a superstore conta com 1.862 produtos


--ANALISE DE CLIENTES
SELECT * FROM customer where rownum < 11;

SELECT COUNT( DISTINCT CUSTOMER_ID) FROM customer; 
select segment from customer group by segment;
---- Hoje a empresa conta com 793 clientes cadastrados, divididos em 03 segmentos ( Home Office, Corporate e Consumer
select segment as segmento, count( distinct customer_name)as total_cliente from customer group by segment order by total_cliente DESC ;
-- o segmento que mais possui clientes cadastrado e de consumidor com 409 clientes.



CREATE VIEW vendas_regiao as
  SELECT 
    b.region as regiao,
    b.state as estado,
    b.city as cidade,
    a. sales as vendas
  FROM orders a INNER JOIN localization b ON (a.order_id = b.order_id);
 -- agora criaremos um view de vendas por regiao, estado e cidade. Pois o Ceo quer acompanhar periodicamente estes numeros, entao será uma nalise constante, assim facilitamos nossa consulta 



SELECT 
  REGIAO,
  sum(VENDAS) as vendas
FROM VENDAS_REGIAO
group by regiao
order by vendas desc;
-- aqui vemos as  vendas por regiao ordenada do maior para menos venda  

select
  estado,
  sum(vendas)as venda
from vendas_regiao 
group by estado
ORDER BY venda DESC
-- aqui vemos as  vendas por estado ordenada do maior para menos venda  

select
  CIDADE,
  sum(vendas) as VENDAS
from vendas_regiao 
group by CIDADE
ORDER BY VENDAS DESC
-- aqui vemos as  vendas por cidade ordenada do maior para menos venda 




--usando CTE
CREATE VIEW top_03_regiao as 
  with vd_regiao_e_uf as (
    SELECT 
      regiao,
      estado,
      sum (vendas) as receita
    FROM vendas_regiao
    GROUP BY regiao, estado
    ORDER BY regiao, receita DESC
  ), cte_row_number as (
    select 
      regiao,
      estado,
      receita,
      ROW_NUMBER() OVER (partition by regiao ORDER BY receita DESC) as rn
    from vd_regiao_e_uf
  )
  select 
  dense_rank() OVER (PARTITION BY regiao order by receita DESC) AS Rk,
  regiao, estado, receita 
  from cte_row_number WHERE rn IN ( 1,2,3 ) 
  --top 03 por regiao







-- usando SubQuery
SELECT 
regiao, estado, receita, 
RANK() OVER( PARTITION BY regiao ORDER BY receita DESC) as rk_vd
FROM (
  SELECT 
    regiao,
    estado,
    sum(vendas) as receita
  FROM vendas_regiao
  group by regiao, estado
)
ORDER BY regiao, receita DESC




SELECT 
regiao,
estado,
sum(vendas) as receita
FROM vendas_regiao
group by regiao, estado
