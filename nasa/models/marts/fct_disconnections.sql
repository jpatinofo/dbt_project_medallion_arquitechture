SELECT mission,device,status, count(*) as total_disconnections FROM {{ ref('stg_events') }}
WHERE mission NOT IN ('UNKN') and status IN ('UNKNOWN')
GROUP BY mission,device,status