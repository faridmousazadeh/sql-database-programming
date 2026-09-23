USE TinyU;
GO

-- Remove the dependent view first so the function can be recreated.
DROP VIEW IF EXISTS dbo.v_students;
GO

DROP FUNCTION IF EXISTS dbo.f_concat;
GO

CREATE FUNCTION dbo.f_concat
(
    @a varchar(100),
    @b varchar(100),
    @sep char(1)
)
RETURNS varchar(201)
AS
BEGIN
    -- Deliberately uses + so a NULL input produces NULL (SQL Server behavior).
    RETURN @a + @sep + @b;
END;
GO

SELECT dbo.f_concat('half', 'baked', '-') AS example_hyphen,
       dbo.f_concat('mike', 'fudge', ' ') AS example_space;
GO

CREATE VIEW dbo.v_students
AS
    SELECT s.student_id,
           dbo.f_concat(s.student_firstname, s.student_lastname, ' ') AS student_name,
           dbo.f_concat(s.student_lastname, ' ' + s.student_firstname, ',') AS student_name_last_first,
           s.student_gpa,
           m.major_name
    FROM dbo.students AS s
    LEFT JOIN dbo.majors AS m
        ON m.major_id = s.student_major_id;
GO

SELECT student_id,
       student_name,
       student_name_last_first,
       student_gpa,
       major_name
FROM dbo.v_students;
GO
