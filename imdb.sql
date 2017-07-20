select count(sub.movie_id)
from
(select movie_id, actor_id, gender, year,
case
when gender = 'F' then
1
when gender = 'M' then
0
END correctgender
from actors a
inner join roles r on r.actor_id = a.id
inner join movies m on r.movie_id = m.id
-- where year in (1918, 1919, 1920)
group by movie_id
having max(correctgender) = 1 and min(correctgender) = 1) sub
group by year
order by year;
