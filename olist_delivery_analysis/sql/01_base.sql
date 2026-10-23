SELECT
  DATE_DIFF(DATE(o.order_delivered_customer_date),
            DATE(o.order_estimated_delivery_date), DAY) AS delay_days,
  r.review_score
FROM `thelook-ecommerce-502702.olist.orders` AS o
JOIN `thelook-ecommerce-502702.olist.reviews` AS r
  ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL