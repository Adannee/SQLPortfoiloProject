SELECT name FROM sqlite_master WHERE type='table';

/*Top 5 Best-Selling Albums*/

SELECT 
    a.Title AS Album, 
    ar.Name AS Artist, 
    COUNT(il.InvoiceLineId) AS Total_Sales
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
JOIN Album a ON t.AlbumId = a.AlbumId
JOIN Artist ar ON a.ArtistId = ar.ArtistId
GROUP BY a.AlbumId
ORDER BY Total_Sales DESC
LIMIT 5;

/* Total Revenue by Genre*/

SELECT 
    g.Name AS Genre, 
    SUM(il.UnitPrice * il.Quantity) AS Total_Revenue
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
JOIN Genre g ON t.GenreId = g.GenreId
GROUP BY g.Name
ORDER BY Total_Revenue DESC;

/*Monthly Revenue Trend*/

WITH MonthlySales AS (
    SELECT 
        strftime('%Y-%m', InvoiceDate) AS Month, 
        SUM(Total) AS Revenue
    FROM Invoice
    GROUP BY Month
)
SELECT * FROM MonthlySales ORDER BY Month;

/*Top 5 Countries by Total Revenue*/

SELECT 
    BillingCountry AS Country, 
    SUM(Total) AS Revenue
FROM Invoice
GROUP BY BillingCountry
ORDER BY Revenue DESC
LIMIT 5;

/*Most Popular Artists by Sales*/

SELECT 
    ar.Name AS Artist, 
    COUNT(il.InvoiceLineId) AS Total_Sales
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
JOIN Album a ON t.AlbumId = a.AlbumId
JOIN Artist ar ON a.ArtistId = ar.ArtistId
GROUP BY ar.ArtistId
ORDER BY Total_Sales DESC
LIMIT 5;

/*Customer Lifetime Value */

SELECT 
    c.CustomerId, 
    c.FirstName || ' ' || c.LastName AS Customer_Name, 
    COUNT(i.InvoiceId) AS Total_Purchases, 
    SUM(i.Total) AS Lifetime_Value
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId
ORDER BY Lifetime_Value DESC
LIMIT 5;

/*Most Popular Music Genre by Country*/

SELECT 
    i.BillingCountry AS Country, 
    g.Name AS Genre, 
    COUNT(il.InvoiceLineId) AS Sales_Count
FROM Invoice i
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
JOIN Track t ON il.TrackId = t.TrackId
JOIN Genre g ON t.GenreId = g.GenreId
GROUP BY Country, Genre
ORDER BY Sales_Count DESC;

/*Employee Performance (Top Sales Reps)*/

SELECT 
    e.FirstName || ' ' || e.LastName AS Employee_Name, 
    SUM(i.Total) AS Total_Sales
FROM Employee e
JOIN Customer c ON e.EmployeeId = c.SupportRepId
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY e.EmployeeId
ORDER BY Total_Sales DESC;