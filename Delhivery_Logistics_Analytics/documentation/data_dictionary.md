# Data Dictionary

Confirm the exact field names against the exported CSV before publishing.

| Field | Description |
|---|---|
| `trip_uuid` | Identifier for a trip |
| `source_center` | Origin center identifier |
| `source_name` | Readable origin name, when available |
| `destination_center` | Destination center identifier |
| `destination_name` | Readable destination name, when available |
| `route_type` | Route category, such as FTL or Carting |
| `observation_start_time` | Start time associated with the selected observation |
| `starting_distance` | Distance value associated with the selected observation |
| `actual_time_minutes` | Recorded actual time in minutes |
| `expected_time_minutes` | OSRM-estimated time in minutes |
| `time_gap_minutes` | Actual time minus estimated time |
| `efficiency_ratio` | Actual time divided by estimated time |

## Derived metrics
- `time_gap_minutes = actual_time_minutes - expected_time_minutes`
- `efficiency_ratio = actual_time_minutes / expected_time_minutes`
- `route_comb` combines the origin and destination into one corridor label.

The interpretation of actual time depends on how the source records
segment observations. Validate the selected subjourney rule before
describing these values as completed journey durations.
