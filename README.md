# SQL Database Programming — TinyU

A portfolio version of IST 659 Problem Set 7 covering stored procedures, scalar and table-valued functions, views, and triggers in Microsoft SQL Server.

## Contents

| File | Topic |
| --- | --- |
| [`sql/01_upsert_major.sql`](sql/01_upsert_major.sql) | Insert or update a major by its business key; includes the CSC and FIN assignment examples. |
| [`sql/02_concat_and_student_view.sql`](sql/02_concat_and_student_view.sql) | Reusable string function and a student view that uses it. |
| [`sql/03_search_majors.sql`](sql/03_search_majors.sql) | Split major names into keywords and search with an inline table-valued function. |
| [`sql/04_student_status_trigger.sql`](sql/04_student_status_trigger.sql) | Add student status fields, synchronize status from the inactive date, and demonstrate deactivation/reactivation. |
| [`docs/design-notes.md`](docs/design-notes.md) | Design choices, improvements over the submitted script, and execution assumptions. |
| [`docs/verification-notes.md`](docs/verification-notes.md) | What is and is not verified for this package. |

## Run order

Connect to the course TinyU database in SQL Server Management Studio or Azure Data Studio, then execute scripts 01 through 04 in order. Each script selects `TinyU` explicitly and uses `GO` batch separators. Script 04 changes the `students` rows for Graduate students when its example updates run; run it only against a disposable/course TinyU copy if you do not want those example changes retained.

## Scope

These examples target the course TinyU schema and SQL Server features. They are not portable as-is to PostgreSQL, MySQL, or SQLite. The original SQL Server database and screenshots were not available in this workspace, so database execution results are not claimed.
