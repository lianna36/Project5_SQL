drop table if exists movie cascade;
create table movie (
	movie_id serial primary key,
	director_id integer,
	title varchar(100),
	release_year integer,
	rating numeric,
	movie_length integer,
  	language_id integer,
	country_id integer
);

drop table if exists director cascade;
create table director (
	director_id serial primary key,
	first_name varchar(50),
	last_name varchar(50),
	nationality varchar(50),
	birth_date date
);


drop table if exists genre cascade;
create table genre (
	genre_id serial primary key,
	genre_name varchar(50)
);

drop table if exists language cascade;
create table language (
	language_id serial primary key,
	language varchar(50)
);


/*drop table if exists ratings cascade;
create table ratings (
	rating_id serial primary key,
	ratings decimal(4,2),
	source varchar(75)
);*/


drop table if exists actor cascade;
create table actor (
	actor_id serial primary key,
	first_name varchar(50),
	last_name varchar(50),
	nationality varchar(50),
	birth_date date
);


drop table if exists award cascade;
create table award (
	award_id serial primary key,
	award_name varchar(50)
);


drop table if exists subscription_plan cascade;
create table subscription_plan (
	subscription_plan_id serial primary key,
	price numeric,
	duration varchar(50),
	description varchar(250)
);


drop table if exists subscriptions cascade;
create table subscriptions (
	subscriptions_id serial primary key,
	user_id integer,
	subscription_plan_id integer,
	start_date date,
	end_date date,
	is_active boolean
);


drop table if exists users cascade;
create table users(
	user_id serial primary key,
	first_name varchar(50),
	last_name varchar(50),
	nationality varchar(50),
	birth_date date,
	email varchar(200)
);


drop table if exists watched_movies cascade;
create table watched_movies (
	watched_movies_id serial primary key,
	user_id integer,
	movie_id integer,
	subscription_plan_id integer,
	watch_date date
);


drop table if exists actor_award cascade;
create table actor_award (
	actor_award_id serial primary key,
	actor_id integer,
	award_id integer,
	award_year integer,
	movie_id integer
);


drop table if exists country cascade;
create table country(
	country_id serial primary key,
	country_name varchar(100)
);


drop table if exists movie_genre cascade;
create table movie_genre (
	movie_genre_id serial primary key,
	movie_id integer,
	genre_id integer
);

drop table if exists movie_actor cascade;
create table movie_actor (
	movie_actor_id serial primary key,
	movie_id integer,
	actor_id integer
);


/*alter table subscriptions drop constraint fk_subscriptions_subscription_plan_subscription_plan_id;
alter table subscriptions drop constraint fk_subscriptions_user_user_id;
alter table watched_movies drop constraint fk_watched_movies_user_user_id;
alter table watched_movies drop constraint fk_watched_movies_movie_movie_id;
alter table watched_movies drop constraint fk_watched_movies_subscription_plan_subscription_plan_id;
alter table movie drop constraint fk_movie_director_director_id;
alter table movie drop constraint fk_movie_language_language_id;
alter table movie drop constraint fk_movie_country_country_id;
alter table users drop constraint fk_users_subscription_plan_subscription_plan_id;
alter table actor_award drop constraint fk_actor_award_actor_actor_id ;
alter table actor_award drop constraint fk_actor_award_award_award_id ;
alter table actor_award drop constraint fk_actor_award_movie_movie_id ;
alter table movie_genre drop constraint fk_actor_movie_genre_movie_id ;
alter table movie_genre drop constraint fk_actor_movie_genre_genre_id ;
alter table movie_actor drop constraint fk_actor_movie_actor_movie_id ;
alter table movie_actor drop constraint fk_actor_movie_actor_actor_id ;*/

 
alter table subscriptions
add constraint fk_subscriptions_subscription_plan_subscription_plan_id foreign key(subscription_plan_id) references subscription_plan(subscription_plan_id)  on delete cascade;

alter table subscriptions
add constraint fk_subscriptions_user_user_id foreign key(user_id) references users(user_id)  on delete cascade;

alter table watched_movies
add constraint fk_watched_movies_user_user_id foreign key(user_id) references users(user_id)  on delete cascade;

alter table watched_movies
add constraint fk_watched_movies_movie_movie_id foreign key(movie_id) references movie(movie_id)  on delete cascade;

alter table watched_movies
add constraint fk_watched_movies_subscription_plan_subscription_plan_id foreign key(subscription_plan_id) references subscription_plan(subscription_plan_id)  on delete cascade;

alter table movie
add constraint fk_movie_director_director_id foreign key(director_id) references director(director_id)  on delete cascade;

alter table movie
add constraint fk_movie_language_language_id foreign key(language_id) references language(language_id)  on delete cascade;

alter table movie
add constraint fk_movie_country_country_id foreign key(country_id) references country(country_id) on delete cascade;

/*alter table users
add constraint fk_users_subscription_plan_subscription_plan_id foreign key(subscription_plan_id) references subscription_plan(subscription_plan_id)  on delete cascade;*/

/*alter table actor_award
drop constraint fk_actor_award_actor_actor_id*/

alter table actor_award
add constraint fk_actor_award_actor_actor_id foreign key(actor_id) references actor(actor_id) on delete cascade;

alter table actor_award
add constraint fk_actor_award_award_award_id foreign key(award_id) references award(award_id) on delete cascade;

alter table actor_award
add constraint fk_actor_award_movie_movie_id foreign key(movie_id) references movie(movie_id) on delete cascade;


alter table movie_genre
add constraint fk_actor_movie_genre_movie_id foreign key(movie_id) references movie(movie_id) on delete cascade;

alter table movie_genre
add constraint fk_actor_movie_genre_genre_id foreign key(genre_id) references genre(genre_id) on delete cascade;

alter table movie_actor
add constraint fk_actor_movie_actor_movie_id foreign key(movie_id) references movie(movie_id) on delete cascade;

alter table movie_actor
add constraint fk_actor_movie_actor_actor_id foreign key(actor_id) references actor(actor_id)  on delete cascade;
