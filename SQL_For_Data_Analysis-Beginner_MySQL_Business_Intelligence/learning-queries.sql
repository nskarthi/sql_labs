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
FROM
    film;

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

/* Can you pull for me a list of each film we have in inventory? I would like to see the film’s title,
description, and the store_id value associated with each item, and its inventory_id. */
SELECT 
    i.inventory_id, i.store_id, f.title, f.description
FROM
    inventory i
        INNER JOIN
    film f ON i.film_id = f.film_id;

/* Count of all films in which each actor appeared */
SELECT
	a.first_name,
    a.last_name,
    COUNT(fa.film_id)
FROM actor a
INNER JOIN film_actor fa
ON a.actor_id = fa.actor_id
GROUP BY a.first_name, a.last_name;

/* One of our investors is interested in the films we carry and how many actors are listed for each film title.
Can you pull a list of all titles, and figure out how many actors are associated with each title? */
SELECT
	f.title,
    count(fa.actor_id) number_of_actors
FROM film f
INNER JOIN film_actor fa
ON f.film_id = fa.film_id
GROUP BY f.title
ORDER BY number_of_actors
LIMIT 5000;

/* Can you pull a list of all titles, and figure out how many actors are associated with each title, even if there are no actors? */
SELECT
	f.title,
    count(fa.actor_id) number_of_actors
FROM film f
LEFT JOIN film_actor fa
ON f.film_id = fa.film_id
GROUP BY f.title
ORDER BY number_of_actors
LIMIT 5000;

/* Customers often ask which films their favorite actors appear in. It would be great to have a list of
all actors, with each title that they appear in. Could you please pull that for me? */
SELECT
	a.first_name,
    a.last_name,
	f.title
FROM actor a
JOIN film_actor fa
on a.actor_id = fa.actor_id
JOIN film f
ON fa.film_id = f.film_id;

/* The Manager from Store 2 is working on expanding our film collection there. Could you pull a list of
distinct titles and their descriptions, currently available in inventory at store 2 */
SELECT
	DISTINCT ft.title,
    ft.description
FROM film ft
JOIN inventory i
ON ft.film_id = i.film_id
WHERE i.store_id = 2;

/* My partner and I want to come by each of the stores in person and meet the managers. 
Please send over the managers’ names at each store, with the full address 
of each property (street address, district, city, and country please). */ 
SELECT
	staff.first_name,
    staff.last_name,
    address.address,
    address.district,
    city.city,
    country.country
FROM store
LEFT JOIN staff ON store.manager_staff_id = staff.staff_id
LEFT JOIN address ON store.address_id = address.address_id
LEFT JOIN city ON address.city_id = city.city_id
LEFT JOIN country on city.country_id = country.country_id;
	
/* I would like to get a better understanding of all of the inventory that would come along with the business. 
Please pull together a list of each inventory item you have stocked, including the store_id number, 
the inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost. */
SELECT
    i.store_id,
	i.inventory_id,
    f.title,
    f.rating,
    f.rental_rate,
    f.replacement_cost
FROM inventory i
JOIN film f
ON i.film_id = f.film_id;

/* From the same list of films you just pulled, please roll that data up and provide a summary level overview 
of your inventory. We would like to know how many inventory items you have with each rating at each store. */
SELECT
	i.store_id,
    f.rating,
	COUNT(i.inventory_id)
FROM inventory i
JOIN film f
ON i.film_id = f.film_id
GROUP BY i.store_id, f.rating
ORDER BY i.store_id, f.rating;

/* Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to see how 
big of a hit it would be if a certain category of film became unpopular at a certain store. We would like to see the 
number of films, as well as the average replacement cost, and total replacement cost, sliced by store and film category. */ 
SELECT
	i.store_id,
    c.name,
    count(f.film_id),
    avg(f.replacement_cost),
    sum(f.replacement_cost)
FROM category c
	JOIN film_category fc
	ON c.category_id = fc.category_id
	JOIN film f
	ON fc.film_id = f.film_id
	JOIN inventory i
	ON f.film_id = i.film_id
