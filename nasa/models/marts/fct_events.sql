SELECT mission,device,status, count(*) as total_events FROM {{ ref('stg_events') }}
--WHERE mission NOT IN ('UNKN')
GROUP BY mission, device, status
