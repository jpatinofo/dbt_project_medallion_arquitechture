SELECT 
    mission,
    event_hour,
    event_minute,
    event_second,
    COUNT(*) AS simultaneous_events
FROM {{ ref('stg_events') }}
GROUP BY mission, event_hour,event_minute, event_second
HAVING COUNT(*) > 1
ORDER BY simultaneous_events DESC