GROUP BY
	i.store_id,
    c.name
ORDER BY 
	SUM(f.replacement_cost) DESC;

/* We want to make sure you folks have a good handle on who your customers are. Please provide a list 
of all customer names, which store they go to, whether or not they are currently active, 
and their full addresses – street address, city, and country. */
SELECT
	CONCAT(cust.first_name, ' ' , cust.last_name) as "Customer Name",
    cust.store_id,
    CASE
		WHEN cust.active = 1 THEN 'ACTIVE'
        ELSE 'INACTIVE'
	END AS "Customer Status",
    CONCAT(addr.address, ", ", cty.city, ", ", ctry.country) as "Customer Address"
FROM customer cust
	JOIN address addr ON cust.address_id = addr.address_id
	JOIN city cty ON addr.city_id = cty.city_id
    JOIN country ctry ON cty.country_id = ctry.country_id;

/* We would like to understand how much your customers are spending with you, and also to know who your most valuable customers are.
Please pull together a list of customer names, their total lifetime rentals, and the sum of all payments you have collected from 
them. It would be great to see this ordered on total lifetime value, with the most valuable customers at the top of the list. */
SELECT
	CONCAT(c.first_name, ' ' , c.last_name) as customer_name,
	COUNT(r.rental_id) as "Total Lifetime Rentals",
    SUM(p.amount) as total_payments
FROM customer c
	JOIN rental r ON c.customer_id = r.customer_id
    JOIN payment p ON r.customer_id = p.customer_id
GROUP BY customer_name
ORDER BY total_payments DESC;
    
/* My partner and I would like to get to know your board of advisors and any current investors. Could you please provide 
a list of advisor and investor names in one table? Could you please note whether they are an investor or an advisor, and 
for the investors, it would be good to include which company they work with. */
SELECT
	first_name, last_name, "Investor" as type, company_name
FROM investor
UNION
SELECT
	first_name, last_name, "Advisor" as type, NULL
FROM advisor;

/* We're interested in how well you have covered the most-awarded actors. Of all the actors with three types of
awards, for what % of them do we carry a film? And how about for actors with two types of awards? Same questions. 
Finally, how about actors with just one award? */
select 
	CONCAT(first_name, " ", last_name) as actor_name,
    CASE
		WHEN awards = "Emmy, Oscar, Tony"  THEN 3
		WHEN awards IN ("Emmy, Oscar", "Emmy, Tony", "Oscar, Tony")  THEN 2
		WHEN awards IN ("Emmy", "Oscar", "Tony")  THEN 2
        ELSE 0
	END AS number_of_awards,
    COUNT(fa.film_id)
FROM actor_award
JOIN film_actor fa ON actor_award.actor_id = fa.actor_id
-- WHERE number_of_awards = 0
GROUP BY actor_name
ORDER BY number_of_awards DESC;

select DISTINCT(awards) from actor_award;

SELECT
	CASE 
		WHEN actor_award.awards = 'Emmy, Oscar, Tony ' THEN '3 awards'
        WHEN actor_award.awards IN ('Emmy, Oscar','Emmy, Tony', 'Oscar, Tony') THEN '2 awards'
		ELSE '1 award'
	END AS number_of_awards, 
    AVG(CASE WHEN actor_award.actor_id IS NULL THEN 0 ELSE 1 END) AS pct_w_one_film
FROM actor_award
GROUP BY number_of_awards;

/* ---------------------------------------------------------------------------------------------
Queries related to 'mavenfuzzyfactory' schema
--------------------------------------------------------------------------------------------- */
USE mavenfuzzyfactory;

SELECT * from orders LIMIT 10;
SELECT * from order_item_refunds LIMIT 10;
SELECT * from order_items LIMIT 10;
SELECT * from products LIMIT 10;
SELECT * from website_sessions LIMIT 10;
SELECT * from website_pageviews LIMIT 10;

