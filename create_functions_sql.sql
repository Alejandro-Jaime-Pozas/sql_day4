SELECT count(*)
FROM actor a 
WHERE last_name LIKE 'S%';

SELECT count(*)
FROM actor a 
WHERE last_name LIKE 'R%';


-- Create a stored fn  - give us the count of actors w a last name that begins w *letter*
-- this is the format to create fn in postgresql

CREATE OR REPLACE FUNCTION get_actor_count(letter varchar(1))
RETURNS integer
LANGUAGE plpgsql
AS $$
	DECLARE actor_count integer;
BEGIN 
	SELECT count(*) INTO actor_count
	FROM actor
	WHERE last_name ILIKE concat(letter, '%');
	RETURN actor_count;
END;
$$;


-- execute the new fn

SELECT get_actor_count('k')


-- create a fn that will tell us which employee had most rentals

SELECT staff_id 
FROM rental r 
GROUP BY staff_id 
ORDER BY count(*) DESC
LIMIT 1;


SELECT concat(first_name, ' ', last_name) as employee
FROM staff s 
WHERE staff_id = (
	SELECT staff_id 
	FROM rental r 
	GROUP BY staff_id 
	ORDER BY count(*) DESC
	LIMIT 1
);

-- FUCNTION START*************
CREATE OR REPLACE FUNCTION employee_with_most_transactions()
RETURNS varchar
LANGUAGE plpgsql
AS $$
	DECLARE employee varchar;
BEGIN 
	SELECT concat(first_name, ' ', last_name) INTO employee -- CHANGE THIS from normally AS to >>> INTO
	FROM staff s 
	WHERE staff_id = (
		SELECT staff_id 
		FROM rental 
		GROUP BY staff_id 
		ORDER BY count(*) DESC
		LIMIT 1
	);
	RETURN employee;
END;
$$;
-- FUNCTION END***************


SELECT employee_with_most_transactions();

SELECT * FROM rental r ;
SELECT * FROM payment p ;


-- Fns can all return Tables
-- create a fn that will return a table w customers (first and last) and their
-- full address (address, city, disctrict, country) by searching a country name 

SELECT c.first_name, c.last_name, a.address, ci.city, a.district, co.country
FROM customer c 
JOIN address a 
ON c.address_id = a.address_id 
JOIN city ci 
ON ci.city_id  = a.city_id 
JOIN country co 
ON co.country_id = ci.country_id 
WHERE co.country = 'China';


-- FUNCTION START*********
CREATE OR REPLACE FUNCTION customers_in_country(country_name varchar(50))
RETURNS TABLE (
	first_name varchar,
	last_name varchar,
	address varchar,
	city varchar,
	district varchar,
	country varchar
)
LANGUAGE plpgsql
AS $$
BEGIN 
	RETURN QUERY -- RETURN query IS used TO RETURN a TABLE within the fn
	SELECT c.first_name, c.last_name, a.address, ci.city, a.district, co.country
	FROM customer c 
	JOIN address a 
	ON c.address_id = a.address_id 
	JOIN city ci 
	ON ci.city_id  = a.city_id 
	JOIN country co 
	ON co.country_id = ci.country_id 
	WHERE co.country ILIKE country_name;
END;
$$;
-- FUNCTION END************

SELECT * 
FROM customers_in_country('china');  

SELECT * 
FROM customers_in_country('united states')
WHERE district = 'California';


-- to remove a fn use >>> DROP FUNCTION fn_name;





