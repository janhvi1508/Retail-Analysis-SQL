-- DATABASE AND TABLE CREATION

-- Shows the list of Databases Created.
SHOW DATABASES;

-- Creates a Database 
-- 'If not exists' is used to avoid the error if we try to crete database which is already been created using same name.
CREATE DATABASE IF NOT EXISTS Study;

-- Command used to select the database to be used for case study
USE Study;

-- Displays the Database on which we are currectly using for case study
SELECT DATABASE();

-- Create Table1 named 'customer_profiles' which contains information of Customer.
-- The Table Schema is same as CSV file.
CREATE TABLE customer_profiles (
	CustomerID DECIMAL(38, 0) NOT NULL, 
	Age DECIMAL(38, 0) NOT NULL, 
	Gender VARCHAR(6) NOT NULL, 
	Location VARCHAR(5), 
	JoinDate VARCHAR(8) NOT NULL
);
-- Display the table schema of Table1 
DESC customer_profiles;

-- Create Table2 named 'product_inventory' which contains information of Products.
-- The Table Schema is same as CSV file.
CREATE TABLE product_inventory (
	ProductID DECIMAL(38, 0) NOT NULL, 
	ProductName VARCHAR(11) NOT NULL, 
	Category VARCHAR(15) NOT NULL, 
	StockLevel DECIMAL(38, 0) NOT NULL, 
	Price DECIMAL(38, 2) NOT NULL
);
-- Display the table schema of Table2 
DESC product_inventory;

-- Create Table3 named 'sales_transaction' which contains information of Sale Transaction.
-- The Table Schema is same as CSV file.
CREATE TABLE sales_transaction (
	TransactionID DECIMAL(38, 0) NOT NULL, 
	CustomerID DECIMAL(38, 0) NOT NULL, 
	ProductID DECIMAL(38, 0) NOT NULL, 
	QuantityPurchased DECIMAL(38, 0) NOT NULL, 
	TransactionDate VARCHAR(8) NOT NULL, 
	Price DECIMAL(38, 2) NOT NULL
);
-- Display the table schema of Table3 
DESC sales_transaction;

-- Displays the list of tables present in the CaseStudy DataBase
SHOW TABLES;

-- Checks if the value of secure_file_priv is Empty Value
-- If yes Loading of data from CSV file is Possible
SHOW VARIABLES LIKE 'secure_file_priv';

/* 
	Insights: The DESC command is a good practice to verify the created schema, and 
    checking secure_file_priv is essential for enabling local data loading. The initial data types 
    (like DECIMAL(38,0) for IDs and VARCHAR for dates) are often temporary, 
    anticipating a data cleaning step.
*/

-- DATA LOADING 
-- Loads the Data present in CSV file to Table1 custmor_profiles
LOAD DATA INFILE 'C:/Users/keeda/OneDrive/Desktop/case study/customer_profiles.csv'
INTO TABLE customer_profiles
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
DESC customer_profiles;
SELECT * FROM customer_profiles;

-- Loads the Data present in CSV file to Table2 product_inventory.
LOAD DATA INFILE 'C:/Users/keeda/OneDrive/Desktop/case study/product_inventory.csv'
INTO TABLE product_inventory
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
DESC product_inventory;
SELECT * FROM product_inventory;

-- Loads the Data present in CSV file to Table3 sales_transaction
LOAD DATA INFILE 'C:/Users/keeda/OneDrive/Desktop/case study/sales_transaction.csv'
INTO TABLE sales_transaction
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
DESC sales_transaction;
SELECT * FROM sales_transaction;
/*
	Insights: LOAD DATA INFILE is a powerful command for bulk data insertion. The IGNORE 1 ROWS clause is 
    vital for skipping header rows in CSV files. The DESCRIBE command after loading helps to quickly check 
    if the data types inferred during loading are correct or if any issues occurred. SELECT * is used for a 
    quick peek at the loaded data.
*/

-- DATA CLEANING

