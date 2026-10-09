-- sub-journey performance table
    
    USE delhivery_analytics;

CREATE OR REPLACE VIEW delhivery_subjourney_performance AS

WITH ranked_observations AS (

    SELECT
        trip_uuid,
        source_center,
        source_name,
        destination_center,
        destination_name,
        route_type,
        cutoff_timestamp,
        actual_distance_to_destination,
        actual_time,
        osrm_time,
        osrm_distance,
        factor,

        ROW_NUMBER() OVER (
            PARTITION BY
                trip_uuid,
                source_center,
                destination_center
            ORDER BY cutoff_timestamp
        ) AS observation_order

    FROM delhivery_clean
)

SELECT
    trip_uuid,
    source_center,
    source_name,
    destination_center,
    destination_name,
    route_type,

    cutoff_timestamp AS observation_start_time,

    actual_distance_to_destination AS starting_distance,

    actual_time AS actual_time_minutes,

    osrm_time AS expected_time_minutes,

    actual_time - osrm_time AS time_gap_minutes,

    ROUND(
        actual_time / NULLIF(osrm_time, 0),
        2
    ) AS efficiency_ratio

FROM ranked_observations

WHERE observation_order = 1;

-- viewing above created table
SELECT
    COUNT(*) AS subjourneys,
    COUNT(DISTINCT trip_uuid) AS trips
FROM delhivery_subjourney_performance;

-- 
SELECT
    COUNT(*) AS total_subjourneys,

    SUM(time_gap_minutes > 0) AS slower_than_expected,

    SUM(time_gap_minutes <= 0) AS on_time_or_faster,

    ROUND(
        100 * SUM(time_gap_minutes > 0) / COUNT(*),
        2
    ) AS pct_slower_than_expected,

    ROUND(
        MIN(time_gap_minutes),
        2
    ) AS smallest_gap_minutes,

    ROUND(
        MAX(time_gap_minutes),
        2
    ) AS largest_gap_minutes

FROM delhivery_subjourney_performance;

-- delay classifiaction
SELECT
    CASE
        WHEN time_gap_minutes <= 0
            THEN 'On time / faster'

        WHEN time_gap_minutes <= 30
            THEN 'Slight delay'

        WHEN time_gap_minutes <= 60
            THEN 'Moderate delay'

        WHEN time_gap_minutes <= 120
            THEN 'Significant delay'

        ELSE 'Severe delay'
    END AS delay_category,

    COUNT(*) AS subjourneys

FROM delhivery_subjourney_performance

GROUP BY
    CASE
        WHEN time_gap_minutes <= 0
            THEN 'On time / faster'
        WHEN time_gap_minutes <= 30
            THEN 'Slight delay'
        WHEN time_gap_minutes <= 60
            THEN 'Moderate delay'
        WHEN time_gap_minutes <= 120
            THEN 'Significant delay'
        ELSE 'Severe delay'
    END

ORDER BY subjourneys DESC;

-- Find problematic routes

SELECT
    source_center,
    destination_center,

    COUNT(*) AS route_volume,

    SUM(time_gap_minutes > 0) AS slower_subjourneys,

    ROUND(
        100 * SUM(time_gap_minutes > 0) / COUNT(*),
        2
    ) AS pct_slower_than_expected,

    SUM(
        CASE
            WHEN time_gap_minutes > 0
            THEN time_gap_minutes
            ELSE 0
        END
    ) AS total_delay_minutes

FROM delhivery_subjourney_performance

GROUP BY
    source_center,
    destination_center

HAVING COUNT(*) >= 10

ORDER BY
    pct_slower_than_expected DESC;
    
-- volume + poor performance.
SELECT
    source_center,
    destination_center,

    COUNT(*) AS route_volume,

    SUM(time_gap_minutes > 0) AS delayed_subjourneys,

    ROUND(
        100 * SUM(time_gap_minutes > 0) / COUNT(*),
        2
    ) AS delay_rate,

    SUM(
        CASE
            WHEN time_gap_minutes > 0
            THEN time_gap_minutes
            ELSE 0
        END
    ) AS total_delay_minutes

FROM delhivery_subjourney_performance

GROUP BY
    source_center,
    destination_center

HAVING COUNT(*) >= 10

ORDER BY
    delayed_subjourneys DESC
LIMIT 20;

-- find extreme subjouneys

USE delhivery_analytics;

SELECT
    trip_uuid,
    source_center,
    source_name,
    destination_center,
    destination_name,
    route_type,
    observation_start_time,
    starting_distance,
    actual_time_minutes,
    expected_time_minutes,
    time_gap_minutes,
    efficiency_ratio
FROM delhivery_subjourney_performance
ORDER BY time_gap_minutes DESC
LIMIT 10;

