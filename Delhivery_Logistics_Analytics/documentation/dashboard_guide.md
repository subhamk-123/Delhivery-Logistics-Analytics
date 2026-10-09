# Tableau Dashboard Guide

## Suggested dashboard components
1. KPI: Total Unique Trips
2. KPI: Average Time Gap (Minutes)
3. KPI: Average Actual-to-Estimated Time Ratio
4. Average Time Gap by Route Type
5. Top Corridors by Average Time Gap
6. Average Time Gap by Source Location
7. A brief scope note explaining the metric.

## Suggested titles
- Total Unique Trips
- Average Time Gap (Minutes)
- Average Actual-to-Estimated Time Ratio
- Average Time Gap by Route Type
- Top Corridors by Average Time Gap
- Average Time Gap by Source Location

If the corridor chart uses `SUM(time_gap_minutes)`, title it
**Top Corridors by Cumulative Time Gap** instead.

## Publishing checklist
- Confirm Tableau uses the full CSV.
- Confirm `COUNTD(trip_uuid)` displays 14,817 for this project run.
- Check all charts for errors, clipped labels, and misleading titles.
- Save as a packaged Tableau workbook (`.twbx`) if appropriate.
- Export a readable dashboard image to the screenshots folder.
