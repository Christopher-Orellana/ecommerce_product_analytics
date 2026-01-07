-- Where does our revenue come from in terms of each RFM segment?

SELECT
    r.segment,
    COUNT(DISTINCT r.customer_unique_id) AS customers,
    SUM(cr.total_item_revenue) AS total_revenue,
    AVG(cr.total_item_revenue) AS avg_revenue_per_customer
FROM v_customer_rfm r
JOIN v_customer_revenue cr
  ON r.customer_unique_id = cr.customer_unique_id
GROUP BY r.segment
ORDER BY total_revenue DESC;
