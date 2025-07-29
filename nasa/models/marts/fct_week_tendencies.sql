SELECT 
    year_week,
    COUNT(*) AS total_events
FROM {{ ref('stg_events') }}
GROUP BY year_week
ORDER BY year_week