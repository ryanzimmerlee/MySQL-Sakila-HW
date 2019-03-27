-----------------------------
--    MySQL Homework       --
--    By: Ryan Zimmerlee   --
--    Date: 3/24/2019      --
-----------------------------
-- Select the 'sakila' database --
USE sakila;

-- View the data in the 'sakila' database --
SELECT * FROM actor;

-- * 1a. Display the first and last names of all actors from the table `actor`.
SELECT first_name, last_name FROM actor;

-- * 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
SELECT CONCAT(first_name, " ", last_name) AS "Actor Full Name" FROM actor;

-- * 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name 
FROM actor
WHERE first_name LIKE 'Joe';

-- * 2b. Find all actors whose last name contain the letters `GEN`:
SELECT first_name AS "First Name", last_name AS "Last Name"
FROM actor
WHERE last_name LIKE '%Gen%';

-- * 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
SELECT first_name AS "First Name", last_name AS "Last Name"
FROM actor
WHERE last_name LIKE '%Li%'
ORDER BY last_name, first_name;

-- * 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- * 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).
-- Create new column called 'Description' within the 'actor' table --
-- Assign it the BLOB datatype instead of the TEXT/VARCHAR datatype...blobs are used to store binary objects, such as images --
ALTER TABLE actor
ADD COLUMN Description BLOB;
SELECT * FROM actor;

-- * 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
ALTER TABLE actor
DROP COLUMN Description;
SELECT * FROM actor;

-- * 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(last_name) 
FROM actor
GROUP BY last_name;
	
-- * 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(last_name)
FROM actor
-- WHERE COUNT(last_name) > 1
GROUP BY last_name;

-- * 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
UPDATE actor
SET first_name = 'Harpo'
WHERE (first_name = 'Groucho' AND last_name = 'Williams');

-- * 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
UPDATE actor SET first_name = 'Groucho' WHERE first_name = 'Harpo';

-- Test 
SELECT first_name, last_name
FROM actor
WHERE first_name = 'Groucho';

-- * 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

-- Code Found Below:
-- 'CREATE TABLE `address` (
--   `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
--   `address` varchar(50) NOT NULL,
--   `address2` varchar(50) DEFAULT NULL,
--   `district` varchar(20) NOT NULL,
--   `city_id` smallint(5) unsigned NOT NULL,
--   `postal_code` varchar(10) DEFAULT NULL,
--   `phone` varchar(20) NOT NULL,
--   `location` geometry NOT NULL,
--   `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
--   PRIMARY KEY (`address_id`),
--   KEY `idx_fk_city_id` (`city_id`),
--   SPATIAL KEY `idx_location` (`location`),
--   CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
-- ) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8'

-- * 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
SELECT s.first_name AS "First Name", s.last_name AS "Last Name", a.address AS "Address"
FROM staff s
JOIN address a
	ON s.address_id = a.address_id;

-- Test - are there only 2 staff members?    
SELECT * FROM staff;

-- * 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
SELECT s.first_name AS  "First Name", s.last_name AS "Last Name", SUM(p.amount) AS "Total Amount"
FROM staff s
JOIN payment p
	ON s.staff_id = p.staff_id
WHERE (p.payment_date >= '2005-08-01' AND p.payment_date <= '2005-08-31')
GROUP BY p.staff_id;

-- * 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
SELECT f.title AS "Movie Title", COUNT(fa.film_id) AS "Number of Actors"
FROM film f
INNER JOIN film_actor fa 
USING (film_id)
GROUP BY f.title;

SELECT * FROM film_actor;

-- * 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT f.title AS "Movie Title", COUNT(f.film_id) AS "Count of Film"
FROM inventory i
JOIN film f
USING (film_id)
WHERE f.title = 'Hunchback Impossible';

-- * 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT c.last_name AS "Last Name", c.first_name AS "First Name", SUM(p.amount) AS "Total Paid"
FROM customer c
JOIN payment p
USING (customer_id)
GROUP BY c.last_name;

-- * 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
SELECT f.title AS "Movie Title", l.name AS "Language"
FROM film f
JOIN language l
USING (language_id)
WHERE (f.title LIKE "K%" OR f.title LIKE "Q%") AND l.name = "English";

-- * 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT first_name AS "First Name", last_name AS "Last Name"
FROM actor a
WHERE a.actor_id IN (
	SELECT fa.actor_id 
    FROM film_actor fa
    WHERE fa.film_id IN (
		SELECT f.film_id
        FROM film f
        WHERE f.title = 'Alone Trip'
	)
);

-- * 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT cu.first_name AS "First Name", cu.last_name AS "Last Name", cu.email AS "Email Address", co.country AS "Country Name"
FROM customer cu 
JOIN address a, city ci, country co 
WHERE cu.address_id = a.address_id AND a.city_id = ci.city_id AND ci.country_id = co.country_id AND co.country_id = 20;

-- * 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.
SELECT f.title AS "Family Movies"
FROM film f
JOIN film_category fc, category c
WHERE f.film_id = fc.film_id AND fc.category_id = c.category_id AND c.category_id = 8;

-- * 7e. Display the most frequently rented movies in descending order.
SELECT f.title, COUNT(r.inventory_id) AS RentalNumber
FROM film f
JOIN inventory i, rental r 
WHERE f.film_id = i.film_id AND i.inventory_id = r.inventory_id
GROUP BY i.film_id
ORDER BY RentalNumber DESC;

-- * 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id AS "Store", SUM(p.amount) AS " Store Revenue"
FROM store s
JOIN payment p
-- Set store ID and staff ID equal because it was a 1:1 relationship...simplified a few steps.  Would not work if more staff was added.
WHERE s.store_id = p.staff_id
GROUP BY s.store_id;

-- * 7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id AS "Store ID", ci.city AS "Store City", co.country AS "Store Country"
FROM store s
JOIN address a, city ci, country co 
WHERE s.address_id = a.address_id AND a.city_id = ci.city_id AND ci.country_id = co.country_id;

-- * 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
-- CAN'T GET ORDER BY OR DESC LIMIT TO WORK...KNOW I NEED SOME SORT OF WRAP/SUBSELECT
SELECT c.name AS "Category Name", SUM(p.amount) AS Gross_Revenue
FROM category c
JOIN film_category fc, inventory i, rental r, payment p 
WHERE c.category_id = fc.category_id AND fc.film_id = i.film_id AND i.inventory_id = r.inventory_id AND r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY Gross_Revenue DESC
LIMIT 5;

-- * 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW TopFiveGenres AS
SELECT c.name AS "Category Name", SUM(p.amount) AS Gross_Revenue
FROM category c
JOIN film_category fc, inventory i, rental r, payment p 
WHERE c.category_id = fc.category_id AND fc.film_id = i.film_id AND i.inventory_id = r.inventory_id AND r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY Gross_Revenue DESC
LIMIT 5;

-- * 8b. How would you display the view that you created in 8a?
SELECT * FROM TopFiveGenres;

-- * 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW TopFiveGenres;