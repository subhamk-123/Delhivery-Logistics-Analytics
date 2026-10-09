USE delhivery_analytics;

SELECT
    source_name,
    destination_name,

    COUNT(*) AS subjourney_volume,

    ROUND(AVG(starting_distance), 2) AS avg_distance_km,

    ROUND(AVG(time_gap_minutes), 2) AS avg_time_gap_minutes,

    ROUND(SUM(time_gap_minutes), 2) AS total_gap_minutes,

    ROUND(AVG(efficiency_ratio), 2) AS avg_efficiency_ratio

FROM delhivery_subjourney_performance

-- PURPOSE: Determine whether high-gap corridors are consistently underperforming or driven by extreme observations.

USE delhivery_analytics;

WITH ranked_gaps AS (
    SELECT
        p.source_name,
        p.destination_name,
        p.time_gap_minutes,

        ROW_NUMBER() OVER (
            PARTITION BY p.source_name, p.destination_name
            ORDER BY p.time_gap_minutes
        ) AS gap_asc,

        COUNT(*) OVER (
            PARTITION BY p.source_name, p.destination_name
        ) AS route_volume

    FROM delhivery_subjourney_performance AS p
),

route_medians AS (
    SELECT
        rg.source_name,
        rg.destination_name,
        rg.route_volume,

        AVG(rg.time_gap_minutes) AS median_gap_minutes

    FROM ranked_gaps AS rg

    WHERE rg.gap_asc IN (
        FLOOR((rg.route_volume + 1) / 2),
        CEIL((rg.route_volume + 1) / 2)
    )

    GROUP BY
        rg.source_name,
        rg.destination_name,
        rg.route_volume
)

SELECT
    rm.source_name,
    rm.destination_name,
    rm.route_volume,

    ROUND(rm.median_gap_minutes, 2) AS median_gap_minutes,

    ROUND(AVG(p.time_gap_minutes), 2) AS avg_gap_minutes,

    ROUND(MAX(p.time_gap_minutes), 2) AS max_gap_minutes

FROM route_medians AS rm

JOIN delhivery_subjourney_performance AS p
    ON rm.source_name = p.source_name
    AND rm.destination_name = p.destination_name

WHERE rm.route_volume >= 10

GROUP BY
    rm.source_name,
    rm.destination_name,
    rm.route_volume,
    rm.median_gap_minutes

ORDER BY
    avg_gap_minutes DESC

LIMIT 25;


USE delhivery_analytics;

SELECT
    source_name,
    destination_name,

    COUNT(*) AS subjourney_volume,

    ROUND(AVG(starting_distance), 2) AS avg_distance_km,

    ROUND(AVG(actual_time_minutes), 2) AS avg_actual_time_minutes,

    ROUND(AVG(expected_time_minutes), 2) AS avg_expected_time_minutes,

    ROUND(AVG(time_gap_minutes), 2) AS avg_time_gap_minutes,

    ROUND(AVG(efficiency_ratio), 2) AS avg_efficiency_ratio

FROM delhivery_subjourney_performance

GROUP BY
    source_name,
    destination_name

HAVING COUNT(*) >= 10

ORDER BY
    avg_efficiency_ratio DESC

LIMIT 25;

USE delhivery_analytics;

SELECT
    CASE
        WHEN expected_time_minutes < 10 THEN 'Under 10 min'
        WHEN expected_time_minutes < 20 THEN '10–19 min'
        WHEN expected_time_minutes < 30 THEN '20–29 min'
        WHEN expected_time_minutes < 45 THEN '30–44 min'
        WHEN expected_time_minutes < 60 THEN '45–59 min'
        ELSE '60+ min'
    END AS expected_time_band,

    COUNT(*) AS subjourney_volume,

    ROUND(AVG(starting_distance), 2) AS avg_distance_km,

    ROUND(AVG(actual_time_minutes), 2) AS avg_actual_time_minutes,

    ROUND(AVG(expected_time_minutes), 2) AS avg_expected_time_minutes,

    ROUND(AVG(time_gap_minutes), 2) AS avg_time_gap_minutes,

    ROUND(AVG(efficiency_ratio), 2) AS avg_efficiency_ratio

FROM delhivery_subjourney_performance

WHERE starting_distance < 50

GROUP BY
    CASE
        WHEN expected_time_minutes < 10 THEN 'Under 10 min'
        WHEN expected_time_minutes < 20 THEN '10–19 min'
        WHEN expected_time_minutes < 30 THEN '20–29 min'
        WHEN expected_time_minutes < 45 THEN '30–44 min'
        WHEN expected_time_minutes < 60 THEN '45–59 min'
        ELSE '60+ min'
    END

ORDER BY
    MIN(expected_time_minutes);
    
    -- PURPOSE: Check the efficiency-ratio distribution before using it as a dashboard KPI.

USE delhivery_analytics;

SELECT
    CASE
        WHEN efficiency_ratio < 1 THEN 'Below 1.0'
        WHEN efficiency_ratio < 1.5 THEN '1.0–1.49'
        WHEN efficiency_ratio < 2 THEN '1.5–1.99'
        WHEN efficiency_ratio < 3 THEN '2.0–2.99'
        WHEN efficiency_ratio < 5 THEN '3.0–4.99'
        WHEN efficiency_ratio < 10 THEN '5.0–9.99'
        ELSE '10+'
    END AS efficiency_band,

    COUNT(*) AS subjourney_volume,

    ROUND(AVG(time_gap_minutes), 2) AS avg_time_gap_minutes,

    ROUND(AVG(starting_distance), 2) AS avg_distance_km,

    ROUND(AVG(expected_time_minutes), 2) AS avg_expected_time_minutes

FROM delhivery_subjourney_performance

GROUP BY
    CASE
        WHEN efficiency_ratio < 1 THEN 'Below 1.0'
        WHEN efficiency_ratio < 1.5 THEN '1.0–1.49'
        WHEN efficiency_ratio < 2 THEN '1.5–1.99'
        WHEN efficiency_ratio < 3 THEN '2.0–2.99'
        WHEN efficiency_ratio < 5 THEN '3.0–4.99'
        WHEN efficiency_ratio < 10 THEN '5.0–9.99'
        ELSE '10+'
    END

ORDER BY
    MIN(efficiency_ratio);