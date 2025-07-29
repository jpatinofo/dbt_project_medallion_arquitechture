{% macro get_view_by_language(language) %}

    SELECT 
        fed.event_year,
        day_map.{{ language }} AS translated_day,
        total_events
    FROM {{ ref('fct_event_days') }} AS fed
    INNER JOIN {{ ref('translate') }} AS day_map
        ON UPPER(fed.day_name) = day_map.ENGLISH_DAY
    ORDER BY total_events DESC
{% endmacro %}