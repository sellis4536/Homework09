/*
1a -- list first_name, last_name from table actor
*/
select first_name, last_name from actor;

/*
1b -- list first_name last_name, ALL CAPS in a single column from table actor
*/
select CONCAT(UPPER(first_name), ' ', UPPER(last_name)) as FNF_CAPS from actor;

/*
2a -- list ID, first_name, last_name where first_name = 'Joe' from table actor
*/
select actor_id, first_name, last_name from actor
	where first_name = 'Joe';

/*
2b. Find all actors whose last name contain the letters 'GEN' from table actor
*/
select actor_id, first_name, last_name from actor
	where last_name LIKE '%GEN%';
    
/*
2c. Find all actors whose last name contain the letters 'LI',
	order by last_name, first_name1 from table actor
*/
select actor_id, first_name, last_name from actor
	where last_name LIKE '%LI%'
    order by last_name, first_name;
    
/* 
2d. Using IN, display the country_id and country columns of the following
	countries: Afghanistan, Bangladesh, and China from table country 
*/
select country_id, country from country
	where country in ('Afghanistan', 'Bangladesh', 'China');

/*
3a. ALTER TABLE actor to add column for 'description' with DTYPE BLOB
*/
ALTER TABLE actor
	add (description BLOB);

/*
3b. DROP newly created description column from table actor
*/

ALTER TABLE actor
	drop description;

/*
4a. List the last names of actors, as well as how many actors have that last name from actor
*/
select distinct(last_name), count(*) as LnCount from actor
	group by last_name
    order by LnCount desc;
    
/*
4b. List last names of actors and the number of actors who have that last name, 
	but only for names that are shared by at least two actors from table actor
*/
select distinct(last_name), count(*) as LnCount from actor
    group by last_name
    having count(*) > 1
    order by LnCount ASC;
    
/*
4c. Update table actor record  where last_name 'WILLIAMS', first_name 'GROUCHO'  to first_name 'HARPO'
*/
UPDATE actor
	SET first_name = (CASE WHEN first_name = 'GROUCHO' THEN 'HARPO' ELSE first_name END)
    where last_name = 'WILLIAMS'
	and first_name = 'GROUCHO';
    
/*
4d. ERROR IN PREVIOUS LINE, Update table actor record where last_name 'WILLIAMS', first_name 'HARPO' back to first_name 'GROUCHO'
*/
UPDATE actor
	SET first_name = (CASE WHEN first_name = 'HARPO' THEN 'GROUCHO' ELSE first_name END)
    WHERE last_name = 'WILLIAMS'
	AND first_name = 'HARPO';
    
/* 
5a. SHOW CREATE TABLE to display CREATE TABLE address schema.
	right click result row, select Copy Row (names, unquoted) and paste to display CREATE TABLE statement
*/
SHOW CREATE TABLE sakila.address;

/*
6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
*/
select first_name, last_name, address from staff
	INNER JOIN address on staff.address_id = address.address_id;

/*
6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
*/
SELECT DISTINCT(CONCAT(First_name, last_name)) as Employee, sum(amount) as 'Total Sales' from staff
	INNER JOIN payment on staff.staff_id = payment.staff_id
	GROUP BY Employee;

/*
6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join
*/
select film.title as Title, count(*) as 'Actor Count' from film_actor
	INNER JOIN film ON film.film_id = film_actor.film_id
	GROUP BY film_actor.film_id
	ORDER BY film_actor.film_id;

/*
6d. How many copies of the film Hunchback Impossible exist in the inventory system?
*/
SELECT title as Title, count(*) as 'Copies Avail.' from film
	INNER JOIN inventory on film.film_id = inventory.film_id
    WHERE title = 'HUNCHBACK IMPOSSIBLE';

/*
6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name
*/
SELECT first_name, last_name, sum(amount) as 'Total Ampount Paid' from customer
	INNER JOIN payment on customer.customer_id = payment.customer_id
    GROUP BY customer.customer_id
    ORDER BY last_name;

/*
7a. rs K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
*/

SELECT f.title
	FROM film as f
	WHERE f.title LIKE 'k%' or f.title like'q%'
		AND (select l.name
		FROM language as l
		WHERE l.name = 'English');

/*
7b. Use subqueries to display all actors who appear in the film Alone Trip.
*/
 SELECT first_name, last_name from actor as a
	WHERE actor_id IN
		(select fa.actor_id from film_actor as fa
		WHERE (select film_id from film  as f
			WHERE title = 'ALONE TRIP'));

/* 
7c. Select names and email addresses of all Canadian customer using joins
*/
SELECT cu.first_name, cu.last_name, cu.email from customer as cu
	INNER JOIN address as a on cu.address_id = a.address_id
    INNER JOIN city as ci on a.city_id = ci.city_id
    INNER JOIN country as co on ci.country_id = co.country_id
    WHERE co.country = 'Canada';

/*
7d. Identify all movies categorized as family films.
*/
SELECT f.film_id, f.title, cat.name as Category from film as f
	INNER JOIN film_category as fc on f.film_id = fc.film_id
    INNER JOIN category as cat on fc.category_id = fc.category_id
    WHERE cat.name = 'Family';

/*
7e. Display the most frequently rented movies in descending order.
*/
SELECT f.title, count(*) as Rentals from film as f
	INNER JOIN inventory as i on f.film_id = i.film_id
    INNER JOIN rental as r on i.inventory_id = r.inventory_id
    GROUP by f.title
    Order by Rentals desc;

/*
7f. Display how much business, in dollars, each store brought in -- RESULT $9.95 SHORT
*/
SELECT s.store_id, sum(amount) as Total from store as s
	INNER JOIN inventory as i on s.store_id = i.store_id
    INNER JOIN rental as r on i.inventory_id = r.inventory_id
    INNER JOIN payment as p on r.rental_id = p.rental_id
    GROUP by s.store_id;
    
/*
7g. Display each store's store ID, city, and country.
*/
SELECT s.store_id, ci.city, co.country from store as s
	INNER JOIN address as a on s.address_id = a.address_id
    INNER JOIN city as ci on a.city_id = ci.city_id
    INNER JOIN country as co on ci.country_id = co.country_id;
    
/*
7h. List the top five genres in gross revenue in descending order.
*/
SELECT cat.name, sum(p.amount) as 'Gross Rev.' from category as cat
	INNER JOIN film_category as fc on cat.category_id = fc.category_id
    INNER JOIN inventory as i on fc.film_id = i.film_id
    INNER JOIN rental as r on i.inventory_id = r.inventory_id
    INNER JOIN payment as p on r.rental_id = p.rental_id
    GROUP by cat.name
    ORDER BY sum(amount) desc
    LIMIT 5;

/*
8a.  Create a view using the querey above (7h.)
*/
CREATE VIEW TOP_5_GROSSING_TITLES AS
SELECT cat.name, sum(p.amount) as 'Gross Rev.' from category as cat
	INNER JOIN film_category as fc on cat.category_id = fc.category_id
    INNER JOIN inventory as i on fc.film_id = i.film_id
    INNER JOIN rental as r on i.inventory_id = r.inventory_id
    INNER JOIN payment as p on r.rental_id = p.rental_id
    GROUP by cat.name
    ORDER BY sum(amount) desc
    LIMIT 5;

/*
8b. Display view TOP_5_GROSSING_TITLES
*/
SELECT * from sakila.TOP_5_GROSSING_TITLES;

/*
8c. Delete the view  TOP_5_GROSSING_TITLES
*/
DROP VIEW sakila.TOP_5_GROSSING_TITLES

