USE delhivery_analytics;

SELECT
    DATE_FORMAT(observation_start_time, '%Y-%m') AS month,

    COUNT(*) AS subjourney_volume,

    ROUND(AVG(time_gap_minutes), 2) AS avg_time_gap_minutes,

    ROUND(AVG(efficiency_ratio), 2) AS avg_efficiency_ratio,

    SUM(time_gap_minutes > 0) AS slower_than_expected,

    ROUND(
        100 * SUM(time_gap_minutes > 0) / COUNT(*),
        2
    ) AS pct_slower_than_expected

FROM delhivery_subjourney_performance

GROUP BY
    DATE_FORMAT(observation_start_time, '%Y-%m')

ORDER BY month;