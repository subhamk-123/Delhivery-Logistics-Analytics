\# SQL Analysis: Delhivery Logistics Analytics



\## Overview

This folder contains the SQL scripts used to prepare, transform, and analyse Delhivery logistics data for the \*\*Delhivery Logistics Performance \& Route Efficiency Intelligence\*\* project.



The analysis focuses on identifying delivery routes and route types that may warrant operational investigation by comparing actual transit time with OSRM-estimated transit time.



\## Business Problem

Which parts of the delivery network should management prioritise for operational investigation, based on differences between actual and OSRM-estimated transit times?



\## Objectives

\- Prepare the raw dataset for analysis.

\- Create a consistent subjourney-level analytical dataset.

\- Calculate actual time, estimated time, time gap, and efficiency ratio.

\- Compare performance across route types and corridors.

\- Identify high-priority routes for further investigation.



\## Data Source

\- \*\*Raw file:\*\* `data/delhivery\_data.csv`

\- \*\*Prepared export:\*\* `data/delhivery\_subjourney\_performance.csv`

\- \*\*Database:\*\* MySQL 8.0



\## Key Metrics



| Metric | Definition |

|---|---|

| Actual Time | Observed transit time in minutes |

| Estimated Time | OSRM-estimated transit time in minutes |

| Time Gap | Actual time − estimated time |

| Efficiency Ratio | Actual time ÷ estimated time |

| Cumulative Time Gap | Sum of time gaps across subjourneys |



A positive time gap means the observed time exceeded the OSRM estimate. These metrics indicate differences from the estimate, not necessarily confirmed delivery delays or their causes.



\## Analysis Workflow

1\. Filter invalid or unusable time observations.

2\. Prepare the subjourney-level analytical view.

3\. Calculate performance metrics.

4\. Compare route types and source-destination corridors.

5\. Identify routes for further investigation.

6\. Export the analytical dataset for Tableau visualisation.



\## SQL Files

Place the SQL scripts in this folder and list their actual filenames below.



01\_database\_setup.sql



02\_data\_profiling.sql



03\_data\_cleaning.sql



04\_kpi\_analysis.sql



05\_time\_series.sql



06\_route\_analysis.sql



07\_root\_cause\_analysis.sql



08\_final\_analysis.sql



\## Key Findings

The analysis contains 26,368 subjourney records across 14,817 distinct trips in the prepared dataset. Several corridors exhibit substantial positive time gaps and may warrant further investigation.



The findings are exploratory and should not be interpreted as proof of route inefficiency or its underlying causes.



\## Tools Used

\- MySQL 8.0

\- SQL: filtering, aggregation, joins or window functions where applicable

\- Tableau: visualisation and dashboard development



\## Limitations

\- Results depend on the selected subjourney representation and available historical observations.

\- Time gaps do not establish the cause of a performance difference.

\- Large cumulative gaps can be influenced by corridor volume.

\- The dataset does not, by itself, establish financial loss or operational causality.



\## Next Steps

Use the prepared analytical dataset to explore route-level patterns in Tableau and develop evidence-based priorities for operational investigation.

