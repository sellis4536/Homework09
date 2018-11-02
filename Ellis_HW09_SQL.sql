/*
Test successful install of schema and data
*/
select * from sakila.staff;

/*
1a -- list first_name, last_name from actors
*/
select first_name, last_name from actor;

/*
1b -- list first_name last_name, ALL CAPS in a single column
*/
select CONCAT(UPPER(first_name), ' ', UPPER(last_name)) as FNF_CAPS from actor;

/*
2a -- list ID, first_name, last_name where first_name = 'Joe' 
*/
select actor_id, first_name, last_name from actor
	where first_name = 'Joe';

/*
2b. Find all actors whose last name contain the letters 'GEN' 
*/
select actor_id, first_name, last_name from actor
	where last_name LIKE '%GEN%';
    
/*
2c. Find all actors whose last name contain the letters 'LI',
	order by last_name, first_name1
*/
select actor_id, first_name, last_name from actor
	where last_name LIKE '%LI%'
    order by last_name, first_name;
    
/* 
2d. Using IN, display the country_id and country columns of the following
	countries: Afghanistan, Bangladesh, and China 
*/
select country_id, country from country
	where country in ('Afghanistan', 'Bangladesh', 'China');

/*
3a. ALTER TABLE actor to add column for 'description' with DTYPE BLOB
*/
ALTER TABLE actor
	add (description BLOB);

/*
3b. DROP newly created description column
*/

ALTER TABLE actor
	drop description;

/*
4a. List the last names of actors, as well as how many actors have that last name.
*/
select distinct(last_name), count(*) as LnCount from actor
	group by last_name
    order by LnCount desc;
    
/*
4b. List last names of actors and the number of actors who have that last name, 
	but only for names that are shared by at least two actors
*/
select distinct(last_name), count(*) as LnCount from actor
    group by last_name
    having count(*) > 1
    order by LnCount ASC;
    
/*
4c. Update actor record last_name 'WILLIAMS', first_name 'GROUCHO'  to first_name 'HARPO'
*/
UPDATE actor
	SET first_name = (CASE WHEN first_name = 'GROUCHO' THEN 'HARPO' ELSE first_name END)
    where last_name = 'WILLIAMS'
	and first_name = 'GROUCHO';
    
/*
4d. ERROR IN PREVIOUS LINE, Update actor record last_name 'WILLIAMS', first_name 'HARPO' back to first_name 'GROUCHO'
*/
UPDATE actor
	SET first_name = (CASE WHEN first_name = 'HARPO' THEN 'GROUCHO' ELSE first_name END)
    where last_name = 'WILLIAMS'
	and first_name = 'HARPO';
    
/* 
5a. SHOW CREATE TABLE to display CREATE TABLE address schema.
	right click result row, select Copy Row (names, unquoted) and paste to display CREATE TABLE statement
*/
SHOW CREATE TABLE sakila.address;

/*
6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join
*/
SELECT DISTINCT(title), (actor_id), count(*) as Actors
	FROM film_actor
	INNER JOIN film ON film.film_id = film_actor.film_id
    group by title
    
    
    
