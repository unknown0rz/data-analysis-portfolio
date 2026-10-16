-- 目的:注文ごとの配送遅延日数とレビュー点数を抽出する
-- データ:Olist(Kaggle)の orders / reviews、配達済みの注文のみ
-- delay_days:実際の配達日 - 予定配達日(プラス=遅延、マイナス=早着)
SELECT
  DATE_DIFF(DATE(o.order_delivered_customer_date),
            DATE(o.order_estimated_delivery_date), DAY) AS delay_days,
  r.review_score
FROM `thelook-ecommerce-502702.olist.orders` AS o
JOIN `thelook-ecommerce-502702.olist.reviews` AS r
  ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL