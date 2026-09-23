USE TinyU;
GO

-- One output row per token found in each major name.
SELECT m.major_id,
       m.major_code,
       m.major_name,
       words.value AS keyword
FROM dbo.majors AS m
CROSS APPLY STRING_SPLIT(m.major_name, ' ') AS words;
GO

DROP FUNCTION IF EXISTS dbo.f_search_majors;
GO

CREATE FUNCTION dbo.f_search_majors
(
    @keyword varchar(100)
)
RETURNS TABLE
AS
RETURN
(
    SELECT m.major_id,
           m.major_code,
           m.major_name
    FROM dbo.majors AS m
    CROSS APPLY STRING_SPLIT(m.major_name, ' ') AS words
    WHERE words.value = @keyword
);
GO

SELECT major_id, major_code, major_name
FROM dbo.f_search_majors('Science')
ORDER BY major_code;
GO
