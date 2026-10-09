# Findings and Recommendations

## Key findings

### 1. Positive time gaps are common
25,916 of 26,368 selected subjourney observations had positive time gaps
(approximately 98.29%). This is a signal for validation, not proof that
98.29% of deliveries were late.

### 2. Some corridors show high cumulative gaps

| Corridor | Count | Average gap (min) | Cumulative gap (min) |
|---|---:|---:|---:|
| Gurgaon -> Bangalore | 66 | 1,387.21 | 91,556 |
| Bangalore -> Gurgaon | 44 | 1,271.14 | 55,930 |
| Gurgaon -> Kolkata | 48 | 1,155.31 | 55,455 |
| Guwahati -> Delhi | 17 | 2,047.18 | 34,802 |
| Gurgaon -> Hyderabad | 29 | 1,139.59 | 33,048 |

These corridors are candidates for investigation, not confirmed bottlenecks.

### 3. Route types differ by metric

| Route type | Subjourneys | Average gap (min) | Average ratio |
|---|---:|---:|---:|
| FTL | 13,939 | 157.81 | 2.27 |
| Carting | 12,429 | 55.89 | 2.86 |

FTL has the larger average absolute gap, while Carting has the higher
relative ratio. Both metrics should be considered together.

## Recommendations
1. Validate high-gap corridors against current operational records.
2. Review absolute gaps, relative ratios, and observation counts together.
3. Investigate extreme observations and verify timestamps and units.
4. Compare FTL and Carting within their operational context.
5. Add hub handling time, shipment outcomes, traffic, weather, and route
   characteristics where available.
6. Monitor trends consistently over time before taking action.
7. Do not translate cumulative time gaps into financial loss without
   validated cost data and a defensible method.

## Conclusion
The project uses SQL and Tableau to turn historical logistics observations
into a prioritization framework. Its value is identifying where further
investigation may be useful, not proving causes or financial savings.

## Scope note
A time gap is the difference between recorded actual time and an
OSRM-estimated time. It is not, by itself, proof of a realized delay,
root cause, or financial loss.