/* We've been live for almost a month now and we’re starting to generate sales. Can you help me understand where the 
bulk of our website sessions are coming from, through yesterday? I’d like to see a breakdown by UTM source , campaign
and referring domain if possible. Thanks! */
SELECT
	utm_source,
    utm_campaign,
    http_referer,
    COUNT(website_session_id) as sessions
FROM website_sessions
WHERE created_at <= '2012-04-12'
GROUP BY 1, 2, 3
ORDER BY sessions DESC;

/* Sounds like gsearch nonbrand is our major traffic source, but we need to understand if those sessions are driving sales.
Could you please calculate the conversion rate (CVR) from session to order ? Based on what we're paying for clicks,
we’ll need a CVR of at least 4% to make the numbers work. */
SELECT
	COUNT(DISTINCT ws.website_session_id) as sessions,
    COUNT(DISTINCT o.order_id) as orders,
    COUNT(o.order_id) / COUNT(ws.website_session_id) as CVR
FROM website_sessions ws
	LEFT JOIN orders o
		ON o.website_session_id = ws.website_session_id
WHERE ws.created_at <= '2012-04-12'
	and ws.utm_source = 'gsearch'
	and ws.utm_campaign = 'nonbrand';

/* YEAR() and WEEK() examples */
SELECT
	YEAR(created_at),
    WEEK(created_at),
    COUNT(DISTINCT website_session_id) as sessions
FROM website_sessions
GROUP BY 1, 2
ORDER BY 3 DESC;

/* CASE() within COUNT() Together */
SELECT
	primary_product_id,
	COUNT(CASE WHEN items_purchased = 1 THEN 1 END) as "1 product",
    COUNT(CASE WHEN items_purchased = 2 THEN 2 END) as "2 products",
    COUNT(DISTINCT order_id)
FROM orders
WHERE order_id BETWEEN 31000 and 32000
GROUP BY 1;

SELECT
	primary_product_id,
	COUNT(CASE WHEN items_purchased = 1 THEN order_id END) as "1 product",
    COUNT(CASE WHEN items_purchased = 2 THEN order_id END) as "2 products",
    COUNT(DISTINCT order_id)
FROM orders
WHERE order_id BETWEEN 31000 and 32000
GROUP BY 1;

/* Based on your conversion rate analysis, we bid down gsearch nonbrand on 2012 04 15. Can you pull gsearch nonbrand 
trended session volume, by week , to see if the bid changes have caused volume to drop at all? */
SELECT
    MIN(DATE(created_at)) as week_start_date,
	COUNT(DISTINCT website_session_id) as sessions
FROM website_sessions
WHERE created_at <= '2012-05-12'
	and utm_source = 'gsearch'
	and utm_campaign = 'nonbrand'
GROUP BY
	WEEK(created_at)  -- OR YEAR(created_at), WEEK(created_at) : Both commented and uncommented queries yield the same result
ORDER BY 1;

/* I was trying to use our site on my mobile device the other day, and the experience was not great. Could you pull
conversion rates from session to order, by device type? If desktop performance is better than on mobile we may be 
able to bid up for desktop specifically to get more volume? */
SELECT
	ws.device_type,
	COUNT(DISTINCT ws.website_session_id) as sessions,
    COUNT(DISTINCT o.order_id) as orders,
    COUNT(o.order_id) / COUNT(ws.website_session_id) as CVR
FROM website_sessions ws
	LEFT JOIN orders o
		ON ws.website_session_id = o.website_session_id
WHERE ws.created_at <= '2012-05-11'
	and ws.utm_source = 'gsearch'
	and ws.utm_campaign = 'nonbrand'
GROUP BY 1
ORDER BY 1;

