
update final_dataset
set movie_title = replace(movie_title, '?', '');


insert into genre(genre_name)
select distinct unnest(string_to_array(genres, '|')) from final_dataset;


insert into genre(genre_name)
values ('whose'), ('law'), ('crime-reality'), ('worker'), ('catch');


select * from genre;

select * from final_dataset where director is null;

select distinct director from final_dataset;

truncate table director restart identity cascade ;
insert into director(
first_name,
last_name
--nationality,
--birth_date,
)
select distinct substring(director, 1, position(' ' in director)), substring(director, position(' ' in director), length(director)) from final_dataset;

select * from director;

delete from director where director_id = 1;

update director set nationality = case when director_id between 1 and 600 then 'USA'
when director_id between 601 and 1200 then 'UK'
when director_id between 1201 and 1800 then 'ITA'
when director_id between 1801 and 2400 then 'ISP' end;


update director set birth_date = bdate.bdate
from (
			select row_number() over() as rn, 
			bdate 
			from generate_series('1974-01-01'::date, '1985-12-31'::date, '1 day'::interval) as bdate(bdate)
			) bdate
where director_id = bdate.rn;

select * from director;


/*select director, (string_to_array(director, ' '))[1], concat((string_to_array(director, ' '))[2], ' ', (string_to_array(director, ' '))[3], ' ', (string_to_array(director, ' '))[4]) from final_dataset

select max(array_length(string_to_array(director, ' '), 1)) from final_dataset;
*/


insert into country(country_name)
select distinct country from final_dataset;


insert into language("language")
select distinct "language" from final_dataset;

delete from "language" where "language" is null;


insert into actor(
first_name,
last_name
--nationality
--birth_date
)

select distinct substring(main_actor, 1, position(' ' in main_actor)), substring(main_actor, position(' ' in main_actor), length(main_actor)) from final_dataset
union 
select distinct substring(actor_2_name, 1, position(' ' in actor_2_name)), substring(actor_2_name, position(' ' in actor_2_name), length(actor_2_name)) from final_dataset
union
select distinct substring(actor_3_name, 1, position(' ' in actor_3_name)), substring(actor_3_name, position(' ' in actor_3_name), length(actor_3_name)) from final_dataset;

select * from actor order by 2;

delete from actor where first_name is null;
delete from actor where last_name is null;


update filled_data set birth_date = TO_DATE(birth_date_text, 'YYYY-MM-DD');
alter table filled_data drop column birth_date_text;

drop table actor cascade;

alter table filled_data rename to actor;

update director set first_name = trim(first_name),
last_name = trim(last_name);


select concat(director.first_name, director.last_name) from director;

insert into movie(
director_id,
title,
release_year,
rating,
movie_length,
language_id,
country_id
)

select distinct director.director_id,final_dataset.movie_title, final_dataset.title_year::integer, final_dataset.imdb_score::numeric,
final_dataset.duration::integer, language.language_id, country.country_id
from final_dataset
left join director on concat(director.first_name, ' ', director.last_name) = final_dataset.director
left join language on language.language = final_dataset.language
left join country on country.country_name = final_dataset.country;


insert into movie_genre(movie_id, genre_id) 
select movie.movie_id, genre.genre_id from movie
inner join final_dataset on movie.title = final_dataset.movie_title
left join genre on final_dataset.genres ilike '%' || genre.genre_name || '%';

insert into movie_actor(movie_id, actor_id)
select movie.movie_id, actor.actor_id from movie
inner join final_dataset on final_dataset.movie_title = movie.title
inner join actor on final_dataset.main_actor = concat(actor.first_name, actor.last_name);


insert into movie_actor(movie_id, actor_id)
select movie.movie_id, actor.actor_id from movie
inner join final_dataset on final_dataset.movie_title = movie.title
inner join actor on final_dataset.actor_2_name = concat(actor.first_name, actor.last_name);


insert into movie_actor(movie_id, actor_id)
select movie.movie_id, actor.actor_id from movie
inner join final_dataset on final_dataset.movie_title = movie.title
inner join actor on final_dataset.actor_3_name = concat(actor.first_name, actor.last_name);


-- Insert statements for the awards