-- Table Schema of Table1 'customer_profiles' before changing the data-types and limits of the columns.
DESCRIBE customer_profiles;
-- Alter Commands to modify the columns for 'customer_profiles' to appropriate data types and lengths.
ALTER TABLE customer_profiles
MODIFY COLUMN CustomerID INT NOT NULL;
ALTER TABLE customer_profiles
MODIFY COLUMN Age INT NOT NULL;
ALTER TABLE customer_profiles
MODIFY COLUMN Gender VARCHAR(6) NOT NULL;
ALTER TABLE customer_profiles
MODIFY COLUMN Location VARCHAR(50) NOT NULL; -- Increased VARCHAR length for location for better flexibility.
ALTER TABLE customer_profiles
MODIFY COLUMN JoinDate DATE NOT NULL; -- Changed to DATE data type for proper date handling.
-- Table Schema of Table1 'customer_profiles' after changing the data-types and limits of the columns.
DESCRIBE customer_profiles;

-- Table Schema of Table2 'product_inventory' before changing the data-types and limits of the columns.
DESCRIBE product_inventory;
-- Alter Commands to modify the columns for 'product_inventory'.
ALTER TABLE product_inventory
MODIFY COLUMN ProductID INT NOT NULL;
ALTER TABLE product_inventory
MODIFY COLUMN ProductName VARCHAR(30) NOT NULL; -- Increased VARCHAR length for product name.
ALTER TABLE product_inventory
MODIFY COLUMN Category VARCHAR(30) NOT NULL; -- Increased VARCHAR length for category.
ALTER TABLE product_inventory
MODIFY COLUMN StockLevel INT NOT NULL;
ALTER TABLE product_inventory
MODIFY COLUMN Price DECIMAL(8,2) NOT NULL; -- Set precision for price.
-- Table Schema of Table2 'product_inventory' after changing the data-types and limits of the columns.
DESCRIBE product_inventory;
SELECT COUNT(*) FROM product_inventory; -- Verifies the total number of rows in product_inventory.

-- Table Schema of Table3 'sales_transaction' before changing the data-types and limits of the columns.
DESCRIBE sales_transaction;
-- Alter Commands to modify the columns for 'sales_transaction'.
ALTER TABLE sales_transaction
MODIFY COLUMN TransactionID INT NOT NULL;
ALTER TABLE sales_transaction
MODIFY COLUMN ProductID INT NOT NULL;
ALTER TABLE sales_transaction
MODIFY COLUMN CustomerID INT NOT NULL;
ALTER TABLE sales_transaction
MODIFY COLUMN QuantityPurchased INT NOT NULL;
ALTER TABLE sales_transaction
MODIFY COLUMN TransactionDate DATE NOT NULL; -- Changed to DATE data type.
ALTER TABLE sales_transaction
MODIFY COLUMN Price DECIMAL(8,2) NOT NULL; -- Set precision for price.
-- Table Schema of Table3 'sales_transaction' after changing the data-types and limits of the columns.
DESCRIBE sales_transaction;

-- Count the rows which have null values (represented as empty strings) in the 'Location' column of 'customer_profiles'.
SELECT COUNT(*) AS "Total_Null_Location_values" FROM customer_profiles
WHERE Location = "";

-- Counts the total number of transactions in the 'sales_transaction' table.
SELECT COUNT(*) AS "Total_number_of_Records" FROM sales_transaction;

-- Deletes the records of customers whose 'Location' is null (empty string) from 'sales_transaction' table.
-- This decision is made because only a small percentage (0.98%) of data would be affected.
SET SQL_SAFE_UPDATES = 0; -- Temporarily disables safe update mode to allow mass deletions.
DELETE FROM sales_transaction
WHERE CustomerID IN (
    SELECT cp.CustomerID -- Select CustomerIDs from customer_profiles
    FROM customer_profiles cp
    WHERE cp.Location = "" -- Filter for customers where location is an empty string
);
SET SQL_SAFE_UPDATES = 1; -- Re-enables safe update mode.

-- Cross-verifies the number of transactions in 'sales_transaction' table after removing records with null locations.
SELECT COUNT(*) FROM sales_transaction;

-- Total number of rows in 'customer_profiles' table that have null values (empty strings) in 'Location'.
SELECT COUNT(*) FROM customer_profiles
WHERE Location="";

