-- Aggregate actual trips per city per month
WITH actual_trips AS (
    SELECT
        ft.city_id,
        DATE_FORMAT(ft.date, '%Y-%m') AS month,
        COUNT(ft.trip_id) AS actual_trips
    FROM
        trips_db.fact_trips ft
    GROUP BY
        ft.city_id,
        DATE_FORMAT(ft.date, '%Y-%m')
),

-- Get target trips per city per month
target_trips AS (
    SELECT
        tt.city_id,
        DATE_FORMAT(tt.month, '%Y-%m') AS month,
        tt.total_target_trips
    FROM
        targets_db.monthly_target_trips tt
)

-- Join aggregated data with city names
SELECT
    dc.city_name,
    at.month,
    at.actual_trips,
    tt.total_target_trips AS target_trips
FROM
    actual_trips at
JOIN
    target_trips tt ON at.city_id = tt.city_id AND at.month = tt.month
JOIN
    trips_db.dim_city dc ON at.city_id = dc.city_id
ORDER BY
    dc.city_name,
    at.month;
