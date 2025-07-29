SELECT
    format_event_date,
    mission,
    status,
    {{ status_counters_by_partition('status', ['event_year', 'event_month', 'event_day', 'mission']) }}
FROM {{ ref('stg_events') }}