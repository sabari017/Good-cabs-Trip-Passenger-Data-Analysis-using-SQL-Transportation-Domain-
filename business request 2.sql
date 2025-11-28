USE targets_db;

SELECT *
FROM monthly_target_trips;

#Total_target_trips monthly
SELECT monthname(month),
		SUM(total_target_trips) AS target_trips_monthly           -- to know the total target trips monthly 
FROM monthly_target_trips
GROUP BY monthname(month);

#Total Target trips city level
SELECT city_id,
		SUM(total_target_trips) AS target_trips_citylevel   -- to know the Total target trips city level
FROM monthly_target_trips
GROUP BY city_id;

USE trips_db;

#Total Actual trips monthly
SELECT monthname(date) AS Month,  
		COUNT(trip_id) AS Actual_total_trips      -- COUNT the tripid overall to get the Actual total trips 
FROM fact_trips
GROUP BY monthname(date)                           -- to display it monthlty 
ORDER BY Actual_total_trips DESC;               

#Total actual trips city level
SELECT c.city_name,
		COUNT(f.trip_id) AS Actual_total_trips            
FROM dim_city c 
INNER JOIN fact_trips f 
ON c.city_id = f.city_id
GROUP BY c.city_name                   --  to display city wise actual total trips 
ORDER BY  Actual_total_trips  DESC;     --  order highest to lowest 

#To get monthly,city level actual trips and target trips and  compare them by categorizing 
WITH actual_monthly AS (                           -- used CTE to create temporary tables so that it can be used again in main query SELECT
    SELECT 
        c.city_name,
        monthname(f.date) AS month,
        COUNT(f.trip_id) AS actual_trips
    FROM trips_db.fact_trips f
    INNER JOIN trips_db.dim_city c
        ON f.city_id = c.city_id
    GROUP BY c.city_name, monthname(f.date)
),

target_monthly AS (
    SELECT 
        c.city_name,   -- city_name added using JOIN
        monthname(t.month) AS month,
        SUM(t.total_target_trips) AS target_trips
    FROM targets_db.monthly_target_trips t
    INNER JOIN trips_db.dim_city c     -- join with trips_db for city_name
        ON t.city_id = c.city_id
    GROUP BY c.city_name, monthname(t.month)
)

SELECT 
    a.city_name,
    a.month,
    a.actual_trips,
    t.target_trips,

    CASE
        WHEN a.actual_trips > t.target_trips THEN 'Above Target'  -- used case to create categories- above target ,below target 
        ELSE 'Below Target'
    END AS performance_status,

    ((a.actual_trips - t.target_trips) / t.target_trips) * 100 AS percentage_difference   -- actual trips - target trips / target trips gives difference
FROM actual_monthly a
INNER JOIN target_monthly t
    ON a.city_name = t.city_name AND a.month = t.month
ORDER BY percentage_difference DESC;




