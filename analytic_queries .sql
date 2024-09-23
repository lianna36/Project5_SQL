select min(start_date) from subscriptions;
--2021-06-02

select max(start_date) from subscriptions;
--2024-02-05

--count of users by year

create view users_by_year as (
	select count(user_id) as user_count,  
				 extract(year from start_date) as year 
	from subscriptions
	group by extract(year from start_date)
	order by extract(year from start_date)
);


--revenue by year
create view revenue_by_year as (
	select  sum(subscription_plan.price) as annual_revenue, 
					count(user_id) as user_count, 
					extract(year from start_date) as year 
	from subscriptions
	inner join subscription_plan on subscription_plan.subscription_plan_id = subscriptions.subscription_plan_id
	group by extract(year from start_date)
	order by extract(year from start_date)
);


--most sold subscription plan
create view sale_counts_by_plan as (
	select subscription_plan.description, 
				 count(subscription_plan.description) 
	from subscription_plan
	inner join subscriptions on subscription_plan.subscription_plan_id = subscriptions.subscription_plan_id
	group by subscription_plan.description
);


--top 10 movies
create view top_10_movies as (
	select title, 
				 release_year, 
				 rating 
	from movie 
	order by rating desc
	limit 10
);


--most popular genre
create view most_popular_genre as (
	select genre.genre_name, 
				 count(watched_movies.movie_id) as movie_count
	from watched_movies
	inner join movie_genre on watched_movies.movie_id = movie_genre.movie_id
	inner join genre on genre.genre_id = movie_genre.genre_id
	group by genre.genre_name
	order by 2 desc
);


--most popular actors
create view most_popular_actors as (
	select max(actor.first_name || ' ' || actor.last_name),
				 count(movie_actor.movie_id) as movies_count
	from movie_actor
	inner join actor on movie_actor.actor_id = actor.actor_id
	group by movie_actor.actor_id
	order by 2 desc
);


--users by nationality
create view user_nationalities as (
	select nationality, 
				 count(user_id) as user_count 
	from users
	group by nationality
	order by 2 desc
);

--top movies watched on website
create view top_watched_movies as (
	select max(movie.title) as movie_title, 
			   count(watched_movies.watched_movies_id) as watched_count
	from movie
	inner join watched_movies on watched_movies.movie_id = movie.movie_id
	group by watched_movies.movie_id
	order by 2 desc
	limit 5
);


drop function if exists popular_movies_by_genre_and_period(genre varchar, start_year int, end_year int);
create or replace function popular_movies_by_genre_and_period(in_genre varchar, in_start_year int, in_end_year int)
	returns setof varchar(100)
	language plpgsql
	as
	$$
	begin 
		return query (
			select movie.title 
			from movie 
			inner join movie_genre on movie_genre.movie_id = movie.movie_id
			where movie_genre.genre_id in (
				select genre_id 
				from genre 
				where genre_name = in_genre
				)
			and movie.release_year between in_start_year and in_end_year
			order by rating desc
			limit 5
		);

	end;
	$$;


select * from popular_movies_by_genre_and_period('Drama', 2000, 2010);

