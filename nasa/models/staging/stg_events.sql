{{ config(
    materialized='incremental',
    unique_key='event_id',
    schema='silver'
) }}

WITH standar_events AS (
    SELECT
        ev.event_id,
        STRPTIME(ev.date, '%d%m%y%H%M%S') AS converted_date,
        ev.mission,
        ev.device_type,
        ev.device_status,
        ev.hash
    FROM {{ ref('src_events') }} ev
)

SELECT 
    event_id,
    {{ date_info('converted_date') }},
    converted_date real_event_date,
    mission,
    UPPER(device_type) device,
    UPPER(device_status) status
FROM standar_events

WHERE 
    {% if is_incremental() %}
        event_id > (SELECT MAX(event_id) FROM {{ this }})
    {% else %}
        1=1
    {% endif %}