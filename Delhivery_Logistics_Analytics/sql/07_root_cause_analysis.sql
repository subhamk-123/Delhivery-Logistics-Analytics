USE delhivery_analytics;

SELECT
    route_type,

    COUNT(*) AS subjourney_volume,

    ROUND(AVG(time_gap_minutes), 2) AS avg_time_gap_minutes,

    ROUND(AVG(efficiency_ratio), 2) AS avg_efficiency_ratio,

    MIN(time_gap_minutes) AS min_time_gap_minutes,

    MAX(time_gap_minutes) AS max_time_gap_minutes

FROM delhivery_subjourney_performance

GROUP BY route_type

ORDER BY avg_time_gap_minutes DESC;

-- PURPOSE: Examine whether longer subjourneys are associated with larger actual-vs-expected time gaps.

USE delhivery_analytics;

SELECT
    CASE
        WHEN starting_distance < 50 THEN 'Under 50 km'
        WHEN starting_distance < 100 THEN '50–99 km'
        WHEN starting_distance < 250 THEN '100–249 km'
        WHEN starting_distance < 500 THEN '250–499 km'
        ELSE '500+ km'
    END AS distance_band,

    COUNT(*) AS subjourney_volume,

    ROUND(AVG(starting_distance), 2) AS avg_distance_km,

    ROUND(AVG(time_gap_minutes), 2) AS avg_time_gap_minutes,

    ROUND(AVG(efficiency_ratio), 2) AS avg_efficiency_ratio

FROM delhivery_subjourney_performance

GROUP BY
    CASE
        WHEN starting_distance < 50 THEN 'Under 50 km'
        WHEN starting_distance < 100 THEN '50–99 km'
        WHEN starting_distance < 250 THEN '100–249 km'
        WHEN starting_distance < 500 THEN '250–499 km'
        ELSE '500+ km'
    END

ORDER BY
    MIN(starting_distance);
    
-- PURPOSE: Examine distance-related performance separately for each route type.

USE delhivery_analytics;

SELECT
    route_type,

    CASE
        WHEN starting_distance < 50 THEN 'Under 50 km'
        WHEN starting_distance < 100 THEN '50–99 km'
        WHEN starting_distance < 250 THEN '100–249 km'
        WHEN starting_distance < 500 THEN '250–499 km'
        ELSE '500+ km'
    END AS distance_band,

    COUNT(*) AS subjourney_volume,

    ROUND(AVG(time_gap_minutes), 2) AS avg_time_gap_minutes,

    ROUND(AVG(efficiency_ratio), 2) AS avg_efficiency_ratio

FROM delhivery_subjourney_performance

GROUP BY
    route_type,
    CASE
        WHEN starting_distance < 50 THEN 'Under 50 km'
        WHEN starting_distance < 100 THEN '50–99 km'
        WHEN starting_distance < 250 THEN '100–249 km'
        WHEN starting_distance < 500 THEN '250–499 km'
        ELSE '500+ km'
    END

ORDER BY
    route_type,
    MIN(starting_distance);
    
    
-- PURPOSE: Identify route corridors with sufficient volume and measure their average performance.

USE delhivery_analytics;

SELECT
    source_name,
    destination_name,

    COUNT(*) AS subjourney_volume,

    ROUND(AVG(starting_distance), 2) AS avg_distance_km,

    ROUND(AVG(time_gap_minutes), 2) AS avg_time_gap_minutes,

    ROUND(AVG(efficiency_ratio), 2) AS avg_efficiency_ratio,

    MIN(time_gap_minutes) AS min_time_gap_minutes,

    MAX(time_gap_minutes) AS max_time_gap_minutes

FROM delhivery_subjourney_performance

GROUP BY
    source_name,
    destination_name

HAVING COUNT(*) >= 10

ORDER BY
    avg_time_gap_minutes DESC

LIMIT 20;

USE delhivery_analytics;

SELECT
    route_type,
    source_name,
    destination_name,

    COUNT(*) AS subjourney_volume,

    ROUND(AVG(starting_distance), 2) AS avg_distance_km,

    ROUND(AVG(time_gap_minutes), 2) AS avg_time_gap_minutes,

    ROUND(
        AVG(
            time_gap_minutes / NULLIF(starting_distance, 0) * 100
        ),
        2
    ) AS avg_gap_per_100km,

    ROUND(AVG(efficiency_ratio), 2) AS avg_efficiency_ratio

FROM delhivery_subjourney_performance

GROUP BY
    route_type,
    source_name,
    destination_name

HAVING COUNT(*) >= 10

ORDER BY
    avg_gap_per_100km DESC

LIMIT 20;

-- PURPOSE: Compare actual and expected time across distance bands to determine what is driving the extreme efficiency ratios.

USE delhivery_analytics;

SELECT
    CASE
        WHEN starting_distance < 50 THEN 'Under 50 km'
        WHEN starting_distance < 100 THEN '50–99 km'
        WHEN starting_distance < 250 THEN '100–249 km'
        WHEN starting_distance < 500 THEN '250–499 km'
        ELSE '500+ km'
    END AS distance_band,

    COUNT(*) AS subjourney_volume,

    ROUND(AVG(actual_time_minutes), 2) AS avg_actual_time_minutes,

    ROUND(AVG(expected_time_minutes), 2) AS avg_expected_time_minutes,

    ROUND(AVG(time_gap_minutes), 2) AS avg_time_gap_minutes,

    ROUND(AVG(efficiency_ratio), 2) AS avg_efficiency_ratio

FROM delhivery_subjourney_performance

GROUP BY
    CASE
        WHEN starting_distance < 50 THEN 'Under 50 km'
        WHEN starting_distance < 100 THEN '50–99 km'
        WHEN starting_distance < 250 THEN '100–249 km'
        WHEN starting_distance < 500 THEN '250–499 km'
        ELSE '500+ km'
    END

ORDER BY
    MIN(starting_distance);