/* After your device level analysis of conversion rates, we realized desktop was doing well, so we bid 
our gsearch nonbrand desktop campaigns up on 2012 05 19. Could you pull weekly trends for both desktop 
and mobile so we can see the impact on volume? You can use 2012-04-15 until the bid change as a baseline. */
SELECT
    MIN(DATE(created_at)) as week_start_date,
	COUNT(CASE WHEN device_type = 'desktop' THEN website_session_id END) as dtop_sessions,
	COUNT(CASE WHEN device_type = 'mobile' THEN website_session_id END) as dtop_sessions
FROM website_sessions
WHERE created_at >= '2012-04-15'
	and created_at <= '2012-06-09'
	and utm_source = 'gsearch'
	and utm_campaign = 'nonbrand'
GROUP BY WEEK(created_at)
ORDER BY 1;

/* PAGE VIEWS - Summary*/
SELECT
	pageview_url,
    COUNT(DISTINCT website_pageview_id)
FROM website_pageviews
WHERE website_pageview_id < 1000
GROUP BY 1
ORDER BY 2 DESC;

/* Get me the pages where the user landed first */
SELECT
	website_session_id,
    min(website_pageview_id)
FROM website_pageviews
WHERE website_pageview_id < 1000
GROUP BY 1
ORDER BY 2;

SELECT * FROM website_pageviews
ORDER BY 3, 1;

/* Using CREATE TEMPORARY TABLE */
DROP TEMPORARY TABLE first_pageview;
CREATE TEMPORARY TABLE first_pageview
SELECT
	website_session_id,
    min(website_pageview_id) as min_pv_id
FROM website_pageviews
WHERE created_at < '2012-06-12'
GROUP BY 1
ORDER BY 2;

/* Summary of entry page views vs Sessions - USES TEMPORARY TABLE */
SELECT
    wp.pageview_url AS landing_page,  -- aka "entry page"
    COUNT(DISTINCT fp.website_session_id)
FROM first_pageview fp
	LEFT JOIN website_pageviews wp
    ON fp.min_pv_id = wp.website_pageview_id
GROUP BY 1;

/* Most-viewed website pages, ranked by session volume */
SELECT
	pageview_url,
    COUNT(DISTINCT website_session_id) as sessions
FROM website_pageviews
WHERE created_at < '2021-06-09'
GROUP BY 1
ORDER BY 2 DESC;

SELECT * from website_pageviews;
select * from first_pageview;

/* ------------------------------------------------------------------------------------------------------------------
Would you be able to pull a list of the top entry pages? I want to confirm where our users are hitting the site.
If you could pull all entry pages and rank them on entry volume, that would be - USES TEMPORARY TABLE
	Step 1: For each session id, find the first page view -> Load this data into a TEMPORARY TABLE
	Step 2: Find the url the customer saw on the first page --> Using LEFT JOIN
------------------------------------------------------------------------------------------------------------------ */
-- Step 1 Query:
DROP TEMPORARY TABLE first_pageview;
CREATE TEMPORARY TABLE first_pageview
SELECT
	website_session_id,
    MIN(website_pageview_id) as min_pv_id
FROM website_pageviews
WHERE created_at < '2012-06-12'
GROUP BY 1;

-- Step 2 Query:
SELECT
	wp.pageview_url,
    COUNT(DISTINCT fp.website_session_id)
FROM first_pageview fp
	LEFT JOIN website_pageviews wp
		ON fp.min_pv_id = wp.website_pageview_id
GROUP BY 1
ORDER BY 2 DESC;

/* ------------------------------------------------------------------------------------------------------------------
A/B EXPERIMENT:
	Business Context: We want to see landing page performance for a certain time period
    User Context: Identify the page visits beyond the landing page
		Step 1: For the relevant session, find the first website_pageview_id --> create TEMPORARY table
		Step 2: Identify the landing page (url) of each session
		Step 3: Counting pageviews for each session, to identify 'bounces'
        Step 4: Summarizing total sessions and bounced sessions, by Landing Page
------------------------------------------------------------------------------------------------------------------ */

-- Step 1:
DROP TABLE first_pageviews_demo;
CREATE TEMPORARY TABLE first_pageviews_demo
SELECT
	wp.website_session_id,
    MIN(wp.website_pageview_id) as min_pageview_id
