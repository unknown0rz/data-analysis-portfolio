WITH prev1 AS (
  SELECT
    user_pseudo_id,

    MAX(
      CASE WHEN event_name = 'add_payment_info'
           THEN 1
           ELSE 0
      END
    ) AS payment_group,

    MAX(
      CASE WHEN event_name = 'purchase'
           THEN 1
           ELSE 0
      END
    ) AS purchase_group
  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY
  user_pseudo_id
)

SELECT
  SUM(purchase_group) AS purchase_users,
  SUM(
    CASE WHEN purchase_group = 1 AND payment_group = 1
         THEN 1
         ELSE 0
    END
  ) AS purchase_and_payment_users
FROM
  prev1