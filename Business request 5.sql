USE trips_db;

SELECT *
FROM fact_trips;

# monthly revenue for each city 
SELECT c.city_name,
		monthname(f.date) AS month,               -- used monthname function to display the month from given date
        SUM(f.fare_amount) AS Monthly_amount      -- SUM to get the total amount
FROM dim_city c 
INNER JOIN fact_trips f 
ON c.city_id = f.city_id
GROUP BY c.city_name,monthname(f.date)
ORDER BY Monthly_amount DESC;  -- used order by monthly amount desc to get the city wise monthly highest revenue


# total revenue of each city
SELECT c.city_name,
        SUM(f.fare_amount) AS Total_amount     -- SUM to get the total revenue overall
FROM dim_city c 
INNER JOIN fact_trips f 
ON c.city_id = f.city_id
GROUP BY c.city_name;

#monthly revenue for each city CTE
WITH Monthly_revenue AS(SELECT c.city_name,  -- created CTE to make it easier and  reuse the table or result in main query
		                      monthname(f.date) AS month,
                              SUM(f.fare_amount) AS Monthly_amount
FROM dim_city c 
INNER JOIN fact_trips f 
ON c.city_id = f.city_id
GROUP BY c.city_name,monthname(f.date)
),

# total revenue of each city CTE
Total_revenue AS (SELECT c.city_name,
                         SUM(f.fare_amount) AS Total_amount
FROM dim_city c 
INNER JOIN fact_trips f 
ON c.city_id = f.city_id
GROUP BY c.city_name
)
SELECT m.city_name,         -- both CTE are included in main query to get the percentage contribution
		m.month,
        (m.Monthly_amount / t.Total_amount) * 100 AS Percentage_contribution  -- monthly amount / total amount to get percentage distribution monthly of each city
FROM Monthly_revenue m 
INNER JOIN Total_revenue t 
ON m.city_name = t.city_name
ORDER BY Percentage_contribution DESC;
