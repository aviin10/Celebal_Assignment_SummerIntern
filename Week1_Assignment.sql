USE AdventureWorksDW2022;
GO

-- 1. List of all customers
SELECT * FROM DimCustomer;

-- 2. Customers where email ends in 'N' (case-insensitive)
SELECT * FROM DimCustomer WHERE EmailAddress LIKE '%n';

-- 3. Customers who live in Berlin or London
SELECT * FROM DimGeography
WHERE City IN ('Berlin', 'London');

-- 4. Customers who live in UK or USA
SELECT dc.*
FROM DimCustomer dc
JOIN DimGeography dg ON dc.GeographyKey = dg.GeographyKey
WHERE dg.EnglishCountryRegionName IN ('United Kingdom', 'United States');

-- 5. All products sorted by product name
SELECT * FROM DimProduct
ORDER BY EnglishProductName;

-- 6. Products where product name starts with 'A'
SELECT * FROM DimProduct
WHERE EnglishProductName LIKE 'A%';

-- 7. Customers who ever placed an order
SELECT DISTINCT dc.CustomerKey, dc.FirstName, dc.LastName
FROM DimCustomer dc
JOIN FactInternetSales fis ON dc.CustomerKey = fis.CustomerKey;

-- 8. Customers who live in London and have bought a product named 'chai'
SELECT DISTINCT dc.CustomerKey, dc.FirstName, dc.LastName
FROM DimCustomer dc
JOIN DimGeography dg ON dc.GeographyKey = dg.GeographyKey
JOIN FactInternetSales fis ON dc.CustomerKey = fis.CustomerKey
JOIN DimProduct dp ON fis.ProductKey = dp.ProductKey
WHERE dg.City = 'London' AND dp.EnglishProductName LIKE '%chai%';

-- 9. Customers who never placed an order
SELECT * FROM DimCustomer
WHERE CustomerKey NOT IN (SELECT DISTINCT CustomerKey FROM FactInternetSales);

-- 10. Customers who ordered 'Tofu'
SELECT DISTINCT dc.CustomerKey, dc.FirstName, dc.LastName
FROM DimCustomer dc
JOIN FactInternetSales fis ON dc.CustomerKey = fis.CustomerKey
JOIN DimProduct dp ON fis.ProductKey = dp.ProductKey
WHERE dp.EnglishProductName LIKE '%Tofu%';

-- 11. First order of the system
SELECT TOP 1 * FROM FactInternetSales
ORDER BY OrderDateKey;

-- 12. Most expensive order (by SalesAmount)
SELECT TOP 1 * FROM FactInternetSales
ORDER BY SalesAmount DESC;

-- 13. OrderID and average quantity of items in that order
SELECT SalesOrderNumber, AVG(OrderQuantity) AS AvgQty
FROM FactInternetSales
GROUP BY SalesOrderNumber;

-- 14. OrderID with min and max quantity
SELECT SalesOrderNumber,
       MIN(OrderQuantity) AS MinQty,
       MAX(OrderQuantity) AS MaxQty
FROM FactInternetSales
GROUP BY SalesOrderNumber;

-- 15. Managers and number of employees reporting to them
SELECT ParentEmployeeKey AS ManagerKey, COUNT(*) AS TotalEmployees
FROM DimEmployee
WHERE ParentEmployeeKey IS NOT NULL
GROUP BY ParentEmployeeKey;


-- 16. OrderID with total quantity > 300
SELECT SalesOrderNumber, SUM(OrderQuantity) AS TotalQty
FROM FactInternetSales
GROUP BY SalesOrderNumber
HAVING SUM(OrderQuantity) > 300;

-- 17. Orders placed on or after 1996-12-31
SELECT * FROM FactInternetSales
WHERE CONVERT(DATE, CAST(OrderDateKey AS CHAR(8))) >= '1996-12-31';

-- 18. Orders shipped to Canada
SELECT fis.*
FROM FactInternetSales fis
JOIN DimSalesTerritory dst ON fis.SalesTerritoryKey = dst.SalesTerritoryKey
WHERE dst.SalesTerritoryCountry = 'Canada';

-- 19. Orders with SalesAmount > 200
SELECT * FROM FactInternetSales
WHERE SalesAmount > 200;

-- 20. Countries and total sales in each country
SELECT dst.SalesTerritoryCountry, SUM(fis.SalesAmount) AS TotalSales
FROM FactInternetSales fis
JOIN DimSalesTerritory dst ON fis.SalesTerritoryKey = dst.SalesTerritoryKey
GROUP BY dst.SalesTerritoryCountry;

-- 21. Customer name and number of orders
SELECT dc.FirstName, dc.LastName, COUNT(*) AS OrdersPlaced
FROM DimCustomer dc
JOIN FactInternetSales fis ON dc.CustomerKey = fis.CustomerKey
GROUP BY dc.FirstName, dc.LastName;

-- 22. Customers who placed more than 3 orders
SELECT dc.FirstName, dc.LastName, COUNT(*) AS OrdersPlaced
FROM DimCustomer dc
JOIN FactInternetSales fis ON dc.CustomerKey = fis.CustomerKey
GROUP BY dc.FirstName, dc.LastName
HAVING COUNT(*) > 3;

-- 23. Discontinued products ordered between 1997 and 1998
SELECT DISTINCT dp.ProductKey, dp.EnglishProductName
FROM DimProduct dp
JOIN FactInternetSales fis ON dp.ProductKey = fis.ProductKey
WHERE dp.Status = 'Discontinued'
  AND CONVERT(DATE, CAST(fis.OrderDateKey AS CHAR(8))) BETWEEN '1997-01-01' AND '1998-01-01';

-- 24. Employee first name, last name, and their supervisor's name
SELECT e.FirstName AS EmployeeFirst, e.LastName AS EmployeeLast,
       m.FirstName AS ManagerFirst, m.LastName AS ManagerLast
FROM DimEmployee e
LEFT JOIN DimEmployee m ON e.ParentEmployeeKey = m.EmployeeKey;

-- 25. Employee name and total sales
SELECT 
    e.FirstName, e.LastName, 
    SUM(frs.SalesAmount) AS TotalSales
FROM DimEmployee e
JOIN FactResellerSales frs ON e.EmployeeKey = frs.EmployeeKey
GROUP BY e.FirstName, e.LastName;

-- 26. Customers whose email contains 'a'
SELECT * FROM DimCustomer
WHERE EmailAddress LIKE '%a%';