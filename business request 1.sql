USE trips_db;

# To verify the tables in the current database
SELECT *
FROM dim_city;

# To check the columns and data  present in this table
SELECT *
FROM fact_trips;

#Total_trips
SELECT COUNT(trip_id) AS Total_trips  -- Used COUNT function to get the total trips(Results - 425903 Total trips)
FROM fact_trips;

#Average Fare Per Trip
SELECT trip_id,
		AVG(fare_amount) AS Avg_fare_per_trip --  Used AVG function to get avg fare amount and group by trip_id to get (result avg fare per trip)
FROM fact_trips
GROUP BY trip_id
ORDER BY Avg_fare_per_trip DESC;

#Average Fare Per Km
SELECT  trip_id,
		AVG(fare_amount / distance_travelled_km) AS Avg_fare_per_km  -- used Avg fare per km = total fare / km 
FROM fact_trips
GROUP BY trip_id
ORDER BY Avg_fare_per_km DESC;


#Total no.of trips city_wise
SELECT c.city_name,
		COUNT(f.trip_id) AS total_trips   -- used inner join to join dim_city and fact_trips table  to get city name
FROM dim_city c 
INNER JOIN fact_trips f 
ON c.city_id = f.city_id
GROUP BY c.city_name
ORDER BY total_trips DESC;

#city with total trips and the percentage contribution of each city's trips to overall trips
SELECT c.city_name,
		COUNT(f.trip_id) AS Total_trips_citywise,
        (COUNT(f.trip_id)/(SELECT COUNT(*) FROM fact_trips)) * 100 AS Percentage_contribution_to_total_trips  --  city_trips/total_trips * 100 to get  percentage of each city
FROM dim_city c 
INNER JOIN fact_trips f 
ON c.city_id = f.city_id
GROUP BY c.city_name
ORDER BY Percentage_contribution_to_total_trips DESC;





