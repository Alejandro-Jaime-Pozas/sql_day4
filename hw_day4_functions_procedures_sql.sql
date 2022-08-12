

--1. Create a Stored Procedure that will insert a new film into the film table with the
--following arguments: title, description, release_year, language_id, rental_duration,
--rental_rate, length, replace_cost, rating

SELECT * FROM film f ORDER BY film_id DESC ;

CREATE OR REPLACE PROCEDURE insert_film(
	title varchar, 
	description varchar, 
	release_year integer, 
	language_id integer, 
	rental_duration integer, 
	rental_rate numeric, 
	length integer, 
	replacement_cost numeric, 
	rating mpaa_rating 
	)
LANGUAGE plpgsql
AS $$
BEGIN 
	INSERT INTO film (
		title ,
		description ,
		release_year ,
		language_id ,
		rental_duration ,
		rental_rate ,
		length ,
		replacement_cost ,
		rating 
		)
	VALUES (
		title ,
		description ,
		release_year ,
		language_id ,
		rental_duration ,
		rental_rate ,
		length ,
		replacement_cost ,
		rating 
		);
END;
$$;

DROP PROCEDURE insert_film(character varying,character varying,integer,integer,integer,numeric,integer,numeric,character varying); 



CALL insert_film(
	'The Diving Bell and the Butterfly', 
	'xdescription',
	1990,
	1,
	3,
	2.99,
	120,
	9.99,
	'R' 
	);
















--2. Create a Stored Function that will take in a category_id and return the number of
--films in that category




SELECT *
FROM category c ;

SELECT * 
FROM film_category fc ;

SELECT c.category_id, name, count(*) AS num_films
FROM film_category fc 
JOIN category c 
ON c.category_id = fc.category_id 
--WHERE name ILIKE 'Sports'
GROUP BY c.category_id, name 
ORDER BY num_films DESC ;

----------------------------------------------

SELECT count(*)
FROM film_category fc 
WHERE category_id = 15
GROUP BY category_id ;



CREATE OR REPLACE FUNCTION get_num_films(desired_category integer)
RETURNS integer 
LANGUAGE plpgsql
AS $$ 
	DECLARE num_films integer;
BEGIN 
	SELECT count(*) INTO num_films
	FROM film_category fc 
	WHERE category_id = desired_category;
	RETURN num_films;
END;
$$;

DROP FUNCTION get_num_films(integer)


SELECT get_num_films(16);






