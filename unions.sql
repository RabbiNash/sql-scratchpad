/*Construct an out result set such as
c0l1,col2
5 , 'something'
*/

--query one: outputs a table, one row and one column
select 5 as Column1
		, 'Hello' as Column2

Union --the two generated tables with both queries are union compatible they have the same header
	  -- same order and types for each columns
select 10, 'World'
 
Union
SELECT 30 , NULL