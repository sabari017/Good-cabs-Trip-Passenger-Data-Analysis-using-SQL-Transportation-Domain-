USE trips_db;

SELECT *
FROM fact_trips;

-- 1) Passenger Rating by City & Passenger Type
SELECT 
    c.city_name,
    f.passenger_type,
    AVG(f.passenger_rating) AS avg_passenger_rating
FROM dim_city c
INNER JOIN fact_trips f 
       ON c.city_id = f.city_id
GROUP BY c.city_name, f.passenger_type
ORDER BY avg_passenger_rating DESC;   -- to display the avg rating highest to lowest


-- 2) Driver Rating by City  (separate query)
SELECT 
    c.city_name,
    AVG(f.driver_rating) AS avg_driver_rating      -- AVG to find the average rating of drivers
FROM dim_city c
INNER JOIN fact_trips f 
       ON c.city_id = f.city_id
GROUP BY c.city_name
ORDER BY avg_driver_rating DESC;  -- to display the avg rating highest to lowest

#identifying month with highest and lowest total trips (peak and low demand)
SELECT c.city_name,
		monthname(f.date) AS month,               -- used function monthname to display the name of month(date)
        COUNT(f.trip_id) AS Total_trips
FROM dim_city c 
INNER JOIN fact_trips f 
       ON c.city_id = f.city_id 
GROUP BY c.city_name,monthname(f.date)
ORDER BY Total_trips DESC;   -- to know peak and low demand monthly by city 


#To find total trips during weekdays and weekends for cities
SELECT 
    c.city_name,
                                                          -- using case to create categories weekend, weekday based on the condition
    CASE 
        WHEN DAYOFWEEK(f.date) IN (1, 7) THEN 'Weekend'   -- Saturday, Sunday    
        ELSE 'Weekday'                                   -- Monday to Friday
    END AS day_type,             
    
    COUNT(f.trip_id) AS total_trips          
FROM fact_trips f
INNER JOIN dim_city c 
       ON f.city_id = c.city_id
GROUP BY c.city_name, day_type
ORDER BY c.city_name, total_trips DESC;


#city with highest weekend trips
SELECT city_name, total_trips
FROM (                                            -- used subquery from to create temporary table and result. This result will be used in main SELECT query
    SELECT 
        c.city_name,
        COUNT(*) AS total_trips
    FROM fact_trips f
    JOIN dim_city c ON f.city_id = c.city_id
    WHERE DAYOFWEEK(f.date) IN (1,7)
    GROUP BY c.city_name
) AS t
ORDER BY total_trips DESC    -- to get the  city with highest total trips in weekend
LIMIT 1;


#It is a summary combining the AVG passenger and driver rating city level.
SELECT 
    city_name,
    passenger_type,
    avg_passenger_rating,
    avg_driver_rating
FROM                                       -- used FROM subquery to create a temporary table and use this result in main query
(
 SELECT c.city_name,
		f.passenger_type,
		AVG(f.driver_rating) AS avg_driver_rating,
		AVG(f.passenger_rating) AS avg_passenger_rating
FROM dim_city c
INNER JOIN fact_trips f 
       ON c.city_id = f.city_id
GROUP BY c.city_name, f.passenger_type
)AS A
ORDER BY avg_passenger_rating DESC,avg_driver_rating DESC;

