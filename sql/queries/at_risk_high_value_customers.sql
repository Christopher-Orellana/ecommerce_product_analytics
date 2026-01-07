-- Which high-value customers are at risk of churn and should be prioritized for retention?

SELECT
    r.customer_unique_id,
    r.segment,
    r.recency_days,
    cr.total_orders,
    cr.total_item_revenue
FROM v_customer_rfm r
JOIN v_customer_revenue cr
  ON r.customer_unique_id = cr.customer_unique_id
WHERE r.segment LIKE 'At Risk%'
ORDER BY cr.total_item_revenue DESC
LIMIT 50;