FROM website_pageviews wp
	INNER JOIN website_sessions ws
		ON wp.website_session_id = ws.website_session_id
WHERE ws.created_at BETWEEN '2014-01-01' AND '2014-02-01'
GROUP BY 1;

SELECT * FROM first_pageviews_demo;

-- Step 2:
CREATE TEMPORARY TABLE sessions_w_landing_page_demo
SELECT
	fpd.website_session_id,
    wp.pageview_url as landing_page
FROM first_pageviews_demo fpd
	LEFT JOIN website_pageviews wp
		ON fpd.min_pageview_id = wp.website_pageview_id;

SELECT * from sessions_w_landing_page_demo;

-- Step 3:
DROP TABLE bounced_sessions_only;
CREATE TEMPORARY TABLE bounced_sessions_only
SELECT
	swlpd.website_session_id,
    swlpd.landing_page,
    COUNT(wp.website_pageview_id) AS count_of_pages_viewed
FROM sessions_w_landing_page_demo swlpd
	JOIN website_pageviews wp
		ON swlpd.website_session_id = wp.website_session_id
GROUP BY 1, 2
HAVING count_of_pages_viewed = 1;

SELECT * from bounced_sessions_only;

-- Step 4 (prep-query):
SELECT
	swlpd.landing_page,
    swlpd.website_session_id,
    bso.website_session_id
FROM sessions_w_landing_page_demo swlpd
	LEFT JOIN bounced_sessions_only bso
		ON swlpd.website_session_id = bso.website_session_id
ORDER BY 2;

-- Step 4 (final output):
SELECT
	swlpd.landing_page,
    COUNT(DISTINCT swlpd.website_session_id) AS sessions,
    COUNT(bso.website_session_id) AS bounced_sessions,
    CONCAT(ROUND(COUNT(bso.website_session_id) / COUNT(DISTINCT swlpd.website_session_id) * 100, 0), "%") AS bounce_rate
FROM sessions_w_landing_page_demo swlpd
	LEFT JOIN bounced_sessions_only bso
		ON swlpd.website_session_id = bso.website_session_id
GROUP BY 1
ORDER BY 1;

/* ------------------------------------------------------------------------------------------------------------------
Business Context: The other day you showed us that all of our traffic is landing on the homepage right now. We should 
	check how that landing page is performing. Can you pull bounce rates for traffic landing on the homepage? I would 
	like to see three numbers… Sessions, Bounced Sessions, and % of Sessions which Bounced (aka “Bounce Rate").
	Step 1: For the relevant session, find the first website_pageview_id --> create TEMPORARY table
	Step 2: Identify the landing page (url) of each session
	Step 3: Counting pageviews for each session, to identify 'bounces'
	Step 4: Summarizing total sessions and bounced sessions, by Landing Page
------------------------------------------------------------------------------------------------------------------ */

-- Step 1:
DROP TABLE first_pageviews_demo;
CREATE TEMPORARY TABLE first_pageviews_demo
SELECT
	wp.website_session_id,
    MIN(wp.website_pageview_id) as min_pageview_id
FROM website_pageviews wp
	INNER JOIN website_sessions ws
		ON wp.website_session_id = ws.website_session_id
WHERE ws.created_at < '2012-06-14'
GROUP BY 1;

SELECT * FROM first_pageviews_demo;

-- Step 2:
DROP TABLE sessions_w_landing_page_demo;
CREATE TEMPORARY TABLE sessions_w_landing_page_demo
SELECT
	fpd.website_session_id,
    wp.pageview_url as landing_page
FROM first_pageviews_demo fpd
	LEFT JOIN website_pageviews wp
		ON fpd.min_pageview_id = wp.website_pageview_id
WHERE wp.pageview_url = '/home';

SELECT * from sessions_w_landing_page_demo;

