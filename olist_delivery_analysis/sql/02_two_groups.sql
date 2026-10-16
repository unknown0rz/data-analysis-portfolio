-- 目的:遅延の有無でレビュー評価を比較する
-- 低評価:review_score が1〜2点
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
  CASE WHEN delay_days >= 1 THEN "遅れた"
       ELSE "遅れていない"
  END AS delay_group,
  COUNT(*) AS orders,
  ROUND(AVG(review_score), 2) AS avg_score,
  ROUND(AVG(IF(review_score <= 2, 1, 0)) * 100, 1) AS low_score
FROM base
GROUP BY delay_group