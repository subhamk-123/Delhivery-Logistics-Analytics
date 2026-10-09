USE delhivery_analytics;

-- Check how many observations each trip contains
SELECT
    trip_uuid,
    COUNT(*) AS observation_count
FROM delhivery_raw
GROUP BY trip_uuid
ORDER BY observation_count DESC
;

-- Check whether each trip has one source-destination combination
SELECT
    trip_uuid,
    COUNT(DISTINCT source_center) AS source_count,
    COUNT(DISTINCT destination_center) AS destination_count
FROM delhivery_raw
GROUP BY trip_uuid
HAVING source_count > 1
    OR destination_count > 1
;

-- Check whether route type changes within a trip
SELECT
    trip_uuid,
    COUNT(DISTINCT route_type) AS route_type_count
FROM delhivery_raw
GROUP BY trip_uuid
HAVING route_type_count > 1
LIMIT 20;

-- whether each row is a separate observation during a trip, rather than a separate trip
SELECT
    trip_uuid,
    COUNT(*) AS observations,
    COUNT(DISTINCT od_start_time) AS start_times,
    COUNT(DISTINCT cutoff_timestamp) AS cutoff_times,
    COUNT(DISTINCT actual_distance_to_destination) AS distances
FROM delhivery_raw
GROUP BY trip_uuid
ORDER BY observations DESC
LIMIT 20;

-- checking cotoff time as grain (no it is not unique too)
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT cutoff_timestamp) AS unique_cutoff_timestamps
FROM delhivery_raw;

-- Next test: trip_uuid + cutoff_timestamp as grain
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT trip_uuid, cutoff_timestamp) AS unique_trip_timestamp_pairs
FROM delhivery_raw;

-- using one trip as a sample to understand how actual_time, osrm_time, and the segment fields behave
SELECT
    trip_uuid,
    cutoff_timestamp,
    actual_distance_to_destination,
    actual_time,
    osrm_time,
    factor,
    segment_actual_time,
    segment_osrm_time,
    segment_osrm_distance,
    segment_factor
FROM delhivery_raw
WHERE trip_uuid = 'trip-153741093647649320'
ORDER BY cutoff_timestamp;

-- overall delay distribution
SELECT
    ROUND(AVG(segment_actual_time - segment_osrm_time), 2) AS avg_time_gap,
    ROUND(AVG(segment_factor), 2) AS avg_efficiency_factor,

    SUM(segment_actual_time > segment_osrm_time) AS slower_than_expected,
    COUNT(*) AS total_segments,

    ROUND(
        100 * SUM(segment_actual_time > segment_osrm_time) / COUNT(*),
        2
    ) AS pct_slower_than_expected

FROM delhivery_raw
WHERE segment_actual_time IS NOT NULL
  AND segment_osrm_time IS NOT NULL;
  
  -- creating delay bands
  SELECT
    CASE
        WHEN segment_actual_time <= segment_osrm_time
            THEN 'On time / faster'

        WHEN segment_actual_time - segment_osrm_time <= 5
            THEN '1-5 min slower'

        WHEN segment_actual_time - segment_osrm_time <= 10
            THEN '6-10 min slower'

        WHEN segment_actual_time - segment_osrm_time <= 20
            THEN '11-20 min slower'

        ELSE '20+ min slower'
    END AS delay_band,

    COUNT(*) AS segment_count,

    ROUND(
        100 * COUNT(*) / (
            SELECT COUNT(*)
            FROM delhivery_raw
            WHERE segment_actual_time IS NOT NULL
              AND segment_osrm_time IS NOT NULL
        ),
        2
    ) AS percentage_of_segments

FROM delhivery_raw

WHERE segment_actual_time IS NOT NULL
  AND segment_osrm_time IS NOT NULL

GROUP BY delay_band

