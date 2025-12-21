# Product Analytics: E-Commerce Revenue & Customer Journey  
### Olist Brazilian E-Commerce – SQL-First Funnel & Cohort Analysis

This project applies a **SQL-first product analytics workflow** to transactional data from the  
**Olist Brazilian E-Commerce** dataset.  
The goal is **to identify revenue leakage and friction points across the customer journey**  
and translate analytical findings into actionable business recommendations.

---

## Dataset
**Source:** Olist Brazilian E-Commerce Dataset  

**Core tables used:**
- `orders`
- `order_items`
- `customers`

**Notes:**
- Orders may be canceled or undelivered
- Delivery timestamps may be missing
- Orders can contain multiple items
- Customers may place multiple orders over time

---

## Analytical Summary
A descriptive, decision-support analytics framework:

- **Unit of analysis:** orders, order items, customers
- **Revenue definition:** item price + freight (excluding canceled or undelivered orders unless stated)
- **Customer definition:** unique `customer_unique_id`
- **Lifecycle stages:** order placed → approved → shipped → delivered

No predictive models or causal assumptions are used.  
All results depend on explicitly stated business rules.

---

## Metrics
Core metrics analyzed include:

- Total revenue
- Average order value (AOV)
- Funnel conversion across order lifecycle stages
- Cancellation and delivery delay rates
- Repeat purchase rate and cohort retention

Metric definitions and assumptions are made explicit in SQL.

---

## Project Contents
1. **Data loading & validation**
   - relational integrity checks
   - row counts and missing values
2. **Metric definition**
   - revenue and order value
   - funnel logic
3. **Funnel analysis**
   - order drop-offs
   - cancellation and delay impact
4. **Cohort analysis**
   - repeat customer behavior
   - retention over time
5. **Visualization**
   - summary dashboard
6. **Interpretation & conclusion**
   - findings
   - recommendations
   - limitations

---

## Project Layout
```
ecommerce_product_analytics/
├── data/ # raw data (excluded from version control)
├── sql/ # schema, loading, metrics, cohorts
├── notebooks/ # optional exploration
├── dashboard/ # exported visualizations
├── memo/ # decision memo
└── README.md
```
## Requirements
`pip install -r requirements.txt`

## Status
**In progress**

## License
MIT License © 2025
