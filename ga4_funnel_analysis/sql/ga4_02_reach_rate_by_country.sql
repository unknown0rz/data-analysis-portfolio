WITH prev1 AS (
SELECT
  CASE WHEN geo.country = 'United States' 
       THEN 'アメリカ'
       ELSE 'アメリカ以外'
  END AS user_group,

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
  user_group
)

SELECT
  user_group,
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
