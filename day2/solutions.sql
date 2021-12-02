-- Solution Day 2: Part 1
with net_movement as (
    select sum(case when movement = 'forward' then move else 0 end) as horizontal,
           sum(case when movement = 'down' then move else 0 end) -
           sum(case when movement = 'up' then move else 0 end)      as vertical
    from pilot
)
select horizontal * vertical from net_movement;

-- Solution Day 2: Part 2
with cumulative_moves as (
    select id,
           movement,
           move,
           sum(case when movement = 'forward' then move else 0 end)
               over (order by id rows between unbounded preceding and current row)  as horizontal,
           sum(case when movement = 'down' then move when movement = 'up' then -move else 0 end)
               over (order by id rows between unbounded preceding and current row)  as vertical
    from pilot
), depth_moves as (
    select *,
           case when movement = 'forward' then move * vertical else 0 end as depth_target
    from cumulative_moves
), net_movement as (
    select *, sum(depth_target) over (order by id rows between unbounded preceding and current row) as depth
    from depth_moves
)
select horizontal * depth from net_movement where id = (select max(id) from pilot);
