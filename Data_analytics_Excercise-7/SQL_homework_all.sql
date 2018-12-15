USE sakila;


#1a. Display the first and last names of all actors from the table actor

SELECT actor.first_name AS `First name`
, actor.last_name AS `Last name`
FROM actor;

#1b. Display the first and last name of each actor in a single column in upper
#    case letters. Name the column Actor Name.

SELECT CONCAT(actor.first_name, ' ', actor.last_name) AS `Actor name`
FROM actor;

#2a. You need to find the ID number, first name, and last name of an actor, of 
# whom you know only the first name, "Joe." What is one query would you use to
# obtain this information?

SELECT actor.actor_id AS `Actor ID`
, actor.first_name AS `First name`
, actor.last_name AS `Second name`
FROM actor 
WHERE first_name = 'Joe';

#2b. Find all actors whose last name contain the letters GEN:

SELECT * FROM actor 
WHERE actor.last_name LIKE '%GEN%';

#2c. Find all actors whose last names contain the letters LI. This time,
# order the rows by last name and first name, in that order:

SELECT * FROM actor 
WHERE actor.last_name LIKE '%LI%'
ORDER BY actor.last_name, actor.first_name;

#2d. Using IN, display the country_id and country columns of the following
# countries: Afghanistan, Bangladesh, and China:

SELECT country.country_id AS `Country ID`
, country.country AS `Country`
FROM country
WHERE country.country IN ('Afghanistan', 'Bangladesh', 'China');

#3a. You want to keep a description of each actor. You don't think you will
# be performing queries on a description, so create a column in the table actor 
# named description and use the data type BLOB (Make sure to research the type BLOB, 
# as the difference between it and VARCHAR are significant).

ALTER TABLE actor
ADD COLUMN `description` BLOB 
AFTER last_update;

#3b. Very quickly you realize that entering descriptions for each actor is too much 
#effort. Delete the description column.

ALTER TABLE actor
DROP COLUMN `description`;


#4a. List the last names of actors, as well as how many actors have that last name.

SELECT actor.last_name AS `Last name`
, COUNT(*) AS `Count`
FROM actor
GROUP BY actor.last_name;


#4b. List last names of actors and the number of actors who have that last name, but only 
# for names that are shared by at least two actors

SELECT actor.last_name AS `Last name`
, COUNT(actor.last_name) AS `Count`
FROM actor
GROUP BY actor.last_name
HAVING `Count` >= 2;

#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS.
# Write a query to fix the record.

UPDATE actor
SET actor.first_name = 'HARPO'
WHERE actor.first_name = 'GROUCHO' AND actor.last_name = 'WILLIAMS';

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the 
# correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.

UPDATE actor
SET actor.first_name = 'GROUCHO'
WHERE actor.first_name = 'HARPO' AND actor.last_name = 'WILLIAMS';

#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?

SHOW CREATE TABLE address;

#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

SELECT staff.first_name AS `First name`
, staff.last_name AS `Last name`
, address.address AS `Address`
FROM staff LEFT JOIN address ON staff.address_id=address.address_id;

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

SELECT staff.first_name AS `First name`
, staff.last_name AS `Last name`
, SUM(payment.amount) AS `Total_amount`
FROM staff LEFT JOIN payment ON staff.staff_id = payment.staff_id
WHERE payment.payment_date LIKE '2005-08%'
GROUP BY staff.first_name, staff.last_name;

#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

SELECT film.title AS `Film title`
, COUNT(DISTINCT film_actor.actor_id) as `Total actors`
FROM film INNER JOIN film_actor ON film.film_id = film_actor.film_id
GROUP BY film.title;

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT film.title AS `Film title`
, COUNT(DISTINCT inventory.inventory_id) as `Total copies`
FROM film INNER JOIN inventory ON film.film_id = inventory.film_id
WHERE film.title = 'HUNCHBACK IMPOSSIBLE';

#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:

SELECT customer.first_name AS `First name`
, customer.last_name AS `Last name`
, sum(payment.amount) AS `Total amount paid`
FROM customer INNER JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY customer.first_name, customer.last_name
ORDER BY customer.last_name;

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q
# have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

