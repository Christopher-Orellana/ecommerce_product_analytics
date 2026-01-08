-- Customers
-- Grain: one row per customer_id
-- ----------------------------
CREATE TABLE customers (
    customer_id         VARCHAR PRIMARY KEY,
    customer_unique_id  VARCHAR NOT NULL,
    customer_zip_code   VARCHAR,
    customer_city       VARCHAR,
    customer_state      VARCHAR
);


-- Orders
-- Grain: one row per order_id
-- ----------------------------
CREATE TABLE orders (
    order_id                     VARCHAR PRIMARY KEY,
    customer_id                  VARCHAR NOT NULL,
    order_status                 VARCHAR NOT NULL,
    order_purchase_timestamp     TIMESTAMP,
    order_approved_at            TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers (customer_id)
);


-- Order Items
-- Grain: one row per (order_id, order_item_id)
-- ----------------------------
CREATE TABLE order_items (
    order_id        VARCHAR NOT NULL,
    order_item_id   INTEGER NOT NULL,
    product_id      VARCHAR,
    seller_id       VARCHAR,
    shipping_limit_date TIMESTAMP,
    price           NUMERIC(10,2) NOT NULL,
    freight_value   NUMERIC(10,2) NOT NULL,

    CONSTRAINT pk_order_items
        PRIMARY KEY (order_id, order_item_id),

    CONSTRAINT fk_items_order
        FOREIGN KEY (order_id)
        REFERENCES orders (order_id)
);


-- Order Payments
-- Grain: one row per (order_id, payment_sequential)
-- ----------------------------
CREATE TABLE order_payments (
    order_id            VARCHAR NOT NULL,
    payment_sequential  INTEGER NOT NULL,
    payment_type        VARCHAR,
    payment_installments INTEGER,
    payment_value       NUMERIC(10,2) NOT NULL,

    CONSTRAINT pk_order_payments
        PRIMARY KEY (order_id, payment_sequential),

    CONSTRAINT fk_payments_order
        FOREIGN KEY (order_id)
        REFERENCES orders (order_id)
);