-- Deletes the rows that have null values (empty strings) in 'Location' from 'customer_profiles'.
-- This is done because it represents a very small percentage (0.013%) of the data.
SET SQL_SAFE_UPDATES = 0; -- Temporarily disables safe update mode.
DELETE FROM customer_profiles
WHERE Location = '';
SET SQL_SAFE_UPDATES = 1; -- Re-enables safe update mode.

-- Cross-verifies if columns with null values (empty strings) have been deleted from 'customer_profiles'.
-- The count should reflect Total Number of rows - Total Number of null location rows (e.g., 1000 - 13).
SELECT COUNT(*) FROM customer_profiles;

-- Checks if the prices in 'sales_transaction' match the prices in 'product_inventory' for the same ProductID.
-- If they don't match, it corrects the 'Price' in 'sales_transaction' to reflect the 'product_inventory' price.
UPDATE sales_transaction st
JOIN product_inventory pi ON st.ProductID = pi.ProductID
SET st.Price = pi.Price
WHERE st.Price != pi.Price;

-- Displays the ProductID, ProductName, and Category for products where 'StockLevel' is zero (represented as empty string initially).
SELECT ProductID, ProductName, Category FROM product_inventory
WHERE StockLevel = '';

-- Counts the number of transactions for ProductID = 93.
SELECT COUNT(*) FROM sales_transaction
WHERE ProductID = 93;

-- Changes the 'Price' to 0 for transactions involving ProductID = 93, as this product is indicated as out of stock.
SET SQL_SAFE_UPDATES = 0; -- Temporarily disables safe update mode.
UPDATE sales_transaction SET Price = 0
WHERE ProductID = 93;
SET SQL_SAFE_UPDATES = 1; -- Re-enables safe update mode.

-- Cross-verifies if there are now 29 entries where the 'Price' is 0, confirming the previous update.
SELECT COUNT(*) FROM sales_transaction
WHERE Price = 0;

-- Displays duplicate transactions based on a combination of CustomerID, ProductID, QuantityPurchased, and TransactionDate.
-- ROW_NUMBER() is used to assign a unique number to each row within a partition,
-- allowing identification of duplicates (where Duplicate_values > 1).
WITH DuplicateTransactions AS (
    SELECT
        *, -- Select all columns from the sales_transactions table
        ROW_NUMBER() OVER (
            PARTITION BY
                CustomerID,
                ProductID,
                QuantityPurchased,
                TransactionDate
            ORDER BY
                TransactionID -- Used to determine which duplicate row to keep/delete.
        ) as Duplicate_values
    FROM
        sales_transaction
)
SELECT
    *
FROM
    DuplicateTransactions
WHERE
    Duplicate_values > 1;

-- Creates a temporary table to store unique values for TransactionIDs 4999 and 5000.
-- This is part of a strategy to remove duplicate entries.
CREATE TEMPORARY TABLE temp_unique_sales_subset AS
SELECT DISTINCT
    TransactionID,
    CustomerID,
    ProductID,
    QuantityPurchased,
    TransactionDate,
    Price
FROM
    sales_transaction
WHERE
    TransactionID IN (4999, 5000);

-- Deletes all entries with TransactionIDs 4999 and 5000 from the original 'sales_transaction' table.
DELETE FROM sales_transaction
WHERE TransactionID IN (4999, 5000);

-- Inserts the unique records (previously saved in the temporary table) back into the 'sales_transaction' table.
INSERT INTO sales_transaction (
    TransactionID,
    CustomerID,
    ProductID,
    QuantityPurchased,
    TransactionDate,
    Price
)
SELECT
    TransactionID,
    CustomerID,
    ProductID,
    QuantityPurchased,
    TransactionDate,
    Price
FROM
    temp_unique_sales_subset;

-- Drops/Deletes the temporary table after its use, freeing up resources.
DROP TEMPORARY TABLE temp_unique_sales_subset;

-- Total number of records present in the 'sales_transaction' table after data cleaning.
SELECT COUNT(*) AS "Total_No_of_Records" FROM sales_transaction;

/*
	Insights: This section is comprehensive and well-executed.
	* Data Type Correction: Changing DECIMAL(38,0) and VARCHAR to INT, DATE, and more appropriate VARCHAR lengths
      is crucial for data integrity, efficient storage, and accurate calculations.
	* Handling Nulls/Empty Strings: Identifying and deleting records with missing Location data is a valid approach, 
      especially if the percentage is small and these records would skew analysis. The use of SET SQL_SAFE_UPDATES = 0; 
      and SET SQL_SAFE_UPDATES = 1; is important for allowing such modifications.
	* Data Consistency: The UPDATE statement to synchronize Price between sales_transaction and product_inventory is 
      vital for accurate sales reporting.
	* Handling Out-of-Stock Products: Setting Price = 0 for ProductID = 93 when stock is zero is a reasonable decision, 
      assuming this reflects products that were once available but are now discontinued or temporarily unavailable, and should 
      not contribute to sales revenue.
	* Duplicate Removal: The WITH clause and ROW_NUMBER() are excellent for identifying and managing duplicate records, ensuring
      data uniqueness. The temporary table strategy is effective for removing and re-inserting unique data.
*/

-- EXPLORATORY DATA ANALYSIS (EDA)

-- List of all customers present.
SELECT * FROM customer_profiles;

-- Count of total customers present.
SELECT COUNT(*) AS "Total_no_of_Customers" FROM customer_profiles;

-- List of all products present.
SELECT * FROM product_inventory;

-- Count of total products present.
SELECT COUNT(*) AS "Total_no_of_Products" FROM product_inventory;

-- List of all sales transactions.
SELECT * FROM sales_transaction;

-- Count of total sales transactions.
SELECT COUNT(*) AS "Total_no_of_Transactions" FROM sales_transaction;

-- Distribution of customers by Gender in percentage.
SELECT
    Gender,
    COUNT(CustomerID) AS NumberOfCustomers,
    (COUNT(CustomerID) * 100.0 / (SELECT COUNT(*) FROM customer_profiles)) AS Percentage
FROM
    customer_profiles
GROUP BY
    Gender
ORDER BY
    NumberOfCustomers DESC;
    
/* Insight: This query provides a clear demographic breakdown of the customer base by gender, highlighting the proportion 
of each gender.
*/

-- Distribution of customers by Location in percentage.
SELECT
    Location,
    COUNT(CustomerID) AS NumberOfCustomers,
    (COUNT(CustomerID) * 100.0 / (SELECT COUNT(*) FROM customer_profiles)) AS Percentage
FROM
    customer_profiles
GROUP BY
    Location
ORDER BY
    NumberOfCustomers DESC;
/*	Insight: This shows where the customer base is concentrated, which can be useful for targeted marketing or supply 
	chain optimization.
*/

-- Minimum, Maximum, and Average Age of Customers.
SELECT
    MIN(Age) AS MinimumAge,
    MAX(Age) AS MaximumAge,
    AVG(Age) AS AverageAge
FROM
    customer_profiles;
-- Insight: Provides a quick summary of the age range and central tendency of the customer demographic.

-- Age distribution of customers grouped into predefined age ranges.
SELECT
    CASE
        WHEN Age BETWEEN 0 AND 18 THEN '0-18 (Youth)'
        WHEN Age BETWEEN 19 AND 30 THEN '19-30 (Young Adult)'
        WHEN Age BETWEEN 31 AND 45 THEN '31-45 (Adult)'
        WHEN Age BETWEEN 46 AND 60 THEN '46-60 (Middle-Aged)'
        ELSE '61+ (Senior)'
    END AS AgeGroup,
    COUNT(CustomerID) AS NumberOfCustomers
FROM
    customer_profiles
GROUP BY
    AgeGroup
ORDER BY
    MIN(Age);
-- Insight: Categorizing age allows for easier analysis of customer segments and their preferences.

-- Age distribution by specific age values, ordered by the number of customers.
SELECT
    Age,
    COUNT(CustomerID) AS NumberOfCustomers
FROM
    customer_profiles
GROUP BY
    Age
ORDER BY
    NumberOfCustomers DESC;
-- Insight: Reveals specific age points with higher customer concentrations.

-- Customer joining trends by year.
SELECT
    DATE_FORMAT(JoinDate, '%Y') AS JoiningYear,
    COUNT(CustomerID) AS NumberOfCustomersJoined
FROM
    customer_profiles
GROUP BY
    JoiningYear
ORDER BY
    JoiningYear;
-- Insight: Helps understand growth in customer acquisition over the years.

