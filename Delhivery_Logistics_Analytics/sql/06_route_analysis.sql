USE delhivery_analytics;

SELECT
    source_center,
    source_name,
    destination_center,
    destination_name,

    COUNT(*) AS subjourney_volume,

    ROUND(AVG(time_gap_minutes), 2) AS avg_time_gap_minutes,

    ROUND(AVG(efficiency_ratio), 2) AS avg_efficiency_ratio

FROM delhivery_subjourney_performance

GROUP BY
    source_center,
    source_name,
    destination_center,
    destination_name

ORDER BY avg_time_gap_minutes DESC
LIMIT 20;

-- PURPOSE: Measure consistency of route performance.
USE delhivery_analytics;

SELECT
    source_center,
    source_name,
    destination_center,
    destination_name,

    COUNT(*) AS subjourney_volume,

    ROUND(AVG(time_gap_minutes), 2) AS avg_time_gap_minutes,

    MIN(time_gap_minutes) AS min_time_gap_minutes,

    MAX(time_gap_minutes) AS max_time_gap_minutes,

    ROUND(AVG(efficiency_ratio), 2) AS avg_efficiency_ratio

FROM delhivery_subjourney_performance

GROUP BY
    source_center,
    source_name,
    destination_center,
    destination_name

HAVING COUNT(*) >= 5

ORDER BY avg_time_gap_minutes DESC
LIMIT 20;

USE delhivery_analytics;

WITH route_metrics AS (

    SELECT
        source_center,
        source_name,
        destination_center,
        destination_name,

        COUNT(*) AS subjourney_volume,

        ROUND(AVG(time_gap_minutes), 2) AS avg_time_gap_minutes,

        SUM(time_gap_minutes) AS total_gap_minutes,

        ROUND(AVG(efficiency_ratio), 2) AS avg_efficiency_ratio

    FROM delhivery_subjourney_performance

    GROUP BY
        source_center,
        source_name,
        destination_center,
        destination_name

    HAVING COUNT(*) >= 5
),

ranked_routes AS (

    SELECT
        *,
        RANK() OVER (
            ORDER BY subjourney_volume DESC
        ) AS volume_rank,

        RANK() OVER (
            ORDER BY avg_time_gap_minutes DESC
        ) AS avg_gap_rank,

        RANK() OVER (
            ORDER BY total_gap_minutes DESC
        ) AS total_gap_rank

    FROM route_metrics
)

SELECT
    source_name,
    destination_name,
    subjourney_volume,
    avg_time_gap_minutes,
    total_gap_minutes,
    avg_efficiency_ratio,
    volume_rank,
    avg_gap_rank,
    total_gap_rank

FROM ranked_routes

ORDER BY total_gap_rank

LIMIT 20;

-- PURPOSE: Measure whether corridor-level underperformance is persistent rather than driven by isolated observations.

USE delhivery_analytics;

SELECT
    source_name,
    destination_name,

    COUNT(*) AS subjourney_volume,

    ROUND(AVG(time_gap_minutes), 2) AS avg_time_gap_minutes,

    ROUND(AVG(efficiency_ratio), 2) AS avg_efficiency_ratio,

    SUM(time_gap_minutes > 0) AS slower_subjourneys,

    ROUND(
        100 * SUM(time_gap_minutes > 0) / COUNT(*),
        2
    ) AS pct_slower_than_expected,

    MIN(time_gap_minutes) AS min_time_gap_minutes,

    MAX(time_gap_minutes) AS max_time_gap_minutes

FROM delhivery_subjourney_performance

GROUP BY
    source_name,
    destination_name

HAVING COUNT(*) >= 10

ORDER BY
    pct_slower_than_expected DESC,
    subjourney_volume DESC

LIMIT 20;

-- PURPOSE: Normalize time gaps by distance to identify corridors with unusually high gap intensity.

USE delhivery_analytics;

SELECT
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
    source_name,
    destination_name

HAVING COUNT(*) >= 10

ORDER BY
    avg_gap_per_100km DESC

LIMIT 20;