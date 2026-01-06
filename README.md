# Grain-Safe Revenue & Customer Analytics in PostgreSQL  
### Olist Brazilian E-Commerce Dataset

This project builds a **grain-safe analytical layer in PostgreSQL** using transactional data from the  
**Olist Brazilian E-Commerce** dataset.

The objective is to **prevent silent metric corruption**—especially revenue inflation—caused by
joining fact tables at incompatible grains (orders, items, payments).  
Instead of relying on analyst discipline alone, this project **enforces correctness using 
the database schema and analytical views**.

The result is a production-ready analytics foundation that produces **accurate revenue and
customer metrics**, suitable for downstream dashboards and decision-making.

---

## Dataset

**Source:** Olist Brazilian E-Commerce Dataset (Brazil)

### Core tables loaded and enforced
- `customers` — customer identity and location
- `orders` — order lifecycle and timestamps
- `order_items` — line-item revenue (price + freight)
- `order_payments` — payment transactions and reconciliation

### Key data characteristics
- Orders can contain **multiple items**
- Orders can have **multiple payments**
- Customers can place **multiple orders over time**
- Orders may be canceled or undelivered
- Payment totals may differ from item totals due to vouchers, freight, or adjustments like discounts

---

## Core Design Principle: Grain

This project is built around a single rule:

> **Never aggregate after joining fact tables at different grains.**

Grain is explicitly enforced at every layer:

- **Order grain** --> one row per `order_id`
- **Customer grain** --> one row per `customer_unique_id`

All revenue and customer metrics are computed by:
1. Aggregating each fact table at its natural grain  
2. Joining only same-grain results  
3. Exposing metrics through analytical views that cannot multiply rows

---

## Schema & Integrity Enforcement

- Primary keys enforce entity identity
- Composite keys enforce line-item and payment uniqueness
- Foreign keys prevent orphaned records
- Invalid assumptions are rejected

Postgres is intentionally used as a **constraint-enforcer**, not just database storage and querying.

---

## Analytical Views

The analytical layer encodes grain and business rules directly into views.

### Order-grain views
- `v_order_item_revenue` — item revenue per order
- `v_order_payment_revenue` — payment revenue per order
- `v_order_financials` — item vs payment reconciliation (1 row per order)

### Customer-grain views
- `v_customer_revenue` — lifetime orders and revenue per customer
- `v_customer_behavior` — tenure and recency metrics
- `v_customer_rfm` — RFM scoring and segmentation

Each grain-claiming view is validated to guarantee **exactly one row per entity**.

---

## Metrics & Business Definitions

All metrics are explicitly defined in SQL:

- **Revenue:** sum of item prices (line-item grain)
- **Customer identity:** `customer_unique_id`
- **Lifetime value (LTV):** total item revenue per customer
- **Frequency:** total orders per customer
- **Recency:** days since last order
- **RFM segmentation:** quintile-based scoring (1–5)

No predictive models or causal assumptions are made.  
All outputs are **descriptive and decision-supporting**.

---

## Analyses

The project produces decision-ready queries such as:

- Revenue by RFM segment
- Revenue concentration (decile / Pareto analysis)
- High-value customers at churn risk
- Share of revenue from repeat customers
- Average order value by customer segment

All queries operate on grain-safe views.

---

## Project Structure
```
ecom_product_analytics/
├── data/ # raw CSVs (excluded)
├── sql/
│ ├── schema/ # base tables (order-level grain)
│ ├── views/ # analytical views (customer, revenue, RFM)
│ └── queries/ # SQL queries for business insight
├── README.md
```
---

## How to Run

1. Install PostgreSQL  
2. Create the database  
3. Run schema scripts  
4. Load CSVs using `\copy`  
5. Create analytical views  
6. Execute queries from `sql/queries/`  

---

## Status

**In Progress — analytics layer validated on full dataset - dashboard in progress.**

---

## License

MIT License © 2025
