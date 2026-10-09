\# Delhivery Logistics Analytics



\## 1. Company Context



Delhivery is an Indian logistics and supply-chain company operating across services such as express parcel delivery, freight, warehousing, and supply-chain solutions.



For a logistics business, delivery performance depends on factors such as route characteristics, distance, transportation conditions, and the time required to move shipments between locations.



This project uses publicly available Delhivery logistics data to perform a business analytics case study focused on delivery efficiency and operational prioritization.



> \*\*Important:\*\* This is an external analytical case study based on publicly available data. It does not represent Delhivery's internal operational data or current management decisions.



\---



\## 2. Business Problem



A logistics network can experience differences between the time expected for a journey and the time actually taken.



However, looking only at overall average delivery time does not tell management:



\* Which routes are consistently inefficient?

\* Which locations experience greater delays?

\* Which inefficient routes also handle significant volumes?

\* Are inefficiencies persistent or concentrated in particular periods?

\* Which areas should be investigated first?



The business problem is therefore to identify and understand \*\*where delivery inefficiency is concentrated and which parts of the network should receive greater operational attention.\*\*



\---



\## 3. Business Objective



The objective of this analysis is to use logistics data to:



1\. Measure overall delivery performance.

2\. Compare actual travel time with expected travel time.

3\. Identify routes and locations associated with higher inefficiency.

4\. Examine whether poor performance is persistent over time.

5\. Combine operational inefficiency with route volume to identify priority areas.

6\. Translate the findings into a management-oriented dashboard and decision framework.



\---



\## 4. Stakeholder



\### Primary Stakeholder



\*\*Operations Management\*\*



The analysis is designed to support managers responsible for understanding and improving logistics-network performance.



\### Secondary Stakeholders



\* Network planning teams

\* Transportation/route management teams

\* Business analysts

\* Supply-chain decision makers



\---



\## 5. Analytical Scope



The analysis will focus on:



\* Delivery/trip performance

\* Source and destination locations

\* Route characteristics

\* Actual versus expected travel time

\* Distance

\* Route volume

\* Performance trends over time

\* Persistent underperformance



The project will not attempt to determine the financial impact of individual operational decisions because the publicly available dataset does not provide complete internal cost, revenue, staffing, or customer-level information.



\---



\## 6. Key Business Questions



\### Q1. Overall Performance



How is delivery performance distributed across the available logistics records?



\### Q2. Route Efficiency



Which routes have the largest difference between actual and expected travel time?



\### Q3. Volume + Inefficiency



Which routes combine relatively high activity with poor delivery efficiency?



\### Q4. Location Patterns



Are particular source or destination locations associated with higher inefficiency?



\### Q5. Time Patterns



Are inefficiencies persistent over time or concentrated in specific periods?



\### Q6. Management Prioritization



Which routes or operational segments should be prioritized for further investigation based on measurable performance indicators?



\---



\## 7. Initial KPI Framework



\### Actual Travel Time



The observed time taken for a journey.



\### Expected Travel Time



The estimated travel time available in the dataset.



\### Time Gap



\*\*Time Gap = Actual Travel Time − Expected Travel Time\*\*



A positive value indicates that the journey took longer than expected.



\### Efficiency Ratio



\*\*Efficiency Ratio = Actual Travel Time ÷ Expected Travel Time\*\*



Interpretation:



\* Ratio < 1 → actual time was lower than expected

\* Ratio = 1 → actual time matched expected time

\* Ratio > 1 → actual time exceeded expected time



\### Route Volume



Number of trips/records associated with a route after establishing the correct analytical grain.



> The exact definition of a "trip" will be established during data profiling because the raw dataset may contain multiple records associated with the same `trip\_uuid`.



\---



\## 8. Analytical Approach



The project will follow this sequence:



\*\*Data Understanding → Data Quality → Data Cleaning → SQL Analysis → Performance Analysis → Root-Cause Exploration → Business Prioritization → Power BI Dashboard\*\*



SQL will be used as the primary analytical tool.



Power BI will subsequently be used to communicate the final findings through an interactive management dashboard.



\---



\## 9. Assumptions and Limitations



1\. The analysis uses publicly available logistics data rather than Delhivery's internal operational database.

2\. The dataset's exact analytical grain must be established before calculating trip-level KPIs.

3\. Actual and expected travel times are treated according to the definitions provided by the dataset.

4\. Relationships discovered in the data will not automatically be interpreted as causal relationships.

5\. The analysis cannot account for internal factors such as driver availability, vehicle allocation, operational costs, weather, traffic incidents, or customer-specific constraints unless such variables are present in the dataset.

6\. Recommendations will be based only on patterns supported by the available data.



\---



\## 10. Expected Business Output



The final project will produce:



\* A cleaned analytical dataset

\* SQL-based performance analysis

\* Route and location-level efficiency analysis

\* Identification of priority areas for investigation

\* Tableau management dashboard

\* A concise business story connecting findings to operational decisions



