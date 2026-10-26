WITH step AS (
SELECT 
  COUNT(DISTINCT
    CASE WHEN event_name = 'view_item' THEN user_pseudo_id
    END
  ) AS view_item,

  COUNT(DISTINCT
    CASE WHEN event_name = 'add_to_cart' THEN user_pseudo_id
    END
  ) AS add_to_cart,

  COUNT(DISTINCT
    CASE WHEN event_name = 'begin_checkout' THEN user_pseudo_id
    END
  ) AS begin_checkout,

  COUNT(DISTINCT
    CASE WHEN event_name = 'add_shipping_info' THEN user_pseudo_id
    END
  ) AS add_shipping_info,

  COUNT(DISTINCT
    CASE WHEN event_name = 'add_payment_info' THEN user_pseudo_id
    END
  ) AS add_payment_info,

  COUNT(DISTINCT
    CASE WHEN event_name = 'purchase' THEN user_pseudo_id
    END
  ) AS purchase
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
)

SELECT
  view_item,
  purchase,

  ROUND(
    SAFE_DIVIDE(
      purchase,view_item
    )*100,1
  ) AS purchase_rate,

  ROUND(
    SAFE_DIVIDE(
      add_payment_info,add_shipping_info
    )*100,1
  ) AS add_payment_rate
FROM
  step