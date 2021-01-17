USE [A20-PlayDB-Nash]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER TRIGGER dbo.trg_SetStudentNumber 
   ON dbo.Student
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Local variables
	DECLARE @currentApplicationStatus int;
	DECLARE @cohortName nvarchar(100);
	DECLARE @lastSequenceNumberInt int;
	DECLARE @lastSequenceNumberStr nvarchar(100);

	DECLARE @newStudentNumber nvarchar(100);
	DECLARE @currentStudentNumber nvarchar(100);

	DECLARE @studentID int;


	--A trigger always fires, regardless which columns have been impacted



	--we must run our code iif applicationStatust is updated
	--Use of a poorly named T-SQL function... UPDATE :)
	--Test whether applicationstatus column has been updated by the update query firing the trigger

	--the systen variable (@@) @@NESTLEVEL (int) tells the count of recursive calls to the current functtion
	IF @@NESTLEVEL < 2
	BEGIN

		--Extra "protection": run the trigger if and only if more than one row is found in inserted
		DECLARE @rowCount int;
		SET @rowCount = (SELECT COUNT(*) FROM inserted)

		IF UPDATE(ApplicationStatus) AND @rowCount > 0
		BEGIN
			--target column has been updated carry on.

			-- Retrieving the value of application status from updated row in a local variable
			--  Datatypes must match

			--We could have multiple rows in inserted, we need to iterate over the rows in inserted with the cursor

			-- a cursor is a variable but has NO @ symbol in front of its name -- for iterating over the rows, the cursor needs to be shaped into a form taking
			--result from result set.
			DECLARE updatedStudentCursor CURSOR FOR -- FOR a result set
					SELECT StudentId, ApplicationStatus, StudentNumber, CohortName
					FROM inserted

		    -- it's at this point that the query attached to the cursor definition gets run, result of query loaded in memory
			OPEN updatedStudentCursor;
			-- The cursor is a pointer on a row
			-- Reading the first row
			-- FETCH reads a row pointed by the cursor and allows to bring the column values into local variables
			FETCH NEXT FROM updatedStudentCursor INTO 
							@studentId,
							@currentApplicationStatus,
							@currentStudentNumber,
							@cohortName;

			-- @FETCH_STATUS indicates whther the resultset is exhausted
			WHILE @@FETCH_STATUS = 0
			BEGIN

				--Row by row processiong of all the rows in inserted, refer to the cursor bound variables above

				IF @currentApplicationStatus = 4 AND @currentStudentNumber IS NULL

				/*SET @cohortName = (
									SELECT LTRIM(RTRIM(REPLACE(
										REPLACE(LOWER(Cohortname), 'autumn', ''), 'spring', '')))
									FROM inserted
									); */

					SET @cohortName = LOWER(@cohortName);
					SET @cohortName = REPLACE(@cohortName, 'autumn', '');
					SET @cohortName = REPLACE(@cohortName, 'spring', '');
					SET @cohortName = LTRIM(RTRIM(@cohortName));

				--Get the last sequence number for the value of @cohortYear
				SET @lastSequenceNumberInt = (
											select MAX( COALESCE( CAST(RIGHT(StudentNumber,3)as int), 0 )) + 1
											from Student
											where
											Cohortname like '%' + @cohortName
				);

				--means pad 00s to achieve three digits
				SET @lastSequenceNumberStr = FORMAT(@lastSequenceNumberInt, '00#');

				SET @newStudentNumber = CONCAT(@cohortName, @lastSequenceNumberStr)

				-- We modify the table data, a transaction should be open, in case fo a failure

				BEGIN TRANSACTION

				BEGIN TRY
					UPDATE Student
					Set StudentNumber = @newStudentNumber
					WHERE StudentId = @studentID

					-- if update is OK, we commit the update to the table
					COMMIT;
				END TRY
				BEGIN CATCH
					--Do not apply any changes to the table in case of exceptions
					ROLLBACK;
				END CATCH
			END

			-- DON"T FORGET TO READ (FETCH) THE NEXT ROW OF THE RESULTSET OTHERWISE YOUR WHILE LOOP WILL NOT FINISH: fetch next row
			FETCH NEXT FROM updatedStudentCursor INTO 
							@studentId,
							@currentApplicationStatus,
							@currentStudentNumber,
							@cohortName;
		END

		--HOUSE KEEPING
		CLOSE updatedStudentCursor;
		DEALLOCATE updatedStudentCursor;

	END
END

