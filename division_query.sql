SELECT	* --put whichever columns you need here
FROM Customers AS Cu
WHERE NOT EXISTS
(
	SELECT	*
	FROM	Products AS Pr
	WHERE	
			Pr.Colour = 'Grey' -- Constraints on each table can also 
			AND NOT EXISTS		-- be integrated in the division query canvas
			(
				SELECT	*
				FROM	Purchase as Pu
				WHERE
						Pu.ProductId = Pr.ProductId
						AND Pu.CustomerId = Cu.CustomerId
						AND Pu.Quantity >= 2 -- Same here
			)
)