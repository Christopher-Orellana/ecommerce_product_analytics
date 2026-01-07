-- Do a small number or customers generate most of our revenue? or is it more spread out?

WITH ranked_customers AS (
    SELECT
        customer_unique_id,
        total_item_revenue,
        NTILE(10) OVER (ORDER BY total_item_revenue DESC) AS revenue_decile
    FROM v_customer_revenue
)
SELECT
    revenue_decile,
    COUNT(*)                         AS customers,
    SUM(total_item_revenue)          AS decile_revenue,
    SUM(total_item_revenue)
      / SUM(SUM(total_item_revenue)) OVER () AS revenue_share
FROM ranked_customers
GROUP BY revenue_decile
ORDER BY revenue_decile;
