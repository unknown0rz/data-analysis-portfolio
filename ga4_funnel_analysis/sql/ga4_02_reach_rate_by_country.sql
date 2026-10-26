--仮説「アメリカ以外の人は離れやすい」
--結果「アメリカ58.4%・アメリカ以外59.2%とほぼ差が無い」仮説は支持されなかった
--国ごとに見ると、人数が極端に少ない国は到達率100%となり、意味のない数字になるため
--CASE を用いて2グループにまとめた

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