-- Customer joining trends by month and year.
SELECT
    DATE_FORMAT(JoinDate, '%Y-%m') AS JoiningMonth,
    COUNT(CustomerID) AS NumberOfCustomersJoined
FROM
    customer_profiles
GROUP BY
    JoiningMonth
ORDER BY
    JoiningMonth;
-- Insight: Provides a more granular view of customer acquisition trends, potentially revealing seasonal patterns.

-- Count of products by Category.
SELECT
    Category,
    COUNT(ProductID) AS NumberOfProducts
FROM
    product_inventory
GROUP BY
    Category
ORDER BY
    NumberOfProducts DESC;
-- Insight: Identifies the most populated product categories, indicating the diversity and focus of the product catalog.

-- Top 10 most expensive products.
SELECT
    ProductID,
    ProductName,
    Category,
    Price
FROM
    product_inventory
ORDER BY
    Price DESC;
-- Insight: Highlights high-value items, which could be important for premium customer segments or profit analysis.

-- Products with low stock levels (e.g., less than 10).
SELECT
    ProductID,
    ProductName,
    Category,
    StockLevel
FROM
    product_inventory
WHERE
    StockLevel < 10
ORDER BY
    StockLevel ASC;
-- Insight: Crucial for inventory management and preventing stockouts, ensuring popular items are replenished.

-- Distribution of products by stock level ranges.
SELECT
    CASE
        WHEN StockLevel = 0 THEN 'Out of Stock'
        WHEN StockLevel BETWEEN 1 AND 50 THEN 'Low Stock (1-50)'
        WHEN StockLevel BETWEEN 50 AND 90 THEN 'Medium Stock (50-90)'
        ELSE 'High Stock (91+)'
    END AS StockRange,
    COUNT(ProductID) AS NumberOfProducts
FROM
    product_inventory
GROUP BY
    StockRange
ORDER BY
    FIELD(StockRange, 'Out of Stock', 'Low Stock (1-50)', 'Medium Stock (50-90)', 'High Stock (91+)');
-- Insight: Categorizes products by their stock availability, helping prioritize inventory actions.

-- Overall Minimum, Maximum, and Average Stock Level.
SELECT
    MIN(StockLevel) AS MinimumStockLevel,
    MAX(StockLevel) AS MaximumStockLevel,
    AVG(StockLevel) AS AverageStockLevel
FROM
    product_inventory;
-- Insight: Provides a quick overview of inventory levels across all products.

-- Average price per Category.
SELECT
    Category,
    AVG(Price) AS AveragePrice
FROM
    product_inventory
GROUP BY
    Category
ORDER BY
    AveragePrice DESC;
-- Insight: Shows which categories generally contain higher-priced or lower-priced items.

-- Total Sales Amount and Total Quantity Sold across all transactions.
SELECT
    SUM(QuantityPurchased * Price) AS TotalSalesAmount,
    SUM(QuantityPurchased) AS TotalQuantitySold
FROM
    sales_transaction;
-- Insight: Provides fundamental metrics for overall business performance.

-- Sales trends by year.
SELECT
    DATE_FORMAT(TransactionDate, '%Y') AS SalesYear,
    SUM(QuantityPurchased * Price) AS TotalSalesAmount,
    SUM(QuantityPurchased) AS TotalQuantitySold,
    COUNT(TransactionID) AS NumberOfTransactions
FROM
    sales_transaction
GROUP BY
    SalesYear
ORDER BY
    SalesYear;
-- Insight: Tracks annual sales performance, indicating growth or decline over time.

-- Sales trends by month and year.
SELECT
    DATE_FORMAT(TransactionDate, '%Y-%m') AS SalesMonth,
    SUM(QuantityPurchased * Price) AS TotalSalesAmount,
    SUM(QuantityPurchased) AS TotalQuantitySold,
    COUNT(TransactionID) AS NumberOfTransactions
FROM
    sales_transaction
GROUP BY
    SalesMonth
ORDER BY
    SalesMonth;
-- Insight: Provides seasonal sales patterns, useful for forecasting and marketing campaigns.

-- Best-Selling Products by Quantity.
SELECT
    st.ProductID,
    pi.ProductName,
    pi.Category,
    SUM(st.QuantityPurchased) AS TotalQuantitySold
