/* non_usa_customers.sql: Provide a query showing Customers (just their full names, customer ID and country) who are not in the US.*/

SELECT c.FirstName, c.LastName, c.CustomerID, c.Country FROM Customer c WHERE  c.Country NOT IN ('USA');

/*brazil_customers.sql: Provide a query only showing the Customers from Brazil.*/

SELECT c.Firstname, c.LastName, c.CustomerID, c.Country FROM Customer c WHERE c.Country IN ('Brazil');

/*brazil_customers_invoices.sql: Provide a query showing the Invoices of customers who are from Brazil. The resultant table should show the customer's full name, Invoice ID, Date of the invoice and billing country.*/

SELECT c.country, i.invoicedate, i.invoiceid, c.firstname, c.lastname FROM Customer c LEFT JOIN Invoice i WHERE c.country IN ('Brazil');

/*sales_agents.sql: Provide a query showing only the Employees who are Sales Agents.*/

SELECT e.firstname, e.lastname FROM Employee e WHERE e.title IN ('Sales Support Agent');

/*unique_invoice_countries.sql: Provide a query showing a unique/distinct list of billing countries from the Invoice table.*/

SELECT * FROM Invoice i GROUP BY i.billingcountry;

/* sales_agent_invoices.sql: Provide a query that shows the invoices associated with each sales agent. The resultant table should include the Sales Agent's full name.*/

SELECT e.FirstName, e.LastName, i.InvoiceID FROM Invoice i LEFT JOIN Customer c ON  i.CustomerID = c.CustomerID LEFT JOIN Employee e ON c.SupportRepID = e.EmployeeID; 

/* invoice_totals.sql: Provide a query that shows the Invoice Total, Customer name, Country and Sale Agent name for all invoices and customers.*/

SELECT c.firstname, c.lastname, i.total, e.firstname as AgentFirstName, e.lastname as AgentLastName FROM Invoice i LEFT JOIN Customer c ON i.customerID = c.customerID LEFT JOIN Employee e ON c.supportrepid = e.employeeid;

/*total_invoices_{year}.sql: How many Invoices were there in 2009 and 2011?*/
	
SELECT strftime('%Y',i.InvoiceDate) AS "InvoiceYear", COUNT(i.invoiceid) AS Invoicesfrom2009 FROM Invoice i WHERE strftime('%Y',i.invoiceDate) IN ('2009', '2011');

/*total_sales_{year}.sql: What are the respective total sales for each of those years?*/

SELECT strftime('%Y',i.InvoiceDate) AS "InvoiceYear", COUNT(i.invoiceid) AS TotalInvoicesForYear FROM Invoice i WHERE strftime('%Y',i.invoiceDate) IN ('2009', '2011') GROUP BY "InvoiceYear";

/*invoice_37_line_item_count.sql: Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for Invoice ID 37.*/

SELECT i.invoiceID AS "InvoiceID", Count(i.InvoiceLineID) FROM InvoiceLine i WHERE i.invoiceID=37;

/*line_items_per_invoice.sql: Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for each Invoice. HINT: GROUP BY*/

SELECT i.invoiceID AS "InvoiceID", Count(i.InvoiceLineID) FROM InvoiceLine i GROUP BY i.invoiceID;

/*line_item_track.sql: Provide a query that includes the purchased track name with each invoice line item.*/

SELECT t.name, i.trackid, i.invoicelineid FROM InvoiceLine i LEFT JOIN Track t ON t.trackid=i.trackid;

/*line_item_track_artist.sql: Provide a query that includes the purchased track name AND artist name with each invoice line item.*/

SELECT t.name, i.invoicelineid, a.name  FROM InvoiceLine i LEFT JOIN Track t ON t.trackid=i.trackid LEFT JOIN Album m ON t.albumID = m.albumid LEFT JOIN Artist a ON m.artistid=a.artistid;

/*country_invoices.sql: Provide a query that shows the # of invoices per country. HINT: GROUP BY*/

SELECT i.billingcountry, COUNT(i.invoiceid) FROM Invoice i GROUP BY i.billingcountry;
SELECT c.country, COUNT(i.invoiceid) FROM Invoice i LEFT JOIN Customer c ON c.customerid =i.customerid GROUP BY c.country;

/*playlists_track_count.sql: Provide a query that shows the total number of tracks in each playlist. The Playlist name should be include on the resulant table.*/

SELECT y.name AS TrackCount, COUNT(p.trackid) FROM PlaylistTrack p LEFT JOIN Playlist y ON y.playlistid=p.playlistid GROUP BY y.name;

/*tracks_no_id.sql: Provide a query that shows all the Tracks, but displays no IDs. The result should include the Album name, Media type and Genre.*/

SELECT a.title AS AlbumTitle, m.name AS MediaType, g.name AS Genre FROM Track t LEFT JOIN Album a ON t.albumid=a.albumid LEFT JOIN MediaType m ON m.mediatypeid=t.mediatypeid LEFT JOIN GENRE g ON g.genreid=t.genreid;

