select *
from movies
where year = 1985;

select count(*)
from movies
where year = 1982;

select *
from actors
where last_name like '%stack%';

select count(*) as count, first_name
from actors
group by first_name
order by count desc
limit 10;

select count(*) as count, last_name
from actors
group by last_name
order by count desc
limit 10;

select count(r.actor_id) as role_number, a.first_name, a.last_name
from actors a
inner join roles r on r.actor_id = a.id
group by a.id
order by role_number desc
limit 100;

select count(movie_id) as genre_count, genre
from movies_genres mg
inner join movies m on m.id = mg.movie_id
group by genre
order by genre_count;

select first_name, last_name
from roles r
inner join movies m on r.movie_id = m.id
inner join actors a on a.id = r.actor_id
where m.name = 'Braveheart'
and m.year = 1995
order by last_name;

select d.first_name, d.last_name, m.name, m.year
from directors d
inner join movies_directors md on md.director_id = d.id
inner join movies m on m.id = md.movie_id
inner join movies_genres mg on mg.movie_id = m.id
where mg.genre = 'Film-Noir'
and m.year % 4 = 0
order by m.name;

select a.first_name, a.last_name, m.name
from roles r
join actors a on a.id = r.actor_id
join movies m on m.id = r.movie_id
where r.movie_id IN (select m.id
from roles r
inner join movies m on m.id = r.movie_id
inner join movies_genres mg on mg.movie_id = m.id
inner join actors a on a.id = r.actor_id
where a.first_name = 'Kevin'
and a.last_name = 'Bacon'
and mg.genre = 'Drama')
and a.first_name != 'Kevin'
and a.last_name != 'Bacon';

select a.first_name, a.last_name, m.name
from actors a
inner join roles r on r.actor_id = a.id
inner join movies m on m.id = r.movie_id
where m.id IN (select r.movie_id
from roles r
inner join movies_genres mg on mg.movie_id = r.movie_id
where r.actor_id = 22591
and mg.genre = 'Drama')
and a.id != 22591;

select r.actor_id
from roles r
inner join movies m on m.id = r.movie_id
where r.actor_id IN (select r.actor_id
from movies m
inner join roles r on r.movie_id = m.id
where year < 1900)
and year > 2000
group by 1;

select sub.actor_id
from (select r1.*
from roles r1
inner join roles r2 on r1.movie_id = r2.movie_id
and r1.actor_id = r2.actor_id
and r1.role != r2.role) sub
inner join movies m on m.id = sub.movie_id
group by 1
having count(distinct sub.role) >=5
and m.year > 1990;


