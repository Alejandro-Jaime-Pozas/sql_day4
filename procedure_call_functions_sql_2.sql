SELECT *
FROM customer c 
WHERE loyalty_member = TRUE;

-- reset all member to loyalty = false 
UPDATE customer 
SET loyalty_member = FALSE;



-- Create a Procedure that will set customers who have spent > 100 to loyalty members

-- subquery
UPDATE customer 
SET loyalty_member = TRUE 
WHERE customer_id IN (
	SELECT customer_id 
	FROM payment 
	GROUP BY customer_id 
	HAVING sum(amount) >= 100 -- remember HAVING IS LIKE a FILTER WITHIN the GROUP BY FILTER....
);


-- put into procedure 
CREATE OR REPLACE PROCEDURE update_loyalty_status()
LANGUAGE plpgsql
AS $$
BEGIN 
	UPDATE customer 
	SET loyalty_member = TRUE 
	WHERE customer_id IN (
		SELECT customer_id 
		FROM payment 
		GROUP BY customer_id 
		HAVING sum(amount) >= 100
	);	
END;
$$;


--EXECUTE a PROCEDURE - we use CALL 
CALL update_loyalty_status(); 

SELECT *
FROM customer 
WHERE loyalty_member = TRUE AND customer_id = 554;


-- find customers who are close to becoming loyalty (almost over $100)
SELECT customer_id, sum(amount)
FROM payment p 
GROUP BY customer_id 
HAVING sum(amount) BETWEEN 95 AND 100;

-- push one of the customers over the threshold
INSERT INTO payment(customer_id, staff_id, rental_id, amount, payment_date)
VALUES (554, 1, 1, 5.99, '2022-08-11 14:23:00'); -- date format (yyyy-mm-dd hh:mm:ss)

SELECT *
FROM customer c 
WHERE customer_id = 554;

--CALL the PROCEDURE 
CALL update_loyalty_status();


-- Create a procedure that takes in arguments
CREATE OR REPLACE PROCEDURE add_actor(first_name varchar, last_name varchar) -- you can leave varchar wo parentheses, it DEFAULTS TO needed length
LANGUAGE plpgsql
AS $$
BEGIN 
	INSERT INTO actor(first_name, last_name, last_update)
	VALUES ('Tom', 'Cruise', now()); -- now() RETURNS an UPDATE datetime 
END;
$$;


-- Add an actor to our table
CALL add_actor ('Tom', 'Cruise');

SELECT * 
FROM actor a
WHERE last_name = 'Cruise';


CALL add_actor ('Tom', 'Hanks');

SELECT * 
FROM actor a
WHERE last_name = 'Hanks';






