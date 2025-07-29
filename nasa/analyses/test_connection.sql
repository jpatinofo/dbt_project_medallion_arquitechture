SELECT *
FROM {{ source('dlake', 'events') }}
LIMIT 10;