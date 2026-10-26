SELECT
  MIN(event_date) AS old_date,
  MAX(event_date) AS new_date,
  COUNT(DISTINCT event_date) AS days
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
