USE trips_db;

#City-Wide Overall Repeat Passenger Rate (All Months Combined)
SELECT c.city_name,
        SUM(p.total_passengers) AS Total_passengers,   -- SUM (total passengers) to get overall total passengers count
        SUM(p.repeat_passengers) AS repeat_passengers,  -- SUM to get the overall total repeat passengers
        (SUM(p.repeat_passengers) / SUM(p.total_passengers)) * 100 AS city_repeat_passenger_rate -- repeate passemgers / total passengers *100 gives the overall city repeat passengers rate
FROM dim_city c 
INNER JOIN fact_passenger_summary p 
ON c.city_id = p.city_id
GROUP BY c.city_name
ORDER BY city_repeat_passenger_rate DESC;  -- to display the repeat passenger rate from highest to lowest

#Monthly Repeat Passenger Rate (City + Month Level)
SELECT 
    c.city_name,
    monthname(p.month) AS month,  -- changed the date format to get only month name
    p.total_passengers,
    p.repeat_passengers,
    (p.repeat_passengers / p.total_passengers) * 100 AS monthly_repeat_passenger_rate  -- repeat passengers / total passengers to know the repeat passenger rate
FROM fact_passenger_summary p
INNER JOIN dim_city c
    ON p.city_id = c.city_id
    ORDER BY monthly_repeat_passenger_rate DESC;   -- to display the repeat passenger rate from highest to lowest