INSERT INTO award (award_name) VALUES ('Academy Awards (Oscars)');
INSERT INTO award (award_name) VALUES ('Golden Globe Awards');
INSERT INTO award (award_name) VALUES ('Cannes Film Festival');
INSERT INTO award (award_name) VALUES ('BAFTA Awards');
INSERT INTO award (award_name) VALUES ('Berlin International Film Festival (Berlinale)');
INSERT INTO award (award_name) VALUES ('Venice Film Festival');
INSERT INTO award (award_name) VALUES ('Sundance Film Festival');
INSERT INTO award (award_name) VALUES ('Toronto International Film Festival (TIFF)');
INSERT INTO award (award_name) VALUES ('César Awards');
INSERT INTO award (award_name) VALUES ('Goya Awards');
INSERT INTO award (award_name) VALUES ('Saturn Awards');
INSERT INTO award (award_name) VALUES ('Annie Awards');
INSERT INTO award (award_name) VALUES ('Hugo Awards');
INSERT INTO award (award_name) VALUES ('Critics'' Choice Awards');
INSERT INTO award (award_name) VALUES ('Ariel Awards');
INSERT INTO award (award_name) VALUES ('Apsara Awards');
INSERT INTO award (award_name) VALUES ('Asian Film Awards');
INSERT INTO award (award_name) VALUES ('David di Donatello Awards');
INSERT INTO award (award_name) VALUES ('Japanese Academy Awards');
INSERT INTO award (award_name) VALUES ('Logie Awards');
INSERT INTO award (award_name) VALUES ('Filmfare Awards');
INSERT INTO award (award_name) VALUES ('Independent Spirit Awards');
INSERT INTO award (award_name) VALUES ('National Film Awards (UK)');
INSERT INTO award (award_name) VALUES ('MTV Movie & TV Awards');
INSERT INTO award (award_name) VALUES ('Razzie Awards');


truncate table actor_award restart identity cascade;

-- Insert random pairs into table_c with different random ids
INSERT INTO actor_award (actor_id, award_id)
SELECT
    a.actor_id,
    b.award_id
FROM
    (SELECT actor_id FROM actor ORDER BY actor_id LIMIT 300) a
JOIN
    (SELECT award_id FROM award ORDER BY award_id LIMIT 3) b
ON TRUE

UNION

SELECT
    a.actor_id,
    b.award_id
FROM
    (SELECT actor_id FROM actor ORDER BY actor_id LIMIT 300 OFFSET 310) a
JOIN
    (SELECT award_id FROM award ORDER BY award_id LIMIT 3 OFFSET 3) b
ON TRUE

UNION

SELECT
    a.actor_id,
    b.award_id
FROM
    (SELECT actor_id FROM actor ORDER BY  actor_id LIMIT 300 OFFSET 620) a
JOIN
    (SELECT award_id FROM award ORDER BY award_id LIMIT 3 OFFSET 6) b
ON TRUE

UNION 

SELECT
    a.actor_id,
    b.award_id
FROM
    (SELECT actor_id FROM actor ORDER BY  actor_id LIMIT 300 OFFSET 930) a
JOIN
    (SELECT award_id FROM award ORDER BY award_id LIMIT 3 OFFSET 9) b
ON TRUE

UNION

SELECT
    a.actor_id,
    b.award_id
FROM
    (SELECT actor_id FROM actor ORDER BY  actor_id LIMIT 300 OFFSET 1000) a
JOIN
    (SELECT award_id FROM award ORDER BY award_id LIMIT 3 OFFSET 12) b
ON true

UNION

SELECT
    a.actor_id,
    b.award_id
FROM
    (SELECT actor_id FROM actor ORDER BY  actor_id LIMIT 300 OFFSET 1350) a
JOIN
    (SELECT award_id FROM award ORDER BY award_id LIMIT 3 OFFSET 15) b
ON TRUE

UNION

SELECT
    a.actor_id,
    b.award_id
FROM
    (SELECT actor_id FROM actor ORDER BY  actor_id LIMIT 300 OFFSET 1650) a
JOIN
    (SELECT award_id FROM award ORDER BY award_id LIMIT 3 OFFSET 18) b
ON TRUE

UNION

SELECT
    a.actor_id,
    b.award_id
FROM
    (SELECT actor_id FROM actor ORDER BY  actor_id LIMIT 300 OFFSET 1990) a
JOIN
    (SELECT award_id FROM award ORDER BY award_id LIMIT 3 OFFSET 21) b
ON TRUE
UNION

SELECT
    a.actor_id,
    b.award_id
FROM
    (SELECT actor_id FROM actor ORDER BY  actor_id LIMIT 300 OFFSET 1290) a
JOIN
    (SELECT award_id FROM award ORDER BY award_id LIMIT 3 OFFSET 24) b
ON TRUE;



