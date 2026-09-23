# Design notes

## Major upsert

`major_code` is treated as the business key, matching the prompt. For a new code, the procedure assigns one greater than the current maximum `major_id`; `COALESCE` also handles an empty `majors` table. The assignment material does not establish a transaction or concurrency strategy. If concurrent writers are possible, two sessions could calculate the same next ID; the later Problem Set 8 transaction-safe pattern is the appropriate next step for that concern.

## Student names and view

The scalar `f_concat` function demonstrates combining two strings with a one-character separator. The view calls it twice to display first-last and last-first names. A `LEFT JOIN` keeps a student visible even if its major reference is absent or NULL; if TinyU enforces the relationship as mandatory, this returns the same student set as an inner join.

With SQL Server's normal NULL concatenation behavior, `f_concat` returns NULL if either input is NULL. The assignment does not specify an alternate NULL policy.

## Keyword search

`STRING_SPLIT` plus `CROSS APPLY` emits one row per token. The inline table-valued function reuses that expression to return majors containing the requested token. Matching follows the database collation (for example, case sensitivity depends on that collation).

## Student status trigger

The trigger is set-based, so it handles multi-row updates. It derives `student_active` from whether `student_inactive_date` is present, including inserted rows, and updates only rows whose status is out of sync. The demonstration then deactivates and reactivates Graduate students as required by the assignment.

The example intentionally uses the assignment's fixed date. The UPDATE statements affect all TinyU Graduate rows when run; inspect the target database before running if it contains other work.
