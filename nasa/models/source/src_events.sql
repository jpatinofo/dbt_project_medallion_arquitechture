{{ config(
    materialized='ephemeral',
) }}

SELECT 
    event_id,
    date,
    mission,
    device_type,
    device_status,
    hash
FROM {{ source('dlake', 'events') }}