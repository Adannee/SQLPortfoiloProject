/*Total Global Video Game Sales*/
SELECT SUM(Global_Sales) AS Total_Global_Sales FROM vgsales;

/*Top 5 Best-Selling Video Games*/
SELECT Name, Global_Sales
FROM vgsales
ORDER BY Global_Sales DESC
LIMIT 5;
/*Sales by Platform*/
SELECT Platform, SUM(Global_Sales) AS Total_Sales
FROM vgsales
GROUP BY Platform
ORDER BY Total_Sales DESC;

/*Sales by Genre*/
SELECT Genre, SUM(Global_Sales) AS Total_Sales
FROM vgsales
GROUP BY Genre
ORDER BY Total_Sales DESC;

/*Most Successful Game Publishers*/
SELECT Publisher, SUM(Global_Sales) AS Total_Sales
FROM vgsales
GROUP BY Publisher
ORDER BY Total_Sales DESC
LIMIT 5;

/*Sales Trends by Year*/
SELECT Year, SUM(Global_Sales) AS Yearly_Sales
FROM  vgsales
GROUP BY Year
ORDER BY Year;

/*Most Popular Genre by Year*/
WITH GenreRank AS (
    SELECT Year, Genre, SUM(Global_Sales) AS Total_Sales,
           RANK() OVER (PARTITION BY Year ORDER BY SUM(Global_Sales) DESC) AS rnk
    FROM vgsales
    GROUP BY Year, Genre
)
SELECT Year, Genre, Total_Sales
FROM GenreRank
WHERE rnk = 1
ORDER BY Total_Sales DESC;

SELECT Name, Global_Sales
FROM vgsales
ORDER BY Global_Sales DESC
LIMIT 1;

SELECT Year, 
       SUM(Global_Sales) AS Total_Sales, 
       LAG(SUM(Global_Sales)) OVER (ORDER BY Year) AS Previous_Year_Sales,
       ROUND(((SUM(Global_Sales) - LAG(SUM(Global_Sales)) OVER (ORDER BY Year)) 
              / LAG(SUM(Global_Sales)) OVER (ORDER BY Year)) * 100, 2) AS Growth_Rate
FROM vgsales
GROUP BY Year
ORDER BY Growth_Rate DESC;

/*Longest-Lasting Top 10 Games*/
WITH RankedGames AS (
    SELECT Name, Year, 
           RANK() OVER (PARTITION BY Year ORDER BY Global_Sales DESC) AS rank
    FROM vgsales
)
SELECT Name, COUNT(DISTINCT Year) AS Years_In_Top_10
FROM RankedGames
WHERE rank <= 10
GROUP BY Name
ORDER BY Years_In_Top_10 DESC
LIMIT 10;

SELECT Region, SUM(Global_Sales) AS Total_Sales
FROM vgsales
GROUP BY Region
ORDER BY Total_Sales DESC;