ORDER BY
    CASE delay_band
        WHEN 'On time / faster' THEN 1
        WHEN '1-5 min slower' THEN 2
        WHEN '6-10 min slower' THEN 3
        WHEN '11-20 min slower' THEN 4
        WHEN '20+ min slower' THEN 5
    END;
    
    -- trip level delay
    
    SELECT
    trip_uuid,

    COUNT(*) AS total_segments,

    ROUND(
        AVG(segment_actual_time - segment_osrm_time),
        2
    ) AS avg_time_gap,

    MAX(segment_actual_time - segment_osrm_time)
        AS max_time_gap,

    SUM(segment_actual_time > segment_osrm_time)
        AS delayed_segments,

    ROUND(
        100 * SUM(segment_actual_time > segment_osrm_time) / COUNT(*),
        2
    ) AS pct_delayed_segments,

    ROUND(
        AVG(segment_factor),
        2
    ) AS avg_efficiency_factor

FROM delhivery_raw

WHERE segment_actual_time IS NOT NULL
  AND segment_osrm_time IS NOT NULL

GROUP BY trip_uuid

ORDER BY avg_time_gap DESC
limit 15;

-- finding if one row for a trip is outlier or normal (for each trip, no of row= no of segment)(like there are 428 trips jinka data sirf ek row me nipat gaya hai, 2375 ka 2 row/segment me)
SELECT
    total_segments,
    COUNT(*) AS number_of_trips
FROM (
    SELECT 
        trip_uuid,
        COUNT(*) AS total_segments
    FROM delhivery_raw
    WHERE segment_actual_time IS NOT NULL
      AND segment_osrm_time IS NOT NULL
    GROUP BY trip_uuid
) AS trip_sizes
GROUP BY total_segments
ORDER BY total_segments;

-- ategorise trips on the basis od no of segment(rows)
SELECT
    SUM(total_segments >= 2) AS trips_2_plus,
    SUM(total_segments >= 3) AS trips_3_plus,
    SUM(total_segments >= 5) AS trips_5_plus,
    SUM(total_segments >= 10) AS trips_10_plus,
    COUNT(*) AS total_trips
FROM (
    SELECT
        trip_uuid,
        COUNT(*) AS total_segments
    FROM delhivery_raw
    WHERE segment_actual_time IS NOT NULL
      AND segment_osrm_time IS NOT NULL
    GROUP BY trip_uuid
) AS trip_sizes;

-- droping the idea of removing outliers trips for now and creating a table with each row depicting a trip

CREATE OR REPLACE VIEW trip_performance AS

SELECT
    trip_uuid,

    -- Basic trip information
    MAX(route_type) AS route_type,
    COUNT(*) AS observation_count,

    -- Segment performance
    ROUND(AVG(segment_actual_time), 2) AS avg_actual_segment_time,
    ROUND(AVG(segment_osrm_time), 2) AS avg_expected_segment_time,

    -- Delay
    ROUND(
        AVG(segment_actual_time - segment_osrm_time),
        2
    ) AS avg_time_gap,

    MAX(
        segment_actual_time - segment_osrm_time
    ) AS max_time_gap,

    -- Number of observations slower than expected
    SUM(
        segment_actual_time > segment_osrm_time
    ) AS delayed_observations,

    -- Percentage of observations slower than expected
    ROUND(
        100 * SUM(
            segment_actual_time > segment_osrm_time
        ) / COUNT(*),
        2
    ) AS pct_delayed_observations,

    -- Relative efficiency
    ROUND(
        AVG(segment_factor),
        2
    ) AS avg_efficiency_factor

FROM delhivery_raw

WHERE segment_actual_time IS NOT NULL
  AND segment_osrm_time IS NOT NULL

GROUP BY trip_uuid;

SELECT *
FROM trip_performance
LIMIT 20;

SELECT
    COUNT(*) AS total_trip_rows,
    COUNT(DISTINCT trip_uuid) AS unique_trips
FROM trip_performance;

-- checking zero values

SELECT
    COUNT(*) AS total_rows,

    SUM(segment_actual_time < 0)
        AS negative_actual_time,

    SUM(segment_osrm_time <= 0)
        AS nonpositive_osrm_time,

    SUM(segment_osrm_distance < 0)
        AS negative_osrm_distance

