USE trips_db;

SELECT *
FROM fact_passenger_summary;

#Total new passengers
SELECT SUM(new_passengers) AS Total_new_passengers    -- to get the total new passengers count 
FROM fact_passenger_summary;

#Top 3 cities with highest no of new passengers 
SELECT c.city_name, 
		SUM(p.new_passengers) AS Total_new_Passengers
FROM dim_city c 
INNER JOIN fact_passenger_summary p 
ON c.city_id = p.city_id
GROUP BY c.city_name
ORDER BY Total_new_Passengers DESC      -- used order by desc to get the top cities with highest no of total new passengers 
LIMIT 3;    --  limit 3 indicates that display top 3 cities with highest total new passengers

#Bottom 3 cities with lowest number of new passengers 
SELECT c.city_name, 
		SUM(p.new_passengers) AS Total_new_Passengers
FROM dim_city c 
INNER JOIN fact_passenger_summary p 
ON c.city_id = p.city_id
GROUP BY c.city_name
ORDER BY Total_new_Passengers ASC --  used order by asc to get the bottom cities with lowest no of total new passengers 
LIMIT 3;  -- limit 3 indicates that display bottom 3 cities with lowest no of total new passengers

