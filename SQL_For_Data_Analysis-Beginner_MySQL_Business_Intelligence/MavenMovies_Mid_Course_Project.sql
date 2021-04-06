use mavenmovies;

/* 1. We will need a list of all staff members, including their first and last names, 
email addresses, and the store identification number where they work. */ 
SELECT first_name, last_name, email, store_id FROM staff;

/* 2. We will need separate counts of inventory items held at each of your two stores. */ 
SELECT store_id, count(inventory_id) from inventory
GROUP BY store_id;

/* 3. We will need a count of active customers for each of your stores. Separately, please. */
SELECT store_id, COUNT(*) FROM customer
WHERE active = 1
GROUP BY store_id;

/* 4. In order to assess the liability of a data breach, we will need you to provide a count 
of all customer email addresses stored in the database. */
select count(email) from customer;

/* 5. We are interested in how diverse your film offering is as a means of understanding how likely 
you are to keep customers engaged in the future. (a) Please provide a count of unique film titles 
you have in inventory at each store and then (b) Provide a count of the unique categories of films you provide. */
-- (a)
select store_id, COUNT(DISTINCT 
film_id) from inventory
group by store_id;

-- (b)
SELECT count(DISTINCT name) from category;

/* Summary of each film's categoy */
select f.title, c.name from film f
join film_category fc
on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
order by fc.film_id;

/* 6. We would like to understand the replacement cost of your films. Please provide the replacement cost for the 
film that is least expensive to replace, the most expensive to replace, and the average of all films you carry */
SELECT
	MIN(replacement_cost),
    MAX(replacement_cost),
    AVG(replacement_cost)
FROM film;

/* 7. We are interested in having you put payment monitoring systems and maximum payment processing restrictions in 
place in order to minimize the future risk of fraud by your staff. Please provide the average payment you process, as 
well as the maximum payment you have processed. */
SELECT
	AVG(amount),
    MAX(amount)
FROM payment;

/* 8. We would like to better understand what your customer base looks like. Please provide a list of all 
customer identification values, with a count of rentals they have made all-time, with your highest volume 
customers at the top of the list. */
SELECT
	customer_id,
    COUNT(rental_id) as count_of_rentals
FROM rental
GROUP BY customer_id
ORDER BY count_of_rentals desc;


