CREATE DATABASE PROJECT_1;
USE PROJECT_1;

SHOW TABLES;

SELECT * FROM album;

SELECT * FROM album2;

SELECT * FROM artist;

SELECT * FROM customer;

SELECT * FROM employee;

SELECT * FROM genre;

SELECT * FROM invoice;

SELECT * FROM invoice_line;

SELECT * FROM media_type;

SELECT * FROM playlist;

SELECT * FROM playlist_track;

SELECT * FROM track;

# I NEED TO EXAMINE THE DATASET WITH SQL TO HELP THE STORE UNDERSTAND IT'S BUSINESS GROWTH BY ANSWERING NECESSARY QUESTIONS.

# QUESTIONS TO SOLVE 

#Q1: WHO IS THE SENIOR MOST EMPLOYEE BASED ON JOB TITLE?
SELECT first_name, last_name, levels,title
FROM employee
ORDER BY levels DESC
LIMIT 1;

#Q2: WHICH COUNTRIES HAVE THE MOST INVOICES?
SELECT COUNT(invoice_id), billing_country
FROM invoice
GROUP BY billing_country
ORDER BY COUNT(invoice_id) DESC
LIMIT 5;

#Q3: WHAT ARE TOP 3 VALUES OF TOTAL INVOICE?
SELECT total
FROM invoice
ORDER BY total DESC
LIMIT 3;

#Q4: WHICH CITY HAS THE BEST CUSTOMERS? WE WOULD LIKE TO THROW A PROMOTIONAL MUSIC FESTIVAL IN THAT CITY.
#WRITE A QUERY THAT RETURNS ONE CITY THAT HAS THE HIGHEST SUM OF INVOICE TOTAL.
# RETURN BOTH THE CITY NAME & SUM OF ALL INVOICE TOTALS.
SELECT SUM(total),billing_city
FROM invoice
GROUP BY billing_city
ORDER BY SUM(total) DESC
LIMIT 1;

#Q5: WHO IS THE BEST CUSTOMER? THE CUSTOMER WHO HAS SPENT THE MOST MONEY WILL BE DECLARED THE BEST CUSTOMER
# WRITE A QUERY THAT RETURNS THE PERSON WHO HAS SPENT THE MOST MONEY?
SELECT customer.customer_id, customer.first_name, customer.last_name, SUM(invoice.total) AS total
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name
ORDER BY total DESC
LIMIT 1;

#Q6: WRITE QUERY TO RETURN THE EMAIL, FIRST NAME, LAST NAME, & GENRE OF ALL ROCK MUSIC LISTENERS. 
#RETURN YOUR LIST ORDER ALPHABETICALLY BY EMAIL STARTING WITH A. 
SELECT * FROM genre;
# JOIN GENRE_ID
SELECT * FROM track;
# JOIN TARCK_ID
SELECT * FROM invoice_line;
# JOIN invoice_id
SELECT * FROM invoice;
# JOIN customer_id
SELECT * FROM customer;

SELECT DISTINCT customer.email,customer.first_name,customer.last_name
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN(
  SELECT track_id 
  FROM track
  JOIN genre ON track.genre_id = genre.genre_id
  WHERE genre.name LIKE "Rock")
  ORDER BY customer.email;

#Q7 LET'S INVITE THE ARTISTS WHO HAVE WRITTEN THE MOST ROCK MUSIC IN OUR DATASET.
# WRITE A QUERY THAT RETURNS THE ARTIST NAME AND TOTAL TRACK COUNT OF THE TOP 10 ROCK BANDS
SELECT * FROM artist;
# JOIN ALBUM (artist_id)
SELECT * FROM album;
# JOIN TRACK (album_id)
SELECT * FROM track;
# JOIN genre (genre_id)
SELECT * FROM genre;

SELECT artist.name,artist.artist_id,COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE "Rock"
GROUP BY artist.name,artist.artist_id
ORDER BY number_of_songs DESC
LIMIT 10;

#Q8 RETURN ALL THE TRACK NAMES THAT HAVE A SONG LENGTH LONGER THAN THE AVERAGE SONG LENGTH. 
#RETURN THE NAME AND MILLISECONGS FOR EACH TRACK. 
#ORDER BY THE SONG LENTHG WITH THE LONGEST SONGS LISTED FIRST. 
SELECT track.name,track.milliseconds
FROM track
WHERE track.milliseconds > (
   SELECT AVG(milliseconds)AS avg_track_length
   FROM track)
ORDER BY milliseconds DESC;

#Q9 FIND HOW MUCH AMOUNT SPENT BY EACH CUSTOMER ON ARTISTS? 
# WRITE A QUERY TO RETURN CUSTOMER NAME, AERTIST NAME AND TOTAL SPENT. 
WITH best_selling_artist AS (
SELECT artist.artist_id,artist.name,
	   SUM(invoice_line.unit_price * invoice_line.quantity) AS total_sales
FROM invoice_line
JOIN track ON track.track_id = invoice_line.track_id
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
GROUP BY artist.artist_id,artist.name
ORDER BY total_sales DESC
LIMIT 1
)

SELECT customer.customer_id,customer.first_name,customer.last_name,best_selling_artist.name,
SUM(invoice_line.unit_price * invoice_line.quantity) AS amount_spent
FROM invoice
JOIN customer ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
JOIN track ON track.track_id = invoice_line.track_id
JOIN album ON album.album_id = track.album_id
JOIN best_selling_artist ON best_selling_artist.artist_id = album.artist_id
GROUP BY customer.customer_id,customer.first_name,customer.last_name,best_selling_artist.name
ORDER BY amount_spent DESC;

