FROM
    sales_transaction st
JOIN
    product_inventory pi ON st.ProductID = pi.ProductID
GROUP BY
    st.ProductID, pi.ProductName, pi.Category
ORDER BY
    TotalQuantitySold DESC;
-- Insight: Identifies the most popular products in terms of units sold, good for inventory planning and promotions.

-- Best-Selling Products by Total Sales Amount.
SELECT
    st.ProductID,
    pi.ProductName,
    pi.Category,
    SUM(st.QuantityPurchased * st.Price) AS TotalSalesAmount
FROM
    sales_transaction st
JOIN
    product_inventory pi ON st.ProductID = pi.ProductID
GROUP BY
    st.ProductID, pi.ProductName, pi.Category
ORDER BY
    TotalSalesAmount DESC;
-- Insight: Pinpoints products that generate the most revenue, highlighting high-value items.

-- Customers by Total Spending.
SELECT
    st.CustomerID,
    cp.Gender,
    cp.Location,
    SUM(st.QuantityPurchased * st.Price) AS TotalSpent
FROM
    sales_transaction st
JOIN
    customer_profiles cp ON st.CustomerID = cp.CustomerID
GROUP BY
    st.CustomerID, cp.Gender, cp.Location
ORDER BY
    TotalSpent DESC;
-- Insight: Identifies top-spending customers, crucial for loyalty programs and personalized marketing.

-- Average Transaction Value.
SELECT
    AVG(QuantityPurchased * Price) AS AverageTransactionValue
FROM
    sales_transaction;
-- Insight: Provides a benchmark for the typical value of a single transaction.

-- Most popular product categories by total quantity sold.
SELECT
    pi.Category,
    SUM(st.QuantityPurchased) AS TotalQuantitySoldByCategory
FROM
    sales_transaction st
JOIN
    product_inventory pi ON st.ProductID = pi.ProductID
GROUP BY
    pi.Category
ORDER BY
    TotalQuantitySoldByCategory DESC;
-- Insight: Shows which product categories are most frequently purchased, guiding product development and marketing efforts.

-- Average spending per customer.
SELECT
    AVG(TotalSpent) AS AverageSpendingPerCustomer
FROM (
    SELECT
        CustomerID,
        SUM(QuantityPurchased * Price) AS TotalSpent
    FROM
        sales_transaction
    GROUP BY
        CustomerID
) AS CustomerSpending;
-- Insight: Provides an overall average of how much each customer spends, useful for customer lifetime value calculations.

-- Sales analysis divided by Customer Gender.
SELECT
    cp.Gender,
    COUNT(st.TransactionID) AS NumberOfTransactions,
    SUM(st.QuantityPurchased) AS TotalQuantitySold,
    SUM(st.QuantityPurchased * st.Price) AS TotalSalesAmount
FROM
    sales_transaction st
JOIN
    customer_profiles cp ON st.CustomerID = cp.CustomerID
GROUP BY
    cp.Gender
ORDER BY
    TotalSalesAmount DESC;
-- Insight: Helps understand sales performance across different gender demographics.

-- Sales analysis divided by Customer Location.
SELECT
    cp.Location,
    COUNT(st.TransactionID) AS NumberOfTransactions,
    SUM(st.QuantityPurchased) AS TotalQuantitySold,
    SUM(st.QuantityPurchased * st.Price) AS TotalSalesAmount
FROM
    sales_transaction st
JOIN
    customer_profiles cp ON st.CustomerID = cp.CustomerID
GROUP BY
    cp.Location
ORDER BY
    TotalSalesAmount DESC;
-- Insight: Reveals geographical sales strengths and weaknesses, informing distribution and marketing strategies.

-- Sales analysis divided by Product Category.
SELECT
    pi.Category,
    COUNT(st.TransactionID) AS NumberOfTransactions,
    SUM(st.QuantityPurchased) AS TotalQuantitySold,
    SUM(st.QuantityPurchased * st.Price) AS TotalSalesAmount
FROM
    sales_transaction st
JOIN
    product_inventory pi ON st.ProductID = pi.ProductID
GROUP BY
    pi.Category
ORDER BY
    TotalSalesAmount DESC;
