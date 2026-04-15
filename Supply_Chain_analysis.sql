-- ============================================
-- SUPPLY CHAIN PROCUREMENT ANALYSIS PROJECT
-- Tool: SQLite (DB Browser)
-- ============================================

-- 1. View Raw Data
SELECT * FROM Supply_Chain LIMIT 10;

-- ============================================
-- 2. Create Clean Table (Fix column names & formats)
-- ============================================

CREATE TABLE supply_chain_clean AS
SELECT
    Product,
    Supplier,
    "Warehouse Location" AS warehouse_location,
    Quantity,
    "Unit Price" AS unit_price,
    "Total Cost" AS total_cost,
    "Revenue Sales" AS revenue_sales,
    "Profit Generated" AS profit_generated,
    DATE("Order Date") AS order_date,
    DATE("Delivery Date") AS delivery_date,
    "Delivery Days" AS delivery_days
FROM Supply_Chain;

-- ============================================
-- 3. Create Final Table with KPIs
-- ============================================

CREATE TABLE supply_chain_final AS
SELECT
    *,
    
    -- Delivery Delay Validation
    (JULIANDAY(delivery_date) - JULIANDAY(order_date)) AS calculated_delay,
    
    -- Profit Margin Percentage
    (profit_generated * 100.0 / revenue_sales) AS profit_margin
    
FROM supply_chain_clean;

-- ============================================
-- 4. Data Validation
-- ============================================

SELECT 
    Supplier,
    total_cost,
    revenue_sales,
    profit_generated,
    delivery_days,
    calculated_delay,
    profit_margin
FROM supply_chain_final
LIMIT 10;

-- ============================================
-- 5. Business Insights Queries
-- ============================================

-- Top Suppliers by Cost
SELECT Supplier, SUM(total_cost) AS total_spend
FROM supply_chain_final
GROUP BY Supplier
ORDER BY total_spend DESC;

-- Most Profitable Products
SELECT Product, SUM(profit_generated) AS total_profit
FROM supply_chain_final
GROUP BY Product
ORDER BY total_profit DESC;

-- Warehouse Cost Distribution
SELECT warehouse_location, SUM(total_cost) AS total_cost
FROM supply_chain_final
GROUP BY warehouse_location
ORDER BY total_cost DESC;

-- Monthly Spending Trend
SELECT 
    strftime('%Y-%m', order_date) AS month,
    SUM(total_cost) AS monthly_spend
FROM supply_chain_final
GROUP BY month
ORDER BY month;
