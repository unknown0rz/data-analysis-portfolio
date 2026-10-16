--title:カテゴリ別売上・購入数・平均単価
--条件：2017年1月～2018年8月までの期間（2016年と2018年の9月以降のデータは除外）
--　　　order_statusがdeliveredのデータのみを対象

WITH category AS (
SELECT
  ROUND(SUM(i.price),0) AS total_sales,
  p.product_category_name,
  COUNT(p.product_category_name) AS cnt_purchase,
  ROUND(AVG(i.price),0) AS avg_price
FROM
  `thelook-ecommerce-502702.olist.orders` AS o
  JOIN `thelook-ecommerce-502702.olist.items` AS i
  ON o.order_id = i.order_id
  JOIN `thelook-ecommerce-502702.olist.products` AS p
  ON i.product_id = p.product_id
WHERE
  o.order_purchase_timestamp >= '2017-01-01'
  AND o.order_purchase_timestamp < '2018-09-01'
  AND o.order_status = 'delivered'
GROUP BY
  p.product_category_name
ORDER BY
  total_sales DESC
LIMIT 10
)

SELECT
  total_sales,
  cnt_purchase,
  avg_price,

  CASE
    WHEN product_category_name = 'beleza_saude' THEN '美容・健康'
    WHEN product_category_name = 'relogios_presentes' THEN '腕時計・ギフト'
    WHEN product_category_name = 'cama_mesa_banho' THEN '寝具・タオル・バス用品'
    WHEN product_category_name = 'esporte_lazer' THEN 'スポーツ・レジャー'
    WHEN product_category_name = 'informatica_acessorios' THEN 'パソコン・周辺機器'
    WHEN product_category_name = 'moveis_decoracao' THEN '家具・インテリア'
    WHEN product_category_name = 'utilidades_domesticas' THEN '生活雑貨'
    WHEN product_category_name = 'cool_stuff' THEN 'おもしろグッズ・雑貨'
    WHEN product_category_name = 'automotivo' THEN 'カー用品'
    WHEN product_category_name = 'ferramentas_jardim' THEN '工具・ガーデン用品'
    ELSE product_category_name
  END AS language_jpn
FROM
  category
ORDER BY
  total_sales DESC