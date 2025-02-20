select 
  dc.city_name, 
  count(ft.trip_id) as total_trips, 
  sum(ft.fare_amount) / sum(ft.distance_travelled_km) as avg_fare_per_km, 
  avg(ft.fare_amount) as avg_fare_trip, 
  ROUND(
    (
      count(ft.trip_id)/(
        select 
          count(trip_id) as sum_trip 
        from 
          fact_trips
      )
    )* 100, 
    2
  ) as perct_contri_total_trips 
from 
  dim_city dc 
  inner join fact_trips ft on dc.city_id = ft.city_id 
group by 
  dc.city_name
