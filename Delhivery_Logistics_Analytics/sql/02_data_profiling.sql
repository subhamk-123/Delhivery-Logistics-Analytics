use delhivery_analytics;

//dataset_size
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT trip_uuid) AS unique_trips,
    COUNT(DISTINCT route_schedule_uuid) AS unique_route_schedules,
    COUNT(DISTINCT source_center) AS unique_sources,
    COUNT(DISTINCT destination_center) AS unique_destinations
FROM delhivery_raw;

//data_range
SELECT
    MIN(trip_creation_time) AS earliest_trip,
    MAX(trip_creation_time) AS latest_trip,
    MIN(od_start_time) AS earliest_start,
    MAX(od_end_time) AS latest_end
FROM delhivery_raw;

//route_types
SELECT
    route_type,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT trip_uuid) AS unique_trips
FROM delhivery_raw
GROUP BY route_type
ORDER BY unique_trips DESC;

//missing_values (there are no missing)
SELECT
    SUM(data IS NULL) AS missing_data,
    SUM(trip_creation_time IS NULL) AS missing_trip_creation_time,
    SUM(route_schedule_uuid IS NULL) AS missing_route_schedule,
    SUM(route_type IS NULL) AS missing_route_type,
    SUM(trip_uuid IS NULL) AS missing_trip_uuid,
    SUM(source_center IS NULL) AS missing_source_center,
    SUM(destination_center IS NULL) AS missing_destination_center,
    SUM(actual_time IS NULL) AS missing_actual_time,
    SUM(osrm_time IS NULL) AS missing_osrm_time,
    SUM(actual_distance_to_destination IS NULL) AS missing_actual_distance
FROM delhivery_raw;

//numerical ranges
SELECT
    MIN(actual_time) AS min_actual_time,
    MAX(actual_time) AS max_actual_time,
    MIN(osrm_time) AS min_osrm_time,
    MAX(osrm_time) AS max_osrm_time,
    MIN(actual_distance_to_destination) AS min_actual_distance,
    MAX(actual_distance_to_destination) AS max_actual_distance,
    MIN(segment_actual_time) AS min_segment_actual_time,
    MAX(segment_actual_time) AS max_segment_actual_time
FROM delhivery_raw;

