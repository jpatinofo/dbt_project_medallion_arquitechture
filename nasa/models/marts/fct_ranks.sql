SELECT *
FROM (
    SELECT 
        mission,
        device,
        COUNT(*) AS total,
        ROW_NUMBER() OVER (PARTITION BY mission ORDER BY COUNT(*) DESC) AS rank
    FROM {{ ref('stg_events') }}
    GROUP BY mission, device
) ranked