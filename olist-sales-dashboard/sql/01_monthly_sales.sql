--title:月次売上・増減率
--条件：2017年1月～2018年8月までの期間（2016年と2018年の9月以降のデータは除外）
--　　　order_statusがdeliveredのデータのみを対象

WITH month AS (
SELECT
  DATE_TRUNC(o.order_purchase_timestamp,MONTH) AS order_month,
  COUNT(DISTINCT i.order_id) AS order_count,
  ROUND(SUM(i.price),0) AS sales
FROM
  `thelook-ecommerce-502702.olist.orders` AS o
  JOIN `thelook-ecommerce-502702.olist.items` AS i
  ON o.order_id = i.order_id
WHERE
  o.order_status = 'delivered'
  AND o.order_purchase_timestamp >= '2017-01-01'
  AND o.order_purchase_timestamp < '2018-09-01'
GROUP BY
  order_month
),

prev AS (
SELECT
  order_month,
  order_count,
  sales,
  LAG(sales) OVER(ORDER BY order_month) AS prev_sales
FROM
  month
)

SELECT
  order_month,
  order_count,
  sales,
  prev_sales,
  
  ROUND(
    SAFE_DIVIDE(
      sales - prev_sales,prev_sales
    )*100,0
  ) AS mom_rate
FROM
  prev
ORDER BY
  order_month