-- Step 3:
DROP TABLE bounced_sessions_only;
CREATE TEMPORARY TABLE bounced_sessions_only
SELECT
	swlpd.website_session_id,
    swlpd.landing_page,
    COUNT(wp.website_pageview_id) AS count_of_pages_viewed
FROM sessions_w_landing_page_demo swlpd
	JOIN website_pageviews wp
		ON swlpd.website_session_id = wp.website_session_id
GROUP BY 1, 2
HAVING count_of_pages_viewed = 1;

SELECT * from bounced_sessions_only;

-- Step 4 (prep-query):
SELECT
	swlpd.landing_page,
    swlpd.website_session_id,
    bso.website_session_id
FROM sessions_w_landing_page_demo swlpd
	LEFT JOIN bounced_sessions_only bso
		ON swlpd.website_session_id = bso.website_session_id
ORDER BY 2;

-- Step 4 (final output):
SELECT
	swlpd.landing_page,
    COUNT(DISTINCT swlpd.website_session_id) AS sessions,
    COUNT(bso.website_session_id) AS bounced_sessions,
    CONCAT(ROUND(COUNT(bso.website_session_id) / COUNT(DISTINCT swlpd.website_session_id) * 100, 0), "%") AS bounce_rate
FROM sessions_w_landing_page_demo swlpd
	LEFT JOIN bounced_sessions_only bso
		ON swlpd.website_session_id = bso.website_session_id
GROUP BY 1
ORDER BY 1;


/* --------------------------------------------------------------------------------------------------------------------
									SCHEMA: MASTER_SQL_FOR_DATA_SCIENCE
-------------------------------------------------------------------------------------------------------------------- */
SELECT 
    SUM(CASE WHEN department = 'Sports' THEN 1 ELSE 0 END) AS sports_employees,
    SUM(CASE WHEN department = 'Tools' THEN 1 ELSE 0 END) AS tools_employees,
    SUM(CASE WHEN department = 'Clothing' THEN 1 ELSE 0 END) AS clothing_employees,
    SUM(CASE WHEN department = 'Computers' THEN 1 ELSE 0 END) AS computers_employees
FROM
    employees;

SELECT
	first_name,
    (CASE WHEN region_id = 1 THEN (SELECT country from regions WHERE region_id = 1) END) as region_1,
    (CASE WHEN region_id = 2 THEN (SELECT country from regions WHERE region_id = 2) END) as region_2,
    (CASE WHEN region_id = 3 THEN (SELECT country from regions WHERE region_id = 3) END) as region_3,
    (CASE WHEN region_id = 4 THEN (SELECT country from regions WHERE region_id = 4) END) as region_4,
    (CASE WHEN region_id = 5 THEN (SELECT country from regions WHERE region_id = 5) END) as region_5,
    (CASE WHEN region_id = 6 THEN (SELECT country from regions WHERE region_id = 6) END) as region_6,
    (CASE WHEN region_id = 7 THEN (SELECT country from regions WHERE region_id = 7) END) as region_7
FROM employees;

SELECT
	COUNT(a.region_1) + COUNT(a.region_2) + COUNT(a.region_3) as united_states,
	COUNT(a.region_4) + COUNT(a.region_5) as asia,
    COUNT(a.region_5) + COUNT(a.region_7) as canada
FROM (
	SELECT
		first_name,
		(CASE WHEN region_id = 1 THEN (SELECT country from regions WHERE region_id = 1) END) as region_1,
		(CASE WHEN region_id = 2 THEN (SELECT country from regions WHERE region_id = 2) END) as region_2,
		(CASE WHEN region_id = 3 THEN (SELECT country from regions WHERE region_id = 3) END) as region_3,
		(CASE WHEN region_id = 4 THEN (SELECT country from regions WHERE region_id = 4) END) as region_4,
		(CASE WHEN region_id = 5 THEN (SELECT country from regions WHERE region_id = 5) END) as region_5,
		(CASE WHEN region_id = 6 THEN (SELECT country from regions WHERE region_id = 6) END) as region_6,
		(CASE WHEN region_id = 7 THEN (SELECT country from regions WHERE region_id = 7) END) as region_7
	FROM employees) a;

