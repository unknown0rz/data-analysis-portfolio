SELECT
  COUNT(*) AS all_data,

  COUNT(
    CASE WHEN user_pseudo_id IS NULL
         THEN 1
    END
  ) AS null_data
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
