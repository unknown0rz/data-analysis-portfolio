--仮説「スマホの人は入力が面倒で離れやすい」
--結果「tablet 61.2%・mobile 60.1%・desktop 59.2% とほぼ差が無い」仮説は支持されなかった
--注意点9,714人→9,851人のズレ → 端末を跨いでる人が重なって数えられている

WITH prev1 AS (
SELECT
  device.category,
  COUNT(DISTINCT 
    CASE WHEN event_name = 'add_shipping_info'
         THEN user_pseudo_id
    END) AS add_shipping_users,

  COUNT(DISTINCT
    CASE WHEN event_name = 'add_payment_info'
         THEN user_pseudo_id
    END) AS add_payment_users
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY
  device.category
)

SELECT
  category,
  add_shipping_users,
  add_payment_users,
  
  ROUND(
    SAFE_DIVIDE(
      add_payment_users,add_shipping_users
    )*100,1
  ) AS reach_rate
FROM
  prev1
ORDER BY
  reach_rate DESC
