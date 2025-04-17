USE sakila;

-- 1. 
SELECT DISTINCT
title
FROM
film;

-- 2.
SELECT
title
FROM film
WHERE rating = 'PG-13'; 

-- 3.
SELECT
title,
description
FROM
film
WHERE description LIKE '%amazing%';

-- 4.
SELECT
title
FROM
film
WHERE length > 120;

-- 5. 
SELECT 
first_name,
last_name
FROM
actor
ORDER BY last_name;

-- 6.
SELECT
first_name,
last_name
FROM actor
WHERE last_name = 'Gibson';

-- 7.
SELECT
first_name,
last_name
FROM actor
WHERE actor_id BETWEEN 10 AND 20
ORDER BY last_name;

-- 8.
SELECT
title
FROM
film
WHERE rating <> 'R' AND rating <> 'PG-13';

-- 9.
SELECT
rating,
COUNT(title) AS total_films
FROM film
GROUP BY
rating;

-- 10.
SELECT
customer.customer_id,
customer.first_name,
customer.last_name,
COUNT(rental.rental_id) AS total_rentals
FROM customer
LEFT JOIN rental -- aunque no tenga rental quiero sacarlo
ON customer.customer_id = rental.customer_id
GROUP BY customer.customer_id,
customer.first_name,
customer.last_name;

-- 11. 
-- revisar
SELECT
category.name,
COUNT(film_category.film_id) AS total_films
FROM category
LEFT JOIN film_category -- aunque la categoria no tenga peliculas quiero verlo
ON category.category_id = film_category.category_id
GROUP BY category.name;

SELECT
category.name,
COUNT(rental_id) AS total_rentals
FROM category
INNER JOIN film_category ON category.category_id = film_category.category_id
INNER JOIN inventory ON film_category.film_id = inventory.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY category.name;


-- 12.
SELECT
rating,
ROUND(AVG(length), 0) AS avg_length
FROM
film
GROUP BY rating;

-- 13.
SELECT
actor.first_name,
actor.last_name
FROM actor 
INNER JOIN (
	SELECT
    film_actor.actor_id
    FROM film_actor
	INNER JOIN film ON film_actor.film_id = film.film_id
	WHERE film.title = 'Indian Love') t1
ON actor.actor_id = t1.actor_id
ORDER BY last_name;
    
-- 14.
SELECT
title,
description
FROM
film
WHERE description LIKE '%dog%' OR description LIKE '%cat%';

-- 15.
SELECT
title
FROM
film
WHERE release_year BETWEEN 2005 AND 2010;

-- 16.
SELECT
film.title
FROM film
INNER JOIN film_category ON film.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
WHERE name = 'Family';

-- 17.
SELECT
title
FROM
film
WHERE rating = 'R' AND length > 120;

-- EXTRAS

-- 18. 
SELECT
actor.first_name,
actor.last_name
FROM actor
INNER JOIN film_actor
ON actor.actor_id = film_actor.actor_id
GROUP BY actor.actor_id, actor.first_name, actor.last_name
HAVING COUNT(film_actor.actor_id) > 10
ORDER BY actor.last_name;

-- 19.
SELECT DISTINCT
actor.first_name,
actor.last_name
FROM actor
LEFT JOIN film_actor
ON actor.actor_id = film_actor.actor_id
WHERE actor.actor_id NOT IN (
	SELECT
    actor_id
    FROM film_actor)
ORDER BY actor.last_name;

-- 20.
SELECT
category.name,
ROUND(AVG(film.length), 0) AS avg_length
FROM category
INNER JOIN film_category ON category.category_id = film_category.category_id
INNER JOIN film ON film_category.film_id = film.film_id
WHERE  film.length > 120
GROUP BY category.name;

-- 21.
SELECT
actor.first_name,
actor.last_name,
COUNT(film_actor.actor_id) AS total_films
FROM actor
INNER JOIN film_actor
ON actor.actor_id = film_actor.actor_id
GROUP BY actor.first_name, actor.last_name
HAVING total_films >= 5
ORDER BY actor.last_name;

-- 22.
SELECT DISTINCT
film.title
FROM film
INNER JOIN 
	(SELECT
	rental.rental_id,
    film.film_id
	FROM rental
	INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
	INNER JOIN film ON inventory.film_id = film.film_id
	WHERE rental_duration > 5) t1
ON film.film_id = t1.film_id;

-- 23.
SELECT
first_name,
last_name
FROM actor
WHERE actor_id NOT IN (
	SELECT DISTINCT
	actor.actor_id
	FROM actor
	INNER JOIN film_actor ON actor.actor_id = film_actor.film_id
	INNER JOIN film_category ON film_actor.film_id = film_category.film_id
	INNER JOIN category ON film_category.category_id = category.category_id
	WHERE category.name = 'Horror')
ORDER BY last_name;

-- 24.
SELECT
film.title
FROM film
INNER JOIN film_category ON film.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
WHERE length > 180 AND category.name= 'Comedy';
    
-- 25.
SELECT
actor1.first_name AS first_name1,
actor1.last_name AS last_name1,
actor2.first_name AS first_name2,
actor2.last_name AS last_name2,
t1.common_films
FROM (
	SELECT
	film_actor1.actor_id AS actor_id1,
	film_actor2.actor_id AS actor_id2,
	COUNT(*) AS common_films -- cada fila del resultado del join representa una película compartida entre dos actores entonces cuento el numero de filas creadas
	FROM film_actor film_actor1
	JOIN film_actor film_actor2
	ON film_actor1.film_id = film_actor2.film_id
	WHERE film_actor1.actor_id < film_actor2.actor_id -- evito duplicados tipo (1, 2) (2, 1), con <> sí salen
	GROUP BY film_actor1.actor_id, film_actor2.actor_id) t1
INNER JOIN actor actor1 ON t1.actor_id1 = actor1.actor_id
INNER JOIN actor actor2 ON t1.actor_id2 = actor2.actor_id;

