
-- View 1: Current stock for each product in each warehouse
CREATE OR REPLACE VIEW CURRENT_STOCK AS
SELECT 
    t.Product_ID,
    p.Product_Name,
    t.Warehouse_ID,
    w.Location_Name,
    SUM(CASE WHEN t.Transaction_Type = 'IN' THEN t.Quantity ELSE -t.Quantity END) AS Stock
FROM INVENTORY_TRANSACTION t
JOIN PRODUCT p ON t.Product_ID = p.Product_ID
JOIN WAREHOUSE w ON t.Warehouse_ID = w.Warehouse_ID
GROUP BY t.Product_ID, p.Product_Name, t.Warehouse_ID, w.Location_Name;

-- View 2: Low stock items (Stock < Reorder_Level)
CREATE OR REPLACE VIEW LOW_STOCK_ITEMS AS
SELECT 
    cs.Product_ID, 
    cs.Product_Name, 
    p.Reorder_Level, 
    cs.Stock,
    (p.Reorder_Level - cs.Stock) AS Shortage_Quantity
FROM CURRENT_STOCK cs
JOIN PRODUCT p ON cs.Product_ID = p.Product_ID
WHERE cs.Stock < p.Reorder_Level;

-- View 3: Supplier performance (total units supplied)
CREATE OR REPLACE VIEW SUPPLIER_TOTAL AS
SELECT 
    s.Supplier_ID, 
    s.Company_Name, 
    COALESCE(SUM(t.Quantity), 0) AS Total_Units_Supplied
FROM SUPPLIER s
LEFT JOIN INVENTORY_TRANSACTION t ON s.Supplier_ID = t.Supplier_ID AND t.Transaction_Type = 'IN'
GROUP BY s.Supplier_ID, s.Company_Name;

-- Test the views (optional)
SELECT * FROM CURRENT_STOCK;
SELECT * FROM LOW_STOCK_ITEMS;
SELECT * FROM SUPPLIER_TOTAL;