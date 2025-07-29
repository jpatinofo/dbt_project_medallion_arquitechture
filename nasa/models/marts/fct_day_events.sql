SELECT 
day_name,
COUNT(*) AS total_events
FROM  {{ ref('stg_events') }}
GROUP BY day_name
ORDER BY 2