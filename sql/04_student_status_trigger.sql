USE TinyU;
GO

-- Add the assignment columns only when they are not already present.
IF COL_LENGTH('dbo.students', 'student_active') IS NULL
BEGIN
    ALTER TABLE dbo.students
        ADD student_active char(1) NOT NULL
            CONSTRAINT DF_students_student_active DEFAULT ('Y') WITH VALUES;
END;
GO

IF COL_LENGTH('dbo.students', 'student_inactive_date') IS NULL
BEGIN
    ALTER TABLE dbo.students
        ADD student_inactive_date date NULL;
END;
GO

DROP TRIGGER IF EXISTS dbo.trg_student_active;
GO

CREATE TRIGGER dbo.trg_student_active
ON dbo.students
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Set-based for multi-row statements. The difference predicate prevents
    -- a nested trigger invocation from issuing another no-op update.
    UPDATE s
    SET student_active = expected.active_value
    FROM dbo.students AS s
    INNER JOIN inserted AS i
        ON i.student_id = s.student_id
    CROSS APPLY
    (
        VALUES (CASE WHEN s.student_inactive_date IS NULL THEN 'Y' ELSE 'N' END)
    ) AS expected(active_value)
    WHERE s.student_active <> expected.active_value;
END;
GO

-- Assignment demonstration: deactivate Graduate students and inspect results.
UPDATE dbo.students
SET student_inactive_date = '2020-08-01'
WHERE student_year_name = 'Graduate';
GO

SELECT student_id,
       student_firstname,
       student_lastname,
       student_year_name,
       student_active,
       student_inactive_date
FROM dbo.students
WHERE student_year_name = 'Graduate'
ORDER BY student_id;
GO

-- Assignment demonstration: reactivate Graduate students and inspect results.
UPDATE dbo.students
SET student_inactive_date = NULL
WHERE student_year_name = 'Graduate';
GO

SELECT student_id,
       student_firstname,
       student_lastname,
       student_year_name,
       student_active,
       student_inactive_date
FROM dbo.students
WHERE student_year_name = 'Graduate'
ORDER BY student_id;
GO