SELECT
    COUNT(CASE WHEN region_id IN (1, 2, 3) THEN 1 ELSE NULL END) AS united_states,
    COUNT(CASE WHEN region_id IN (4, 5) THEN 1 ELSE NULL END) AS asia,
    COUNT(CASE WHEN region_id IN (6, 7) THEN 1 ELSE NULL END) AS canada
FROM employees;

SELECT
    COUNT(a.first_name) FROM (SELECT first_name FROM employees WHERE region_id IN 
			(SELECT region_id FROM regions where country = 'United States')) a;

SELECT
	name,
    SUM(supply) as supplies,
    (CASE
		WHEN SUM(supply) < 20000 THEN "LOW"
        WHEN SUM(supply) BETWEEN 20000 AND 50000 THEN "ENOUGH"
        WHEN SUM(supply) > 50000 THEN "FULL"
	END) as category
FROM fruit_imports
GROUP BY name
ORDER BY supplies;

-- Same result as above, but different query
SELECT name, total_supply,
	(CASE
		WHEN total_supply < 20000 THEN "LOW"
		WHEN total_supply BETWEEN 20000 AND 50000 THEN "ENOUGH"
		WHEN total_supply > 50000 THEN "FULL"
	END) as category
FROM (SELECT name, SUM(supply) as total_supply
FROM fruit_imports GROUP BY name) a;

SELECT * from fruit_imports;

SELECT
	season, SUM(supply * cost_per_unit) FROM fruit_imports
GROUP BY 1;

SELECT SUM(CASE WHEN season = 'Winter' THEN total_cost end) as Winter_total,
SUM(CASE WHEN season = 'Summer' THEN total_cost end) as Summer_total,
SUM(CASE WHEN season = 'Spring' THEN total_cost end) as Spring_total,
SUM(CASE WHEN season = 'Fall' THEN total_cost end) as Spring_total,
SUM(CASE WHEN season = 'All Year' THEN total_cost end) as Spring_total
FROM (
select season, sum(supply * cost_per_unit) total_cost
from fruit_imports
group by season
    ) a;

SELECT
	department,
    COUNT(employee_id) as employees_count
FROM employees
GROUP BY 1
HAVING employees_count > 38
ORDER BY 2;

/* Same result as above but different query */
SELECT department FROM
(SELECT
	department,
    COUNT(employee_id) as employees_count
FROM employees
GROUP BY 1
HAVING employees_count > 38
ORDER BY 2) a;

/* Same result as above but different query */
SELECT
	department
FROM employees
GROUP BY department
HAVING COUNT(employee_id) > 38
ORDER BY COUNT(employee_id);

/* Same result as above but different query */
SELECT department
FROM employees e1
WHERE 38 < (SELECT COUNT(*)
FROM employees e2
WHERE e2.department = e1.department)
GROUP BY department;

/* Highest paid employees salary for each one of the departments */
SELECT
	department,
    MAX(salary)
FROM employees
GROUP BY department
ORDER BY 2 DESC;

/* Department vs Highest paid employee name vs Salary vs Wording that says "Highest / Lowest" */
SELECT
	department, salary, first_name, "HIGHEST SALARY"
FROM employees e1
WHERE salary = (SELECT MAX(salary) from employees e2 where e1.department = e2.department)
UNION
SELECT
	department, salary, first_name, "LOWEST SALARY"
FROM employees e1
WHERE salary = (SELECT MIN(salary) from employees e2 where e1.department = e2.department)
ORDER BY department, salary DESC;

/* Same result as above but different query */
SELECT department, first_name, salary,
CASE WHEN salary = max_by_department THEN 'HIGHEST SALARY'
	WHEN salary = min_by_department THEN 'LOWEST SALARY'
