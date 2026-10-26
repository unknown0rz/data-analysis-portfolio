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
  CASE WHEN category = 'desktop' THEN 'デスクトップ'
       WHEN category = 'mobile' THEN 'モバイル'
       WHEN category = 'tablet' THEN 'タブレット'
       ELSE category
  END AS device,
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