/*invoices_line_item_count.sql: Provide a query that shows all Invoices but includes the # of invoice line items.*/
SELECT i.invoiceID, COUNT(l.invoicelineid) FROM Invoice i LEFT JOIN InvoiceLine l ON i.invoiceid=l.invoiceid GROUP BY i.invoiceID;

/*sales_agent_total_sales.sql: Provide a query that shows total sales made by each sales agent.*/
SELECT e.firstname, e.lastname, i.invoiceid AS TotalSales FROM Invoice i LEFT JOIN Customer c ON c.customerid=i.customerid LEFT JOIN Employee e ON c.supportrepid=e.employeeid GROUP BY e.firstname;

/*top_2009_agent.sql: Which sales agent made the most in sales in 2009?--Hint: Use the MAX function on a subquery.*/

SELECT e.firstname, e.lastname, MAX(TotalSale$) AS TopAgent2009
FROM (SELECT ROUND(SUM(i.total),2) AS TotalSale$ 
	FROM Invoice i, Customer c, Employee e
	WHERE strftime('%Y',i.InvoiceDate) IN ('2009')
	AND c.customerid=i.customerid 
	AND c.supportrepid=e.employeeid
	GROUP BY e.firstname), Employee e, Invoice i;

/* top_agent.sql: Which sales agent made the most in sales over all? SHOWS ALL AGENTS*/
SELECT e.firstname, e.lastname, ROUND(SUM(i.total),2) AS TotalSale$ 
FROM Invoice i 
LEFT JOIN Customer c ON c.customerid=i.customerid 
LEFT JOIN Employee e ON c.supportrepid=e.employeeid 
GROUP BY e.employeeid;
--ORDER BY TotalSale$ DESC LIMIT 1, will show max too

/* top_agent.sql: Which sales agent made the most in sales over all?*/
SELECT firstname, lastname, MAX(TotalSale$) AS OverallSale$
	FROM (SELECT e.firstname, e.lastname, ROUND(SUM(i.total),2) AS TotalSale$ 
	FROM Invoice i 
	LEFT JOIN Customer c ON c.customerid=i.customerid 
	LEFT JOIN Employee e ON c.supportrepid=e.employeeid 
	GROUP BY e.firstname);

/*sales_agent_customer_count.sql: Provide a query that shows the count of customers assigned to each sales agent.*/
SELECT e.firstname, e.lastname, COUNT(c.customerID) AS CustomerCount
FROM Customer c 
LEFT JOIN Employee e ON c.supportrepid=e.employeeid
GROUP BY e.firstname;

/*sales_per_country.sql: Provide a query that shows the total sales per country.*/
SELECT i.billingcountry AS BillingCountry, SUM(i.total) AS TotalSales
FROM Invoice i
GROUP BY i.billingcountry;

SELECT c.country AS CustomerCountry, SUM(i.total) AS TotalSales
FROM Invoice i
LEFT JOIN Customer c ON c.customerid=i.customerid
GROUP BY c.country;
--just realized billingcountry and customer's country are the same

/*top_country.sql: Which country's customers spent the most?*/
SELECT c.country AS CountrySales, SUM(i.total) AS TotalSales
FROM Invoice i
LEFT JOIN Customer c ON c.customerid=i.customerid
GROUP BY c.country
ORDER BY TotalSales DESC LIMIT 1;

top_2013_track.sql: Provide a query that shows the most purchased track of 2013.
SELECT t.name, t.trackid, Count(*) AS TimesPurchasedIn2013
FROM InvoiceLine l
LEFT JOIN Track t ON t.trackid=l.trackid
LEFT JOIN Invoice i ON l.invoiceid=i.invoiceid
WHERE strftime('%Y',i.InvoiceDate)='2013'
GROUP BY l.trackid
ORDER BY TimesPurchasedIn2013 DESC LIMIT 10;
--SUM(1)

/*top_5_tracks.sql: Provide a query that shows the top 5 most purchased tracks over all.*/
SELECT t.name, t.trackid, Count(*) AS TimesPurchasedSinceStartofDB
FROM InvoiceLine l
LEFT JOIN Track t ON t.trackid=l.trackid
LEFT JOIN Invoice i ON l.invoiceid=i.invoiceid
GROUP BY l.trackid
ORDER BY TimesPurchasedSinceStartofDB DESC LIMIT 5;

/*top_3_artists.sql: Provide a query that shows the top 3 best selling artists.*/
SELECT a.name AS Artist, Count(l.trackid) AS TracksSold, ROUND(SUM(l.unitprice),2) AS Sales
FROM Artist a
LEFT JOIN Album m ON a.artistid=m.artistid
LEFT JOIN Track t ON m.albumid=t.albumid
LEFT JOIN Invoiceline l ON t.trackid=l.trackid
GROUP BY a.name
ORDER BY Sales DESC LIMIT 3;

/*top_media_type.sql: Provide a query that shows the most purchased Media Type.*/
SELECT m.name AS MediaType, COUNT(l.trackid) AS TimesPurchased
FROM MediaType m
LEFT JOIN Track t ON m.mediatypeid=t.mediatypeid
LEFT JOIN InvoiceLine l ON t.trackid=l.trackid
GROUP BY m.name
ORDER BY TimesPurchased DESC LIMIT 5;