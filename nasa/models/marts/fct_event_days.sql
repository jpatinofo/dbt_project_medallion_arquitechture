SELECT 
    event_year,
    day_name,
    COUNT(*) AS total_events
FROM  {{ ref('stg_events') }}
GROUP BY event_year, day_name
ORDER BY 3