SELECT 
    mission,
    MIN(real_event_date) AS first_event,
    MAX(real_event_date) AS last_event,
    DATEDIFF('day', MIN(real_event_date), MAX(real_event_date)) AS active_days,
    COUNT(*) AS total_events,
    COUNT(*) * 1.0 / NULLIF(DATEDIFF('day', MIN(real_event_date), MAX(real_event_date)), 0) AS avg_events_per_day
FROM {{ ref('stg_events') }}
GROUP BY mission
ORDER BY active_days DESC