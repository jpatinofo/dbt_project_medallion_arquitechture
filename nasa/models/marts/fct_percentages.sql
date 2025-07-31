SELECT 
    mission,
    device,
    (total_events * 100.0 / total_events_all) as percentage
FROM
(
    SELECT 
        mission,
        device,
        count(*) as total_events,
        (
            SELECT count(*)
            FROM {{ ref('stg_events') }}
            WHERE mission NOT IN ('UNKN')
        ) as total_events_all

    FROM {{ ref('stg_events') }}
    WHERE mission NOT IN ('UNKN')
    GROUP BY mission, device
) as subquery
