# Delhivery Logistics Performance & Route Efficiency Intelligence

## Overview
A logistics analytics portfolio project using MySQL and Tableau to
identify subjourneys and corridors that may deserve operational investigation.

**Business question:** Which parts of the delivery network should
management prioritize for operational investigation, and why?

## Tools
- MySQL 8.0 and MySQL Workbench
- SQL for data profiling, cleaning, and analysis
- Tableau for KPI cards and performance visualizations
- CSV for transferring the analytical view to Tableau

## Workflow
1. Profile the raw dataset.
2. Clean invalid time observations.
3. Build a subjourney-level analytical view.
4. Calculate time gaps and actual-to-estimated time ratios.
5. Analyze route types, sources, and corridors.
6. Visualize the results in Tableau.
7. Document findings, recommendations, and limitations.

## Selected results
- Clean observations: 142,502
- Distinct trips: 14,817
- Analytical subjourneys: 26,368
- Positive time gaps: 25,916 of 26,368
- FTL average gap: approximately 157.81 minutes
- Carting average gap: approximately 55.89 minutes

These figures reflect the project's selected data preparation and
subjourney representation. Validate them against the final SQL outputs.

## Metrics
- Time gap = actual journey time - OSRM-estimated journey time.
- Efficiency ratio = actual journey time / OSRM-estimated journey time.
- Cumulative gap = sum of time gaps; it is not a monetary loss estimate.

## Key takeaway
The dashboard helps prioritize routes for further investigation.
It does not prove the cause of a time gap or establish that a delivery was late.

## Repository structure
```text
Delhivery_Logistics_Analytics/
├── README.md
├── data/
├── documentation/
├── screenshots/
├── sql/
└── tableau/
```

## Scope note
This is an independent historical-data portfolio case study, not an
analysis of Delhivery's current internal operations. Check the dataset
licence before redistributing source data.
