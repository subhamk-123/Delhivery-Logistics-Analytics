CREATE DATABASE delhivery_analytics;
use delhivery_analytics;
show databases;
SELECT DATABASE();

SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

use delhivery_analytics;
select * from delhivery_raw limit 3;

SELECT COUNT(*) AS total_rows
FROM delhivery_raw;

SELECT COUNT(DISTINCT trip_uuid) AS unique_trips
FROM delhivery_raw;

SELECT
    trip_uuid,
    cutoff_factor,
    cutoff_timestamp,
    actual_distance_to_destination,
    actual_time,
    osrm_time,
    osrm_distance,
    segment_actual_time,
    segment_osrm_time
FROM delhivery_raw
WHERE trip_uuid = 'trip-153741093647649320'
ORDER BY cutoff_timestamp;