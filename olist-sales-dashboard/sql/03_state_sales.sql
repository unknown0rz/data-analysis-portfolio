
--title:地域別売上・購入数・平均単価
--条件：2017年1月～2018年8月までの期間（2016年と2018年の9月以降のデータは除外）
--　　　order_statusがdeliveredのデータのみを対象

WITH customer AS (
SELECT
  c.customer_state,
  ROUND(SUM(i.price),0) AS total_sales,
  COUNT(DISTINCT o.order_id) AS cnt_orders,

  ROUND(
    SAFE_DIVIDE(
      SUM(i.price),COUNT(DISTINCT o.order_id)
    ),0
  ) AS AOV,

  ROUND(
    SAFE_DIVIDE(
      SUM(i.freight_value),COUNT(DISTINCT o.order_id)
    ),0
  ) AS ASF
FROM
  `thelook-ecommerce-502702.olist.items` AS i
  JOIN `thelook-ecommerce-502702.olist.orders` AS o
  ON i.order_id = o.order_id
  JOIN `thelook-ecommerce-502702.olist.customers` AS c
  ON o.customer_id = c.customer_id
WHERE
  o.order_purchase_timestamp >= '2017-01-01'
  AND o.order_purchase_timestamp < '2018-09-01'
  AND o.order_status = 'delivered'
GROUP BY
  c.customer_state
ORDER BY
  total_sales DESC
LIMIT 10
)

SELECT
  total_sales,
  cnt_orders,
  AOV,
  ASF,

  CASE
    WHEN customer_state = 'SP' THEN 'サンパウロ州(SP)'
    WHEN customer_state = 'RJ' THEN 'リオデジャネイロ州(RJ)'
    WHEN customer_state = 'MG' THEN 'ミナスジェライス州(MG)'
    WHEN customer_state = 'RS' THEN 'リオグランデ・ド・スル州(RS)'
    WHEN customer_state = 'PR' THEN 'パラナ州(PR)'
    WHEN customer_state = 'SC' THEN 'サンタカリナ州(SC)'
    WHEN customer_state = 'BA' THEN 'バイーア州(BA)'
    WHEN customer_state = 'DF' THEN 'ブラジリア(DF)'
    WHEN customer_state = 'GO' THEN 'ゴイアス州(GO)'
    WHEN customer_state = 'ES' THEN 'エスピリトサント州(ES)'
    ELSE customer_state
  END AS state
FROM
  customer
ORDER BY
  total_sales DESC