CREATE TABLE movies (
  id INTEGER PRIMARY KEY,
  name TEXT DEFAULT NULL,
  year INTEGER DEFAULT NULL,
  rank REAL DEFAULT NULL
);

CREATE TABLE actors (
  id INTEGER PRIMARY KEY,
  first_name TEXT DEFAULT NULL,
  last_name TEXT DEFAULT NULL,
  gender TEXT DEFAULT NULL
);

CREATE TABLE roles (
  actor_id INTEGER,
  movie_id INTEGER,
  role_name TEXT DEFAULT NULL
);

CREATE INDEX "actors_idx_first_name" ON "actors" ("first_name");
CREATE INDEX "actors_idx_last_name" ON "actors" ("last_name");

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

select count(distinct r.role) as num_roles_in_movies,  *
from actors a
inner join roles r on r.actor_id = a.id
inner join movies m on r.movie_id = m.id
where m.year > 1990
group by a.id, m.id
having num_roles_in_movies > 4;

select year, count(*) as femaleOnly
from movies join
(
  select movie_id
  from actors a join roles r
  on r.actor_id = a.id and a.gender = 'F'

  except

  select movie_id
  from actors a join roles r
  on r.actor_id = a.id and a.gender = 'M'
) as t
on t.movie_id = movies.id
group by year;
