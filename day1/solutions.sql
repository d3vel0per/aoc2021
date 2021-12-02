-- Solution Day 1: Problem 1
with increasing(is_increasing) as (select case when (depth - lag(depth) over (order by id)) > 0 then 1 else 0 end from depth_gauge)
select sum(is_increasing) from increasing;

-- Solution Day 1: Problem 2
with three_measurement_window as (select id, sum(depth) over(order by id rows between current row and 2 following) as measurement from depth_gauge)
, increasing(is_increasing) as (select case when (measurement - lag(measurement) over (order by id)) > 0 then 1 else 0 end from three_measurement_window)
select sum(is_increasing) from increasing;
