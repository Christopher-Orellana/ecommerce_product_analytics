-- Do our customers buy more often or more per order?

SELECT
    r.segment,
    SUM(cr.total_item_revenue) / SUM(cr.total_orders) AS avg_order_value
FROM v_customer_rfm r
JOIN v_customer_revenue cr
  ON r.customer_unique_id = cr.customer_unique_id
GROUP BY r.segment
ORDER BY avg_order_value DESC;