-- Insight: Shows which product categories are driving the most sales revenue.

-- Sales analysis divided by Customer Age Group.
SELECT
    CASE
        WHEN cp.Age BETWEEN 0 AND 18 THEN '0-18 (Youth)'
        WHEN cp.Age BETWEEN 19 AND 30 THEN '19-30 (Young Adult)'
        WHEN cp.Age BETWEEN 31 AND 45 THEN '31-45 (Adult)'
        WHEN cp.Age BETWEEN 46 AND 60 THEN '46-60 (Middle-Aged)'
        ELSE '61+ (Senior)'
    END AS AgeGroup,
    COUNT(st.TransactionID) AS NumberOfTransactions,
    SUM(st.QuantityPurchased * st.Price) AS TotalSalesAmount
FROM
    sales_transaction st
JOIN
    customer_profiles cp ON st.CustomerID = cp.CustomerID
GROUP BY
    AgeGroup
ORDER BY
    MIN(cp.Age);
/*	Insight: Identifies which age groups contribute most to sales, aiding in demographic-specific product development and 
	marketing.
*/

-- Average quantity purchased per category.
SELECT
    pi.Category,
    AVG(st.QuantityPurchased) AS AverageQuantityPerSale
FROM
    sales_transaction st
JOIN
    product_inventory pi ON st.ProductID = pi.ProductID
GROUP BY
    pi.Category
ORDER BY
    AverageQuantityPerSale DESC;
-- Insight: Indicates typical purchase sizes for different product categories.

-- Products with high sales but low stock (Potential reorder candidates).
SELECT
    pi.ProductID,
    pi.ProductName,
    pi.Category,
    pi.StockLevel,
    SUM(st.QuantityPurchased * st.Price) AS TotalSalesAmount
FROM
    product_inventory pi
JOIN
    sales_transaction st ON pi.ProductID = st.ProductID
WHERE
    pi.StockLevel < 10 -- Define 'low stock' threshold
GROUP BY
    pi.ProductID, pi.ProductName, pi.Category, pi.StockLevel
ORDER BY
    TotalSalesAmount DESC;
/*	Insight: This is a crucial query for identifying products that are selling well but are at risk of running out, 
	prompting urgent reordering.
*/
-- Customers who bought products from the 'Electronics' category.
SELECT DISTINCT
    cp.CustomerID,
    cp.Gender,
    cp.Location,
    cp.Age
FROM
    customer_profiles cp
JOIN
    sales_transaction st ON cp.CustomerID = st.CustomerID
JOIN
    product_inventory pi ON st.ProductID = pi.ProductID
WHERE
    pi.Category = 'Electronics';
-- Insight: Helps in understanding the profile of customers interested in specific product categories.

-- Customers who bought products from the 'Clothing' category.
SELECT DISTINCT
    cp.CustomerID,
    cp.Gender,
    cp.Location,
    cp.Age
FROM
    customer_profiles cp
JOIN
    sales_transaction st ON cp.CustomerID = st.CustomerID
JOIN
    product_inventory pi ON st.ProductID = pi.ProductID
WHERE
    pi.Category = 'Clothing';
-- Insight: Similar to the above, provides insights into customer profiles for the 'Clothing' category.

-- Customers who bought products from the 'Home & Kitchen' category.
SELECT DISTINCT
    cp.CustomerID,
    cp.Gender,
    cp.Location,
    cp.Age
FROM
    customer_profiles cp
JOIN
    sales_transaction st ON cp.CustomerID = st.CustomerID
JOIN
    product_inventory pi ON st.ProductID = pi.ProductID
WHERE
    pi.Category = 'Home & Kitchen';
-- Insight: Profiles customers interested in 'Home & Kitchen' items.

-- Customers who bought products from the 'Beauty & Health' category.
SELECT DISTINCT
    cp.CustomerID,
    cp.Gender,
    cp.Location,
    cp.Age
FROM
    customer_profiles cp
JOIN
    sales_transaction st ON cp.CustomerID = st.CustomerID
JOIN
    product_inventory pi ON st.ProductID = pi.ProductID
WHERE
    pi.Category = 'Beauty & Health';
-- Insight: Profiles customers interested in 'Beauty & Health' items.