INSERT INTO subscription_plan (price, start_date, end_date)
SELECT
    (RANDOM() * 100 + 10)::decimal(5,2) AS price,  -- Generates a random price between 10.00 and 110.00
    (CURRENT_DATE + (floor(random() * 30) * INTERVAL '1 day'))::DATE AS start_date,  -- Random start_date within the next 30 days
    (CURRENT_DATE + (floor(random() * 60 + 30) * INTERVAL '1 day'))::DATE AS end_date  -- Random end_date between 30 and 90 days from today
FROM
    generate_series(1, 5);
		
		
		
WITH distinct_plans AS (
    SELECT ROW_NUMBER() over(),
		subscription_plan_id
    FROM subscription_plan
    ORDER BY RANDOM()
    LIMIT 100
),
user_data AS (
    SELECT
		ROW_NUMBER() over(),
        -- Random first names
        (ARRAY['John', 'Jane', 'Michael', 'Emily', 'David', 'Sarah', 'Robert', 'Laura', 'Daniel', 'Sophia'])[floor(random() * 10 + 1)] AS first_name,
        
        -- Random last names
        (ARRAY['Smith', 'Johnson', 'Williams', 'Jones', 'Brown', 'Davis', 'Miller', 'Wilson', 'Moore', 'Taylor'])[floor(random() * 10 + 1)] AS last_name,
        
        -- Random nationalities
         (ARRAY['USA', 'CAN', 'UK', 'AUS', 'DEN', 'FRA', 'ITA', 'ISP', 'CNS', 'IND'])[floor(random() * 10 + 1)] AS nationality,
        
        -- Random birth dates between 1970-01-01 and 2000-12-31
        (CURRENT_DATE - (floor(random() * 12000 + 7300) * INTERVAL '1 day'))::DATE AS birth_date,
        
        -- Random boolean for is_prime_user
        (RANDOM() > 0.5) AS is_prime_user
    FROM generate_series(1, 100)
),
user_with_plans AS (
    SELECT DISTINCT
        u.first_name,
        u.last_name,
        u.nationality,
        u.birth_date,
        u.is_prime_user,
        p.subscription_plan_id
    FROM user_data u,distinct_plans p
	
    -- Ensure the unique assignment of subscription_plan_id
)
INSERT INTO users (first_name, last_name, nationality, birth_date)
SELECT DISTINCT
    first_name,
    last_name,
    nationality,
    birth_date
FROM user_with_plans
ORDER BY first_name;


select distinct nationality from actor;


update actor_award set movie_id = movie_actor.movie_id
from movie_actor
where actor_award.actor_id = movie_actor.actor_id;


update actor_award set award_year = movie.release_year + 1
from movie
where actor_award.movie_id = movie.movie_id;


select * from actor_award where award_year is  null;

delete from movie where release_year is null;
delete from movie where director_id is null;



-- --begin;
-- update users_old set first_name = users_old.first_name || duplicated.rn,
-- last_name = users_old.last_name || duplicated.rn,
-- birth_date = users_old.birth_date + duplicated.rn * '1 year'::interval
-- from
-- (
-- select row_number() over(partition by  first_name,
-- 	last_name/*,
-- 	nationality,
-- 	birth_date*/) as rn,user_id,first_name,
-- 	last_name,
-- 	nationality,
-- 	birth_date from users_old) as duplicated
-- 	where  users_old.user_id = duplicated.user_id
-- 	and rn > 1;
-- 	
-- 	select * from users_old order by 2,3,4,5;
-- --	rollback;
-- 

/*insert into users(first_name,
	last_name,
	nationality,
	birth_date,
	email)
	
	select first_name,
	last_name,
	nationality,
	birth_date,
	concat(lower(first_name), lower(last_name), extract(year from birth_date), '@gmail.com') as email from users_old;*/
	
update users set email = concat(lower(first_name), lower(last_name), extract(year from birth_date), '@gmail.com');

select * from users order by 2,3,4

/*INSERT INTO subscription_plan (price, duration, description)
SELECT
    ROUND((random() * (100 - 10) + 10)::numeric, 2) AS price,  -- Random price between 10 and 100
    (ARRAY['1 year', '3 months', '6 months', '1 month'])[floor(random() * 4 + 1)] AS duration,  -- Randomly select a duration string
    (ARRAY[
        'Basic Plan',
        'Standard Plan',
        'Premium Plan',
        'Family Plan',
        'Student Plan',
        'Annual Plan',
        'Monthly Plan',
        'Exclusive Plan',
        'Sports Plan',
        'Entertainment Plan'
    ])[floor(random() * 10 + 1)] AS description               -- Randomly select a description
FROM generate_series(1, floor(random() * (10 - 8 + 1) + 8)::integer) AS gs;*/

