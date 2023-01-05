select * from routes;
/* Implementing the check constraint for the flight number and unique constraint for the route_id fields.*/
alter table routes
ADD CHECK (flight_num >1),
add unique (route_id);

/*Constraint to ensure that the distance miles field is not null and greater than 0*/
alter table routes
modify column distance_miles int not null;

alter table routes
ADD CHECK (distance_miles >0);

/*query to display all the passengers (customers) who have travelled in routes 01 to 25. Taking data  from the passengers_on_flights table.*/
select * from passengers_on_flights
where route_id between 1 and 5;

/*query to identify the number of passengers and total revenue in business class from the ticket_details table*/
select count(customer_id), sum(price_per_ticket) as total_revenue_for_business_class from ticket_details
where class_id = 'Bussiness';

/*query to display the full name of the customer by extracting the first name and last name from the customer table*/
select concat(first_name, '', last_name) as full_name from customer_table;

/*query to extract the customers who have registered and booked a ticket. Use data from the customer and ticket_details tables*/
select customer_table.customer_id, customer_table.first_name, customer_table.last_name, ticket_details.no_of_tickets
from customer_table 
inner join ticket_details on customer_table.customer_id = ticket_details.customer_id
where ticket_details.no_of_tickets >= 1;

/*query to identify the customer’s first name and last name based on their customer ID and brand (Emirates) from the ticket_details table*/
select ticket_details.customer_id, customer_table.first_name, customer_table.last_name, ticket_details.class_id
from ticket_details
inner join customer_table on ticket_details.customer_id = customer_table.customer_id;

/*query to identify the customers who have travelled by Economy Plus class using Group By and Having clause on the passengers_on_flights table.*/
select customer_id, count(travel_date) as no_of_tickets, class_id from passengers_on_flights
group by customer_id
having class_id = "Economy Plus";

/*query to identify whether the revenue has crossed 10000 using the IF clause on the ticket_details table*/
DELIMITER $$
Create procedure Revenuecheck
( out Message varchar (100))
begin
declare sum_of_revenue int default 0;
select sum(price_per_ticket) into sum_of_revenue from ticket_details where price_per_ticket is not null;
if sum_of_revenue<10000
then
	set Message = 'Insufficient Revenue';
else 
set Message = 'Revenue has exceeded 10000';
END IF;
END $$
DELIMITER ;

CALL revenuecheck(@message);
select @message;
 
 /*query to create and grant access to a new user to perform operations on a database*/
CREATE USER 'new_user_Jireh'@'localhost'
IDENTIFIED BY 'user_password';

GRANT ALL PRIVILEGES 
ON *.* 
TO new_user_Jireh@localhost;
 
/*query to find the maximum ticket price for each class using window functions on the ticket_details table*/
select class_id, price_per_ticket, max(price_per_ticket) over (partition by class_id) as max_price from ticket_details;

/*query to extract the passengers whose route ID is 4 by improving the speed and performance of the passengers_on_flights table*/
select customer_id, seat_num, travel_date, route_id from passengers_on_flights
where 
route_id = 4;

/*For the route ID 4, write a query to view the execution plan of the passengers_on_flights table.*/
explain
select customer_id, seat_num, travel_date, route_id from passengers_on_flights
where 
route_id = 4;

/*A query to calculate the total price of all tickets booked by a customer across different aircraft IDs using rollup function*/
select customer_id, aircraft_id, sum(price_per_ticket) as total_price from ticket_details
group by
aircraft_id,
customer_id
with rollup;

/* a query to create a view with only business class customers along with the brand of airlines.*/
create view Bus_Class_Customers as 
select customer_id, class_id, brand from 
ticket_details
where class_id = "Bussiness";

select * from Bus_Class_Customers;


/*a query to create a stored procedure that extracts all the details from the routes table where the travelled distance is more than 2000 miles*/

DELIMITER $$
 CREATE PROCEDURE routedetails (distanceinmiles int)
       BEGIN
         select distance_miles from routes where distance_miles>2000 into distanceinmiles;
       END$$
       call routedetails(@distanceinmiles);
       
  
  DELIMITER $$
Create procedure Distancecheck
( out Message varchar (100))
begin
declare distancetraveled int default 0;
select distance_miles into distancetraveled from routes where distance_miles is not null;
if distancetraveled >=0 <= 2000
then
	set Message = 'Insufficient Revenue';
END IF;
END $$
DELIMITER ;
  call distancecheck (@message);