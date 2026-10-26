WITH prev1 AS (
SELECT
  event_name,
  COUNT(DISTINCT user_pseudo_id) AS cnt_users
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE
  event_name IN ('view_item','add_to_cart','begin_checkout','add_shipping_info','add_payment_info','purchase')
GROUP BY
  event_name
)

SELECT
  CASE WHEN event_name = 'view_item' THEN '1_商品閲覧'
       WHEN event_name = 'add_to_cart' THEN '2_カート'
       WHEN event_name = 'begin_checkout' THEN '3_購入手続き'
       WHEN event_name = 'add_shipping_info' THEN '4_配送先入力'
       WHEN event_name = 'add_payment_info' THEN '5_決済方法入力'
       WHEN event_name = 'purchase' THEN '6_購入'
       ELSE event_name
  END AS step,

  cnt_users
FROM
  prev1
ORDER BY
  step