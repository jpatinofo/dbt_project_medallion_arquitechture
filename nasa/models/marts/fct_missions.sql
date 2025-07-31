SELECT mission,status, count(*) as total_killed FROM {{ ref('stg_events') }}
WHERE mission NOT IN ('UNKN') and status IN ('KILLED')
GROUP BY mission, status
