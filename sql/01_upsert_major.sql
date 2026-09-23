USE TinyU;
GO

-- Upsert a major using major_code as the business key.
-- The assignment schema uses major_id as a manually assigned key.
DROP PROCEDURE IF EXISTS dbo.p_upsert_major;
GO

CREATE PROCEDURE dbo.p_upsert_major
    @major_code varchar(10),
    @major_name varchar(100)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.majors
        WHERE major_code = @major_code
    )
    BEGIN
        UPDATE dbo.majors
        SET major_name = @major_name
        WHERE major_code = @major_code;
    END
    ELSE
    BEGIN
        DECLARE @next_major_id int;

        SELECT @next_major_id = COALESCE(MAX(major_id), 0) + 1
        FROM dbo.majors;

        INSERT INTO dbo.majors (major_id, major_code, major_name)
        VALUES (@next_major_id, @major_code, @major_name);
    END;
END;
GO

-- Assignment demonstration: inspect the two target codes before and after.
SELECT major_id, major_code, major_name
FROM dbo.majors
WHERE major_code IN ('CSC', 'FIN');
GO

EXEC dbo.p_upsert_major
    @major_code = 'CSC',
    @major_name = 'Computer Science';

EXEC dbo.p_upsert_major
    @major_code = 'FIN',
    @major_name = 'Finance';
GO

SELECT major_id, major_code, major_name
FROM dbo.majors
WHERE major_code IN ('CSC', 'FIN')
ORDER BY major_code;
GO
