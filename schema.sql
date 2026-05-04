-- Create CATEGORY table
CREATE TABLE CATEGORY (
    Category_ID   NUMBER PRIMARY KEY,
    Category_Name VARCHAR2(50) NOT NULL UNIQUE,
    Description   VARCHAR2(200)
);

-- Create SUPPLIER table
CREATE TABLE SUPPLIER (
    Supplier_ID     NUMBER PRIMARY KEY,
    Company_Name    VARCHAR2(100) NOT NULL,
    Contact_Person  VARCHAR2(50),
    Email           VARCHAR2(100) UNIQUE,
    Phone           VARCHAR2(20)
);

-- Create WAREHOUSE table
CREATE TABLE WAREHOUSE (
    Warehouse_ID   NUMBER PRIMARY KEY,
    Location_Name  VARCHAR2(100) NOT NULL,
    Total_Capacity NUMBER CHECK (Total_Capacity > 0)
);

-- Create PRODUCT table
CREATE TABLE PRODUCT (
    Product_ID     NUMBER PRIMARY KEY,
    Product_Name   VARCHAR2(100) NOT NULL,
    Category_ID    NUMBER NOT NULL,
    Unit_Price     NUMBER(10,2) CHECK (Unit_Price >= 0),
    Reorder_Level  NUMBER DEFAULT 10 CHECK (Reorder_Level > 0),
    FOREIGN KEY (Category_ID) REFERENCES CATEGORY(Category_ID)
);

-- Create SUPPLIER_PRODUCT junction table (many-to-many)
CREATE TABLE SUPPLIER_PRODUCT (
    Supplier_ID NUMBER,
    Product_ID  NUMBER,
    PRIMARY KEY (Supplier_ID, Product_ID),
    FOREIGN KEY (Supplier_ID) REFERENCES SUPPLIER(Supplier_ID),
    FOREIGN KEY (Product_ID)  REFERENCES PRODUCT(Product_ID)
);

-- Create INVENTORY_TRANSACTION table
CREATE TABLE INVENTORY_TRANSACTION (
    Transaction_ID   NUMBER PRIMARY KEY,
    Product_ID       NUMBER NOT NULL,
    Warehouse_ID     NUMBER NOT NULL,
    Supplier_ID      NUMBER NULL,
    Transaction_Type CHAR(3) CHECK (Transaction_Type IN ('IN', 'OUT')),
    Quantity         NUMBER CHECK (Quantity > 0),
    Transaction_Date DATE DEFAULT SYSDATE,
    FOREIGN KEY (Product_ID)   REFERENCES PRODUCT(Product_ID),
    FOREIGN KEY (Warehouse_ID) REFERENCES WAREHOUSE(Warehouse_ID),
    FOREIGN KEY (Supplier_ID)  REFERENCES SUPPLIER(Supplier_ID)
);

-- Confirm all tables created
SELECT table_name FROM user_tables ORDER BY table_name;