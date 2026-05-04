-- 1. INNER JOIN: Products with their category names
SELECT p.Product_ID, p.Product_Name, c.Category_Name, p.Unit_Price
FROM PRODUCT p
JOIN CATEGORY c ON p.Category_ID = c.Category_ID;

-- 2. LEFT JOIN: All suppliers and any stock they supplied 
SELECT s.Company_Name, t.Transaction_ID, t.Quantity
FROM SUPPLIER s
LEFT JOIN INVENTORY_TRANSACTION t ON s.Supplier_ID = t.Supplier_ID AND t.Transaction_Type = 'IN';

-- 3. SUBQUERY: Products that have never been sold (no OUT transaction)
SELECT Product_ID, Product_Name
FROM PRODUCT
WHERE Product_ID NOT IN (
    SELECT DISTINCT Product_ID
    FROM INVENTORY_TRANSACTION
    WHERE Transaction_Type = 'OUT'
);

-- 4. AGGREGATION - SUM: Best selling products (total quantity sold)
SELECT p.Product_Name, SUM(t.Quantity) AS Total_Sold
FROM INVENTORY_TRANSACTION t
JOIN PRODUCT p ON t.Product_ID = p.Product_ID
WHERE t.Transaction_Type = 'OUT'
GROUP BY p.Product_Name
ORDER BY Total_Sold DESC;

-- 5. AGGREGATION - AVG: Average sale quantity per product
SELECT p.Product_Name, AVG(t.Quantity) AS Avg_Sale_Size
FROM INVENTORY_TRANSACTION t
JOIN PRODUCT p ON t.Product_ID = p.Product_ID
WHERE t.Transaction_Type = 'OUT'
GROUP BY p.Product_Name;

-- 6. Total stock value in each warehouse (using CURRENT_STOCK view)
SELECT 
    cs.Warehouse_ID,
    cs.Location_Name,
    SUM(cs.Stock * p.Unit_Price) AS Total_Value
FROM CURRENT_STOCK cs
JOIN PRODUCT p ON cs.Product_ID = p.Product_ID
GROUP BY cs.Warehouse_ID, cs.Location_Name;

-- 7. Monthly summary of IN and OUT quantities
SELECT 
    EXTRACT(YEAR FROM Transaction_Date) AS Year,
    EXTRACT(MONTH FROM Transaction_Date) AS Month,
    Transaction_Type,
    SUM(Quantity) AS Total_Quantity
FROM INVENTORY_TRANSACTION
GROUP BY EXTRACT(YEAR FROM Transaction_Date), EXTRACT(MONTH FROM Transaction_Date), Transaction_Type
ORDER BY Year, Month;

-- 8. All transactions for a specific product (e.g., Product_ID = 302)
SELECT 
    t.Transaction_ID,
    t.Transaction_Type,
    t.Quantity,
    t.Transaction_Date,
    s.Company_Name AS Supplier_Name
FROM INVENTORY_TRANSACTION t
LEFT JOIN SUPPLIER s ON t.Supplier_ID = s.Supplier_ID
WHERE t.Product_ID = 302
ORDER BY t.Transaction_Date;

-- 9. All suppliers for a given product (many-to-many relationship)
SELECT 
    p.Product_Name,
    s.Company_Name,
    s.Contact_Person,
    s.Phone
FROM PRODUCT p
JOIN SUPPLIER_PRODUCT sp ON p.Product_ID = sp.Product_ID
JOIN SUPPLIER s ON sp.Supplier_ID = s.Supplier_ID
WHERE p.Product_ID = 302;