SELECT film.title AS `Film title`
FROM film
WHERE film.title LIKE 'K%' OR film.title LIKE 'Q%' AND film.language_id IN (
	SELECT `language`.language_id 
    FROM `language`
    WHERE `language`.name = 'ENGLISH'
    );

#7b. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT actor.first_name AS `First name`
, actor.last_name AS `Last name`
FROM actor
WHERE actor.actor_id IN (
	SELECT film_actor.actor_id
    FROM film_actor
    WHERE film_actor.film_id IN (
		SELECT film.film_id
        FROM film
        WHERE film.title = 'ALONE TRIP'
        )
	);
    

#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins
# to retrieve this information.

SELECT customer.first_name AS `First name`
, customer.last_name AS `Last name`
, customer.email AS `Email`
FROM customer
WHERE customer.address_id IN (
	SELECT address.address_id
    FROM address
    WHERE address.city_id IN (
		SELECT city.city_id
        FROM city LEFT JOIN country ON city.country_id = country.country_id
        WHERE country.country = 'CANADA'
        )
	);

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT film.title AS `Title`
, category.name AS `Genre`
FROM film 
LEFT JOIN film_category
	INNER JOIN category
    ON film_category.category_id = category.category_id
ON film.film_id = film_category.film_id
WHERE category.name = 'Family';

#7e. Display the most frequently rented movies in descending order.

SELECT film.title AS `Title`
, COUNT(rental.inventory_id) AS `Rental count`
FROM film
LEFT JOIN inventory
	INNER JOIN rental
    ON inventory.inventory_id = rental.inventory_id
ON film.film_id = inventory.film_id
GROUP BY film.title
ORDER BY `Rental count` DESC;

#7f. Write a query to display how much business, in dollars, each store brought in.

SELECT store.store_id AS `Store ID`
,CONCAT ('$', FORMAT(SUM(payment.amount), 2)) AS `Total revenue`
FROM store 
LEFT JOIN staff
	INNER JOIN payment
    ON staff.staff_id = payment.staff_id
ON store.store_id = staff.store_id
GROUP BY store.store_id;

#7g. Write a query to display for each store its store ID, city, and country.

SELECT store.store_id AS `Store ID`
, city.city AS `City`
, country.country AS `Country`
FROM store 
LEFT JOIN address
	INNER JOIN city
		INNER JOIN country
        ON city.country_id = country.country_id
    ON address.city_id = city.city_id
ON store.address_id = address.address_id
GROUP BY store.store_id;

#7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment,
# and rental.)

SELECT category.name AS `Genre`
, CONCAT ('$', FORMAT(SUM(payment.amount), 2)) AS `Gross revenue`
FROM category
LEFT JOIN film_category
	INNER JOIN inventory
		INNER JOIN rental
			INNER JOIN payment
            ON rental.rental_id = payment.rental_id
        ON inventory.inventory_id = rental.inventory_id
    ON film_category.film_id = inventory.film_id
ON category.category_id = film_category.category_id
GROUP BY category.name
ORDER BY `Gross revenue` DESC LIMIT 5;

#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above
# to create a view. If you haven't solved 7h, you can substitute another query to create a view.

CREATE VIEW top_five_Genres AS
	SELECT category.name AS `Genre`
	, CONCAT ('$', FORMAT(SUM(payment.amount), 2)) AS `Gross revenue`
	FROM category
	LEFT JOIN film_category
		INNER JOIN inventory
			INNER JOIN rental
				INNER JOIN payment
				ON rental.rental_id = payment.rental_id
			ON inventory.inventory_id = rental.inventory_id
		ON film_category.film_id = inventory.film_id
	ON category.category_id = film_category.category_id
	GROUP BY category.name
	ORDER BY `Gross revenue` DESC LIMIT 5;

#8b. How would you display the view that you created in 8a?

SELECT * FROM top_five_genres;

#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

DROP VIEW sakila.top_five_genres;