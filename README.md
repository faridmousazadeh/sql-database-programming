# SQL Server Database Programming — TinyU

## Overview

This repository presents SQL Server database-programming coursework from IST 659 Problem Set 7. The TinyU exercises demonstrate stored procedures, scalar functions, inline table-valued functions, views, and triggers.

These are course database-programming exercises, not a deployed application.

## Course

**IST 659 — Data Administration Concepts and Database Management**  
Syracuse University

## Objectives

- Create a parameterized procedure that updates an existing major by `major_code` or inserts a new major.
- Define a scalar function for name concatenation and use it in a student view.
- Search major names by keyword with an inline table-valued function.
- Derive student active status from the presence or absence of an inactive date with a trigger.

## Technical Skills

- SQL Server / T-SQL
- Stored procedures and parameters
- Scalar functions and inline table-valued functions
- Views and DML triggers
- DDL and DML
- `IF EXISTS`, `UPDATE`, and `INSERT`
- `COALESCE` and `MAX`
- `STRING_SPLIT` with `CROSS APPLY`
- `LEFT JOIN` and `CASE`
- The `inserted` pseudo-table
- Conditional schema changes with `COL_LENGTH`
- `GO` batch separators and `SET NOCOUNT ON`

## Database Programming Concepts

The scripts use the course `TinyU` database and `dbo` schema. They demonstrate reusable database objects and trigger logic that synchronizes a stored status value with a date field.

## Procedures, Functions, Views, and Triggers

| File | Database object | Demonstrated behavior |
| --- | --- | --- |
| [`sql/01_upsert_major.sql`](sql/01_upsert_major.sql) | `dbo.p_upsert_major` procedure | Accepts parameters, updates an existing major by `major_code`, or inserts a new major using `COALESCE(MAX(major_id), 0) + 1`. Includes CSC and FIN examples. |
| [`sql/02_concat_and_student_view.sql`](sql/02_concat_and_student_view.sql) | `dbo.f_concat` scalar function and `dbo.v_students` view | Concatenates name strings and presents student information with a `LEFT JOIN` to majors. As documented in the design notes, NULL input to the function produces NULL under the described SQL Server behavior. |
| [`sql/03_search_majors.sql`](sql/03_search_majors.sql) | `dbo.f_search_majors` inline table-valued function | Uses `STRING_SPLIT` and `CROSS APPLY` to search major names for a keyword parameter. |
| [`sql/04_student_status_trigger.sql`](sql/04_student_status_trigger.sql) | `dbo.trg_student_active` `AFTER INSERT, UPDATE` trigger | Uses the `inserted` pseudo-table and set-based logic to derive `student_active` from `student_inactive_date`. Includes demonstration updates to Graduate rows. |

## Key SQL Techniques

- Parameterized stored procedures and functions
- Conditional insert-or-update logic with `IF EXISTS`
- Manual ID allocation with `COALESCE(MAX(major_id), 0) + 1`
- String concatenation in a scalar function
- `LEFT JOIN` for student and major information
- Keyword tokenization with `STRING_SPLIT` and `CROSS APPLY`
- Conditional column creation using `COL_LENGTH`
- Trigger logic using `CASE`, `CROSS APPLY (VALUES...)`, and `inserted`
- Set-based handling of inserted or updated rows

## Project Structure

```text
sql-database-programming/
├── README.md
├── .gitignore
├── docs/
│   ├── design-notes.md
│   └── verification-notes.md
└── sql/
    ├── 01_upsert_major.sql
    ├── 02_concat_and_student_view.sql
    ├── 03_search_majors.sql
    └── 04_student_status_trigger.sql
```

## Execution Context

Connect to the course TinyU database in SQL Server Management Studio or Azure Data Studio. Each script selects `TinyU` and uses `GO` batch separators.

The scripts modify database objects and/or data:

- Script 01 drops and recreates `dbo.p_upsert_major`; its examples can update existing CSC/FIN rows or insert them.
- Script 02 drops and recreates `dbo.f_concat` and `dbo.v_students`.
- Script 03 drops and recreates `dbo.f_search_majors`.
- Script 04 may add columns to `dbo.students`, drops and recreates the trigger, and updates Graduate rows to demonstrate deactivation and reactivation.

Use a disposable or course database copy when appropriate. Script 04's example updates apply to all Graduate rows in the target TinyU database.

## Source Integrity and Provenance

The repository presents the Problem Set 7 work as a portfolio version, but it does not include a separate original-submission copy of the SQL. The design and verification notes document the intended behavior and assumptions. The published SQL therefore cannot be directly compared against the submitted source.

## Relationship to Transaction-Safe Procedures and Triggers

This repository demonstrates the database-programming concepts from Problem Set 7. The later [SQL Transaction-Safe Procedures and Triggers](https://github.com/faridmousazadeh/sql-transaction-safe-procedures-triggers) repository builds on related TinyU functionality with transaction handling, error handling, row-count checks, and concurrency-oriented safeguards.

Both repositories contain a procedure named `dbo.p_upsert_major`. Running the later version in the same TinyU database replaces the earlier procedure definition. The projects remain separate because they demonstrate different stages and capabilities. The later repository's design notes also document a remaining race risk in its manual `MAX(major_id) + 1` allocation approach.

## Verification / Limitations

The TinyU database is not included. The repository contains no runtime execution logs, screenshots, or query outputs. The verification notes state that the scripts were not executed in the audit workspace because the course database was unavailable. No performance improvement, measured result, or empirically verified correctness is claimed.

The `MAX(major_id) + 1` manual ID-allocation approach can produce a race condition when concurrent insertions occur. This script does not present that approach as concurrency-safe.

## Key Takeaways

The coursework demonstrates how SQL Server procedures, functions, views, and triggers can encapsulate data operations, reusable expressions, keyword searches, and status synchronization.

## Course Context

This repository presents TinyU database-programming coursework from **IST 659 — Data Administration Concepts and Database Management**, Problem Set 7.
