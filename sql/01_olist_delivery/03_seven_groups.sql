-- 目的:何日遅れからレビュー評価が大きく下がるかを確認する
WITH base AS (
  SELECT
    DATE_DIFF(DATE(o.order_delivered_customer_date),
              DATE(o.order_estimated_delivery_date), DAY) AS delay_days,
    r.review_score
  FROM `thelook-ecommerce-502702.olist.orders` AS o
  JOIN `thelook-ecommerce-502702.olist.reviews` AS r
    ON o.order_id = r.order_id
  WHERE o.order_status = 'delivered'
    AND o.order_delivered_customer_date IS NOT NULL
)
SELECT
  CASE
    WHEN delay_days <= -8 THEN "1_8日以上早い"
    WHEN delay_days <= -1 THEN "2_1〜7日早い"
    WHEN delay_days = 0   THEN "3_予定通り"
    WHEN delay_days <= 3  THEN "4_1〜3日遅れ"
    WHEN delay_days <= 7  THEN "5_4〜7日遅れ"
    WHEN delay_days <= 14 THEN "6_8〜14日遅れ"
    ELSE "7_15日以上遅れ"
  END AS delay_group,
  COUNT(*) AS orders,
  ROUND(AVG(review_score), 2) AS avg_score,
  ROUND(AVG(IF(review_score <= 2, 1, 0)) * 100, 1) AS low_score
FROM base
GROUP BY delay_group
ORDER BY delay_group