END as salary_in_department
FROM (
	SELECT department, first_name, salary,
		(SELECT MAX(salary) FROM employees e2
        WHERE e1.department = e2.department) AS max_by_department,
        (SELECT MIN(salary) FROM employees e2
        WHERE e1.department = e2.department) AS min_by_department
	FROM employees e1
    ) a
WHERE salary = max_by_department
		OR salary = min_by_department
ORDER BY department, salary DESC;

SELECT first_name from employees WHERE department = 'Sports' and salary = 165660;

SELECT
	DISTINCT department
FROM employees
WHERE department NOT IN (
	SELECT department FROM departments);

SELECT
	DISTINCT e.department, d.department
FROM employees e
LEFT JOIN departments d
ON e.department = d.department
WHERE d.department IS NULL;

SELECT
	DISTINCT e.department, d.department
FROM employees e
RIGHT JOIN departments d
ON e.department = d.department
WHERE e.department IS NULL;

SELECT DISTINCT department
FROM employees
UNION
SELECT DISTINCT department
FROM departments;

SELECT DISTINCT e.department, d.department
FROM employees e
LEFT OUTER JOIN departments d
ON e.department = d.department;

SELECT
	department,
    COUNT(*)
FROM employees
GROUP BY 1
UNION
SELECT
	"TOTAL",
    COUNT(*)
FROM employees;

SELECT * FROM regions;

/* First employee hired in the company and the last employee hired in the company */
SELECT * FROM
	(SELECT first_name, department, hire_date,
		(SELECT country FROM regions r where r.region_id = e.region_id) as country
    FROM employees e ORDER BY hire_date DESC LIMIT 1) a
UNION
SELECT * FROM
	(SELECT first_name, department, hire_date,
		(SELECT country FROM regions r where r.region_id = e.region_id)
    FROM employees e ORDER BY hire_date LIMIT 1) b;

/* Same result as above, different query */
(SELECT first_name, department, hire_date, country
FROM employees e JOIN regions r
ON e.region_id = r.region_id
WHERE hire_date = (SELECT MIN(hire_date) from employees)
LIMIT 1)
UNION
SELECT first_name, department, hire_date, country
FROM employees e JOIN regions r
ON e.region_id = r.region_id
WHERE hire_date = (SELECT MAX(hire_date) from employees);

/* Report that shows how the spending for salary budget every 90-day period starting with the starting date
of the first employee to the last employee */
SELECT
	hire_date,
    salary,
    (SELECT SUM(salary) FROM employees e2 where e2.hire_date BETWEEN e1.hire_date - 90 and e1.hire_date) as spending_pattern
FROM employees e1
ORDER BY 3 DESC;

SELECT
	DISTINCT s.student_name, c.course_no, c.course_title, t.last_name
FROM students s
JOIN student_enrollment se ON s.student_no = se.student_no
JOIN courses c ON se.course_no = c.course_no
JOIN teach t ON t.course_no = se.course_no
ORDER BY 1;

SELECT student_name, course_no, course_title, min(last_name) FROM 
(SELECT
	DISTINCT s.student_name, c.course_no, c.course_title, t.last_name
FROM students s
JOIN student_enrollment se ON s.student_no = se.student_no
JOIN courses c ON se.course_no = c.course_no
JOIN teach t ON t.course_no = se.course_no
ORDER BY 1) a
GROUP BY 1, 2, 3
ORDER BY 1;

select * from employees;

SELECT
	department,
    AVG(salary)
FROM employees
GROUP BY department;

SELECT first_name
FROM employees e1
WHERE salary >= (SELECT AVG(salary) FROM employees e2
		WHERE e2.department = e1.department);

SELECT * FROM students;
SELECT * from student_enrollment;
SELECT * FROM professors;
SELECT * from courses;
SELECT * from teach;


SELECT student_no FROM students
WHERE student_no not in (SELECT student_no FROM student_enrollment
	WHERE course_no = 'CS180');

SELECT student_no FROM students
WHERE student_no not in (SELECT student_no FROM student_enrollment
	WHERE course_no IN ('CS110', 'CS107'));