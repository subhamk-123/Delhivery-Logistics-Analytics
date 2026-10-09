# SQL Folder Guide

Use this as an index and adjust it to match the SQL files that actually
exist in your project.

1. `01_database_setup.sql` — create/select database and staging table.
2. `02_data_profiling.sql` — inspect fields, row counts, nulls, and duplicates.
3. `03_data_cleaning.sql` — apply validity filters and build the clean view.
4. `04_kpi_analysis.sql` — calculate summary metrics.
5. `05_time_analysis.sql` — inspect time distributions and comparisons.
6. `06_route_analysis.sql` — aggregate metrics by source, destination, and type.
7. `07_root_cause_analysis.sql` — exploratory checks, not proof of causation.
8. `08_final_analysis.sql` — final outputs used for reporting.

Keep only filenames that actually exist and ensure the order reflects
their dependencies. Never publish database passwords or credentials.
