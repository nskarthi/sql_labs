USE mavenmovies;

/* My understanding is that we  have titles that we rent for durations of 3 , 5 , or 7 days.
Could you pull the records of our films and see if there are  any other rental durations? */
SELECT DISTINCT rental_duration
FROM film
WHERE rental_duration not in (3, 5, 7);

/* I’d like to find out the customers who has paid the most for rentals */
SELECT customer_id, SUM(amount) as total
FROM payment
GROUP BY customer_id
ORDER BY total desc;

/* I’d like to look at payment records for our long term  customers to learn about their purchase patterns.
Could you pull all payments from our first 100 customers (based on customer ID)? */
SELECT customer_id, rental_id, amount, payment_date
FROM payment
WHERE customer_id <= 100;

/* The payment data you gave me on our first 100 customers was great thank you!
Now I’d love to see just payments over $5 for those same customers, since January 1, 2006. */
SELECT customer_id, rental_id, amount, payment_date
FROM payment
WHERE customer_id <= 100
AND amount > 5
AND payment_date >= '2006-01-01';

/* The data you shared previously on customers 42, 53, 60, and 75 was good to see. Now, could you please write 
a queryto pull all payments from those specific customers along with payments over $5 , from any customer? */
SELECT customer_id, rental_id, amount, payment_date
FROM payment
WHERE amount > 5
OR customer_id in (42, 53, 60, 75);

/* We need to understand the special features in our films. Could you pull a list of films which
include a Behind the Scenes special feature? */
SELECT title, special_features
FROM film
WHERE special_features like '%Behind the Scenes%';

/* I need to get a quick overview of how long our movies tend to be rented out for.
Could you please pull a count of titles sliced by rental duration ? */
SELECT rental_duration, COUNT(film_id) AS films_with_this_rental_duration
FROM film
GROUP BY rental_duration;

/* I’m wondering if we charge more for a rental when the replacement cost is higher.
Can you help me pull a count of films , along with the average , min , and max rental rate ,
grouped by replacement cost */
SELECT
	replacement_cost,
    COUNT(film_id),
    MIN(rental_rate),
    MAX(rental_rate),
    AVG(rental_rate)
FROM film
GROUP BY replacement_cost;

/* I’d like to talk to customers that have not rented much from us to understand if there is something
we could be doing better. Could you pull a list of customer_ids with less than 15 rentals all time? */
SELECT
	customer_id,
    COUNT(*) AS total_rentals
FROM rental
GROUP BY customer_id
HAVING total_rentals < 15;

/* I’d like to see if our longest films also tend to be our most expensive rentals. Could you pull me a list 
of all film titles along with their lengths and rental rates , and sort them from longest to shortest? */
SELECT
	title, length, rental_rate
FROM film
ORDER BY length DESC;

/* CASE SAMPLE */
SELECT DISTINCT
	length, 
    CASE
		WHEN length < 60 THEN 'under 1 hr'
        WHEN length BETWEEN 60 and 90 THEN '1-1.5 hrs'
        WHEN length > 90 THEN 'over 1.5 hrs'
        ELSE 'MISS'
	END AS length_bucket
FROM film
ORDER BY length;

/* I’d like to know which store each customer goes to, and whether or not they are active.
Could you pull a list of first and last names of all customers , and label them as either ‘store 1
active’, ‘store 1 inactive’, ‘store 2 active’, or ‘store 2 inactive’? */
SELECT
	first_name,
    last_name,
    CASE
		WHEN store_id = 1 AND active = 0 THEN 'store 1 inactive'
        WHEN store_id = 1 AND active = 1 THEN 'store 1 active'
        WHEN store_id = 2 AND active = 0 THEN 'store 2 inactive'
        WHEN store_id = 2 AND active = 1 THEN 'store 2 active'
	END as store_and_status
FROM customer;

/* COUNT OF CASE Example: Copies of films stored by copies sold by each Store */
SELECT film_id, store_id, COUNT(store_id) FROM inventory
GROUP BY film_id, store_id
ORDER BY film_id, store_id;

/* COUNT OF CASE Example: Copies of films stored by copies sold by each Store */
SELECT
	film_id,
    COUNT(CASE WHEN store_id = 1 THEN inventory_id ELSE NULL END) AS store_1_copies,
    COUNT(CASE WHEN store_id = 2 THEN inventory_id ELSE NULL END) AS store_2_copies,
    COUNT(*) AS total_copies
FROM inventory
GROUP BY film_id
ORDER BY film_id;

/* I’m curious how many inactive customers we have at each store. Could you please create a table to
count the number of customers broken down by store_id (in rows), and active status (in columns)? */
SELECT
	store_id,
	COUNT(CASE WHEN active = 1 THEN store_id ELSE NULL END) as active,
    COUNT(CASE WHEN active = 0 THEN store_id ELSE NULL END) as inactive
FROM customer
GROUP BY store_id
ORDER BY store_id;

/* We will need a list of all staff members, including their first and last names, 
email addresses, and the store identification number where they work. */ 
SELECT first_name, last_name, email, store_id FROM staff;

/* We will need separate counts of inventory items held at each of your two stores. */ 
SELECT store_id, count(inventory_id) from inventory
GROUP BY store_id;

/* We will need a count of active customers for each of your stores. Separately, please. */
SELECT store_id, COUNT(*) FROM customer
WHERE active = 1
GROUP BY store_id;

/* In order to assess the liability of a data breach, we will need you to provide a count 
of all customer email addresses stored in the database. */
select count(email) from customer;

/* We are interested in how diverse your film offering is as a means of understanding how likely 
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

/* We would like to understand the replacement cost of your films. Please provide the replacement cost for the 
film that is least expensive to replace, the most expensive to replace, and the average of all films you carry */
SELECT
	MIN(replacement_cost),
    MAX(replacement_cost),
    AVG(replacement_cost)
FROM film;

/* We are interested in having you put payment monitoring systems and maximum payment processing restrictions in 
place in order to minimize the future risk of fraud by your staff. Please provide the average payment you process, as 
well as the maximum payment you have processed. */
SELECT
	AVG(amount),
    MAX(amount)
FROM payment;

/* We would like to better understand what your customer base looks like. Please provide a list of all 
customer identification values, with a count of rentals they have made all-time, with your highest volume 
customers at the top of the list. */
SELECT
	customer_id,
    COUNT(rental_id) as count_of_rentals
FROM rental
GROUP BY customer_id
ORDER BY count_of_rentals desc;