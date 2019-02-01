USE SAKILA;
-- 1A. Display the first and last names of all actors from the table actor.
SELECT FIRST_NAME,LAST_NAME FROM ACTOR;
-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT CONCAT(UPPER(FIRST_NAME),',',UPPER(LAST_NAME)) 'ACTOR NAME' FROM ACTOR;
-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT ACTOR_ID,FIRST_NAME,LAST_NAME FROM ACTOR WHERE UPPER(FIRST_NAME) = 'JOE';
-- 2b. Find all actors whose last name contain the letters GEN:
SELECT * FROM ACTOR WHERE UPPER(LAST_NAME) LIKE '%GEN%';
-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT * FROM ACTOR WHERE UPPER(LAST_NAME) LIKE '%LI%'
ORDER BY FIRST_NAME ASC,LAST_NAME ASC;
-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT COUNTRY_ID,COUNTRY FROM COUNTRY WHERE UPPER(COUNTRY) IN ('AFGHANISTAN','BANGLADESH','CHINA');
-- 3a. You want to keep a description of each actor. 
-- You don't think you will be performing queries on a description, so create a column in the table actor
-- named description and use the data type BLOB (Make sure to research the type BLOB, as the difference 
-- between it and VARCHAR are significant).
ALTER TABLE ACTOR ADD COLUMN description BLOB AFTER LAST_NAME;
-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE ACTOR DROP COLUMN description;
-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT LAST_NAME,COUNT(LAST_NAME) 'ACTOR COUNT' FROM ACTOR GROUP BY LAST_NAME;
-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT LAST_NAME,COUNT(LAST_NAME) 'ACTOR COUNT' FROM ACTOR GROUP BY LAST_NAME
HAVING COUNT(LAST_NAME) >= 2;
-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE ACTOR SET FIRST_NAME = 'HARPO'
WHERE CONCAT(UPPER(FIRST_NAME),' ',UPPER(LAST_NAME)) = 'GROUCHO WILLIAMS';
-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
-- It turns out that GROUCHO was the correct name after all! In a single query, if the first name 
-- of the actor is currently HARPO, change it to GROUCHO.
UPDATE ACTOR 
	SET FIRST_NAME = 
	CASE
		WHEN FIRST_NAME = 'HARPO' THEN 'GROUCHO'
	END
WHERE CONCAT(UPPER(FIRST_NAME),' ',UPPER(LAST_NAME)) = 'HARPO WILLIAMS';

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE ADDRESS;
CREATE TABLE `address` (
   `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
   `address` varchar(50) NOT NULL,
   `address2` varchar(50) DEFAULT NULL,
   `district` varchar(20) NOT NULL,
   `city_id` smallint(5) unsigned NOT NULL,
   `postal_code` varchar(10) DEFAULT NULL,
   `phone` varchar(20) NOT NULL,
   `location` geometry NOT NULL,
   `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (`address_id`),
   KEY `idx_fk_city_id` (`city_id`),
   SPATIAL KEY `idx_location` (`location`),
   CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON DELETE RESTRICT ON UPDATE CASCADE
 ) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;
 
 -- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT S.FIRST_NAME,S.LAST_NAME,A.ADDRESS FROM STAFF S JOIN ADDRESS A WHERE S.ADDRESS_ID = A.ADDRESS_ID;