-- Customers who have made more than 10 transactions.
SELECT
    cp.CustomerID,
    cp.Age,
    cp.Gender,
    cp.Location,
    COUNT(st.TransactionID) AS NumberOfTransactions
FROM
    customer_profiles cp
JOIN
    sales_transaction st ON cp.CustomerID = st.CustomerID
GROUP BY
    cp.CustomerID, cp.Age, cp.Gender, cp.Location
HAVING
    COUNT(st.TransactionID) > 10
ORDER BY
    NumberOfTransactions DESC;
-- Insight: Identifies loyal and frequent customers, valuable for retention strategies.

-- Customers whose products were out of stock (identified by Price = 0 after cleaning).
SELECT
    TransactionID,
    CustomerID,
    ProductID,
    QuantityPurchased,
    TransactionDate,
    Price
FROM
    sales_transaction
WHERE
    Price = 0;
-- Insight: Lists transactions where the product was out of stock, which could indicate lost sales opportunities.

-- Average age of customers who purchased from each product category.
SELECT
    pi.Category,
    AVG(cp.Age) AS AverageCustomerAge
FROM
    sales_transaction st
JOIN
    customer_profiles cp ON st.CustomerID = cp.CustomerID
JOIN
    product_inventory pi ON st.ProductID = pi.ProductID
GROUP BY
    pi.Category
ORDER BY
    AverageCustomerAge DESC;
-- Insight: Helps tailor marketing messages and product offerings to the dominant age group for each category.

-- Most popular product category for each location.
WITH LocationCategoryPopularity AS (
    SELECT
        cp.Location,
        pi.Category,
        SUM(st.QuantityPurchased) AS TotalQuantitySold,
        ROW_NUMBER() OVER(PARTITION BY cp.Location ORDER BY SUM(st.QuantityPurchased) DESC) AS rn
    FROM
        sales_transaction st
    JOIN
        customer_profiles cp ON st.CustomerID = cp.CustomerID
    JOIN
        product_inventory pi ON st.ProductID = pi.ProductID
    GROUP BY
        cp.Location, pi.Category
)
SELECT
    Location,
    Category AS MostPopularCategory,
    TotalQuantitySold
FROM
    LocationCategoryPopularity
WHERE
    rn = 1
ORDER BY
    Location;
-- Insight: Provides localized insights into product preferences, informing regional inventory and marketing.

-- Customers with no transactions (using LEFT JOIN to find unmatched customers).
SELECT
    cp.CustomerID,
    cp.Gender,
    cp.Location,
    cp.JoinDate
FROM
    customer_profiles cp
LEFT JOIN
    sales_transaction st ON cp.CustomerID = st.CustomerID
WHERE
    st.CustomerID IS NULL;
/*	Insight: Identifies dormant customers or those who registered but haven't made a purchase, potential targets 
	for re-engagement campaigns.
*/

-- Segment customers based on Total Number of Orders.
SELECT
    cp.CustomerID,
    COUNT(DISTINCT st.TransactionID) AS TotalOrders,
    CASE
        WHEN COUNT(DISTINCT st.TransactionID) = 0 THEN 'No orders'
        WHEN COUNT(DISTINCT st.TransactionID) BETWEEN 1 AND 10 THEN 'Low'
        WHEN COUNT(DISTINCT st.TransactionID) BETWEEN 11 AND 30 THEN 'Mid'
        ELSE 'High'
    END AS CustomerSegment
FROM
    customer_profiles cp
LEFT JOIN -- Use LEFT JOIN to include all customers, even those with no orders
    sales_transaction st ON cp.CustomerID = st.CustomerID
GROUP BY
    cp.CustomerID
ORDER BY
    TotalOrders DESC;
/*	Insight: This query performs customer segmentation, a powerful technique for tailoring marketing strategies 
	and understanding customer value.
*/

/*	Insights: The EDA section is very comprehensive, covering various aspects of customer behavior, product performance, 
	and sales trends. The use of JOIN operations to combine data from different tables is effective for gaining holistic insights. 
	The addition of CASE statements for age and stock level grouping is excellent for creating meaningful segments. This set of 
	queries provides a strong foundation for understanding the dataset and identifying key business metrics and patterns.
*/