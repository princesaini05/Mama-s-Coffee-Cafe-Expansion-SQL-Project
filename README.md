# Mama's Coffee Café Expansion Analysis | MySQL

![Project Banner](https://github.com/princesaini05/Mama-s-Coffee-Cafe-Expansion-SQL-Project/blob/75cbfe79f1596622d5593ebaacfeffebf47655fc/Mama's%20coffe%20Expansion%20Analysis%20with%20SQL.png)

## Business Problem
Mama's Coffee Café has sold coffee products online since **January 2023**. Management now wants to open its first physical outlets but has limited budget, so it must choose the **3 best cities in India** to expand into.

Opening a café in the wrong city means high rent with too little demand. This project uses SQL to answer one question:

> **Which three cities offer the best balance of customer demand, revenue and rent cost?**

## Dataset
Relational database with **4 tables** (see `Mama_s_Coffee_Cafe_SCHEMAS.sql`):

| Table | Description | Key columns |
|---|---|---|
| `city` | City-level market data | city_id, city_name, population, estimated_rent, city_rank |
| `customers` | Customer records | customer_id, customer_name, city_id (FK) |
| `products` | Coffee product catalog | product_id, product_name, price |
| `sales` | Transaction records | sale_id, sale_date, product_id (FK), customer_id (FK), total, rating |

**Records:** `[10388]` sales records, `[497]` customers, `[14]` cities, `[28]` products

**Assumption:** 25% of each city's population is treated as potential coffee consumers.

## SQL Concepts Used
- Multi-table `JOIN`s (INNER, LEFT)
- Common Table Expressions (CTEs)
- Subqueries
- Aggregate functions (`SUM`, `COUNT DISTINCT`, `ROUND`)
- Window functions (`DENSE_RANK`, `LAG`)
- Date functions (`EXTRACT` for year, quarter, month)

## Analysis Performed (10 Business Questions)
Full queries are in `Mama_s_Coffee_Cafe_Solutions.sql`.

| # | Question | Technique |
|---|---|---|
| 1 | Estimated coffee consumers per city | Aggregation, ROUND |
| 2 | Total revenue in Q4 2023 by city | JOINs, EXTRACT |
| 3 | Units sold per product | LEFT JOIN, GROUP BY |
| 4 | Average sales per customer in each city | JOINs, COUNT DISTINCT |
| 5 | City population vs coffee consumers vs actual customers | CTEs |
| 6 | Top 3 products in each city | DENSE_RANK window function |
| 7 | Unique customers per city | JOINs |
| 8 | Average sale vs average rent per customer | CTEs |
| 9 | Month-over-month sales growth | LAG window function |
| 10 | Market potential of top cities | Multi-CTE analysis |

## Key Findings

- **Revenue:** Total revenue in Q4 2023 was `[₹1963300]`, led by `[Pune - ₹434330]`.
- **Best-selling product:** `[Cold Brew Coffee Pack (6 Bottles)]` ranked #1 in `[6]` of `[14]` cities (Q6).
- **Growth trend:** Monthly sales `[fluctuated]`, with the strongest month being `[January 2023]` (Q9).
- **Rent impact:** `[Jaipur]` had the lowest rent per customer at ₹`[156]`, while `[Mumbai]` had the highest at ₹`[1,036]]` (Q8).
- **Market size:** Delhi has the largest estimated coffee-consumer base at **7.7 million**, but only `[0.9]`% of them are currently customers (Q5).

## Recommendations
Top three cities for new outlets:

### 1. Pune: best overall
- Highest total revenue in the historical data
- Highest average sale per customer (**₹24,197**)
- Strong balance of revenue and rent cost

### 2. Delhi: best for customer reach
- Largest estimated coffee-consumer market (**7.7 million**)
- **68** active customers
- Average rent per customer of **₹330**, still under ₹500
- Biggest room for untapped growth

### 3. Jaipur: best low-cost option
- **69** active customers
- Lowest average rent per customer (**₹156**)
- Healthy average sale per customer (**₹11.6K**)

## How to Run
1. Run `Mama_s_Coffee_Cafe_SCHEMAS.sql` to create the tables
2. Import data in this order: `city` → `products` → `customers` → `sales`
3. Run queries from `Mama_s_Coffee_Cafe_Solutions.sql`

## Limitations and Next Steps
- Only online sales data was available, so offline demand is estimated using the 25% assumption.
- Rent is a single estimate per city and does not account for locality or footfall.
- **Next steps:** build a Power BI dashboard on top of these queries, and add a profit-per-city model including rent and operating costs.

## Tools
MySQL · SQL · GitHub

## Author
**Prince** · Data Analyst
[GitHub](https://github.com/princesaini05)
