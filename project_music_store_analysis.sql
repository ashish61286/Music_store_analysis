/* Q1: Who is the senior most employee based on the job title */

SELECT first_name,last_name, title
FROM employee
ORDER BY levels DESC
limit 1;

/* Q2: Which countries have the most Invoices? */
select billing_country, count(*) as total_invoice
from invoice
group by billing_country
order by count(*) DESC;

/* Q3: What are top 3 values of total invoice? */
select total
from invoice
order by total DESC
limit 3;

/* Q4: Which city has the best customers? We would like to throw a promotional
Music Festival in the city we made the most money. Write a query that returns
one city that has the highest sum of invoice totals. Return both the city 
name & sum of all invoice totals */
select billing_city as city, sum(total) as total_invoice
from invoice
group by billing_city
order by total_invoice desc
limit 1;

/* Q5: Who is the best customer? The customer who has spent the most money 
will be declared the best customer. Write a query that returns the person 
who has spent the most money.*/
select first_name, last_name, sum(total) as total_money_spent
from customer c
join invoice i
on c.customer_id = i.customer_id
group by first_name, last_name
order by total_money_spent desc
limit 1;

/* Q6: Write query to return the first name, last name, email & Genre of all
Rock Music listeners. Return your list ordered alphabetically by email 
starting with A. */
SELECT Distinct first_name, last_name, email, G.name as genre_name
FROM customer C
JOIN invoice I
ON C.customer_id = I.customer_id
JOIN invoice_line IL
ON I.invoice_id = IL.invoice_id
JOIN track T
ON IL.track_id = T.track_id
JOIN genre G
ON T.genre_id = G.genre_id
WHERE G.name = 'Rock'
ORDER BY C.email;

/* Q7: Let's invite the artists who have written the most rock music in our
dataset. Write a query that returns the Artist name and total track count of
the top 10 rock bands. */
select  a1.name, count(*) as total_track
from artist as a1
join album as a2
on a1.artist_id = a2.artist_id
JOIN track as t
ON a2.album_id = t.album_id
JOIN genre as g
ON t.genre_id = g.genre_id
where g.name = 'Rock'
group by a1.name
order by total_track desc
limit 10;

/* Q8: Return all the track names that have a song length longer than the
average song length. Return the Name and Milliseconds for each track. 
Order by the song length with the longest songs listed first. */
select name, milliseconds as track_length 
from track 
where milliseconds > ( 
	select avg(milliseconds) as avg_track_length 
	from track) 
order by milliseconds desc;

/* Q9: Find how much amount spent by each customer on artists? Write a 
query to return customer name, artist name and total spent */
select concat(first_name,'',last_name) as customer_name, 
a.name as artist_name, sum(total) total_spent
from customer c
JOIN invoice i
ON c.customer_id = i.customer_id
JOIN invoice_line il
ON i.invoice_id = il.invoice_id
JOIN track t
ON il.track_id = t.track_id
JOIN album AL
ON t.album_id = al.album_id
JOIN artist a
ON al.artist_id = a.artist_id
group by customer_name, artist_name
order by total_spent desc;

/* Q10: Write a query that determines the customer that has spent the most
on music for each country. Write a query that returns the country along with
the top customer and how much they spent. For countries where the top amount
spent is shared, provide all customers who spent this amount. */
WITH CTE as (
select (i.billing_country) as country, concat(c.first_name,c.last_name) cust_name, sum(i.total) total_spent,
dense_rank() over(partition by I.billing_country order by sum(I.total) desc)ran
from customer c
join invoice i
on c.customer_id = i.customer_id
group by i.billing_country,c.first_name,c.last_name
)

select country, cust_name, total_spent
from CTE
where ran = 1;



