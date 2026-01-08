
-- Analytical Views:


-- Order Item Revenue
-- Grain: one row per order_id

CREATE OR REPLACE VIEW v_order_item_revenue AS
SELECT
    oi.order_id,
    SUM(oi.price + oi.freight_value) AS item_revenue
FROM order_items oi
GROUP BY oi.order_id;


-- Order Payment Revenue
-- Grain: one row per order_id

CREATE OR REPLACE VIEW v_order_payment_revenue AS
SELECT
    op.order_id,
    SUM(op.payment_value) AS payment_revenue
FROM order_payments op
GROUP BY op.order_id;


-- Order Financials
-- Grain: one row per order_id - Reconcile item revenue vs payments

CREATE OR REPLACE VIEW v_order_financials AS
SELECT
    o.order_id,
    o.order_status,
    ir.item_revenue,
    pr.payment_revenue,
    (pr.payment_revenue - ir.item_revenue) AS revenue_diff
FROM orders o
LEFT JOIN v_order_item_revenue ir
    ON o.order_id = ir.order_id
LEFT JOIN v_order_payment_revenue pr
    ON o.order_id = pr.order_id;


-- Customer Revenue
-- Grain: one row per customer_unique_id

CREATE OR REPLACE VIEW v_customer_revenue AS
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(ir.item_revenue)       AS total_item_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
LEFT JOIN v_order_item_revenue ir
    ON o.order_id = ir.order_id
GROUP BY c.customer_unique_id;


-- Customer Behavior - Recency & Tenure
-- Grain: one row per customer_unique_id

CREATE OR REPLACE VIEW v_customer_behavior AS
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    MIN(o.order_purchase_timestamp) AS first_order_date,
    MAX(o.order_purchase_timestamp) AS last_order_date,
    (MAX(o.order_purchase_timestamp)::DATE
        - MIN(o.order_purchase_timestamp)::DATE) AS customer_tenure_days,
    (CURRENT_DATE
        - MAX(o.order_purchase_timestamp)::DATE) AS recency_days
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id;


-- Customer RFM Segmentation
-- Grain: one row per customer_unique_id

CREATE OR REPLACE VIEW v_customer_rfm AS
WITH base AS (
    SELECT
        cr.customer_unique_id,
        cr.total_orders,
        cr.total_item_revenue,
        cb.recency_days
    FROM v_customer_revenue cr
    JOIN v_customer_behavior cb
        ON cr.customer_unique_id = cb.customer_unique_id
),
scored AS (
    SELECT
        customer_unique_id,
        total_orders,
        total_item_revenue,
        recency_days,

        6 - NTILE(5) OVER (ORDER BY recency_days) AS r_score,
        NTILE(5) OVER (ORDER BY total_orders) AS f_score,
        NTILE(5) OVER (ORDER BY total_item_revenue) AS m_score
    FROM base
)
SELECT
    customer_unique_id,
    total_orders,
    total_item_revenue,
    recency_days,
    r_score,
    f_score,
    m_score,
    (r_score::TEXT || f_score::TEXT || m_score::TEXT) AS rfm_score,
    CASE
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
        WHEN r_score >= 4 AND f_score >= 3 THEN 'Loyal Customers'
        WHEN r_score >= 4 AND f_score <= 2 THEN 'New Customers'
        WHEN r_score <= 2 AND m_score >= 4 THEN 'At Risk (High Value)'
        WHEN r_score <= 2 THEN 'At Risk'
        ELSE 'Others'
    END AS segment
FROM scored;