FROM delhivery_raw;

-- chcking if overlapping data attributes belong to the same row
SELECT
    SUM(
        segment_actual_time < 0
        AND segment_osrm_time <= 0
    ) AS both_invalid,

    SUM(
        segment_actual_time < 0
        AND segment_osrm_time > 0
    ) AS negative_actual_only,

    SUM(
        segment_actual_time >= 0
        AND segment_osrm_time <= 0
    ) AS nonpositive_osrm_only,

    SUM(
        segment_actual_time >= 0
        AND segment_osrm_time > 0
    ) AS valid_observations

FROM delhivery_raw;

-- cleaning

CREATE OR REPLACE VIEW delhivery_clean AS

SELECT *
FROM delhivery_raw

WHERE segment_actual_time >= 0
  AND segment_osrm_time > 0;
  
SELECT
    COUNT(*) AS clean_observations,

    COUNT(DISTINCT trip_uuid) AS unique_trips,

    COUNT(
        DISTINCT trip_uuid,
                 source_center,
                 destination_center
    ) AS unique_subjourneys

FROM delhivery_clean;

-- 
SELECT
    observation_count,
    COUNT(*) AS number_of_subjourneys
FROM (
    SELECT
        trip_uuid,
        source_center,
        destination_center,
        COUNT(*) AS observation_count
    FROM delhivery_clean
    GROUP BY
        trip_uuid,
        source_center,
        destination_center
) AS subjourney_sizes
GROUP BY observation_count
ORDER BY observation_count;

CREATE OR REPLACE VIEW delhivery_clean AS
SELECT *
FROM delhivery_raw
WHERE segment_actual_time >= 0
  AND segment_osrm_time > 0;
  
-- Find one sub-journey with many observations
WITH selected_subjourney AS (
    SELECT
        trip_uuid,
        source_center,
        destination_center,
        COUNT(*) AS observation_count
    FROM delhivery_clean
    GROUP BY
        trip_uuid,
        source_center,
        destination_center
    ORDER BY observation_count DESC
    LIMIT 1
)

SELECT *
FROM selected_subjourney;
 
 -- Now show those actual observations
 WITH selected_subjourney AS (
    SELECT
        trip_uuid,
        source_center,
        destination_center
    FROM delhivery_clean
    GROUP BY
        trip_uuid,
        source_center,
        destination_center
    ORDER BY COUNT(*) DESC
    LIMIT 1
)

SELECT
    d.trip_uuid,
    d.source_center,
    d.destination_center,
    d.cutoff_timestamp,
    d.actual_distance_to_destination,
    d.actual_time,
    d.osrm_time,
    d.osrm_distance,
    d.factor,
    d.segment_actual_time,
    d.segment_osrm_time,
    d.segment_osrm_distance,
    d.segment_factor

FROM delhivery_clean d

JOIN selected_subjourney s
    ON d.trip_uuid = s.trip_uuid
    AND d.source_center = s.source_center
    AND d.destination_center = s.destination_center

ORDER BY d.cutoff_timestamp;
 
 -- CHANGE IN actual_time
    --      VS
-- SUM OF segment_actual_time
SELECT
    trip_uuid,
    source_center,
    destination_center,

    MAX(actual_time) AS first_actual_time,
    MIN(actual_time) AS last_actual_time,

    MAX(actual_time) - MIN(actual_time)
        AS actual_time_change,

    SUM(segment_actual_time)
        AS total_segment_actual_time,

    MAX(osrm_time) AS first_osrm_time,
    MIN(osrm_time) AS last_osrm_time,

    MAX(osrm_time) - MIN(osrm_time)
        AS osrm_time_change,

    SUM(segment_osrm_time)
        AS total_segment_osrm_time

FROM delhivery_clean

WHERE trip_uuid = 'trip-153755502932196495'
  AND source_center = 'IND160002AAC'
  AND destination_center = 'IND562132AAA'

GROUP BY
    trip_uuid,
    source_center,
    destination_center;  
    
    