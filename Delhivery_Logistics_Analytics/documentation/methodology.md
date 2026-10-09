# Methodology

## 1. Data profiling
The raw dataset was profiled in MySQL to inspect row counts, missing
values, duplicates, route categories, and time-related fields.

## 2. Cleaning
The analytical cleaning rule retained observations satisfying:

- `segment_actual_time >= 0`
- `segment_osrm_time > 0`

These conditions remove negative actual times and non-positive estimates.
They do not guarantee that every remaining record is operationally valid.

## 3. Subjourney representation
The project selected one observation per trip, source center, and
destination center using a row-numbering rule ordered by timestamp.

The resulting analysis contained 26,368 subjourney rows and 14,817
distinct trips. This is a modelling choice, not necessarily a complete
reconstruction of every journey.

## 4. Metrics
Time gap:

`actual_time_minutes - expected_time_minutes`

Efficiency ratio:

`actual_time_minutes / expected_time_minutes`

A positive gap means the recorded actual time exceeds the estimate.
Ratios can be inflated when estimated time is very small, so interpret
them alongside absolute gaps and sample sizes.

## 5. Visualization
Tableau was used to compare distinct trips, average time gaps, relative
time ratios, route types, source locations, and individual corridors.

## 6. Validation
- Verify the exported CSV contains the complete analytical result.
- Check the distinct trip count against SQL: expected 14,817.
- Confirm corridor labels contain both origin and destination.
- Review extreme gaps and small estimated-time denominators.
- Ensure titles distinguish average metrics from totals.
