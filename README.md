# Retail Data Analysis with SQL
This repository contains SQL scripts for managing, cleaning, and analyzing a retail dataset. The dataset consists of three core tables: customer_profiles, product_inventory, and sales_transaction. The scripts guide you through database setup, data loading, essential data cleaning steps, and a comprehensive Exploratory Data Analysis (EDA) to uncover valuable business insights.

# Project Overview
This project aims to demonstrate a typical data workflow using SQL, from raw data ingestion to insightful analysis. The key objectives include:

Database Setup: Creating the necessary database and table structures.
Data Loading: Importing data from CSV files into the SQL tables.
Data Cleaning: Addressing data type inconsistencies, handling missing values, ensuring data integrity, and removing duplicates.
Exploratory Data Analysis (EDA): Querying the cleaned data to understand customer demographics, product performance, sales trends, and cross-sectional relationships between tables.

<img width="867" height="425" alt="Screenshot 2025-08-09 135335" src="https://github.com/user-attachments/assets/05c1a58c-eed7-4885-beb7-d11eedbd9d9b" />

<img width="870" height="427" alt="Screenshot 2025-08-09 135531" src="https://github.com/user-attachments/assets/659b03bd-a9c2-41b4-9e38-c8f354458be2" />


# Data Cleaning Highlights
The data cleaning section is robust and addresses several common data quality issues:

Data Type Conversion: Initial DECIMAL and VARCHAR types for IDs, ages, and dates are converted to more appropriate INT and DATE types, improving storage efficiency and enabling proper date/numeric operations. VARCHAR lengths are also adjusted for better fit.
Handling Missing Values: Records with empty Location values in customer_profiles are identified and removed, as they represent a very small percentage of the data, ensuring that location-based analysis is accurate. Corresponding sales transactions are also cleaned.
Data Consistency: The Price column in sales_transaction is updated to match the authoritative Price in product_inventory, resolving potential discrepancies.
Handling Out-of-Stock Products: Transactions involving ProductID = 93 (identified as out of stock with StockLevel = 0) have their Price set to 0 to reflect that no revenue was generated from these items.
Duplicate Removal: A TEMPORARY TABLE and ROW_NUMBER() are used to effectively identify and remove duplicate sales transactions, ensuring that each transaction is counted only once.
Safe Update Mode: The use of SET SQL_SAFE_UPDATES = 0; and SET SQL_SAFE_UPDATES = 1; is demonstrated for safely performing mass updates/deletions.

# Exploratory Data Analysis (EDA) Highlights
The EDA section provides a comprehensive look into the dataset, covering various aspects:

Overall Metrics: Total counts of customers, products, and transactions.
Customer Demographics: Distribution by gender, location, age groups, and joining trends over time.
Product Insights: Analysis of product categories, pricing (top 10 expensive), stock levels (low stock, stock ranges), and average prices per category.
Sales Performance: Total sales amount, total quantity sold, and sales trends by year and month.
Top Performers: Identification of best-selling products by quantity and revenue, and top-spending customers.
Transaction Analysis: Average transaction value and average quantity purchased per category.
Cross-Sectional Analysis:
Sales breakdown by customer gender, location, and age group.
Average customer age per product category.
Most popular product categories by location.
Identification of high-selling products with low stock (reorder candidates).
Customer segmentation based on the number of orders.
Customers who purchased from specific categories (e.g., 'Electronics', 'Clothing').
Customers with no transactions.
Customers who made more than 10 transactions.
Transactions involving out-of-stock products.

# Insights and Key Takeaways
The analysis provided by these scripts can reveal critical business insights, such as:

Customer Segmentation: Understanding different customer groups (e.g., by age, location, or spending habits) allows for tailored marketing campaigns and personalized recommendations.
Inventory Management: Identifying low-stock, high-demand products helps prevent stockouts and optimize inventory replenishment strategies.
Sales Performance Trends: Recognizing seasonal patterns or long-term growth/decline in sales can inform strategic business decisions and forecasting.
Product Popularity: Knowing which products and categories are most popular can guide product development, merchandising, and promotional efforts.
Geographic Performance: Understanding sales distribution by location can help optimize regional marketing and logistics.
