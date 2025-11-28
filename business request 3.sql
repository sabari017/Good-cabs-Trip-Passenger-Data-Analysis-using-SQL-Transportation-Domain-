USE trips_db;

SELECT *
FROM dim_repeat_trip_distribution;

#city level repeat passenger trip frequency
SELECT 
    c.city_name,
     d.month,
    d.trip_count,
    d.repeat_passenger_count,
    -- percentage calculation using subquery
    (d.repeat_passenger_count /                     -- repeat passengers count / total repeat passenger count
        (SELECT SUM(d2.repeat_passenger_count) AS Total_repeat_passengers -- SUM to get the total repeat passenger count   
        -- used select sub query to create a column percentage
         FROM dim_repeat_trip_distribution d2
         WHERE d2.city_id = d.city_id)
    ) * 100 AS percentage
FROM dim_city c
INNER JOIN dim_repeat_trip_distribution d 
    ON c.city_id = d.city_id;