truncate table subscriptions restart identity cascade;


INSERT INTO "project_5_movies"."subscription_plan"("subscription_plan_id", "price", "duration", "description") VALUES (3, '69.80', '6 months', 'Sports Plan');
INSERT INTO "project_5_movies"."subscription_plan"("subscription_plan_id", "price", "duration", "description") VALUES (4, '36.77', '1 month', 'Monthly Plan');
INSERT INTO "project_5_movies"."subscription_plan"("subscription_plan_id", "price", "duration", "description") VALUES (7, '53.31', '3 months', 'Student Plan');
INSERT INTO "project_5_movies"."subscription_plan"("subscription_plan_id", "price", "duration", "description") VALUES (9, '87.99', '1 year', 'Annual Plan');


insert into subscriptions (
	user_id ,
	subscription_plan_id ,
	start_date
)

SELECT distinct
    user_id, 
    unnest(array(
        SELECT subscription_plan_id 
        FROM subscription_plan 
        ORDER BY random() 
    )) AS random_sub,
		(CURRENT_DATE - (floor(random() * 1000 + 200) * INTERVAL '1 day'))::DATE AS start_date
FROM  users;


UPDATE subscriptions 
SET end_date = start_date + subscription_plan.duration::interval,
	  is_active = CASE WHEN start_date + subscription_plan.duration::interval < CURRENT_DATE THEN false ELSE true END
FROM subscription_plan
WHERE subscription_plan.subscription_plan_id = subscriptions.subscription_plan_id;

select *  from subscriptions order by 2;

delete from users where first_name SIMILAR TO '%[0-9]';

--begin;
delete from subscriptions 
using (
select row_number() over(partition by user_id) as rn, subscriptions_id, user_id from subscriptions 
) as user_1
where subscriptions.subscriptions_id = user_1.subscriptions_id
and subscriptions.user_id = user_1.user_id
and subscriptions.subscriptions_id <= 134
and user_1.rn > 1;

select count(subscriptions_id), user_id from subscriptions
group by user_id

--rollback;

truncate watched_movies restart identity cascade;

--execute as much as you would like a user to be wathing movies
insert into watched_movies(
user_id ,
	movie_id /*,
	subscription_plan_id ,
	watch_date */)
	
	select unnest(array(select user_id from users order by random())),	
	unnest(array(select movie_id from movie order by random() limit(select count(*) from users)))
	
	
	select count(movie_id) from watched_movies group by user_id
	select * from watched_movies order by 2
	
	
	--truncate table watched_movies restart identity cascade
	


select count(subscription_plan_id) from subscriptions
group by user_id

DO $$
DECLARE
    cur CURSOR FOR
        SELECT 
            user_id,
            subscription_plan_id,
            start_date,
            end_date,
            (end_date - start_date) AS total_days
        FROM 
            subscriptions;
    
    rec RECORD;
BEGIN
    
    OPEN cur;
    LOOP
        FETCH cur INTO rec;
        EXIT WHEN NOT FOUND;
        UPDATE watched_movies
        SET 
            subscription_plan_id = rec.subscription_plan_id,
            watch_date = rec.start_date + (random() * rec.total_days)::int
        WHERE 
            user_id = rec.user_id 
            AND watch_date IS NULL;
    END LOOP;
    CLOSE cur;
END $$;



select * from watched_movies order by 2,4,3
inner join subscriptions on subscriptions.user_id = watched_movies.user_id and
 subscriptions.subscription_plan_id = watched_movies.subscription_plan_id
order by 2,4,3;



alter table users add column registration_date date,
add column user_password varchar(50);


DO $$
DECLARE
    cur CURSOR FOR
        SELECT user_id,
				uuid_in(overlay(overlay(md5(random()::text || ':' || random()::text) placing '4' from 13) placing to_hex(floor(random()*(11-8+1) + 8)::int)::text from 17)::cstring) as psw
				from users;
    
    rec RECORD;
BEGIN
    OPEN cur;
    
    LOOP
        FETCH cur INTO rec;
        EXIT WHEN NOT FOUND;
        UPDATE users
        SET 
            user_password= rec.psw
        WHERE users.user_id = rec.user_id
         and users.user_password IS NULL;
    END LOOP;
    CLOSE cur;
END $$;



update users set registration_date = sub.start_date - '2 days'::interval
from (
		select distinct user_id,
					 min(start_date) over(partition by user_id order by start_date) as start_date
		from subscriptions)
as sub
where sub.user_id = users.user_id