-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT S.FIRST_NAME 'FIRST NAME' ,S.LAST_NAME 'LAST NAME',SUM(P.AMOUNT) 'TOTAL AMOUNT'
FROM STAFF S JOIN PAYMENT P ON S.STAFF_ID = P.STAFF_ID
WHERE DATE_FORMAT(P.PAYMENT_DATE,'%M %Y') = 'August 2005'
GROUP BY S.FIRST_NAME,S.LAST_NAME
-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT F.FILM_ID, F.TITLE, COUNT(A.ACTOR_ID) 'NUMBER OF ACTORS' 
FROM FILM F JOIN FILM_ACTOR A ON F.FILM_ID = A.FILM_ID
GROUP BY F.FILM_ID
ORDER BY F.TITLE ASC
-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT I.FILM_ID 'FILM ID', F.TITLE TITLE,COUNT(INVENTORY_ID) COPIES FROM INVENTORY I JOIN FILM F
ON F.FILM_ID = I.FILM_ID
WHERE F.TITLE = 'Hunchback Impossible'
-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT C.LAST_NAME 'LAST NAME',C.FIRST_NAME 'FIRST NAME',SUM(P.AMOUNT) 'TOTAL PAID'
FROM PAYMENT P JOIN CUSTOMER C ON P.CUSTOMER_ID = C.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID,C.FIRST_NAME
ORDER BY C.LAST_NAME ASC
-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT TITLE FROM FILM
WHERE EXISTS (SELECT LANGUAGE_ID FROM LANGUAGE WHERE UPPER(NAME) = 'ENGLISH')
AND TITLE LIKE 'K%' OR TITLE LIKE 'Q%'

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT CONCAT(FIRST_NAME,' ',LAST_NAME) ACTOR
FROM ACTOR 
WHERE ACTOR_ID IN (SELECT ACTOR_ID FROM FILM_ACTOR
WHERE FILM_ID IN (SELECT FILM_ID FROM FILM WHERE UPPER(TITLE) = 'ALONE TRIP'))

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and 
-- email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT CONCAT(C.FIRST_NAME,' ',C.LAST_NAME) 'CUSTOMER NAME',C.EMAIL 'EMAIL ADDRESS',CY.COUNTRY
FROM CUSTOMER C JOIN ADDRESS A ON C.ADDRESS_ID = A.ADDRESS_ID JOIN CITY CI ON A.CITY_ID = CI.CITY_ID
JOIN COUNTRY CY ON CI.COUNTRY_ID = CY.COUNTRY_ID
WHERE CY.COUNTRY = 'CANADA'

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
SELECT F.TITLE MOVIE,C.NAME CATEGORY
FROM FILM F JOIN FILM_CATEGORY FC ON F.FILM_ID = FC.FILM_ID JOIN CATEGORY C
ON FC.CATEGORY_ID = C.CATEGORY_ID WHERE UPPER(C.NAME) = 'FAMILY'

-- 7e. Display the most frequently rented movies in descending order.
SELECT F.TITLE,R.RENTAL_DATE
FROM FILM F JOIN INVENTORY I ON F.FILM_ID = I.FILM_ID JOIN RENTAL R ON I.INVENTORY_ID = R.INVENTORY_ID
ORDER BY R.RENTAL_DATE DESC

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT S.STAFF_ID,ST.STORE_ID,SUM(P.AMOUNT)
FROM PAYMENT P JOIN STAFF S ON P.STAFF_ID = S.STAFF_ID JOIN STORE ST ON ST.STORE_ID = S.STORE_ID
GROUP BY S.STAFF_ID,ST.STORE_ID

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT ST.STORE_ID,CI.CITY,CY.COUNTRY
FROM STORE ST JOIN ADDRESS A ON ST.ADDRESS_ID = A.ADDRESS_ID JOIN CITY CI ON CI.CITY_ID = A.CITY_ID
JOIN COUNTRY CY ON CY.COUNTRY_ID = CI.COUNTRY_ID

-- 7h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select c.name,sum(p.amount) 'GROSS AVENUE' from
category c join film_category fc on c.category_id=fc.category_id join inventory i
on i.film_id = fc.film_id join rental r on r.inventory_id = i.inventory_id
join payment p on r.rental_id = p.rental_id
group by c.name
order by sum(p.amount) desc
limit 5

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres 
-- by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, 
-- you can substitute another query to create a view.
create or replace view TOP_FIVE_GENRES as
select c.name,sum(p.amount) 'GROSS AVENUE' from
category c join film_category fc on c.category_id=fc.category_id join inventory i
on i.film_id = fc.film_id join rental r on r.inventory_id = i.inventory_id
join payment p on r.rental_id = p.rental_id
group by c.name
order by sum(p.amount) desc
limit 5

-- 8b. How would you display the view that you created in 8a?
select * from TOP_FIVE_GENRES

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view TOP_FIVE_GENRES
