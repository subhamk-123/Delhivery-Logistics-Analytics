# Limitations and Assumptions

1. The dataset is historical and may not represent current operations.
2. A difference from an OSRM estimate is not necessarily a contractual delay.
3. The subjourney-selection rule may not represent the full duration of a journey.
4. Extreme values may reflect genuine variation, data quality issues, or
   source timestamp semantics.
5. Ratios can become very large when estimated times are small.
6. Averages are sensitive to outliers and small sample sizes.
7. The analysis does not prove causes such as congestion, weather, or hub delays.
8. The analysis does not estimate financial loss.
9. Check the dataset's terms before redistributing source data.

## Future improvements
- Validate time semantics against source documentation.
- Add outlier flags and minimum sample-size thresholds.
- Use medians and percentiles alongside averages.
- Add contextual data and verified delivery outcomes.
- Validate results with operational subject-matter experts.
